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


# Data
data <- read.xlsx('C:/Users/LcmayorquinL/Desktop/MAPEO/resultados.xlsx',sheet = 2)

data$latitude <- as.numeric(data$latitude)
data$longitude <- as.numeric(data$longitude)

leaflet(data = data) %>%
  addTiles() %>%
  addMarkers() %>%
  frameWidget()

