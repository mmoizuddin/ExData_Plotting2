#####################################################################################################################
### Question 2 of EDA Project 2
#
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.
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


# Data Massaging
        Baltimore <- subset(NEI, fips == "24510")


# Data Re-Shaping
        summEmissionBaltimore <- ddply(Baltimore, .(year), summarize, sum=sum(Emissions))
        

# Plotting
        png("plots/plot2.png",width = 480, height = 480)
        with(summEmissionBaltimore,plot(year,sum, type = "b", xlab="Year", ylab = expression("PM"[2.5]), main = "Emissions in Baltimore City, Maryland",axes=FALSE))
        axis(side = 1, at = c("1999","2002","2005","2008"))
        box()
        axis(2)
        dev.off()
        setwd(wd)