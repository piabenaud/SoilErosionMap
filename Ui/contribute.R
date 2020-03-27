
#################################################################################
#### UI for data contribution ###################################################
#################################################################################

fluidPage(
  titlePanel("Contribute soil erosion data to global map"),
  p("Please use the add data function to add additional rows to the table. Once you have finished, download the data and email it to", a(href = 'http://geography.exeter.ac.uk/staff/index.php?web_id=Pia_Benaud', 'Pia Benaud'), "or submit it as a pull-request on the", a(href = 'https://github.com/piabenaud/SoilErosionMap', 'SoilErosionMap'), "github page."),
  p("All data will be checked for consistency before being added to the global geodatabase and map. Please note, contributions are currently be limited to spatially explicit observations of on-site erosion - records based on suspended sediment yields and bathymetry (i.e. off-site representations of soil erosion) will not be included."),
  hr(),
  downloadButton("Erosion_csv", "Download as CSV"),
  br(),
  uiOutput("Build_global")
  )