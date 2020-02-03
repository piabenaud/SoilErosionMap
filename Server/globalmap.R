
#### Interactive global map ####

palG <- colorBin(c("#33a02c", "#b2df8a", "#1f78b4", "#ff7f00", "#e31a1c"), erosiondata$Rslt_Analysis, c(0.000,0.01,1,10,100, 10000), pretty = FALSE)

output$mapG <- renderLeaflet({
  leaflet() %>%  
    setView(lng = 41.902919, lat = 12.464344, zoom = 2.5)%>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik) %>%
    addProviderTiles(providers$Esri.WorldImagery,
                     options = providerTileOptions(opacity = 0.5)) %>%
    addCircleMarkers(data = erosiondata, group = "Cluster", ~Long, ~Lat, layerId=~Site_ID, stroke=FALSE, fillOpacity=0.7,  
                     clusterOptions = markerClusterOptions(iconCreateFunction=JS("function (cluster) {      
                                                                                 var childCount = cluster.getChildCount(); 
                                                                                 var c = ' marker-cluster-';  
                                                                                 if (childCount < 10) {  
                                                                                 c += 'large';  
                                                                                 } else if (childCount < 100) {  
                                                                                 c += 'medium';  
                                                                                 } else { 
                                                                                 c += 'small';  
                                                                                 }    
                                                                                 return new L.DivIcon({ html: '<div><span>' + childCount + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(40, 40) });
}"))) %>%
      addCircles(data = erosiondata, group = "Erosion Rate", ~Long, ~Lat, radius= 1000, layerId=~Site_ID,
                 stroke=FALSE, fillOpacity=0.65, fillColor = ~palG(Rslt_Analysis)) %>%
    addLayersControl(
      options = layersControlOptions(collapsed = FALSE),
      baseGroups = c("Cluster", "Erosion Rate"),
      position = "topleft") %>%
    addLegend("topleft", group = "Erosion Rate", pal=palG, values=erosiondata$Rslt_Analysis, title= "Erosion Rate",
              layerId="colorLegend")
  })


# A reactive expression that returns the set of observations that are in bounds right now
obsInBoundsG <- reactive({
  if (is.null(input$mapG_bounds))
    return(erosiondata[FALSE,])
  bounds <- input$mapG_bounds
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  ##############################################################################
  ##########-------UPDATE to GOOGLEDOC!!!-------------################
  subset(erosiondata,
         Lat >= latRng[1] & Lat <= latRng[2] &
           Long >= lngRng[1] & Long <= lngRng[2] &
           Land_cover == "Arable")
})

output$histRateG <- renderPlot({
  # If no observations are in view, don't plot
  if (nrow(obsInBoundsG()) == 0)
    return(NULL)
  
  ggplot(obsInBoundsG(), aes(Rslt_Analysis)) +     ####################### NEED TO UPDATE   
    geom_histogram(colour= "gray20", fill="#4575b4", binwidth = 0.1) + 
    scale_y_continuous(breaks=c(0,1,10,50),trans="log1p", labels=c(0,1,10,50), limits = c(0, 50)) + 
    scale_x_continuous(breaks=c(0,1,10,100),trans="log1p",labels=c(0,1,10,100), limits = c(0, 100)) +
    labs(title = "Erosion rate for visible arable records", x = expression(Erosion~rate~(t~ha^{-1}~yr^{-1})), y = "Frequency")+
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5, colour = "gray20"),
          plot.title = element_text(colour = "gray20", size = 12, face = "bold"))
})

#study methods boxplot
output$methRateG <- renderPlot({
  # If no observations are in view, don't plot
  if (nrow(obsInBoundsG()) == 0)
    return(NULL)
  
  ggplot(obsInBoundsG(), aes(Stdy_Meth1, Rslt_Analysis)) +  ####################### NEED TO UPDATE 
    stat_boxplot(geom ='errorbar') +
    geom_boxplot(colour= "gray20",
                 fill="#4575b4",
                 outlier.alpha = 0.25)+
    scale_y_continuous(breaks=c(0,1,10,100),trans="log1p", labels=c(0,1,10,100), limits = c(-0.15, 100)) +
    #scale_x_discrete(labels = function(x) str_wrap(x, width = 10), limits=c("Volumetric survey", "Runoff and sediment collection", "Caesium-137")) +
    scale_x_discrete(limits = c("Volumetric survey", "Runoff and sediment collection", "Caesium-137"), labels = c("Volumetric\nsurvey", "Runoff and\nsediment\ncollection", "Caesium-137")) +
    labs( x= "Monitoring Technique", y = expression(Erosion~rate~(t~ha^{-1}~yr^{-1})), caption = "Based on data presented in DOI, where 0 = not detected") +
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5)) +
    stat_summary(fun.data = n_fun, geom = "text", size = 2.5, colour= "gray20", position = position_dodge(.9))  ## adds n to plot
}) 


# Show a popup at the given location
showSitePopupG <- function(Site_ID, lat, lng) {
  selectedSiteG <- erosiondata[erosiondata$Site_ID == Site_ID,]
  content <- as.character(tagList(
    tags$h5("Land Cover: ", selectedSiteG$Land_cover),
    sprintf("Study ID: %s", selectedSiteG$Site_ID),tags$br(),
    sprintf("Study Start: %s", selectedSiteG$Stdy_Start),tags$br(),
    sprintf("Study Finish: %s", selectedSiteG$Stdy_Fin),tags$br(),
    sprintf("County: %s", selectedSiteG$County_Dis),tags$br(),
    sprintf("Soil Association: %s", selectedSiteG$Soil_Assoc),tags$br(),
    sprintf("Soil Series: %s", selectedSiteG$Soil_series),tags$br(),
    sprintf("Scale: %s", selectedSiteG$Stdy_Scale),tags$br(),
    sprintf("Method: %s", selectedSiteG$Stdy_Meth1),tags$br(),
    sprintf("Erosion:Mean: %s", selectedSiteG$Rslt_Mean),tags$br(),
    sprintf("Erosion:Median: %s", selectedSiteG$Rslt_Med),tags$br(),
    sprintf("Erosion:Minimum: %s", selectedSiteG$Rslt_Min),tags$br(),
    sprintf("Erosion:Maximum: %s", selectedSiteG$Rslt_Max),tags$br(),
    sprintf("Erosion:Net: %s", selectedSiteG$Rslt_Net),tags$br(),
    sprintf("Erosion:Gross: %s", selectedSiteG$Rslt_Gross),tags$br(),
    sprintf("Erosion:Volume: %s", selectedSiteG$Rslt_Vol),tags$br(),
    sprintf("Erosion:Calculations: %s", selectedSiteG$Rslt_Analysis),tags$br(),
    sprintf("Process: %s", selectedSiteG$Pathway_1),tags$br(),
    sprintf("Reference: %s", selectedSiteG$Reference),tags$br(),
    sprintf("Link: %s", selectedSiteG$Link)
  ))
  leafletProxy("mapG") %>% addPopups(lng, lat, content, layerId = Site_ID)
}

# When map is clicked, show a popup with erosion observation information
observe({
  leafletProxy("mapG") %>% clearPopups()
  event <- input$mapG_shape_click
  if (is.null(event))
    return()
  
  isolate({
    showSitePopupG(event$id, event$lat, event$lng)
  })
})