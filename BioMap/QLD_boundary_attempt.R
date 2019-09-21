# Rough go at map boundaries

library('ggmap')
library('rgdal')
library('rgeos')
library('maptools')
library('dplyr')
library('tidyr')
library('tmap')
library('leaflet')

# Load dbf file using readOGR`
map <- readOGR(dsn = "data", layer = "MB_2016_QLD")
#plot(map)

saveRDS(object = map, file = "data/qldMap.Rds")

qldMap <- readRDS('data/qldMap.Rds')
leaflet() %>% addTiles() %>% addPolygons(data = qldMap)