##install.packages('rsconnect')
# library(rsconnect)
# rsconnect::setAccountInfo(name='gusajr',
#                           token='84B9AF91911E376EACDF26C7896BCDC3',
#                           secret='XuJpIECl0SLZpY2LVH9Kn8Hc/xya/w9TcuoFvDKC')
# #library(rsconnect)
# rsconnect::deployApp('/home/gusajr/Documents/projects/shiny/heatmaps_years')


rm(list=ls(all=TRUE))

#devtools::install_github('rstudio/leaflet')
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(shiny)

#setwd("/home/gusajr/Documents/projects/shiny/heatmaps_years")
load("Collisions_data_clean.RData")
data <- collisions_data_clean

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$mymap <- renderLeaflet({
      
      years <- input$years  
      sub_exp <- data %>% select ( new.years , `Number of Casualties`, Latitude, Longitude )  %>% filter ( new.years == years) 
      leaflet(sub_exp) %>%
        addTiles() %>%
        addMarkers(lat = ~Latitude, lng = ~Longitude)
      leaflet(sub_exp) %>%  addTiles()  %>%  addHeatmap(lng = ~Longitude, lat = ~Latitude, intensity = ~`Number of Casualties`,
                                                             blur = 20, max = 0.05, radius = 15)
  })
}

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Heatmaps year"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("years",
                  "Years of Heatmaps:", sep="",
                  min = 2012,
                  max = 2016,
                  value = 0,
                  step = 1,
                  )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("mymap")
    )
  )
)

# Run the application 
shinyApp(ui = ui, server = server)
