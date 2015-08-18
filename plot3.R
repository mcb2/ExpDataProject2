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

png(filename = "plot3.png")
balt <- filter(NEI, fips == "24510") %>%
     group_by(type, year) %>%
     summarise(total_emissions = sum(Emissions, na.rm = TRUE)) 
qplot(year, total_emissions, data = balt, facets = .~ type, 
      geom = c("point", "smooth"), method = "lm", 
      group = 1)
dev.off()
