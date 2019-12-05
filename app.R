library(shiny)
library(leaflet)
library(shinydashboard)
library(shinyjs)
library(openxlsx)

options(encoding="UTF-8")

#data <- read.xlsx('C:/Users/User/OneDrive - Departamento Nacional de Planeacion/DIDE/2019/Data Science Projects/Innovation-Mapping/data/resultados.xlsx',sheet = 2)
loadWorkbook_url <- function(url) {
  temp_file <- tempfile(fileext = ".xlsx")
  download.file(url = url, destfile = temp_file, mode = "wb", quiet = TRUE)
  read.xlsx(temp_file,sheet = 2)
}
data <- loadWorkbook_url('https://github.com/FoxHound112263/Innovation-Mapping/raw/master/data/resultados.xlsx')

data <- data[-nrow(data),]

data$latitude <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)

names(data)[names(data) == "Tipo.de.la.entidad.pública"] <- "Tipo.de.la.entidad.publica"

data$Tipo.de.la.entidad.publica <- factor(data$Tipo.de.la.entidad.publica)

new <- c("#15A49D","#DDDB00")[data$'Tipo.de.la.entidad.publica']


ui <- dashboardPage(
  dashboardHeader(title = 'MAPEO EQUIPOS INN. PÚBLICA',titleWidth = 400),
  dashboardSidebar(
    collapsed = TRUE,disable = T
  ),
  dashboardBody(
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    leafletOutput("mymap")
  )
)

server <- function(input, output) {
  addClass(selector = "body", class = "sidebar-collapse")
  
  
  #tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
  
  output$mymap <- renderLeaflet({
  m <- leaflet(data = data) %>%
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
      #"<strong>Meta</strong>: ",
      #data$Meta.1,
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
    m
    
  })
  
  
}

shinyApp(ui, server)
