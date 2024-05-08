Geospatial Analysis


The aim of this project is to map some geospatial data, do some simple analysis with the data and interpret the result in a final report.

Context: You have been contacted by the city of Detroit to help glean insights from the geospatial data that has been gathered. In getting the task done, you are provided with 4 shapefiles to work with, which are briefly described below:
• Neighborhood shapefile: This is a vector polygon that consists of 205 neighborhoods in the city of Detroit.
• Zipcode: It is also a vector polygon that consists of 31 zip code areas in the city of Detroit.
• Grocery stores: This is a vector point of 74 grocery stores in Detroit.
• Crime: It is also a vector point of crime incidents in Detroit. You are only going to work with data for year 2021. Therefore, after you read-in your crime shapefile, and rightly projected it, filter the crime incidents that occurred in the 2021. That is what you will use for the project.
You are meant to perform two major tasks with the datasets. As expected, you are supposed to reproject the data appropriately before performing any task.

Task 1: Crime Incidents in Detroit’s Neighborhood and zip code areas.
1. Make a map of Detroit neighborhoods. Color the neighborhoods that have less than 100 crime incidents in 2021 with ‘green’, and neighborhoods that have more than 1200 crime incidents in 2021 with ‘red’. Make sure there is no frame around your map and title it appropriately.
2. Make a map of the zip code areas in Detroit. Color the zip code areas that have less than 1000 crime incidents in 2021 with ‘green’, and zip code areas that have more than 5000 crime incidents in 2021 with ‘red’. Make sure there is no frame around your map and title it appropriately. Go a little further to include the zip codes of each area in the map.

Task 2: Robbery Incidents around grocery stores. (Note: Robbery incidents, not crime)
1. Make a map of Detroit neighborhoods and grocery store locations. On the same map, plot two(2) buffered zones: half a mile and 1 mile radii around each grocery store. Make sure you color the buffered zones and their borders. You can use any color, but be sure that the colors are well blended.
2. Find the numbers of robbery incidents that happened within half a mile and 1 mile radii of the grocery stores. Make descriptive statistics for each of the robbery incidents variables. Export the data to an excel spreadsheet with only 4 columns: store names, address, and number of robberies within half mile, 1 mile. Do not forget to delete the ‘geometry’ column before exporting your data.
   
