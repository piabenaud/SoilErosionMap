
###########################################################################
#### UI for UK data tab ###################################################
###########################################################################

fluidPage(
  titlePanel("Explore the data behind the UK soil erosion map"),
  p("To download, please press CSV"),
  hr(),
  DT::dataTableOutput("erosiontable")
  )


#(
 #  DT::dataTableOutput("erosiontable")
  #)
