Getting and Cleaning Data - John Hopkins on Coursera
Final Project

The R script, run_analysis.R, does the following:

If necessary, it will download and unzip the dataset automatically and place it in a new 'project' folder in your current working directory
It loads packages tibble, dplyr, and data.table *** IMPORTANT: If you do not have these packages installed, then you first must install them for this script to run properly ***
Reads and merges the training and test datasets into one data set.
Extracts the measurements on the mean and standard deviation.
Adds descriptive activity names to describe the activity codes contained in the data set.
Labels the dataset with descriptive variable names.
Creates a tidy data set with the average of each variable for each activity and each subject.
Writes the end result into tidyproject.txt.