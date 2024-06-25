
#creation du graphique dynamique

plot_airport_line<-function(df,apt){
  liste_aeroport <- unique(aeroport$apt)
  index <- which(aeroport$apt == apt)
  
  # Vérifier si la chaîne de caractères a été trouvée
  if (length(index) == 0) {
    print("La chaîne de caractères n'a pas été trouvée dans la liste.")
  } else {
    print(index)
  }
  default_airport <- liste_aeroport[index]
  
  trafic_aeroport <- aeroport %>%
    mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
    filter(apt %in% default_airport) %>%
    mutate(
      date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
    )
  
  fig <- plot_ly(trafic_aeroport, x = ~date, y = ~trafic, name = 'MAYOTTE', type = 'scatter', mode = 'lines+markers') 
  return(fig)
}

plot_airport_line(aeroport,"FMEE")
