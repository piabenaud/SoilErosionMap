
#########################################################################################
#### Interactive map of UK data #########################################################
#########################################################################################


# Make the base map -------------------------------------------------------

output$map <- renderLeaflet({
  leaflet() %>%  
    setView(lng = -1.542, lat = 54.992, zoom = 6) %>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Colour") %>%
    addProviderTiles(providers$Esri.WorldImagery,
                     options = providerTileOptions(opacity = 0.3), group = "Colour") %>% 
    addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Gray-scale")
})


# Reactive expression - obsInBounds ---------------------------------------
 #creates subset of erosiondata based on observations that are in users bounds

obsInBounds <- reactive({
  if (is.null(input$map_bounds))
    return(erosiondata[FALSE,])
  
  bounds <- input$map_bounds
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  subset(erosiondata,
         Lat >= latRng[1] & 
           Lat <= latRng[2] &
           Long >= lngRng[1] & 
           Long <= lngRng[2] &
           Land_cover == "Arable")
})


# Reactive plot - Erosion histogram ---------------------------------------

output$histRate <- renderPlot({
  if (nrow(obsInBounds()) == 0) # If zero observations are in view, don't plot
    return(NULL)
  
  ggplot(obsInBounds(), aes(Rslt_Analysis)) +  
    geom_histogram(colour= "gray20", fill="#4575b4", binwidth = 0.1) + 
    scale_y_continuous(breaks=c(0,1,10,50),trans="log1p", labels=c(0,1,10,50), limits = c(0, 50)) + 
    scale_x_continuous(breaks=c(0,1,10,100),trans="log1p",labels=c(0,1,10,100), limits = c(0, 100)) +
    labs(title = "Erosion rate for visible arable records", x = expression(Erosion~rate~(t~ha^{-1}~yr^{-1})), y = "Frequency") + #title for all plots
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5, colour = "gray20"),
          plot.title = element_text(colour = "gray20", size = 12, face = "bold"))
})


# Reactive plot - Study methods -------------------------------------------

output$methRate <- renderPlot({
  if (nrow(obsInBounds()) == 0)
    return(NULL)   # If zero observations are in view, don't plot
  
  ggplot(obsInBounds(), aes(Stdy_Meth1, Rslt_Analysis)) +  
    stat_boxplot(geom ='errorbar') +
    geom_boxplot(colour= "gray20",
                 fill="#4575b4",
                 outlier.alpha = 0.25)+
    scale_y_continuous(breaks = c(0,1,10,100),trans = "log1p", labels=c(0,1,10,100), limits = c(-0.15, 100)) +
    scale_x_discrete(limits = c("Volumetric survey", "Runoff and sediment collection", "Caesium-137"), labels = c("Volumetric\nsurvey", "Runoff and\nsediment\ncollection", "Caesium-137")) +
    labs( x= "Monitoring Technique", y = expression(Erosion~rate~(t~ha^{-1}~yr^{-1}))) +
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5)) +
    stat_summary(fun.data = n_fun, geom = "text", size = 2.5, colour= "gray20", position = position_dodge(.9))  ## adds n to plot
}) 


# Reactive plot - Site selection ------------------------------------------

output$selectRate <- renderPlot({
  if (nrow(obsInBounds()) == 0)
    return(NULL)
  
  ggplot(obsInBounds(), aes(Site_selection, Rslt_Analysis)) +  
    stat_boxplot(geom ='errorbar') +
    geom_boxplot(colour = "gray20",
                 fill = "#4575b4",
                 outlier.alpha = 0.25) +
    scale_y_continuous(breaks=c(0,1,10,100),trans="log1p", labels=c(0,1,10,100), limits = c(-0.15, 100)) +
    scale_x_discrete(labels = c("Known to\n erode", "Predicted\n to erode", "Sampling\n grid", "Other")) +
    labs( x= "Site Selection", y = expression(Erosion~rate~(t~ha^{-1}~yr^{-1})), caption = "Based on data presented in DOI, where 0 = not detected") + #caption for whole pane
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5)) +
    stat_summary(fun.data = n_fun, geom = "text", size = 2.5, colour= "gray20", position = position_dodge(.9)) 
}) 


# Transect data vis -----------------------------------------------------------

# polygon colours - colours are not reactive
polycol <-  colorBin(palette =c("black", "#74add1", "#4575b4", "#313695"), domain = transectsWGS$Rate_Med, bins = c(0,0.01,1,10,100), pretty = FALSE)

