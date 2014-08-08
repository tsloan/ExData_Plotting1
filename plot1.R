#############################################################################
##
## plot1.R -This script creates a plot of power consumption data between
##          1st Feb 2007 and 2nd Feb 2007.  The data is downloaded if it
##          is not present.  The plot is stored in a .png file called
##          plot1.png
##
#############################################################################

#############################################################################
##
## Download the data from 
##   https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
##
##############################################################################
DataDir <-"data"
FileURL <- 
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists(DataDir)){
    
    dir.create(DataDir)
    
    ###########################################################################
    ## Download the file into the Create directory 
    ###########################################################################
    
    download.file(fileUrl, 
                  destfile = paste("./",DataDir,"/Dataset.zip",sep=""))
    
    ###########################################################################
    ## Add a file that contains the time and date the data is downloaded 
    ###########################################################################
    
    dateFileCon<-file("./data/DateDataDownloaded","w")
    dateDownloaded <- date()
    write(dateDownloaded,dateFileCon)
    close(dateFileCon)
    
    ###########################################################################
    ## Unzip the archive into ./data
    ###########################################################################
    
    setwd("./data")
    unzip("Dataset.zip")
    setwd("..")
    
}

#############################################################################
## The dataset has 2,075,259 rows and 9 columns. First calculate a rough 
## estimate of how much memory the dataset will require in memory before 
## reading into R. Make sure your computer has enough memory (most modern 
## computers should be fine).
## 
## Memory Requirements
##     = (number of rows * number of colums * 8 bytes/numeric )/2^20/MB
#############################################################################

MemReq <- (2075259 * 9 * 8)/ (2^20) #two of the 
source("CheckMemoryRequirements.R")
if (CheckMemoryRequirements(MemReq)){
    print("enough memory to load complete data into R")
    data<-read.table("./data/household_power_consumption.txt", 
                      header = TRUE,
                      stringsAsFactors=FALSE,
                      sep=";",
                      na.strings=c("?"," ") 
        )
    ## Convert the Date column to the date format
    data$Date<-as.Date(data$Date, format="%d/%m/%Y")
    #data$Time<strptime(data$Time,format="%H:%M:%S")
    ###########################################################################
    ## Extract the data for the dates 2007-02-01 and 2007-02-02
    ###########################################################################
    plotData<-data[data$Date>="2007-02-01",]
    plotData<-plotData[plotData$Date<="2007-02-02",]

    ##########################################################################
    ## Create the plot in a png file
    ##########################################################################
    png(file="plot1.png",width = 480, height = 480, units = "px")
    with(plotData,hist(Global_active_power, 
                       col="red",
                       main="Global Active Power",
                       xlab="Global Active Power(kilowatts)")
         )
    dev.off()
}


