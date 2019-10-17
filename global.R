library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinydashboardPlus)
library(shinyjs)
library(DT)
library(dplyr)
library(readr)
library(anytime)


sapply(list.files("./helpers/", full.names = TRUE), function(x) {source(x, local = .GlobalEnv)})
sapply(list.files("./modules/", full.names = TRUE), function(x) {source(x, local = .GlobalEnv)})

charts <- readr::read_csv("data/charts.csv")
