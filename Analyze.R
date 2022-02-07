mean (bikeshare2021_cleaned_v2$time_diff) # straight average (total ride length / rides)
median(bikeshare2021_cleaned_v2$time_diff) # midpoint number in the ascending array of ride lengths 
max(bikeshare2021_cleaned_v2$time_diff) # longest ride
min(bikeshare2021_cleaned_v2$time_diff) #shortest ride
#Compare members and casual users in mean, max, min
aggregate(bikeshare2021_cleaned_v2$time_diff ~ bikeshare2021_cleaned_v2$member_casual, FUN = mean)
aggregate(bikeshare2021_cleaned_v2$time_diff ~ bikeshare2021_cleaned_v2$member_casual, FUN = max)
aggregate(bikeshare2021_cleaned_v2$time_diff ~ bikeshare2021_cleaned_v2$member_casual, FUN = min)
#Visual the average ride time by each month for members vs caual riders
bikeshare2021_cleaned_v2 %>%
  group_by(month,member_casual) %>% 
  summarise(average_of_ride_time = mean(time_diff), .groups = 'drop') %>%
  ggplot(aes(x = month, y = average_of_ride_time, fill = member_casual)) +
  geom_col(position = 'dodge') +
  labs(x = "month", y = "Average Duration (min)", 
       fill = "Member/Casual", title = "Average Riding Duration by Month: Members vs. Casual Riders")
# Visual the average ride time by each day for memebrs vs cauals riders
bikeshare2021_cleaned_v2 %>% group_by(dayof_week,member_casual) %>% 
  summarise(average_of_ride_time = mean(time_diff), .groups = 'drop') %>%
  ggplot(aes(x = dayof_week, y = average_of_ride_time, fill = member_casual)) +
  geom_col(position = 'dodge') + labs(x = "Day Of Week", y = "Average Duration (min)", fill = "Member/Casual", title = "Average Riding Duration by Day: Members vs. Casual Riders")
# visual the Average number of rides by month: member vs. Casual riders
bikeshare2021_cleaned_v2 %>% 
  group_by(month, member_casual) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  ggplot(aes(x= month, y = number_of_rides, fill = member_casual)) + geom_col(position = 'dodge') + scale_y_continuous(labels = scales::comma) + labs(x = "Month", y = "number of Rides", fill = "member/Casual", title = "Average number of Ride by Month: members vs. Casual Riders")
# Visual the Average Number of Rides by Day: Members vs. Casual Riders
bikeshare2021_cleaned_v2 %>% group_by(dayof_week,member_casual) %>% 
  summarise(number_of_ride = n(), .groups = 'drop') %>%
  ggplot(aes(x = dayof_week, y = number_of_ride, fill = member_casual)) +
  geom_col(position = 'dodge')+scale_y_continuous(labels = scales::comma) +labs(x = "Day Of Week", y = "Number of Rides", fill = "Member/Casual", title = "Average Number of Rides by Day: Members vs. Casual Riders")
# Visual for number of rides grouped by day: rider type
bikeshare2021_cleaned_v2 %>% group_by(dayof_week ,rideable_type) %>% 
  summarise(number_of_ride = n(), .groups = 'drop') %>%
  ggplot(aes(x = dayof_week, y = number_of_ride, fill = rideable_type)) +
  geom_col(position = 'dodge') + scale_y_continuous(labels = scales::comma) + labs(x= "Day Of Week", y = "Number of Rides", fill = "Bike Type", title = " Average number of Rides by Day: ride type" )
# Visualfor Top 10 Used Start Stations 
top_10_start_staction_name <- bikeshare2021_cleaned_v3 %>% group_by(start_station_name) %>% summarise(station_count = n()) %>% arrange(desc(station_count)) %>% head(n = 10)
