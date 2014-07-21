#####################################################################################################################
### Question 4 of EDA Project 2
#
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
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
        coalCombIndex <-  subset(SCC, grepl("Coal", EI.Sector), select = SCC) 
        coalCombSubset <- subset(NEI, scc = coalCombSubset) 

# Data Re-Shaping
        summEmissionCoalComb <- ddply(coalCombSubset, .(year), summarize, sum=sum(Emissions))


# Plotting
        png("plots/plot4.png",width = 480,height = 480)
        gplot <- ggplot(summEmissionCoalComb , aes(year, sum))
        gplot + geom_point() + geom_line() + labs(title = "Coal Combustion-Related Emissions in United States") + labs(x = "Year", y = expression("PM" [2.5]* " Emissions")) + scale_x_continuous(breaks = unique(summEmissionBaltimore$year))
        dev.off()
        setwd(wd)