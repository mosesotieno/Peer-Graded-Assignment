#---- Header  -----

#---- Name : run_analysis

#---- Purpose : Answer the Peer graded questions from Coursera Getting and cleaning Data Module

#---- Author: Moses Otieno

#---- Date : 11 Aug 2020


#---- Body -----

#---- Libraries

library(tidyverse)



#---- Download data

urlsmartphone <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


#---- Download the file if it does not exist
if (!file.exists("./Dataset.zip")){
  
  download.file(urlsmartphone, destfile = "./Dataset.zip")
}

#---- Unzip the file
unzip("./Dataset.zip",exdir = ".")


#---- Import the data one at a time ----

#---- Import the test data ----

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#---- clean up the dataset by applying labelling

#--- Activity labels

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity_code", "activity_labels")

features <- read.table("./UCI HAR Dataset/features.txt")

#---- Assign variable names

names(X_test) <- features$V2
names(y_test) <- "y_test"
names(subject_test) <- "subject"


#---- Select only the mean and sd

X_test <- select(X_test, contains(c("mean()", "std()")))

#--- Finally merge the activity labels with X_test

X_test <- cbind(subject_test, y_test, X_test)

#--- Merge the three datasets

X_test <- merge(activity_labels, X_test,
                by.x = "activity_code", by.y = "y_test")


#--- Identify the test dataset

dataset_label <- rep(c("test"), nrow(X_test))
X_test <- cbind(X_test, dataset_label)


#---- Import the train data ----

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#---- clean up the dataset by applying labelling


# --- Assign variable names

names(X_train) <- features$V2
names(y_train) <- "y_train"
names(subject_train) <- "subject"


#--- Select only the mean and sd

X_train <- select(X_train, contains(c("mean()", "std()")))

#--- Bring all the datasets together

X_train <- cbind(subject_train, y_train, X_train)

X_train <- merge(activity_labels, X_train,
                 by.x = "activity_code", by.y = "y_train")


#--- Identify the train dataset

dataset_label <- rep(c("train"), nrow(X_train))
X_train <- cbind(X_train, dataset_label)


#---- Append the two datasets ----

dim(X_train)
dim(X_test)

names(X_test)
names(X_train)

test_train <- rbind(X_train, X_test)


write.table(test_train, "./UCI HAR Dataset/test_train.txt",
            row.name = FALSE)

#----  Final dataset aggregated ----

test_train2 <- test_train %>%
  group_by(dataset_label, subject, activity_code, activity_labels) %>%
  summarise(across("tBodyAcc-mean()-X":"fBodyBodyGyroJerkMag-std()", mean))


write.table(test_train2, "./UCI HAR Dataset/test_train2.txt", row.name = FALSE)


#--- Remain with the final datasets

environdat <- ls()

rm(list = environdat[!environdat %in% c("test_train2", "test_train")])

rm(environdat)


#---- End ----


