# Exercise - When can I swim?
# (a sorta silly example of how we can use USGS data to inform our recreation!)
# in this lesson, you'll learn how to find sites, find information about sites,
# and learn how to pair USGS with external data to extend the value of different data sets

# Problem: Winters in Wisconsin are long. You want to know when it will be
# comfortable to wade or swim in your favorite stream. 
# Use USGS data and tools to answer this question!

# Personal parameters -- the temperature you're comfortable swimming in + the stream you want to swim in!
# Calculate the first day of 2020 that your stream crossed your temperature threshold.
# Now calculate how variable this date is across the period of record for your stream site.

# BONUS: swimability is not just based on water temperature, but also air temperature!
# set your air temperature threshold, find air temperature records, and calculate the 
# number of days in 2020 that were above your air AND water temperature threshold

# packages you'll need
# run install.package('packagename') on any package you don't have installed
library(dataRetrieval)
library(openmeteo)
library(tidyverse)

# set the site you'll use
# My example is the USGS gage, Black Earth Creek in Black Earth, WI
mysite <- '05406497'

# set your temperature threshold
# convert it to degrees c
mytemp <- 
mytemp_c <- 

# set the parameter you want to fetch
# in this case, we want temperature records (00010)
temp_pcode <- '00010'

# what if we want to discover a site?
temp_sites <- whatNWISdata(stateCd = 'WI', parameterCd = '00010', service = 'dv')

# get the temperature data for this site
# we want to pull from the "dv" or daily values service
# let's grab 
dat <- readNWISdv()

head(dat)
summary(dat$Date)

dat <- renameNWISColumns(dat)

# first, let's pick one year of recent data
dat <- mutate(dat, year = lubridate::year(Date))
dat2012 <- filter(dat, year %in% 2012)

# let's visualize
ggplot(dat2012, aes(x = Date, y = Wtemp)) +
  geom_point() + 
  geom_line() +
  geom_hline(yintercept = mytemp_c, color = 'red') +
  theme_bw() +
  labs(y = 'Water Temperature [deg C]')

# calculate the first day that the river exceeds my threshold


# how many days were swimmable? 

# what about other years? Let's calculate minimum date and swimmable days each year


# but it's not just about water temperature, the air temperature
# needs to be warm, too. Set your air temperature threshold
myairtemp <- 
myairtemp_c <- 

# get local air temperature records
# run install.packages only once
#install.packages('openmeteo')
library(openmeteo)

# find the lat/long of your selected USGS gage

site_meta <- dataRetrieval::readNWISsite(mysite)
airtemps <- openmeteo::weather_history(c(site_meta$dec_lat_va, site_meta$dec_long_va),
                                       start = '2012-01-01', end = '2012-12-31',
                                       daily = 'temperature_2m_max')

# pair the air temps with the water temps
head(airtemps)
head(dat2012)

paired <- left_join(dat2012, airtemps, by = c('Date' = 'date'))

# let's plot the data to make sure it makes sense
ggplot(paired, aes(x = Date, y = daily_temperature_2m_max)) +
  geom_line() +
  geom_line(aes(x = Date, y = Wtemp), col = 'blue') +
  geom_hline(yintercept = myairtemp_c) +
  geom_hline(yintercept = mytemp_c, col = 'blue') +
  theme_bw()

# let's find the dates that meet both criteria!

