library(readr)
library(dplyr)
library(stringr)
library(sf)
library(ggplot2)
library(plotly)
library(leaflet)
library(gt)


source("correction/R/import_data.R")
source("correction/R/create_data_list.R")
source("correction/R/clean_dataframe.R")
source("correction/R/divers_functions.R")
source("correction/R/figures.R")

YEARS_LIST  <- as.character(2018:2022)
MONTHS_LIST <- 1:12
year <- YEARS_LIST[1]
month <- MONTHS_LIST[1]


# Load data ----------------------------------
urls <- create_data_list("./sources.yml")


pax_apt_all <- import_airport_data(unlist(urls$airports))
pax_cie_all <- import_compagnies_data(unlist(urls$compagnies))
pax_lsn_all <- import_liaisons_data(unlist(urls$liaisons))

airports_location <- st_read(urls$geojson$airport)

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

# OBJETS NECESSAIRES A L'APPLICATION ------------------------

trafic_aeroports <- pax_apt_all %>%
  mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
  filter(apt %in% default_airport) %>%
  mutate(
    date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
  )

stats_aeroports <- summary_stat_airport(
  create_data_from_input(pax_apt_all, year, month)
)

#ajout colonne
stats_aeroports_table <- stats_aeroports %>%
  mutate(name_clean = paste0(str_to_sentence(apt_nom), " _(", apt, ")_")
  ) %>%
  select(name_clean, everything())

# un beau tableau

# Utiliser les données 
data <-stats_aeroports_table
data<-data %>% mutate(apt=NULL,apt_nom=NULL)

# Créer et personnaliser le tableau GT
gt_table <- gt(data) %>%
  tab_header(
    title = "Statistiques de fréquentation des aéroports",
    subtitle = "Classement des aéroports"
  ) %>%
  cols_label(
    name_clean = "Aéroport",
    paxdep = "Départs",
    paxarr= "Arrivées",
    paxtra="Transit"
  ) %>%
  fmt_number(columns = starts_with("pax"), suffixing = TRUE) %>%
  fmt_markdown(columns = "name_clean") %>%
  tab_style(
    style = cell_fill(color = "white"),
    locations = cells_body()
    )%>%
  opt_interactive()
  

# Afficher le tableau
gt_table



# VALORISATIONS ----------------------------------------------

figure_plotly <- plot_airport_line(trafic_aeroports,default_airport)
figure_plotly
