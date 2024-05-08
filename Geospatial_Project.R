library(sf)
library(dplyr)
library(tmap)
library(writexl)

########################
# Name: Aileen Gonzalez
# Task: QMSS 301 Project 1 - Geospatial Analysis
########################

setwd("/Users/aigonz/Desktop/QMSS301/Project 1 - Geospatial Project/Data")

# The aim of this project is to map some geospatial data, do some simple analysis with the data and interpret the result in a final report.
# You have been contacted by the city of Detroit to help glean insights from the geospatial data that has been gathered. In getting the task done, you are provided with 4 shapefiles to work with, which are briefly described below:
# • Neighborhood shapefile: This is a vector polygon that consists of 205 neighborhoods in the city of Detroit.
# • Zipcode: It is also a vector polygon that consists of 31 zip code areas in the city of Detroit.
# • Grocery stores: This is a vector point of 74 grocery stores in Detroit.
# • Crime: It is also a vector point of crime incidents in Detroit. You are only going to work with data for year 2021. Therefore, after you read-in your crime shapefile, and rightly projected it, filter the crime incidents that occurred in the 2021. That is what you will use for the project.
# You are meant to perform two major tasks with the datasets. As expected, you are supposed to reproject the data appropriately before performing any task.

# read in neighborhoods, grocery stores, and crimes data
neighborhoods <- st_read("Neighborhoods.shp")
grocery_stores <- st_read("Grocery_Stores_in_City_of_Detroit_Public_View.shp")
crimes <- st_read("RMS_Crime_Incidents.shp")

# check if projected
st_is_longlat(neighborhoods)
st_is_longlat(grocery_stores)
st_is_longlat(crimes)
# all true means all are unprojected

# project all 
neighborhoods_proj <- st_transform(neighborhoods, crs = 5623)
grocery_stores_proj <- st_transform(grocery_stores, crs = 5623)
crimes_proj <- st_transform(crimes, crs = 5623)
# 5623 is EPSG code for Michigan East [which includes Detroit]

# check again if projected
st_is_longlat(neighborhoods_proj)
st_is_longlat(grocery_stores_proj)
st_is_longlat(crimes_proj)
# all false now so all are now projected

# filter crime incidents to those that occurred in 2021
crimes_2021_proj <- crimes_proj %>% 
  filter(year == 2021)
# data is ready to use for the project

# Task 1: Crime Incidents in Detroit’s Neighborhood and zip code areas.
# 1. Make a map of Detroit neighborhoods. Color the neighborhoods that have less than 100 crime incidents in 2021 with ‘green’, and neighborhoods that have more than 1200 crime incidents in 2021 with ‘red’. Make sure there is no frame around your map and title it appropriately.

# Finding the number of crimes in each neighborhood
crimes_by_neigh <- st_within(crimes_2021_proj, neighborhoods_proj, sparse = FALSE) 
# Summing up the numbers
crimes_by_neigh_app <- apply(X = crimes_by_neigh, MARGIN = 2,FUN = sum)
# Binding the crimes_by_neigh_app data with the neighborhoods_proj data
neigh_crimes <- cbind(neighborhoods_proj, crimes_by_neigh_app)
neigh_crimes

#filter data by <100 crime and >1200 crime
less_than_100 <- neigh_crimes %>% 
  filter(crimes_by_neigh_app < 100)

more_than_1200 <- neigh_crimes %>% 
  filter(crimes_by_neigh_app > 1200)

# Creating map with crimes less_than_100 & more_than_1200 layers on top of neighborhood layer
tm_shape(neighborhoods_proj) + tm_polygons(alpha = 0.8) +
          tm_shape(less_than_100) + tm_fill(col = "green") +
          tm_shape(more_than_1200) + tm_fill(col = "red")  +
          tm_layout(main.title = "Map of Detroit Neighborhoods and Crime Incidents in 2021",
                  main.title.position = "center",
                  main.title.size = 1,
                  frame = FALSE) +
  #extra:
tm_credits("(c) Aileen Gonzalez", position=c("left", "bottom"))

# 2. Make a map of the zip code areas in Detroit. Color the zip code areas that have less than 1000 crime incidents in 2021 with ‘green’, and zip code areas that have more than 5000 crime incidents in 2021 with ‘red’. Make sure there is no frame around your map and title it appropriately. Go a little further to include the zip codes of each area in the map.

#read in zipcode data
zipcodes <- st_read("zip_codes.shp")

# figure out if projected
st_is_longlat(zipcodes)
# returns true so means unprojected

# project
zipcodes_proj <- st_transform(zipcodes, crs = 5623)
# 5623 is EPSG code for Michigan East

# check again if projected
st_is_longlat(zipcodes_proj)
# now false, so now projected

