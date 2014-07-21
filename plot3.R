# The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say 
# about fine particulate matter pollution in the United states over the 10-year period 1999-2008. 
# Data for the project is available on
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip 
# The zip file contains two files:

# PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data 
# for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a 
# specific type of source for the entire year.
# fips: A five-digit number (represented as a string) indicating the U.S. county
# SCC: The name of the source as indicated by a digit string (see source code classification table)
# Pollutant: A string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type: The type of source (point, non-point, on-road, or non-road)
# year: The year of emissions recorded

# Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the 
# SCC digit strings int he Emissions table to the actual name of the PM2.5 source.


#####################################################################################################################
library(data.table)
library(ggplot2)
##


# Create required dirs
        wd <- getwd()
        if (!file.exists("EDA_Project2"))  { dir.create("EDA_Project2") } 
        setwd(paste0(getwd(),"/EDA_Project2/"))
        #
        if (!file.exists("NEI_dataset"))  {dir.create("NEI_Dataset") }
        #
        if (!file.exists("plots"))  {dir.create("plots") }
##


# Download Dataset and uncompress
        setwd(paste0(getwd(),"/NEI_Dataset/"))
        if (!file.exists("NEI_Data.zip"))  
        {
                fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip" 
                download.file(fileUrl,"NEI_Data.zip")
        } 
        rmfiles <-  c("summarySCC_PM25.rds","Source_Classification_Code.rds")
        file.remove(rmfiles)
        unzip("NEI_Data.zip")
##


# load datasets
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("source_Classification_Code.rds")
        setwd("..")
##


# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases 
# in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
##

# Data Massaging
        Baltimore <- subset(NEI, fips == "24510")


# Data Re-Shaping
        summEmissionbyTypeBaltimore <- ddply(Baltimore, .(year,type), summarize, sum=sum(Emissions) )


# Plotting
        png("plots/plot3.png",width = 500, height = 480)
        gplot <- ggplot(summEmissionbyTypeBaltimore , aes(year, sum,color=type,shape=type))
        gplot + geom_point() +geom_line() + labs(title = "Baltimore City Emissions") + labs(x = "Year", y = expression("PM" [2.5]* " Emissions")) + scale_x_continuous(breaks = seq(1999,2008,by = 3))
        dev.off()
        setwd(wd)