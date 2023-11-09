# Some intro to R tidbits

# using "projects"

# objects, reading in files, writing files
dat <- data.frame(x = 1:10, y = sample(1:100, 10))
dat[,1]
dat[,'x']
dat$x

# add new column
dat$z <- 'USGS'

# find out information about the data frame
summary(dat)
head(dat)
tail(dat)

dat$names <- c(rep('Sam', 5), rep('Sandra', 5))

# sum two columns
dat$sum_x_y <- dat$x + dat$y

# combine two dataframes based on a common value
# these are called "joins" in R
#install.packages('dplyr')
#install.packages('tidyverse') 
library(tidyverse) 

lookup <- data.frame(names = c('Sam', 'Sandra'), institution = c('USGS', 'UW Milwaukee'))

dat <- left_join(x = dat, y = lookup)
dat <- dat %>%
  left_join(lookup)


# mmsd_wq <- read.csv('in_data/Field_Water_Quality_MMSDPlanningArea_2004-13.csv')
# unique(mmsd_wq$USGS.Site.ID)
# looking at data, subsetting it, modifying it

# quick dplyr tutorial
# verbs: mutate, group, filter, summarize
dat2 <- dat %>%
  filter(y < 85) %>%
  group_by(names) %>%
  summarize(mean_y = mean(y))

# overview of dataRetrieval, grabbing NWIS or WQP data, use examples from Laura's presentation
install.packages('dataRetrieval')
library(dataRetrieval)

mysite <- '07374000'
mypcode <- '00065'
mystart <- '2023-11-02'

ms_br <- dataRetrieval::readNWISuv(siteNumbers = mysite,
                          parameterCd = mypcode,
                          startDate = mystart)
ms_br <- renameNWISColumns(ms_br)

names(ms_br)
#install.packages('ggplot2')
library(ggplot2)
ggplot(ms_br, aes(x = dateTime, y = GH_Inst)) +
  geom_line(color = 'lightblue') +
  labs(y = 'Gage Height', x = 'Date') +
  theme_bw()

# find a gage within a specific state/county
dane <- whatNWISsites(stateCd = 'WI', countyCd = 'Dane', 
                      parameterCd = mypcode)

dane_data <- whatNWISdata(siteNumber = dane$site_no, 
                          parameterCd = mypcode, service = 'dv')
# quick demo of sbtools
# downloaded MMSD data from your IBI section https://www.sciencebase.gov/catalog/item/5d97a332e4b0c4f70d117fb4
# downloaded file "Water_Quality_MMSDPlanningarea_2004-13.csv
# but we can also use package "sbtools"
# install.packages('sbtools')
library(sbtools)
sbtools::item_file_download(sb_id = '5d97a332e4b0c4f70d117fb4', 
                            names = 'Water_Quality_MMSDPlanningArea_2004-13.csv',
                            destinations = 'in_data/Water_Quality_MMSDPlanningArea_2004-13.csv')

dat <- read.csv('in_data/Water_Quality_MMSDPlanningArea_2004-13.csv')
summary(dat)


