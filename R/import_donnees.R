#import des donnees

urls <- create_data_list("sources.yml")

aeroport<-read_csv2(unlist(urls$airports))

aeroport<-clean_data_frame(aeroport)

compagnie<-read_csv2(unlist(urls$compagnie))
compagnie<-clean_data_frame(compagnie)

liaison<-read_csv2(unlist(urls$liaison))
liaison<-clean_data_frame(liaison)

stats_aeroports <- summary_stat_airport(
  create_data_from_input(aeroport, year, month)
)





chemin <- "https://minio.lab.sspcloud.fr/projet-funathon/2024/sujet2/aeroports.geojson"
airport_location <- sf::st_read(dsn = chemin, quiet = TRUE)

#verification du systeme de coordonnees
st_crs(airport_location)

#creation de la carte

leaflet(airport_location) %>%
  addTiles() %>%
  addMarkers(popup = ~paste("Nom:", Nom, "<br>", "Trafic:", as.character(trafic)))


#creation du graphique statique
# liste_aeroport <- unique(aeroport$apt)
# default_airport <- liste_aeroport[1]
# 
# trafic_aeroport <- aeroport %>%
#   mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
#   filter(apt %in% default_airport) %>%
#   mutate(
#     date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
#   )
# 
# 
# g<-ggplot(data = trafic_aeroport, aes(x = date, y = trafic)) +
#   geom_line() +
#   labs(x = "date", y = "trafic", title = "trafic dans FMCZ")+
#   theme_grey()
# 
# plot(g)

