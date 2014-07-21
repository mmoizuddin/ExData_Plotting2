#####################################################################################################################
### Question 1 of EDA Project 2
#
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base 
# plotting system, make a plot showing the total PM2.5 emission from all sources for each of the 
# years 1999, 2002, 2005, and 2008
#####################################################################################################################

suppressWarnings(library(data.table))
suppressWarnings(library(plyr))
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


# Data Re-Shaping
        summEmission <- ddply(NEI, .(year), summarize, sum=sum(Emissions))
        summEmission$year <- as.character(summEmission$year)


# Plotting
        png("plots/plot1.png",width = 480,height = 480)
        with(summEmission,plot(year, sum, type = "b", xlab="Year", ylab = expression("PM"[2.5]), main = "Emissions in United States", axes=FALSE))
        axis(side = 1, at = c("1999","2002","2005","2008"))
        box()
        axis(2)
        dev.off()
        setwd(wd)