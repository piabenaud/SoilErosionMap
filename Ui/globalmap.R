
(
         div(class="outer",
             
             tags$head(
               # Include our custom CSS
               includeCSS("styles.css")#,
               #includeScript("gomap.js")   #add this in at later date
             ),
             
             # If not using custom CSS, set height of leafletOutput to a number instead of percent
             leafletOutput("mapG", width="100%", height="100%"),
             
             # Shiny versions prior to 0.11 should use class = "modal" instead.
             absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                           draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                           width = 330, height = "auto",
                           
                           h2("Observation explorer"),
                           
                           plotOutput("histRateG", height = 220),
                           plotOutput("methRateG", height = 200)
             ),
             
             tags$div(id="cite",
                      'Data compiled following Benaud et al., (Journalname, 2019) DOIlink.'
             )
         )
  )