# Change this to an appropriate directory for your environment
setwd("~/Coursera/Exploratory Data Analysis/Project 2")
library(dplyr)
library(ggplot2)

## Download data
if (!file.exists("data")) {
     dir.create("data")
}
if (!file.exists("./data/exdata-data-NEI_data.zip")) {
     fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
     download.file(fileUrl, destfile = "./data/exdata-data-NEI_data.zip", mode = "wb")
}

## Unzip data
if (!file.exists("./data/summarySCC_PM25.rds")) unzip("./data/exdata-data-NEI_data.zip", exdir = "./data")

## Load data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
NEI$year <- as.factor(NEI$year)

png(filename = "plot4.png")
#coal combustion related sources include "coal" in Short.Name and "combustion" in SCC.Level.One
sources <- filter(SCC, grepl("coal", Short.Name, ignore.case = TRUE), 
                  grepl("combustion", SCC.Level.One, ignore.case = TRUE)) %>%
     select(SCC)
# going to use total coal combustion emissions (i.e. sum) for each year 
coalcombustdata <- filter(NEI, SCC %in% sources$SCC) %>%
     group_by(year) %>%
     summarise(coal_combustion_emissions = sum(Emissions, na.rm = TRUE))
# connecting data point with a line to better visualize the trend
qplot(year, coal_combustion_emissions, data = coalcombustdata, 
      geom = "line", method = "lm", 
      group = 1, main = "Coal Combustion Emissions",
      ylab = "Coal Combustion Emissions (Tons)")
dev.off()

