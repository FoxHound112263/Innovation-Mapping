# load packages
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


# Data
data <- read.xlsx('C:/Users/LcmayorquinL/Desktop/MAPEO/resultados.xlsx',sheet = 2)

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
  addAwesomeMarkers(popup = paste0(
      "<div>",
      "<h3>",
      data$`¿Cuál.es.el.nombre.del.equipo/unidad.de.innovación?`,
      "</h3>",
      "<strong>Dependencia o área misional</strong>: ",
      data$`¿A.qué.dependencia.o.área.misional,.dentro.de.la.entidad,.pertenece.la.unidad.de.innovación?`,
      "</br>",
      "<strong>Propósito</strong>: ",
      data$Describe.en.una.frase.el.propósito.de.este.equipo,
      "</div>"
  ),
                    label= data$Nombre.de.la.entidad.pública.a.la.que.pertenece.el.equipo,
                    icon = icon.ion,
  clusterOptions = markerClusterOptions()
  ) # %>% 
  addLegend("bottomright", colors= c("#15A49D", "#DDDB00"), labels=c("Nacional'", "Territorial"), title="Tipo de la entidad pública")
  
  #addProviderTiles("NASAGIBS.ViirsEarthAtNight2012") %>% 
  #addMarkers(popup = data$Nombre.de.la.entidad.pública.a.la.que.pertenece.el.equipo) %>%
  #frameWidget()

m
saveWidget(m, file="")
library(mapview)
mapshot(m, url = "C:/Users/LcmayorquinL/Desktop/mapeo_equipos.html")


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
