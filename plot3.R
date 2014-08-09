#############################################################################
##
## plot3.R -This script creates a plot of power consumption data between
##          1st Feb 2007 and 2nd Feb 2007.  The data is downloaded if it
##          is not present.  The plot is stored in a .png file called
##          plot3.png
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
    
    download.file(FileURL, 
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
                     na.strings=c("?") 
    )
    
    ###########################################################################
    ## Extract the data for the dates 2007-02-01 and 2007-02-02
    ###########################################################################
    plotData<-data[(data$Date == "1/2/2007" | data$Date == "2/2/2007")  ,]
    
    ## Combine the Date and Time columns and convert to date format
    plotData$Date.Time<-strptime(
        paste(plotData$Date, plotData$Time,sep=" "),
        format="%d/%m/%Y %T")
    
    ##########################################################################
    ## Create the plot in a png file
    ##########################################################################
    print("create plot3.png file")
    png(file="plot3.png",width = 480, height = 480, units = "px")
    
    with(plotData,plot(Date.Time,Sub_metering_1, type="l", col= "black",
                       ylab="Energy sub metering",
                       xlab=""))
    with(plotData,lines(Date.Time,Sub_metering_2, type="l", col= "red"))
    with(plotData,lines(Date.Time,Sub_metering_3, type="l", col= "blue"))
    legend("topright", lty=1,
           col=c("black","red","blue"),
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()
}
