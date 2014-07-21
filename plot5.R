#####################################################################################################################
### Question 5 of EDA Project 2
#
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City (fips == "24510") ?
#####################################################################################################################

suppressWarnings(library(data.table))
suppressWarnings(library(plyr))
suppressWarnings(library(ggplot2))
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


# Data Massaging
# 
        Baltimore <- subset(NEI, fips == "24510" & type == "ON-ROAD")
        Baltimore$type <- "Motor Vehicle"


# Data Re-Shaping
        summEmissionBaltimore <- ddply(Baltimore, .(year,type), summarize, sum=sum(Emissions) )

# Plotting
        png("plots/plot5.png",width = 480, height = 480)
        gplot <- ggplot(summEmissionBaltimore , aes(year, sum, shape=type, color=type))
        gplot + geom_point() + geom_line() + labs(title = "Emissions From Motor Vehicles in Baltimore City") + labs(x = "Year", y = expression("PM" [2.5]* " Emissions")) + scale_x_continuous(breaks = unique(summEmissionBaltimore$year))
        dev.off()
        setwd(wd)