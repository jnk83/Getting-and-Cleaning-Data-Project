
### PRELIMINARIES

## Looks for existing 'project' folder, creates one if necessary, downloads file, and unzips thereto

if(!file.exists("./project")){dir.create("./project")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile="./project/project.zip",mode="wb")
unzip("./project/project.zip",exdir="./project")

## Loads necessary packages

library(tibble)
library(data.table)
library(dplyr)

### STEP ONE: "Merges the training and the test sets to create one data set"

## Reads variable names and activity descriptors

features <- read.table(file = "./project/UCI HAR Dataset/features.txt")
activities <- read.table(file = "./project/UCI HAR Dataset/activity_labels.txt", col.names = c("activitycode", "activity"))

## Reads training data and creates 'subject' and 'activitycode' columns

subtrain <- read.table(file = "./project/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table(file = "./project/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table(file = "./project/UCI HAR Dataset/train/y_train.txt", col.names = "activitycode")

## Reads test data and creates 'subject' and 'activitycode' columns

subtest <- read.table(file = "./project/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table(file = "./project/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table(file = "./project/UCI HAR Dataset/test/y_test.txt", col.names = "activitycode")

## Adds names to the variable columns from features.txt

colnames(xtrain) <- features[,2]
colnames(xtest) <- features[,2]

## Merges the training and test data into one data frame 'merged_data'

mergedtrain <- cbind(subtrain, ytrain, xtrain)
mergedtest <- cbind(subtest, ytest, xtest)
merged_data <- rbind(mergedtrain, mergedtest)

### STEP TWO: "Extracts only the measurements on the mean and standard deviation for each measurement"

## Primarily seeks the relevant 'mean()' and 'std()' columns from merged_data and moves them, along with the 
## 'subject' and 'activitycode' columns, into data frame 'selected'

column_names <- colnames(merged_data)
column_list <- grepl("subject|activitycode|mean\\(\\)|std\\(\\)", column_names)
selected <- merged_data[, column_list]

### STEP THREE: "Uses descriptive activity names to name the activities in the data set"

## Creates a new third column and places the activity descriptors by the activity codes

selected <- add_column(selected, activity = NA, .after = 2)
selected$activity <- activities$activity[match(selected$activitycode, activities$activitycode)]

### STEP FOUR: "Appropriately labels the data set with descriptive variable names"

## Properly formats the column names, i.e. changing to lower case, removing symbols, swapping out abbreviated
## words, etc.

colnames(selected) <- tolower(colnames(selected))
colnames(selected) <- gsub(pattern="[[:punct:]]", x=colnames(selected), replacement="")
colnames(selected) <- gsub(pattern = "acc", x = colnames(selected), replacement = "acceleration")
colnames(selected) <- gsub(pattern = "std", x = colnames(selected), replacement = "standarddeviation")
colnames(selected) <- gsub(pattern = "gyro", x = colnames(selected), replacement = "gyroscope")
colnames(selected) <- gsub(pattern = "^t", x = colnames(selected), replacement = "time")
colnames(selected) <- gsub(pattern = "^f", x = colnames(selected), replacement = "frequency")
colnames(selected) <- gsub(pattern = "mag", x = colnames(selected), replacement = "magnitude")
colnames(selected) <- gsub(pattern = "x$", x = colnames(selected), replacement = "X")
colnames(selected) <- gsub(pattern = "y$", x = colnames(selected), replacement = "Y")
colnames(selected) <- gsub(pattern = "z$", x = colnames(selected), replacement = "Z")
colnames(selected)[3] <- "activity"

### STEP FIVE: "Create a second, independent tidy data set with the average of each variable for each activity
## and each subject."

## Creates the tidy data set (appending '_mean' to the columns of averaged variables), orders the activity codes,
## and thereafter removes the now extraneous activity codes column

tidy <- selected %>% group_by(subject, activity) %>% summarize_all(list(mean = mean))
colnames(tidy)[3] <- "activitycode"; orderedtidy <- tidy[order(tidy$subject, tidy$activitycode),]
orderedtidy <- orderedtidy[, -3]

## Writes our tidy data to file 'tidyproject.txt'

write.table(orderedtidy, "./UCI HAR Dataset/tidyproject.txt", row.names=FALSE)