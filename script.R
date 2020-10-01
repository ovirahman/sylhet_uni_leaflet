library(leaflet)
library(dplyr)
library(htmltools)
library(htmlwidgets)

#Reading in the data
sylhet <- read.csv("sylhet_uni.csv")
#correcting variable names
names(sylhet) <- c("Name","Type", "lat", "lon", "Established")


#Defining Color Pallete for markers
pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "Medical College"))

#filtering data based on university type.
public <- filter(sylhet, Type == "Public")  
private <- filter(sylhet, Type == "Private") 
medical <- filter(sylhet, Type == "Medical College")

#funcion for generating label text
labelText <- function(Name, Type, Established){ 
    paste0("<b>",Name,"</b>", "<br/>","Type: ", Type, "<br/>", "Established:", Established)
}

#note text
note <- tags$div(
    HTML('<b>Public, Private Universities and Medical Colleges in Sylhet</b> <br>
         Developed By: <a href = "https://www.linkedin.com/in/ovirahman">Musaddiqur Rahnan Ovi </a> <br>
         m.ovirahman2@gmail.com  <br>
         Sources: Google, Wikipedia' )
)  


#creating the leaflet map object
map <- leaflet() %>% 
    addProviderTiles("CartoDB") %>% 
    addCircleMarkers(data = public, radius = 8, label = ~Name,
                     popup = ~labelText(Name, Type, Established),
                     color = ~pal(Type), group = "Public") %>% 
    addCircleMarkers(data = private, radius = 8, label = ~Name,
                     popup = ~labelText(Name, Type, Established),
                     color = ~pal(Type), group = "Private") %>% 
    addCircleMarkers(data = medical, radius = 8, label = ~Name,
                     popup = ~labelText(Name, Type, Established),
                     color = ~pal(Type), group = "Medical College") %>% 
    addLegend(pal = pal, 
              values = c("Public", "Private", "Medical College"),position = "topleft") %>% 
    addLayersControl(overlayGroups = c("Public", "Private", "Medical College")) %>%
    addControl(note, position = "bottomleft")


#plotting the map
map



#-----------------------------END----------------------------------




##***alternative method***
## using loop might be usefull when there are many categories / type 

map <-leaflet() %>% 
    addProviderTiles("CartoDB")

for(i in c("Public", "Private", "Medical College")){
    map <-  map %>% 
        addCircleMarkers(data = filter(sylhet, Type == i), radius = 8, label = ~Name,
                         popup = ~paste0("<b>",Name,"</b>", "<br/>", Type, "<br/>", "Established:", Established),
                         color = ~pal(Type), group = i)
}

map <- map %>%
    addLegend(pal = pal, 
              values = c("Public", "Private", "Medical College"),position = "topleft") %>% 
    addLayersControl(overlayGroups = c("Public", "Private", "Medical College")) %>%
    addControl(note, position = "bottomleft")

map















##############################

