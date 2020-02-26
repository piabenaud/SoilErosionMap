

# Load packages -----------------------------------------------------------

library(shiny)
library(dplyr)
library(lubridate)
library(DT)


# Initiate datatable ------------------------------------------------------
  
globaldata <- reactiveValues()

globaldata$Data <- tibble(
  "Longitude" = 50.7369, 
  "Latitute" = -3.5315, 
  "start_date" = ymd("2019-10-06"), 
  "end_date" = today(), 
  "land_cover" = "Arable", 
  "land_use" = "Bare", 
  "textures" = "medium sandy loam", 
  "textures_gen" = "sandy loam", 
  "texture_class" = "SSEW", 
  "Annual_precipitation" = 811, 
  "Precip_intensity" = "NA",
  "method" = "Volumetric - remote sensing", 
  "process" = "Water", 
  "scale" = "Plot",
  "obs_count" = 6,
  "Rslt_Mean" = 10.01, 
  "Rslt_Med" = 4.01, 
  "Rslt_Net" = "NA", 
  "Rslt_Vol" = 6.66,
  "Source_ref" = "Benaud et al., (2020) Made up paper title. Journalname. Vol Issue",  
  "Collector_Ref" = "Benaud, P.", 
  "Link" = "https://github.com/piabenaud/SoilErosionMap")

 
# Render the UI based on input --------------------------------------------

  #### Build_global is the id to use in the UI
  output$Build_global <-renderUI({
      tagList(
             actionButton(inputId = "Add_row_head", label = "Add data"),
             actionButton(inputId = "Del_row_head", label = "Delete row"),
             dataTableOutput("Global_table")) 
    })


# Render the datatable ----------------------------------------------------

  output$Global_table <- DT::renderDataTable({
    DT::datatable(globaldata$Data,
                  selection = 'single',
                  escape = FALSE,
                  extensions = c('FixedColumns','FixedHeader'),
                  options = list(
                    orderClasses = TRUE,
                    dom = 'frtlip',
                    fixedColumns = list(leftColumns = 4),
                    fixedHeader = TRUE))
    })


# Pop up for data entry ---------------------------------------------------

  observeEvent(input$Add_row_head, {
    ### This is the pop up board for input a new row
    showModal(modalDialog(title = "Add a new erosion observation",
                          h4("Location Data"),
                          p("Please report in WSG84 (EPSG:4326) coordinate system."),
                          numericInput(paste0("Long_add", input$Add_row_head), "Longitude:", NA),
                          numericInput(paste0("Lat_add", input$Add_row_head), "Latitude:", NA),
                          h4("Study Dates"),
                          dateInput(paste0("start_date_add", input$Add_row_head), "Start date:", value = Sys.Date()),
                          dateInput(paste0("end_date_add", input$Add_row_head), "End date:", value = Sys.Date()),
                          selectInput(paste0("land_cover_add", input$Add_row_head), "Land cover:", choices = landcover, selectize=FALSE),
                          selectInput(paste0("land_use_add", input$Add_row_head), "Land use:", choices = landuse, selectize=FALSE),
                          selectInput(paste0("textures_add", input$Add_row_head), "Texture (with size):", choices = textures, selectize=FALSE),
                          selectInput(paste0("texture_gen_add", input$Add_row_head), "Texture:", choices = textures_gen, selectize=FALSE),
                          selectInput(paste0("texture_class_add", input$Add_row_head), "Texture classification:", choices = texture_class, selectize=FALSE),
                          numericInput(paste0("annual_add", input$Add_row_head), "Annual precipitation:", NA),
                          numericInput(paste0("intense_add", input$Add_row_head), "Precipitation intensity:", NA),
                          selectInput(paste0("method_add", input$Add_row_head), "Study method:", choices = methods, selectize=FALSE),
                          selectInput(paste0("process_add", input$Add_row_head), "Process:", choices = processes, selectize=FALSE),
                          selectInput(paste0("scale_add", input$Add_row_head), "Study scale:", choices = scales, selectize=FALSE),
                          numericInput(paste0("obs_add", input$Add_row_head), "Number of fields or replicates:", NA),
                          h4("Erosion Rate Data"),
                          p(HTML("Please report in t ha<sup>-1</sup> yr<sup>-1</sup>, NA if not appropriate.")),
                          numericInput(paste0("mean_add", input$Add_row_head), "Mean rate:", NA),
                          numericInput(paste0("med_add", input$Add_row_head), "Median rate:", NA),
                          numericInput(paste0("net_add", input$Add_row_head), "Net rate:", NA),
                          numericInput(paste0("vol_add", input$Add_row_head), "Volumetric rate:", NA),
                          textInput(paste0("source_add", input$Add_row_head), "Citation:", value = "NA"),
                          textInput(paste0("collector_add", input$Add_row_head), "Contributor name:", value = "NA"),
                          textInput(paste0("link_add", input$Add_row_head), "Link or DOI:", value = "NA"),
                          actionButton("go", "Add item"),
                          easyClose = TRUE, footer = NULL ))
    })


