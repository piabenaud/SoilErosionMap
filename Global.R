
#########################################################################################
#### Data, preparation and formatting ###################################################
#########################################################################################

# Load packages -----------------------------------------------------------

library(dplyr)
library(readr)
library(rgdal) # to load shapefiles and change coords (Needs libary(sp) as part of install)


# Load the geodatabase ----------------------------------------------------

erosiondata <- read_csv('Data/main_database_WGS.csv')
#head(erosiondata) # quick sense check


# Load and transform transect data ----------------------------------------

# name CRS codes for BNG and WSG84
#ukgrid <- "+init=epsg:27700" # BNG
#wgs84 <- "+init=epsg:4326" # WGS84

# Load transect data
#transectsBNG <- readOGR("Data/transect", "transect")

# Convert BNG coordinates to WGS84
#transectsWGS <- spTransform(transectsBNG, 
#                            CRS(wgs84))

#writeOGR(transectsWGS, "Data/transect", "transectsWGS", driver="ESRI Shapefile" )
#rm(transectsBNG) # tidy up

# Load transect data
transectsWGS <- readOGR("Data/transect", "transectsWGS")

# Some extra data preparation ---------------------------------------------

# more appropriate precision 
erosiondata <- erosiondata %>% 
  mutate(Rslt_Analysis = round(Rslt_Analysis,digits = 1)) 


# add jitter to point observations to remove clustering/masking when multiple observations in one location
erosiondata <- erosiondata %>% 
  mutate(Long = jitter(Long, factor = 25),
         Lat = jitter(Lat, factor = 25))


# recode site selection to a useful description
erosiondata <- erosiondata %>% 
  mutate(Site_selection = recode_factor(Site_selection,
                                 '1' = "Known to erode",
                                 '2' = "Predicted to erode",
                                 '3' = "Sampling grid",
                                 '4' = "Statistical design",
                                 '5' = "Other")) %>% 
  mutate(Stdy_Meth1 = recode_factor(Stdy_Meth1,
                                    'Caesium-137' = "Caesium-137",
                                    'Runoff and sediment collection' = "Runoff and sediment collection",
                                    'Volumetric survey' = "Volumetric survey"))

# arrange data by Rslt_Analysis (used in paper) for better visualisation
erosiondata <- erosiondata %>% 
  arrange(Land_cover, desc(Rslt_Analysis))

# Split into upland and lowland -------------------------------------------

erosiondata_lowland <- erosiondata %>% 
  filter(Land_cover != "Upland")

erosiondata_upland <- erosiondata %>% 
  filter(Land_cover == "Upland")


# Preparation for data tab ------------------------------------------------


# active link for datatable tab
#erosiondata$Link <- paste0("<a href='", erosiondata$Link, "' target='_blank'>", "More info</a>")

# select data to be visualised
cleantable <- erosiondata %>%
  select("Easting" = Easting,
         "Northing" = Northing,
         "County" = County_Dis,
         "Soil Association" = Soil_Assoc,
         "Soil Series" = Soil_series,
         "Land Cover" = Land_cover,
         "Study Start" = Stdy_Start,
         "Study Finish" = Stdy_Fin,
         "Scale" = Stdy_Scale,
         "Method" = Stdy_Meth1,
         "Erosion:Mean" = Rslt_Mean,
         "Erosion:Median" = Rslt_Med,
         "Erosion:Minimum" = Rslt_Min,
         "Erosion:Maximum" = Rslt_Max,
         "Erosion:Net" = Rslt_Net,
         "Erosion:Gross" = Rslt_Gross,
         "Erosion:Volume" = Rslt_Vol,
         "Erosion:Calculations" = Rslt_Analysis,
         "Process" = Pathway_1,
         "Reference" = Reference,
         "Link" = Link,
         "Lat" = Lat,
         "Long" = Long) %>% 
  mutate(Link = paste0("<a href='", Link,"' target='_blank'>Link</a>")) #html format for link


# Function for adding n to plots ------------------------------------------

n_fun <- function(x){ 
  return(data.frame(y = -0.15, label = paste0("n = ",length(x))))
  }


# Fields for the contribute data tab --------------------------------------

landcover <- c("NA",
               "Arable",
               "Upland",
               "Improved grassland",
               "Woodland",
               "Badlands",
               "Orchard",
               "Horticulture")


landuse <- c("NA",
             "Bare soil",
             "Winter maize",
             "Winter cereal",
             "Spring maize",
             "Spring cereal",
             "Potatoes",
             "Bog",
             "Upland Grassland",
             "Upland Heath",
             "Cattle",
             "Pigs",
             "Sheep",
             "Broadleaf Woodland",
             "Coniferous Woodland",
             "Vineyard",
             "Olive Orchard",
             "Fruit Orchard",
             "Experimental", 
             "Lay",
             "Grassland")


textures <- c("NA",
              "peat", 
              "loamy peat", 
              "peaty loam", 
              "peaty sand", 
              "medium sand", 
              "fine sand", 
              "loamy coarse sand", 
              "loamy medium sand", 
              "loamy fine sand", 
              "coarse sandy loam", 
              "medium sandy loam", 
              "fine sandy loam", 
              "coarse sandy silt loam", 
              "medium sandy silt loam", 
              "fine sandy silt loam", 
              "sandy clay loam", 
              "silt loam",
              "silty clay loam", 
              "silty clay", 
              "clay loam", 
              "clay")


textures_gen <- c("NA",
              "peat", 
              "loamy peat", 
              "peaty loam", 
              "peaty sand", 
              "sand", 
              "loamy sand", 
              "sandy loam", 
              "sandy silt loam", 
              "sandy clay loam", 
              "silt loam",
              "silty clay loam", 
              "silty clay", 
              "clay loam", 
              "clay")


texture_class <- c("NA",
                   "SSEW",
                   "USDA",
                   "Other")


methods <- c("NA",
             "Volumetric - transects",
             "Volumetric - remote sensing",
             "Volumetric - other",
             "Caesium-137",
             "Runoff and sediment collection",
             "Other")


processes <- c("NA",
               "Water",
               "Water - sheetwash",
               "Water - rills",
               "Water - gullies",
               "Water - rills and gullies",
               "Tillage",
               "SLCH",
               "Wind",
               "All",
               "Other")


scales <- c("NA",
            "Plot",
            "Hillslope",
            "Field",
            "Catchment",
            "Regional")


fields <- c("Long", "Lat", "start_date", "end_date", 
            "land_cover", "land_use", "textures", "textures_gen", "texture_class", 
            "Annual_precipitation", "Precip_intensity",
            "method", "process", "scale", 
            "Rslt_Mean", "Rslt_Med", "Rslt_Net", 
            "Source_ref",  "Collector_Ref", "Link")




