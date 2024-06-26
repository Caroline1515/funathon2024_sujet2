library(readr)
library(dplyr)
library(stringr)
library(sf)
library(plotly)
library(ggplot2)

source("R/create_data_list.R")
source("R/clean_data_frame.R")
#source("R/import_donnees.R")
source("R/figures.R")
source ("R/divers_fonctions.R")

year_list  <- as.character(2018:2022)
months_list <- 1:12
year <- year_list[1]
month <- months_list[1]


#chargement des donnees
urls <- create_data_list("sources.yml")

aeroport<-read_csv2(unlist(urls$airports))

aeroport<-clean_data_frame(aeroport)

compagnie<-read_csv2(unlist(urls$compagnie))
compagnie<-clean_data_frame(compagnie)

liaison<-read_csv2(unlist(urls$liaison))
liaison<-clean_data_frame(liaison)

# donnees carte
chemin <- "https://minio.lab.sspcloud.fr/projet-funathon/2024/sujet2/aeroports.geojson"
airport_location <- sf::st_read(dsn = chemin, quiet = TRUE)

#verification du systeme de coordonnees
st_crs(airport_location)




# VALORISATIONS

#carte
leaflet(airport_location) %>%
  addTiles() %>%
  addMarkers(popup = ~paste("Nom:", Nom, "<br>", "Trafic:", as.character(trafic)))

#
figure<-plot_airport_line(aeroport,"FMEE")
figure
