library(shiny)
library(shinyjs)
library(dplyr)
library(DT)
library(ggplot2)
library(qicharts2)

server <- function(input, output, session) { 
  
  data <- callModule(file_upload_server, "data")

  callModule(exploration_server, "explore", data)

  
  
}
