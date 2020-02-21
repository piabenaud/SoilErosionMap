
#### The Shiny app #######################################################

rm(list=ls()) #clear everything (to check app fully works)

# Load packages -----------------------------------------------------------

library(shiny)
library(leaflet)
library(ggplot2)
library(htmltools)
library(dplyr)
library(readr)
library(rgdal) 
library(scales) # for log1p
library(lubridate)
library(DT)


# Run global script ---------------------------------------

source("Global.R")

vars <- c(
  "Erosion Rate" = "Rslt_Analysis", #variables for colour drop-down
  "Study Method" = "Stdy_Meth1",
  "Site Selection" = "Site_selection"
)

varsG <- c(
  "Erosion Rate" = "Rslt_Analysis",  #variables for colour drop-down
  "Study Method" = "Stdy_Meth1"
)


# Link together the ui ----------------------------------------------------

ui <- navbarPage("Soil Erosion Geodatabase", id="nav",
                 tabPanel("UK map", source("Ui/ukmap.R", local = TRUE)),
                 tabPanel("UK geodata explorer", source("Ui/ukdata.R", local = TRUE)),
                 tabPanel("Global map", source("Ui/globalmap.R", local = TRUE)),
                 tabPanel("Contribute data", source("Ui/contribute.R", local = TRUE))
                )


# Link together the server ------------------------------------------------

server <- function(input, output, session) {
  source("Server/ukmap.R", local = TRUE)
  source("Server/ukdata.R", local = TRUE)
  source("Server/globalmap.R", local = TRUE)
  source("Server/contribute.R", local = TRUE)
}


# Build the app -----------------------------------------------------------

shinyApp(ui = ui, server = server)
