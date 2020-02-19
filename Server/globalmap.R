
#########################################################################################
#### Interactive global  #########################################################
#########################################################################################


# Set the colour palette --------------------------------------------------

palG <- colorBin(c("black", "#FDE725FF", "#31688EFF", "#440154FF", "#35B779FF"), erosiondata$Rslt_Analysis, c(0.000,0.01,1,10,100,10000), pretty = FALSE)


# Determine pop-up content ------------------------------------------------

popup_g <- paste0("<b>","Land Cover: ","</b>", erosiondata$Land_cover, "<br>",
                    "<b>","Study ID: ","</b>", erosiondata$Site_ID, "<br>",
                    "<b>","Study Start: ","</b>", htmlEscape(erosiondata$Stdy_Start), "<br>",
                    "<b>","Study Finish: ","</b>", htmlEscape(erosiondata$Stdy_Fin), "<br>",
                    "<b>","County: ","</b>", erosiondata$County_Dis, "<br>",
                    "<b>","Soil Association: ","</b>", htmlEscape(erosiondata$Soil_Assoc), "<br>",
                    "<b>","Method: ","</b>", erosiondata$Stdy_Meth1, "<br>",
                    "<b>","Scale: ","</b>", erosiondata$Stdy_Scale, "<br>",
                    "<b>","Site selection: ","</b>", erosiondata$Site_selection, "<br>",
                    "<b>","Erosion rate: Mean: ","</b>", erosiondata$Rslt_Mean, "<br>",
                    "<b>","Erosion rate: Median: ","</b>", erosiondata$Rslt_Med, "<br>",
                    "<b>","Erosion rate: Minimum: ","</b>", erosiondata$Rslt_Min, "<br>",
                    "<b>","Erosion rate: Maximum: ","</b>", erosiondata$Rslt_Max, "<br>",
                    "<b>","Erosion rate: Net: ","</b>", erosiondata$Rslt_Net, "<br>",
                    "<b>","Erosion rate: Gross: ","</b>", erosiondata$Rslt_Gross, "<br>",
                    "<b>","Erosion volume: ","</b>", erosiondata$Rslt_Vol, "<br>",
                    "<b>","Erosion rate: Calculations: ","</b>", erosiondata$Rslt_Analysis, "<br>",
                    "<b>","Reference: ","</b>", erosiondata$Reference, "<br>",
                    "<b>",erosiondata$Link,"</b>")


# Make the map ------------------------------------------------------------

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
      addCircles(data = erosiondata, group = "Erosion Rate", ~Long, ~Lat, radius= 1500, layerId=~Site_ID,
                 stroke=FALSE, fillOpacity=0.65, fillColor = ~palG(Rslt_Analysis), popup = popup_g) %>%
    addLayersControl(
      options = layersControlOptions(collapsed = FALSE),
      baseGroups = c("Cluster", "Erosion Rate"),
      position = "topleft") %>%
    addLegend("topleft", group = "Erosion Rate", pal=palG, values=erosiondata$Rslt_Analysis, title= "Erosion Rate",
              layerId="colorLegend")
  })



# Build the reactive plots ------------------------------------------------

# A reactive expression that returns the set of observations that are in bounds right now
obsInBoundsG <- reactive({
  if (is.null(input$mapG_bounds))
    return(erosiondata[FALSE,])
  bounds <- input$mapG_bounds
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  
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


## Done
