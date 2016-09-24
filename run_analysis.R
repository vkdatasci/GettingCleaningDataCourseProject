library(plyr)

#
# Global variables: paths, data source
#
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- "data"
dataZipFile <- file.path(dataDir, "ucidata.zip")
workingDir <- file.path(dataDir, "UCI HAR Dataset")
outDir <- "output"

#
# download file function
#
downloadFile <- function() {
    # test for the rawdata file
   if (!file.exists(dataZipFile)) {
        if (!file.exists(dataDir)) {
            dir.create(dataDir)
        }
        download.file(fileUrl, dest=dataZipFile, method="curl")
    }
    unzip(dataZipFile, exdir=dataDir)
}

#
# test for working directory, start download if needed
#
getData <- function() {

    if (!file.exists(workingDir)) {
        downloadFile()
    }
    setwd(workingDir)
}


#
# read data, add activity and subject cols
#
readData <- function(dname, colnames) {
    d <- read.table(file.path(dname,sprintf("X_%s.txt",dname)), col.names=colnames)
    d[,"activity"] <- read.table(file.path(dname,sprintf("y_%s.txt",dname)))
    d[,"subject"] <- read.table(file.path(dname,sprintf("subject_%s.txt",dname)))
    d
}

#
# merge train and test data sets
#
mergeSets <- function() {
    # set descriptive column names
    dataColnames <- as.character(read.table("features.txt")[,2])
    trainData <- readData("train", dataColnames)
    testData <- readData("test", dataColnames)
    mergedData <- rbind(testData, trainData)
    mergedData
}


#
# analyze data
#
analyzeData <- function(dataset) {
    
    # grep columns with mean, std, keep activity and subject columns
    meanstdSubset <- dataset[,grep("\\.(mean|std)\\.\\.|activity|subject", colnames(dataset))]

    # compute average
    meanAndStdAv <- ddply(.data=meanstdSubset, .variables=.(activity,subject), .fun=colMeans)

    # get activities as factor
    meanAndStdAv$activity <- as.factor(meanAndStdAv$activity)
    
    # set descriptive names from the activity labels file
    levels(meanAndStdAv$activity) <- read.table("activity_labels.txt")[,2]
    meanAndStdAv
}

#
# write output file
#
writeOut <- function(tidydata, outDir) {
    setwd("../..")
    if (!file.exists(outDir)) { 
        dir.create(outDir)
    }
    write.table(tidydata, file.path(outDir,"tidy.txt"), row.name=FALSE)
}

#
# "main" steps
#
getData()
m <- mergeSets()
tidydata <- analyzeData(m)
writeOut(tidydata, outDir)

