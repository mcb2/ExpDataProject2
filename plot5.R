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

png(filename = "plot5.png")
# all motor vehicle polution short names include the string "vehicle" in SCC.Level.Two
sources <- filter(SCC, grepl("vehicle", SCC.Level.Two, ignore.case = TRUE)) %>%
     select(SCC)
vehicledata <- filter(NEI, SCC %in% sources$SCC, fips == "24510") %>%
     group_by(year) %>%
     summarise(total_vehicle_emissions = sum(Emissions, na.rm = TRUE))
# connecting data point with a line to better visualize the trend
qplot(year, total_vehicle_emissions, data = vehicledata, 
      geom = "line", method = "lm", 
      group = 1, main = "Baltimore City Motor Vehicle Emissions",
      ylab = "Total Emissions (Tons)")
dev.off()