popup_tran <- paste("<b>","County:","</b>", transectsWGS$County, "<br>",
                  "<b>","Year:","</b>", transectsWGS$Study_star, "<br>",
                  "<b>","Method:","</b>", transectsWGS$Study_meth, "<br>",
                  "<b>","Site selection:","</b>", "Predicted to erode", "<br>",
                  "<b>","Area of farmland surveyed (ha):","</b>", transectsWGS$Study_area, "<br>",
                  "<b>","Erosion rate - Median:","</b>", transectsWGS$Rate_Med, "<br>",
                  "<b>","Erosion rate - Maximum:","</b>", transectsWGS$Rate_Max, "<br>",
                  "<b>","Reference:","</b>", transectsWGS$Reference_)


# Lowland popups ----------------------------------------------------------

popup_low <- paste0("<b>","Land Cover: ","</b>", erosiondata_lowland$Land_cover, "<br>",
                  "<b>","Study ID: ","</b>", erosiondata_lowland$Site_ID, "<br>",
                  "<b>","Study Start: ","</b>", htmlEscape(erosiondata_lowland$Stdy_Start), "<br>",
                  "<b>","Study Finish: ","</b>", htmlEscape(erosiondata_lowland$Stdy_Fin), "<br>",
                  "<b>","County: ","</b>", erosiondata_lowland$County_Dis, "<br>",
                  "<b>","Soil Association: ","</b>", htmlEscape(erosiondata_lowland$Soil_Assoc), "<br>",
                  "<b>","Method: ","</b>", erosiondata_lowland$Stdy_Meth1, "<br>",
                  "<b>","Scale: ","</b>", erosiondata_lowland$Stdy_Scale, "<br>",
                  "<b>","Site selection: ","</b>", erosiondata_lowland$Site_selection, "<br>",
                  "<b>","Erosion rate: Mean: ","</b>", erosiondata_lowland$Rslt_Mean, "<br>",
                  "<b>","Erosion rate: Median: ","</b>", erosiondata_lowland$Rslt_Med, "<br>",
                  "<b>","Erosion rate: Minimum: ","</b>", erosiondata_lowland$Rslt_Min, "<br>",
                  "<b>","Erosion rate: Maximum: ","</b>", erosiondata_lowland$Rslt_Max, "<br>",
                  "<b>","Erosion rate: Net: ","</b>", erosiondata_lowland$Rslt_Net, "<br>",
                  "<b>","Erosion rate: Gross: ","</b>", erosiondata_lowland$Rslt_Gross, "<br>",
                  "<b>","Erosion volume: ","</b>", erosiondata_lowland$Rslt_Vol, "<br>",
                  "<b>","Erosion rate: Calculations: ","</b>", erosiondata_lowland$Rslt_Analysis, "<br>",
                  "<b>","Reference: ","</b>", erosiondata_lowland$Reference, "<br>",
                  "<a href='", erosiondata_lowland$Link, "' target='_blank'>", "Link</a>")

# Upland popups ----------------------------------------------------------

popup_up <- paste0("<b>","Land Cover: ","</b>", erosiondata_upland$Land_cover, "<br>",
                    "<b>","Study ID: ","</b>", erosiondata_upland$Site_ID, "<br>",
                    "<b>","Study Start: ","</b>", htmlEscape(erosiondata_upland$Stdy_Start), "<br>",
                    "<b>","Study Finish: ","</b>", htmlEscape(erosiondata_upland$Stdy_Fin), "<br>",
                    "<b>","Site selection: ","</b>", erosiondata_upland$Site_selection, "<br>",
                    "<b>","County: ","</b>", erosiondata_upland$County_Dis, "<br>",
                    "<b>","Soil Association: ","</b>", htmlEscape(erosiondata_upland$Soil_Assoc), "<br>",
                    "<b>","Method: ","</b>", erosiondata_upland$Stdy_Meth1, "<br>",
                    "<b>","Scale: ","</b>", erosiondata_upland$Stdy_Scale, "<br>",
                    "<b>","Erosion volume: ","</b>", erosiondata_upland$Rslt_Vol, "<br>",
                    "<b>","Erosion rate: Calculations: ","</b>", erosiondata_upland$Rslt_Analysis, "<br>",
                    "<b>","Reference: ","</b>", erosiondata_upland$Reference, "<br>",
                    "<a href='", erosiondata_upland$Link, "' target='_blank'>", "Link</a>")


# Specify marker radius --------------------------------------------------------

rad_low <- ifelse(erosiondata_lowland$Rslt_Analysis <= 10, ((erosiondata_lowland$Rslt_Analysis+10)*200), 5000)
rad_up <- ifelse(erosiondata_upland$Rslt_Analysis <= 100, ((erosiondata_upland$Rslt_Analysis+10)*50), 5000)


# Allocate colour palettes ------------------------------------------------

