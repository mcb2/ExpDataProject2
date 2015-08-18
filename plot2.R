# Change this to an appropriate directory for your environment
setwd("~/Coursera/Exploratory Data Analysis/Project 2")
library(dplyr)

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

png(filename = "plot2.png")
totalbalt <- filter(NEI, fips == "24510") %>%
     group_by(year) %>%
     summarise(total_emissions = sum(Emissions, na.rm = TRUE))
plot(totalbalt, main = "Total Emissions by Year for Baltimore City", 
     ylab = "Total Emissions in Tons")
abline(lm(total_emissions ~ year, totalbalt))
dev.off()
