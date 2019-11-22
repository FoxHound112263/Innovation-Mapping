# load packages
install.packages("leaflet.providers")
library(dplyr)
library(ggplot2)
library(rjson)
library(jsonlite)
library(leaflet)
library(RCurl)
library(httr)
library(curl)
library(RJSONIO)
library(here)
library(tidyverse)
library(stringr)
library(sf)
library(widgetframe)
library(openxlsx)
library(leaflet.minicharts)
library(leaflet.providers)


# Data
data <- read.xlsx('C:/Users/LcmayorquinL/Desktop/MAPEO/resultados.xlsx',sheet = 2)
# HOME
data <- read.xlsx('C:/Users/User/OneDrive - Departamento Nacional de Planeacion/DIDE/2019/Data Science Projects/Innovation-Mapping/data/resultados.xlsx',sheet = 2)
data <- data[-nrow(data),]

data$latitude <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)

data$Tipo.de.la.entidad.pública <- factor(data$Tipo.de.la.entidad.pública)

new <- c("#15A49D","#DDDB00")[data$Tipo.de.la.entidad.pública]

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = new
)

icon.ion <- makeAwesomeIcon(icon = 'flag', markerColor = 'blue', library='ion')

m <-  leaflet(data = data) %>%
  addTiles() %>%
  #addCircleMarkers() %>% 
  addCircleMarkers(popup = paste0(
      "<div>",
      "<h3>",
      data$`¿Cuál.es.el.nombre.del.equipo/unidad.de.innovación?`,
      "</h3>",
      "<strong>Dependencia o área misional</strong>: ",
      data$`¿A.qué.dependencia.o.área.misional,.dentro.de.la.entidad,.pertenece.la.unidad.de.innovación?`,
      "</br>",
      "<strong>Propósito</strong>: ",
      data$Describe.en.una.frase.el.propósito.de.este.equipo,
      "</br>",
      "<strong>Meta</strong>: ",
      data$Meta.1,
      "</div>"
  ),
                    label= data$Nombre.de.la.entidad.pública.a.la.que.pertenece.el.equipo,
                    #icon = icon.ion,
                    stroke = T, fillOpacity = 0.7,
                    color = new,
  clusterOptions = markerClusterOptions(iconCreateFunction=JS("function (cluster) {    
       childCount = cluster.getChildCount();  
       if (childCount < 1000) {  
       c = 'rgba(255, 69, 0, 0.9);'
       c = 'rgba(255, 69, 0, 0.9);'  
       }    
       return new L.DivIcon({
             html: '<div style=\"background-color:'+c+' \"><span>' +
             childCount + '</span></div>', className: 'marker-cluster',  
             iconSize: new L.Point(20, 20) });
      }")),
  )  %>% 
  addLegend("bottomright", colors= c("#15A49D", "#DDDB00"), labels=c("Nacional'", "Territorial"), title="Tipo de la entidad pública") %>% 
  
  addProviderTiles("Stamen.TonerLite")
  #addMarkers(popup = data$Nombre.de.la.entidad.pública.a.la.que.pertenece.el.equipo) %>%
  #frameWidget()

m
saveWidget(m, file="")
library(mapview)
mapshot(m, url = "C:/Users/LcmayorquinL/Desktop/mapeo_equipos.html")
# Home
mapshot(m, url = "C:/Users/User/Desktop/mapeo_equipos.html")


basemap <- leaflet(data = data) %>%
  addTiles()

basemap %>%
  addMinicharts(
      data$longitude,
    data$latitude,
    #type = "pie",
    #chartdata = data$`¿Cuál.es.el.nombre.del.equipo/unidad.de.innovación?`,
    colorPalette = c("green", "blue"),
    popup = popupArgs(
      labels = c("Nacional'", "Territorial"),
      html = paste0(
        "<div>",
        "<h3>",
        data$`¿Cuál.es.el.nombre.del.equipo/unidad.de.innovación?`,
        "</h3>",
        "Propósito: ",
        data$Describe.en.una.frase.el.propósito.de.este.equipo,
        "<br>",
        "Entidad pública: ",
        data$Nombre.de.la.entidad.pública.a.la.que.pertenece.el.equipo,
        "</div>"
      )
    )
  ) %>% 
  frameWidget()

library(htmlwidgets)
saveWidget(m, file="m.html")
