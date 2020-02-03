(
         fluidPage(
           titlePanel("Contribute soil erosion data to global map"),
           fluidRow(
             column(6, ##test column width
                    h3("Location Data"),
                    p("Please report in WSG84 (EPSG:4326) coordinate system.")
             ),
             column(6,
                    h3("Study Dates"),
                    p("Please report in YYYY-MM-DD format, NA if unknown ")
             )),
           
           fluidRow(
             column(3,
                    textInput("Long", "Longitude", "")
             ),
             column(3,
                    textInput("Lat", "Latitude", "")
             ),
             column(3,
                    textInput("start_date", "Start Date", "")
             ),
             column(3,
                    textInput("end_date", "End Date", "")
             )),
           
           fluidRow(
             hr(),
             column(4,
                    selectInput("land_cover", "Land Cover", landcover, selectize=FALSE)
             ),
             column(4,
                    selectInput("land_use", "Land Use", landuse, selectize=FALSE)
             ),
             column(4,
                    selectInput("texture", "Soil Texture", textures, selectize=FALSE)
             )),
           
           fluidRow(
             column(4,
                    selectInput("method", "Study Method", methods, selectize=FALSE)
             ),
             column(4,
                    selectInput("process", "Erosion Process", processes, selectize=FALSE)
             ),
             column(4,
                    selectInput("scale", "Study Extent", scales, selectize=FALSE)
             )),
           
           fluidRow(
             hr(),
             column(12, 
                    h3("Erosion Rate Data"),
                    p(HTML("Please report in t ha<sup>-1</sup> yr<sup>-1</sup>, NA if not appropriate."))
             )),
           
           fluidRow(
             column(3,
                    textInput("Rslt_Mean", "Mean Rate", "")
             ),
             column(3,
                    textInput("Rslt_Med", "Median Rate", "")
             ),
             column(3,
                    textInput("Rslt_Net", "Net Rate", "")
             )),
           
           fluidRow(
             hr(),
             column(3,
                    textInput("Source_Ref", "Citation", "")
             ),
             column(3,
                    textInput("Collector_Ref", "Contributor", "")
             ),
             column(4,
                    textInput("Link", "DOI", "")
             )),
           
           fluidRow(
             br(),
             column(12,
                    actionButton("submit", "Submit")
             ))
           )
  )