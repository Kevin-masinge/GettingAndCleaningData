## run_analysis.R
## Getting and Cleaning Data - Course Project
##
## This script performs the following steps on the UCI HAR Dataset:
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation
##     for each measurement.
##  3. Uses descriptive activity names to name the activities in the data set.
##  4. Appropriately labels the data set with descriptive variable names.
##  5. From the data set in step 4, creates a second, independent tidy data
##     set with the average of each variable for each activity and each subject.
##
## The script assumes the "UCI HAR Dataset" folder is in the working directory.
## If it isn't, it will download and unzip the data automatically.

library(dplyr)

## ---------------------------------------------------------------------
## 0. Download and unzip the data if it doesn't already exist
## ---------------------------------------------------------------------
dataDir <- "UCI HAR Dataset"

if (!file.exists(dataDir)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "UCI_HAR_Dataset.zip", method = "curl")
  unzip("UCI_HAR_Dataset.zip")
}

## ---------------------------------------------------------------------
## 1. Read in all of the necessary data
## ---------------------------------------------------------------------

# Features (column names) and activity labels
features      <- read.table(file.path(dataDir, "features.txt"),
                             col.names = c("index", "feature_name"),
                             stringsAsFactors = FALSE)
activityLabels <- read.table(file.path(dataDir, "activity_labels.txt"),
                              col.names = c("activity_id", "activity_name"),
                              stringsAsFactors = FALSE)

# Training data
xTrain <- read.table(file.path(dataDir, "train", "X_train.txt"))
yTrain <- read.table(file.path(dataDir, "train", "y_train.txt"),
                      col.names = "activity_id")
subjectTrain <- read.table(file.path(dataDir, "train", "subject_train.txt"),
                            col.names = "subject")

# Test data
xTest <- read.table(file.path(dataDir, "test", "X_test.txt"))
yTest <- read.table(file.path(dataDir, "test", "y_test.txt"),
                     col.names = "activity_id")
subjectTest <- read.table(file.path(dataDir, "test", "subject_test.txt"),
                           col.names = "subject")

## ---------------------------------------------------------------------
## 2. Assign descriptive column names to the X (measurement) data sets
##    using the names from features.txt
## ---------------------------------------------------------------------
colnames(xTrain) <- features$feature_name
colnames(xTest)  <- features$feature_name

## ---------------------------------------------------------------------
## 1 (cont). Merge the training and the test sets to create one data set
## ---------------------------------------------------------------------

# Combine subject, activity, and measurement columns for each set
trainData <- cbind(subjectTrain, yTrain, xTrain)
testData  <- cbind(subjectTest, yTest, xTest)

# Merge (row-bind) the training and test data sets
mergedData <- rbind(trainData, testData)

## ---------------------------------------------------------------------
## 2 (cont). Extract only the measurements on the mean and standard
##           deviation for each measurement
## ---------------------------------------------------------------------

# Identify columns that represent the mean() or std() measurements,
# along with the subject and activity_id columns
colsToKeep <- grepl("subject|activity_id|mean\\(\\)|std\\(\\)",
                     colnames(mergedData))

mergedData <- mergedData[, colsToKeep]

## ---------------------------------------------------------------------
## 3. Use descriptive activity names to name the activities in the data set
## ---------------------------------------------------------------------

mergedData <- merge(mergedData, activityLabels, by = "activity_id")

# Remove the now-redundant activity_id column
mergedData$activity_id <- NULL

## ---------------------------------------------------------------------
## 4. Appropriately label the data set with descriptive variable names
## ---------------------------------------------------------------------

names(mergedData) <- gsub("^t", "Time", names(mergedData))
names(mergedData) <- gsub("^f", "Frequency", names(mergedData))
names(mergedData) <- gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData) <- gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData) <- gsub("Mag", "Magnitude", names(mergedData))
names(mergedData) <- gsub("BodyBody", "Body", names(mergedData))
names(mergedData) <- gsub("-mean\\(\\)", "Mean", names(mergedData))
names(mergedData) <- gsub("-std\\(\\)", "Std", names(mergedData))
names(mergedData) <- gsub("-freq\\(\\)", "Frequency", names(mergedData))
names(mergedData) <- gsub("-", "", names(mergedData))

# Reorder columns so subject and activity_name come first
mergedData <- mergedData %>%
  select(subject, activity_name, everything())

## ---------------------------------------------------------------------
## 5. Create a second, independent tidy data set with the average of
##    each variable for each activity and each subject
## ---------------------------------------------------------------------

tidyData <- mergedData %>%
  group_by(subject, activity_name) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  arrange(subject, activity_name)

## ---------------------------------------------------------------------
## Write the tidy data set to a text file
## ---------------------------------------------------------------------

write.table(tidyData, "tidy_data.txt", row.names = FALSE)
