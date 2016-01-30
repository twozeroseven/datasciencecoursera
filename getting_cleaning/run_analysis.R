#LOAD EXTERNAL LIBRARIES
library(data.table)

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

#COMBINE DATASETS
# Bind test data
testData <- cbind(as.data.table(subject_test), Y_Test, X_Test)
trainData <- cbind(as.data.table(subject_test), Y_Train, X_Train)

#datasets are now equal - bind together by row
totalData <- rbind(testData,trainData)

#GROUP/ORGANIZE DATA
#identifiy id column labels
ids <- c("Subject", "Activity_ID", "Activity_Label")
#get all columns besides first 3
data_labels <- setdiff(colnames(totalData), ids)
#melt data together to a skinnier data set with all column observations now in one variable column
melt_data <- melt(totalData, id = ids, measure.vars = data_labels)

#CREATE TIDY DATA
#cast into a new data set - now grouped by subject and activity, showing mean of each value. 
tidy <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)

#write new file
write.table(tidy,'tidy.txt')