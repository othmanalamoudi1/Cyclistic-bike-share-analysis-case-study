install.packages("tidyverse")
library(ggplot2)
library(tidyr)
library(dplyr)
library(readr)
library(readxl)
#importing the merged dataset 
bikeshare2021 <- read.csv("/Users/othmanalamoudi/Desktop/R-project/BikeShare_2021.csv")


#Observe the number of rows & columns: 
nrow(bikeshare2021) 
ncol(bikeshare2021)

#to generate the distance travel 
#where I will calculate the distance for each trip in **meter**
install.packages("geosphere")
library(geosphere)
point1 <- select(bikeshare2021, start_lat, end_lng)
point2 <- select(bikeshare2021, end_lat, start_lng)
bikeshare2021$distance_traveled <- distHaversine(point1,point2, r =6378137 )
# take a peak at the distance_traveled column
df_distance_traveled <- select(bikeshare2021, start_lat, end_lng, end_lat, start_lng, distance_traveled)
knitr::kable(head(df_distance_traveled),"pipe")

# to create new column for the how many days took 
bikeshare2021$date_diff <- as.Date(as.character(bikeshare2021$started_at), format = "%Y-%m-%d") -
  as.Date(as.character(bikeshare2021$ended_at), format = "%Y-%m-%d")

#to View the the new column and make sure there is not vlaue less then zro 
df_date_diff <- select(bikeshare2021, started_at, ended_at, date_diff)
df_date_diff_asc <- arrange(df_date_diff, desc(-date_diff))
knitr::kable(head(df_date_diff_asc),"pipe")

# to remove the negative days 
filtered_bikeshare2021 <- bikeshare2021 %>% filter(date_diff >= 0)

#caluclate the time diffrence to fine the duration in mintues for each trip 
filtered_bikeshare2021$time_diff <- difftime(filtered_bikeshare2021$ended_at, filtered_bikeshare2021$started_at, units = "mins")

# to make sure there is no negative value  
df_time_diff <- select(filtered_bikeshare2021, started_at, ended_at, time_diff)
df_time_diff_asc <- arrange(df_time_diff, desc(-time_diff))
knitr::kable(head(df_time_diff_asc),"pipe")
# remove the nagetive value 
filtered_bikeshare2021_v2 <- filtered_bikeshare2021 %>% filter(time_diff >= 0)

# create a column for day of week which will represnt the day of the trip
library(lubridate)
filtered_bikeshare2021_v2$dayof_week <- wday(filtered_bikeshare2021_v2$started_at, label = TRUE)

# create a column month which will display the month of the trip 
filtered_bikeshare2021_v2$month <- format(as.Date(filtered_bikeshare2021_v2$started_at), "%m")

# create a new dataset to excluded the columns that it wouldn't be used for the analysis
bikeshare2021_cleaned_v1 <- select(filtered_bikeshare2021_v2, rideable_type,started_at,ended_at,start_station_name,end_station_name,member_casual,distance_traveled,time_diff,dayof_week,month)

# remove rows with missing values
bikeshare2021_cleaned_v2 <- bikeshare2021_cleaned_v1[complete.cases(bikeshare2021_cleaned_v1), ]

# #replacing empty rows with NA
bikeshare2021_cleaned_v2[bikeshare2021_cleaned_v2 == ""] <- NA

#removing NA value 
bikeshare2021_cleaned_v3 <- na.omit(bikeshare2021_cleaned_v2)
