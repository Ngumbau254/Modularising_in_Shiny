library(shiny)
library(dplyr)
library(sf)
library(ggplot2)
library(tmap)

shinyServer(
  function(input, output, session){
    
    afsis.data <- read.csv("Data/plotting_data.csv")%>%
      mutate(
        Depth= factor(Depth, level=c("Topsoil", "Subsoil"), ordered= TRUE)
      )%>%
      st_as_sf(coords = c("Longitude", "Latitude"), crs=4326)
    
    output$soil_box <- renderPlot({
      ggplot(afsis.data, aes(x=LandCover, y=CORG, fill=Depth))+
        geom_boxplot(notch = TRUE)
    })
    
    output$soil_map <- renderPlot({
      data("World")
      
      World%>%
        filter(continent=="Africa")%>%
        tm_shape()+
        tm_borders(col="brown")+
        tm_shape(afsis.data)+
        tm_dots(col="LandCover", size = "CORG")
      
    })
    
  }
)
