# 1. Download the data and unzip to directory

if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

# 2. Read in the tables for both the training and test files
# Training tables

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Testing tables

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#features and acvitities

features <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Create variable names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

#3. Merge data

mtrain <- cbind(y_train, subject_train, x_train)
mtest <- cbind(y_test, subject_test, x_test)
AllData <- rbind(mtrain, mtest)

#4. # Vector to extract variable names.  ID, mean and stddev columns need to be set as TRUE
colnames <- colnames(AllData)

meanstd <- (grepl("activityId" , colnames) | 
                 grepl("subjectId" , colnames) | 
                 grepl("mean.." , colnames) | 
                 grepl("std.." , colnames) 
                 )
meanstd <- AllData[ , meanstd == TRUE]

#5.Descriptive activity names to name the activities in the data set

ActivityNames <- merge(meanstd, activityLabels,
                              by='activityId',
                              all.x=TRUE)



#6. Create a second, independent tidy data set with the average of each variable for each activity and each subject


TidyData <- aggregate(. ~subjectId + activityId, ActivityNames, mean)
TidyData <- TidyData[order(TidyData$subjectId, TidyData$activityId),]

#7. Write to Text File

write.table(TidyData, "TidyData.txt", row.name=FALSE)