# Add the new data to the datatable ---------------------------------------

  observeEvent(input$go, {
    new_row <- tibble(
      "Longitude" = input[[paste0("Long_add", input$Add_row_head)]], 
      "Latitute" = input[[paste0("Lat_add", input$Add_row_head)]], 
      "start_date" = input[[paste0("start_date_add", input$Add_row_head)]],
      "end_date" = input[[paste0("end_date_add", input$Add_row_head)]], 
      "land_cover" = input[[paste0("land_cover_add", input$Add_row_head)]], 
      "land_use" = input[[paste0("land_use_add", input$Add_row_head)]], 
      "textures" = input[[paste0("textures_add", input$Add_row_head)]], 
      "textures_gen" = input[[paste0("texture_gen_add", input$Add_row_head)]], 
      "texture_class" = input[[paste0("texture_class_add", input$Add_row_head)]], 
      "Annual_precipitation" = input[[paste0("annual_add", input$Add_row_head)]],
      "Precip_intensity" = input[[paste0("intense_add", input$Add_row_head)]],
      "method" = input[[paste0("method_add", input$Add_row_head)]],
      "process" = input[[paste0("process_add", input$Add_row_head)]],
      "scale" = input[[paste0("scale_add", input$Add_row_head)]],
      "obs_count" = input[[paste0("obs_add", input$Add_row_head)]],
      "Rslt_Mean" = input[[paste0("mean_add", input$Add_row_head)]], 
      "Rslt_Med" = input[[paste0("med_add", input$Add_row_head)]], 
      "Rslt_Net" = input[[paste0("net_add", input$Add_row_head)]],
      "Rslt_Net" = input[[paste0("net_add", input$Add_row_head)]],
      "Rslt_Vol" = input[[paste0("vol_add", input$Add_row_head)]],
      "Source_ref" = input[[paste0("source_add", input$Add_row_head)]],  
      "Collector_Ref" = input[[paste0("collector_add", input$Add_row_head)]],
      "Link" = input[[paste0("link_add", input$Add_row_head)]],
      )
    globaldata$Data <- rbind(globaldata$Data,new_row)
    removeModal()
  })
  
  
# Delete row function -----------------------------------------------------

# warning message
  observeEvent(input$Del_row_head,{
    showModal(
      if(length(input$Global_table_rows_selected)>=1 ){
        modalDialog(
          title = "Warning",
          paste("Are you sure you want to delete this row?" ),
          footer = tagList(
            modalButton("Cancel"),
            actionButton("ok", "Yes")
          ), easyClose = TRUE)
      }
      else {
        modalDialog(
          title = "Attention",
          paste("Please select the row you wish to delete." ), 
          easyClose = TRUE)
      }
      )
  })
  
  # delete rows function on pressing 'Yes'
  observeEvent(input$ok, {
    globaldata$Data <- globaldata$Data[-input$Global_table_rows_selected,]
    removeModal()
  })
  
  
# Download csv function ---------------------------------------------------

  output$Erosion_csv<- downloadHandler(
    filename = function() {
      paste("Soil_erosion_observations", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(tibble(globaldata$Data), file, row.names = FALSE)
    }
  )

