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
# USGS gage, Pheasant Branch at Middleton, WI
mysite <- '05427948'

# set the parameter you want to fetch
# in this case, we want temperature records (00010)
temp_pcode <- '00010'

# get local air temperature records
# run install.packages only once
install.packages('openmeteo')
library(openmeteo)

# find the lat/long of your selected USGS gage

site_meta <- dataRetrieval::readNWISsite(mysite)
airtemps <- openmeteo::weather_history(c(site_meta$dec_lat_va, site_meta$dec_long_va),
                                       start = '2020-01-01', end = '2020-12-31',
                                       daily = 'temperature_2m_max')
