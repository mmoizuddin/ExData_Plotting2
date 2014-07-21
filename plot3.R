#####################################################################################################################
### Question 3 of EDA Project 2
#
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases 
# in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
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
        Baltimore <- subset(NEI, fips == "24510")


# Data Re-Shaping
        summEmissionbyTypeBaltimore <- ddply(Baltimore, .(year,type), summarize, sum=sum(Emissions) )


# Plotting
        png("plots/plot3.png",width = 500, height = 480)
        gplot <- ggplot(summEmissionbyTypeBaltimore , aes(year, sum,color=type,shape=type))
        gplot + geom_point() +geom_line() + labs(title = "Baltimore City Emissions") + labs(x = "Year", y = expression("PM" [2.5]* " Emissions")) + scale_x_continuous(breaks = unique(summEmissionBaltimore$year))
        dev.off()
        setwd(wd)