# Finding the number of crimes in each zipcode
crimes_by_zip <- st_within(crimes_2021_proj, zipcodes_proj, sparse = FALSE) 
# Summing up the numbers
crimes_by_zip_app <- apply(X = crimes_by_zip, MARGIN = 2,FUN = sum)
# Binding the crimes_by_zip_app data with the zipcodes_proj data
zip_crimes <- cbind(zipcodes_proj, crimes_by_zip_app)
zip_crimes

#filter data by <1000 crime and >5000 crime
less_than_1000 <- zip_crimes %>% 
  filter(crimes_by_zip_app < 1000)

more_than_5000 <- zip_crimes %>% 
  filter(crimes_by_zip_app > 5000)

# Creating map with crimes less_than_1000 [in green] & more_than_5000 [in red] layers on top of zipcodes layer, includes text of zipcodes
tm_shape(zipcodes_proj) + tm_polygons(alpha = 0.8) +
  tm_shape(less_than_1000) + tm_fill(col = "green") +
  tm_shape(more_than_5000) + tm_fill(col = "red")  +
  tm_shape(zipcodes_proj) + tm_text('zipcode', size = 0.6) +
  tm_layout(main.title = "Map of Detroit Zipcodes and Crime Incidents in 2021",
            main.title.position = "center",
            main.title.size = 1,
            frame = FALSE) +
  #extra:
  tm_credits("(c) Aileen Gonzalez", position=c("left", "bottom"))


# Task 2: Robbery Incidents around grocery stores. (Note: Robbery incidents, not crime).
# 1. Make a map of Detroit neighborhoods and grocery store locations. On the same map, plot
# two(2) buffered zones: half a mile and 1 mile radii around each grocery store. Make sure you color the buffered zones and their borders. You can use any color, but be sure that the colors are well blended.

# Create a buffer of 0.5 mile radius around each grocery store
gro_half_buff <- st_buffer(grocery_stores_proj, dist = 2640)

# Create a buffer of 1 mile radius around each grocery store
gro_1m_buff <- st_buffer(grocery_stores_proj, dist = 5280)

# Creating map with grocery half buffer [in red] & grocery 1 mile buffer [in green] layers on top of neighborhoods layer with black dots indicating grocery store locations
tm_shape(neighborhoods_proj) + tm_polygons(alpha = 0.3) +
  tm_shape(grocery_stores_proj) + tm_dots(col = "black", size = 0.1) +
  tm_shape(gro_half_buff) + tm_borders(col = "red") + tm_fill(col = "red", alpha = 0.2) +
  tm_shape(gro_1m_buff) + tm_borders(col = "green") + tm_fill(col = "green", alpha = 0.2) +
  tm_layout(main.title = "Map of Grocery Stores in Detroit",
            main.title.position = "center",
            main.title.size = 1,
            frame = FALSE) +
  #extra:
  tm_credits("(c) Aileen Gonzalez", position=c("left", "bottom"))

# 2. Find the numbers of robbery incidents that happened within half a mile and 1 mile radii of the grocery stores. Make descriptive statistics for each of the robbery incidents variables. Export the data to an excel spreadsheet with only 4 columns: store names, address, and number of robberies within half mile, 1 mile. Do not forget to delete the ‘geometry’ column before exporting your data.
# NOTE: There is a column in the crime shapefile named ‘offense_de’. It describes the nature of the crime incidents. So, you are meant to use crime incidents that are ‘Robbery’ in this task.

# Filter crime data for 'Robbery' incidents
robbery_incidents <- crimes_2021_proj %>%
  filter(offense_de == "ROBBERY")

#Getting the number of robbery incidents within half a mile radii of the grocery stores
rob_within_half <- st_within(robbery_incidents, gro_half_buff, sparse = FALSE)
#Getting the number of robbery incidents within mile radii of the grocery stores
rob_within_1m <- st_within(robbery_incidents, gro_1m_buff, sparse = FALSE)

#Number of robberies: Summing the number of robberies around the grocery stores
num_robs_within_half <- apply(X = rob_within_half, MARGIN=2,FUN=sum)
num_robs_within_1m <- apply(X = rob_within_1m, MARGIN=2,FUN=sum)

# Descriptive statistics for each of the robbery incidents variables
summary(num_robs_within_half)
summary(num_robs_within_1m)

# Binding the grocery store data with the robbery data within half mile and 1miles
grocery_robberies <- cbind(grocery_stores_proj, num_robs_within_half, num_robs_within_1m)

colnames(grocery_robberies)

# Creating a new objects by selecting few columns
grocery_robberies1 <- grocery_robberies %>% 
  select(Store_Name, Address, num_robs_within_half, num_robs_within_1m)

class(grocery_robberies1)

# Dropping the geometry column
grocery_robberies1 <- st_drop_geometry(grocery_robberies1)

class(grocery_robberies1)

# Save the data
save(grocery_robberies1, file = "detroit grocery stores and robberies.RData")

# save as excel
write_xlsx(grocery_robberies1, 'detroit grocery stores and robberies.xlsx')
