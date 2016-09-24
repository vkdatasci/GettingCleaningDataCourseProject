library(plyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- "data"
dataZipFile <- file.path(dataDir, "ucidata.zip")
workingDir <- file.path(dataDir, "UCI HAR Dataset")
outDir <- "output"


downloadFile <- function() {
   if (!file.exists(dataZipFile)) {

        if (!file.exists(dataDir)) {
            dir.create(dataDir)
        }

        download.file(fileUrl, dest=dataZipFile, method="curl")
    }
    unzip(dataZipFile, exdir=dataDir)
}

getData <- function() {

    if (!file.exists(workingDir)) {
        downloadFile()
    }
    setwd(workingDir)
 
    
}



readData <- function(dname, colnames) {
    d <- read.table(file.path(dname,sprintf("X_%s.txt",dname)), col.names=colnames)
    d[,"activity"] <- read.table(file.path(dname,sprintf("y_%s.txt",dname)))
    d[,"subject"] <- read.table(file.path(dname,sprintf("subject_%s.txt",dname)))
    d
}

mergeSets <- function() {
    dataColnames <- as.character(read.table("features.txt")[,2])
    trainData <- readData("train", dataColnames)
    testData <- readData("test", dataColnames)
    mergedData <- rbind(testData, trainData)
    mergedData
}


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

writeOut <- function(tidydata, outDir) {
    if (!file.exists(outDir)) { 
        dir.create(outDir)
    }
    write.csv(tidydata, file.path(outDir,"tidy.txt"))
}


getData()
m <- mergeSets()
tidydata <- analyzeData(m)
writeOut(tidydata, outDir)

