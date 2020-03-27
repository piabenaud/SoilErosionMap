
#########################################################################################
#### Interactive global  #########################################################
#########################################################################################


# Set the colour palette --------------------------------------------------

palG <- colorBin(c("black", "#31688EFF", "#35B779FF", "#440154FF", "#FDE725FF"), global_erosiondata$Rslt_Vis, c(0.000,0.01,1,10,100,10000), pretty = FALSE)


# Determine pop-up content ------------------------------------------------

popup_g <- paste0("<b>","Land Cover: ","</b>", global_erosiondata$land_cover, "<br>",
                  "<b>","Study Start: ","</b>", htmlEscape(global_erosiondata$start_date), "<br>",
                  "<b>","Study Finish: ","</b>", htmlEscape(global_erosiondata$end_date), "<br>",
                  "<b>","Country: ","</b>", global_erosiondata$Country, "<br>",
                  "<b>","Method: ","</b>", global_erosiondata$method, "<br>",
                  "<b>","Scale: ","</b>", global_erosiondata$scale, "<br>",
                  "<b>","Erosion rate: Mean: ","</b>", global_erosiondata$Rslt_Mean, "<br>",
                  "<b>","Erosion rate: Median: ","</b>", global_erosiondata$Rslt_Med, "<br>",
                  "<b>","Erosion rate: Net: ","</b>", global_erosiondata$Rslt_Net, "<br>",
                  "<b>","Erosion volume: ","</b>", global_erosiondata$Rslt_Vol, "<br>",
                  "<b>","Erosion rate: Displayed: ","</b>", global_erosiondata$Rslt_Vis, "<br>",
                  "<b>","Reference: ","</b>", global_erosiondata$Source_ref, "<br>",
                  "<b>","Collector: ","</b>", global_erosiondata$Collector_Ref, "<br>",
                  "<b>","<a href='", global_erosiondata$Link, "' target='_blank'>", "Link</a>","</b>")


# Make the map ------------------------------------------------------------

output$mapG <- renderLeaflet({
  leaflet() %>%  
    setView(lng = 41.902919, lat = 12.464344, zoom = 2.5)%>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik) %>%
    addProviderTiles(providers$Esri.WorldImagery,
                     options = providerTileOptions(opacity = 0.5)) %>%
    addCircleMarkers(data = global_erosiondata, group = "Cluster", ~Long, ~Lat, layerId=~Obs_num, stroke=FALSE, fillOpacity=0.7,  
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
      addCircles(data = global_erosiondata, group = "Erosion Rate", ~Long, ~Lat, radius= 1500, layerId=~Obs_num,
                 stroke=FALSE, fillOpacity=0.65, fillColor = ~palG(Rslt_Vis), popup = popup_g) %>%
    addLayersControl(
      options = layersControlOptions(collapsed = FALSE),
      overlayGroups = c("Cluster", "Erosion Rate"),
      position = "topleft") %>%
    addLegend("topleft", group = "Erosion Rate", pal=palG, values=global_erosiondata$Rslt_Vis, title= "Erosion Rate",
              layerId="colorLegend")
  })



# Build the reactive plots ------------------------------------------------

# A reactive expression that returns the set of observations that are in bounds right now
obsInBoundsG <- reactive({
  if (is.null(input$mapG_bounds))
    return(global_erosiondata[FALSE,])
  bounds <- input$mapG_bounds
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  
  subset(global_erosiondata,
         Lat >= latRng[1] & Lat <= latRng[2] &
           Long >= lngRng[1] & Long <= lngRng[2] &
           land_cover == "Arable")
})

output$histRateG <- renderPlot({
  # If no observations are in view, don't plot
  if (nrow(obsInBoundsG()) == 0)
    return(NULL)
  
  ggplot(obsInBoundsG(), aes(Rslt_Vis)) +      
    geom_histogram(colour= "gray20", fill="#4575b4", binwidth = 0.1) + 
    scale_y_continuous(breaks=c(0,1,10,50,100),trans="log1p", labels=c(0,1,10,50, 100), limits = c(0, 100)) + 
    scale_x_continuous(breaks=c(0,1,10,100),trans="log1p",labels=c(0,1,10,100), limits = c(0, 100)) +
    labs(title = "Erosion rate for visible arable records", x = expression(Erosion~rate~(t~ha^{-1}~yr^{-1})), y = "Frequency")+
    theme_classic() + 
    theme(axis.title = element_text(size = 10.5, colour = "gray20"),
          plot.title = element_text(colour = "gray20", size = 12, face = "bold"))
})


