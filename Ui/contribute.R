
#################################################################################
#### UI for data contribution ###################################################
#################################################################################

fluidPage(
  titlePanel("Contribute soil erosion data to global map"),
  p("Please use the add data function to add additional rows to the table. Once you have finished, download the data and email it to P.Benaud@exeter.ac.uk or submit it as a pull-request on the SoilErosionMap page."),
  p("All data will be checked for consistency before being added to the global geodatabase and map."),
  hr(),
  downloadButton("Erosion_csv", "Download as CSV"),
  br(),
  uiOutput("Build_global")
  )