
(
         div(class="outer",
             
             tags$head(
               # Include our custom CSS
               includeCSS("styles.css")#,
               #includeScript("gomap.js")   #add this in at later date
             ),
             
             # If not using custom CSS, set height of leafletOutput to a number instead of percent
             leafletOutput("map", width="100%", height="100%"),
             
             # Shiny versions prior to 0.11 should use class = "modal" instead.
             absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                           draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                           width = 330, height = "auto",
                           
                           h3("Observation explorer"),
                           
                           selectInput("colour_low", "Lowland colour", vars),
                           selectInput("colour_up", "Upland colour", vars),
                           
                           plotOutput("histRate", height = 200),
                           plotOutput("methRate", height = 180),
                           plotOutput("selectRate", height = 180)
             ),
             
             tags$div(id="cite",
                      'Data compiled for ', tags$em('National-scale geodata describe widespread accelerated soil erosion'), ' by Pia Benaud et al., (Geoderma, 2020) DOIlink.'
             )
         )
)