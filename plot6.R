#####################################################################################################################
### Question 6 of EDA Project 2
#
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
# Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
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
        BaltimoreVsLA <- subset(NEI, fips %in% c("24510","06037") & type == "ON-ROAD")
        BaltimoreVsLA$fips <- ifelse(BaltimoreVsLA$fips=="24510", "Baltimore City", "Los Angeles")
        BaltimoreVsLA$type <- "Motor Vehicle"

# Data Re-Shaping
        summEmissionbyMVBaltimore <- ddply(BaltimoreVsLA, .(year, fips, type), summarize, sum=sum(Emissions) )

# Plotting
        png("plots/plot6.png",width = 480, height = 480)
        gplot <- ggplot(summEmissionbyMVBaltimore , aes(year, sum, shape=fips, color=fips))
        gplot + geom_point() + geom_line() + labs(title = "Baltimore City VS LA Motor Vehicle Emissions Comparison") + labs(x = "Year", y = expression("PM" [2.5]* " Emissions")) + scale_x_continuous(breaks = seq(1999,2008,by = 3))
        dev.off()
        setwd(wd)