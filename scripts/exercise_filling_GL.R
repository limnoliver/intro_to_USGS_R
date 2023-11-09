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
# hint: use readNWISdv to get daily values

# let's plot a year of data and see what it looks like!

# okay, how much water moved through this river in a year?

# how can we get to cubic feet (volume) instead of a rate (ft3 per second)
# we could multiple each day by the number of second/d and then sum, or 
# we could sum and then multiple the total value by seconds 
# we could find the average of all days then multiple by the number of seconds per year
# is that the same thing?

# convert to a volume per year unit

# get your GL and flow units to match
# pick a unit that the rest of the world uses :)

# now lets calculate how many years of discharge it would take to fill Baikal

# how representative is this of an average flow year? 
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
# take to fill your lake!



  
