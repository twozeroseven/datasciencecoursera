#CodeBook - Getting and Cleaning Data Course Project

This document describes the code inside run_analysis.R.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz... More information can be found in the [README file](README.md).

##SECTIONS
The code is split into the following sections denoted by matching comments:

* LOAD EXTERNAL LIBRARIES
* LOAD EXTERNAL DATA FILES
* CLEAN/FILTER DATASETS
* COMBINE DATASETS
* GROUP/ORGANIZE DATA
* CREATE TIDY DATA

##LOAD EXTERNAL LIBRARIES

Loading external libraries in this case just one 'data.table'

```R
#LOAD EXTERNAL LIBRARIES
library(data.table)
```
##LOAD EXTERNAL DATA FILES

Load all external data files - these are all txt files so we use read.table.
Set working directory first our project root

```R
#LOAD EXTERNAL DATA FILES
setwd('Documents/projects/datasciencecoursera/getting_cleaning')
activities <- read.table('data/activity_labels.txt')[,2]
features <- read.table('data/features.txt')[,2]
X_Test <- read.table('data/test/X_test.txt')
Y_Test <- read.table('data/test/y_test.txt')
X_Train <- read.table('data/train/X_train.txt')
Y_Train <- read.table('data/train/y_train.txt')
subject_test <- read.table('data/test/subject_test.txt')
subject_train <- read.table('data/train/subject_train.txt')
```

##CLEAN/FILTER DATASETS

Filter down data by extracting only the mean and STD columns.
Use features.txt file to add more descriptive columns names to data.

```R
#CLEAN/FILTER DATASETS
#find col names with mean or std
meanStdCols <- grepl("mean|std", features)

#change columns names to more descriptive names - from text file features.txt
names(X_Test) <- features
names(X_Train) <- features

#remove columns except mean or std
X_Test <- X_Test[,meanStdCols]
X_Train <- X_Train[,meanStdCols]

# add activity labels with Y Test
Y_Test[,2] = activities[Y_Test[,1]]
Y_Train[,2] = activities[Y_Train[,1]]
names(Y_Test) = c("Activity_ID", "Activity_Label")
names(Y_Train) = c("Activity_ID", "Activity_Label")
names(subject_test) = "Subject"
```

##COMBINE DATASETS

Use CBIND function to bind columns of X values to Y values for both TEST and TRAIN data.

```R
#COMBINE DATASETS
# Bind test data
testData <- cbind(as.data.table(subject_test), Y_Test, X_Test)
trainData <- cbind(as.data.table(subject_test), Y_Train, X_Train)
```
Combine both testData and trainData into one master dataset

```R
#datasets are now equal - bind together by row
totalData <- rbind(testData,trainData)
```
##GROUP/ORGANIZE DATA

Seperate Subject, Activity Id, Activity Label columns from the rest of the data.
Melt dataset from giant wide data with many many observation per row into a skinnier dataset with 1 observation per row.  Use MELT() function for this.

```R
#GROUP/ORGANIZE DATA
#identifiy id column labels
ids <- c("Subject", "Activity_ID", "Activity_Label")
#get all columns besides first 3
data_labels <- setdiff(colnames(totalData), ids)
#melt data together to a skinnier data set with all column observations now in one variable column
melt_data <- melt(totalData, id = ids, measure.vars = data_labels)
```

##CREATE TIDY DATA

Once data is melted it can now be cast into grouped format.
Use DCAST() function to group by Subject & Activiy_Label, while applying the MEAN function to each observation.
Finally write tidy data to seperate file.

```R
#CREATE TIDY DATA
#cast into a new data set - now grouped by subject and activity, showing mean of each value. 
tidy <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)

#write new file
write.table(tidy,'tidy.txt')
```