library(yaml)

create_data_list<-function (source_file){
  liste_source<- yaml::read_yaml(source_file)
  return(liste_source)
}
  
