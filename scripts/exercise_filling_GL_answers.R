# How many years of river discharge would it take to fill a Great Lake?
# In this exercise, you'll learn how to get river discharge data and manipulate it
# in a variety of ways, plot it, and calculate how many years of river discharge it
# would take to fill a GL of choice!

# first, pick a Great Lake. Doesn't have to be Laurentian! 
# my pick is Lake Baikal in Russia. Let's set our volume. 
baikal_km3 <- 23610 # units are cubic kilometers

# now let's pick a River
# Because I picked a really big lake, I'm going to pick a Big River. 
# I'm going to pick the Mississippi at Belle Chasse, LA (one of the last gages before
# entering the Gulf of Mexico)

mysite <- '07374525'

# let's get all discharge data from the site
# find different parameter codes here: https://help.waterdata.usgs.gov/code/parameter_cd_nm_query?parm_nm_cd=%25discharge%25&fmt=html
dat <- readNWISdv(siteNumber = mysite, parameterCd = '00060')
dat <- dat %>%
  renameNWISColumns() %>%
  mutate(year = lubridate::year(Date))

# let's plot a year of data and see what it looks like!
dat2020 <- filter(dat, year %in% 2020)

ggplot(dat2020, aes(x = Date, y = Flow)) +
  geom_line()

# okay, how much water moved through this river in a year?
attributes(dat)

# how can we get to cubic feet (volume) instead of a rate (ft3 per second)
# we could multiple each day by the number of second/d and then sum, or 
# we could sum and then multiple the total value by seconds 
# we could find the average of all days then multiple by the number of seconds per year
# is that the same thing?
test <- sum(dat2020$Flow)*24*60*60
test2 <- mutate(dat2020, daily = Flow*24*60*60)
test2 <- sum(test2$daily)
test3 <- mean(dat2020$Flow) * 366*24*60*60

# okay, so now we have a total value
flow_ft3peryear <- sum(dat2020$Flow)*24*60*60

# our GL units are in km3 - let's convert units to match
ft3_to_km3 <- function(ft3){return(ft3*2.83168e-11)}
km3_to_ft3 <- function(km3){return(km3/2.83168e-11)}

# let's convert our flow so we're using units the rest of the world uses
flow_km3peryear <- ft3_to_km3(ft3 = flow_ft3peryear)

# now lets calculate how many years of discharge it would take to fill Baikal
baikal_km3/flow_km3peryear

# 37.3 years using 2020 flow!
# how representative is this of an average flow year for the Mississippi? 
# Many of you have likely seen reports of low flows in the Mississippi this year
# first, let's visually look at cumulative discharge each year

dat_cumulative <- dat %>%
  arrange(Date) %>%
  group_by(year) %>%
  mutate(cumulative_flow = cumsum(Flow),
         n = n()) %>%
  filter(n >= 360)

# we need to add a common date for plotting purposes, let's use DOY
dat_cumulative <- mutate(dat_cumulative, doy = lubridate::yday(Date))

# now let's plot, and make our year a different color!
ggplot(dat = dat_cumulative, aes(x = doy, y = cumulative_flow)) +
  geom_line(aes(group = year, color = year)) +
  geom_line(dat = filter(dat_cumulative, year %in% 2020), color = 'red')

# the variability is important! Let's find the range in years that it would
# take to fill Baikal
flow_by_year <- dat %>%
  group_by(year) %>%
  summarize(annual_flow_km3 = ft3_to_km3(sum(Flow)*24*60*60),
            n = n()) %>%
  filter(n >= 360)

# now let's add a column to this dataframe that calculates the years to 
# fill Baikal
flow_by_year <- flow_by_year %>%
  mutate(years_to_fill = baikal_km3/annual_flow_km3)

# the range is 31.5 - 72.8 years!

  
