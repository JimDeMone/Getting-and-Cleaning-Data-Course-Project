################################################################
## Download the data
################################################################
#if(!file.exists("./data")){dir.create("./data")}
#download.file(fileUrl,destfile="./data/data.zip")
#unzip("./data/data.zip", exdir="./data")
################################################################
## Read in the meta data
################################################################
# get the names of the data points and clean them
features <- read.table("data/UCI HAR Dataset/features.txt")
featureNames <- tolower(gsub("[-()]","", features$V2))
featureNames <- gsub("^t","time", featureNames)
featureNames <- gsub("^f","frequency", featureNames)
featureNames <- gsub("([0-9])+,([0-9])+","\\1to\\2", featureNames)
featureNames <- gsub(",","", featureNames)
featureNames <- gsub("bodybody","body", featureNames)
featureNames <- gsub("acc","accelerometer", featureNames)
featureNames <- gsub("gyro","gyroscope", featureNames)
featureNames <- gsub("std","standarddeviation", featureNames)
featureNames <- gsub("mag","magnitude", featureNames)

# Get the translation of activity type to activity name
activitylables <- read.table("data/UCI HAR Dataset/activity_labels.txt")
# Clean them up
colnames(activitylables) <- c("level","label")
activitylables$label = gsub("_","",activitylables$label)
activitylables$label = tolower(activitylables$label)

##############################################################
## Read in the TEST data
##############################################################
# Read in the test data points
testdata <- read.table("data/UCI HAR Dataset/test/X_test.txt")

# Set the column names to the feature names
colnames(testdata) <- featureNames
# Filter to only mean and std columns
testdata <- testdata[,grep("(mean|standarddeviation)",colnames(testdata))]

# Get the activity for the data points
testactivities <- read.table("data/UCI HAR Dataset/test/y_test.txt")
colnames(testactivities) <- c("activitytype")

# Add the activity column to the end
testdata <- cbind(testdata, testactivities)
# Make them into factor variables
testdata$activitytype <- factor(x = testdata$activitytype, levels=activitylables$level, labels = activitylables$label)

# add a data type of test to this data as the second column
testdata <- cbind("test", testdata)
colnames(testdata)[1] <- "datatype"

# Read in the subjects create a table of subject ids
testsubjects <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
colnames(testsubjects) <- c("subjectid")
# add as the first column
testdata <- cbind(testsubjects, testdata)

##############################################################
## Read in the TRAIN data
##############################################################
# Read in the test data points
traindata <- read.table("data/UCI HAR Dataset/train/X_train.txt")

# Set the column names to the feature names
colnames(traindata) <- featureNames
# Filter to only mean and std columns
traindata <- traindata[,grep("(mean|standarddeviation)",colnames(traindata))]

# Get the activity for the data points
trainactivities <- read.table("data/UCI HAR Dataset/train/y_train.txt")
colnames(trainactivities) <- c("activitytype")

# Add the activity column to the end
traindata <- cbind(traindata, trainactivities)
# Make them into factor variables
traindata$activitytype <- factor(x = traindata$activitytype, levels=activitylables$level, labels = activitylables$label)

# add a data type of train to this data as the second column
traindata <- cbind("train", traindata)
colnames(traindata)[1] <- "datatype"

# Read in the subjects create a table of subject ids
trainsubjects <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
colnames(trainsubjects) <- c("subjectid")
# add as the first column
traindata <- cbind(trainsubjects, traindata)

###############################################################
## Create the full dataset
###############################################################
fulldata <- rbind(testdata, traindata)

################################################################
## Create the final dataset of averages by activity and subject
################################################################
finaldata <- aggregate(fulldata[,grep("(mean|standarddeviation)",colnames(fulldata))], list(fulldata$subjectid, fulldata$datatype, fulldata$activitytype), mean)
colnames(finaldata) <- paste0("mean",colnames(finaldata))
colnames(finaldata) <- c("subjectid","datatype","activitytype",colnames(finaldata[4:89]))