# These observers are responsible for maintaining the colour of the circles and legend,
# according to the variables the user has chosen to map to color
observe({
  colorBy_low <- input$colour_low
  colorBy_up <- input$colour_up
  
  if (colorBy_low == "Rslt_Analysis") {
    colorData_low <- erosiondata_lowland$Rslt_Analysis
    pal <- colorBin(c("black", "#74add1", "#4575b4","#313695"), domain = colorData_low, bins = c(0,0.01,1,10,100), na.color = NA)
  } else {
    colorData_low <- erosiondata_lowland[[colorBy_low]]
    pal <- colorFactor(c("#440154FF", "#31688EFF", "#35B779FF","#FDE725FF"), colorData_low)
  }
 
  if (colorBy_up == "Rslt_Analysis") {
    colorData_up <- erosiondata_upland$Rslt_Analysis
    pal2 <- colorBin(c("black", "#ffffbf", "#fdae61", "#f46d43", "#a50026"), colorData_up, c(0.000,0.01,1,10,100, 10000), pretty = FALSE, na.color = NA)
  } else {
    colorData_up <- erosiondata_upland[[colorBy_up]]
    pal2 <- colorFactor(c("#440154FF", "#31688EFF", "#35B779FF","#FDE725FF"), colorData_up)
  }


  leafletProxy("map") %>%  # adds shapes onto map
    clearShapes() %>%
    addPolygons(data = transectsWGS, color = "gray20", fillOpacity = 0.5, weight = 0.25, fillColor = ~polycol(Rate_Med), popup = popup_tran) %>%
    addCircles(data = erosiondata_lowland, group = "Lowland", ~Long, ~Lat, radius = rad_low, layerId=~Site_ID,
               stroke=FALSE, fillOpacity=0.65, fillColor=pal(colorData_low), popup = popup_low) %>%
    addCircles(data = erosiondata_upland, group = "Upland", ~Long, ~Lat, radius= rad_up, layerId=~Site_ID,
               stroke=FALSE, fillOpacity=0.65, fillColor=pal2(colorData_up), popup = popup_up) %>%
    addLayersControl(
      options = layersControlOptions(collapsed = FALSE),
      overlayGroups = c("Lowland", "Upland"),
      baseGroups = c("Colour", "Gray-scale"),
      position = "topleft") %>% 
    addLegend("topleft", group = "Lowland", pal=pal, values=colorData_low, title= "Lowland data",
              layerId="colorLegend2") %>% 
    addLegend("topleft",  group = "Upland", pal=pal2, values=colorData_up, title= "Upland data",
              layerId="colorLegend1")
})


# Create pop-ups to display on click --------------------------------------

#showSitePopup <- function(Site_ID, lat, lng) {
#  selectedSite <- erosiondata[erosiondata$Site_ID == Site_ID,]
#  content <- as.character(tagList(
#    tags$h5("Land Cover: ", selectedSite$Land_cover),
#    sprintf("Study ID: %s", selectedSite$Site_ID),tags$br(),
#    sprintf("Study Start: %s", selectedSite$Stdy_Start),tags$br(),
#    sprintf("Study Finish: %s", selectedSite$Stdy_Fin),tags$br(),
#    sprintf("County: %s", selectedSite$County_Dis),tags$br(),
#    sprintf("Soil Association: %s", selectedSite$Soil_Assoc),tags$br(),
#    sprintf("Soil Series: %s", selectedSite$Soil_series),tags$br(),
#    sprintf("Scale: %s", selectedSite$Stdy_Scale),tags$br(),
#    sprintf("Method: %s", selectedSite$Stdy_Meth1),tags$br(),
#    sprintf("Erosion:Mean: %s", selectedSite$Rslt_Mean),tags$br(),
#    sprintf("Erosion:Median: %s", selectedSite$Rslt_Med),tags$br(),
#    sprintf("Erosion:Minimum: %s", selectedSite$Rslt_Min),tags$br(),
#    sprintf("Erosion:Maximum: %s", selectedSite$Rslt_Max),tags$br(),
#    sprintf("Erosion:Net: %s", selectedSite$Rslt_Net),tags$br(),
#    sprintf("Erosion:Gross: %s", selectedSite$Rslt_Gross),tags$br(),
#    sprintf("Erosion:Volume: %s", selectedSite$Rslt_Vol),tags$br(),
#    sprintf("Erosion:Calculations: %s", selectedSite$Rslt_Analysis),tags$br(),
#    sprintf("Process: %s", selectedSite$Pathway_1),tags$br(),
#    sprintf("Reference: %s", selectedSite$Reference),tags$br(),
#    sprintf("Link: %s", selectedSite$Link)
#  ))
#  leafletProxy("map") %>% addPopups(lng, lat, content, layerId = Site_ID)
#}

# When map is clicked, show a popup with erosion observation information
#observe({
#  leafletProxy("map") %>% clearPopups()
#  event <- input$map_shape_click
#  if (is.null(event))
#    return()
  
#  isolate({
#    showSitePopup(event$id, event$lat, event$lng)
#  })
#})

