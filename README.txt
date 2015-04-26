==================================================================
Samsung Data Set Analysis
file: run_analysis.R
Version 1.0
==================================================================
Lizeth Milena López Valero
Data Science Analysis
Cleaning and Cleansing Data
sietemonos@gmail.com
==================================================================

The script proccess the raw data from Samsung Human Activity Recognition project, from test and train activities performed by 30 volunteers, stored in train and test folders: by the following steps:

1. Reads all the train and test data from the files:

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.


2. Merges in a whole data set.

3. Extracts only the mean and standard deviation for each measurement in the data set.

4. Changes the activity labels and the column names for meaningful names, from the files:

- 'activity_labels.txt': Links the class labels with their activity name.

- 'features.txt': The complete list of variables of each feature vector.

4. From the result data set, creates a new one data set with the average of each variable for each activity and each subject.

5. Writes the second data set in the 'tidydata.txt' file.


*******WARNING: ********

This script only works if the Samsung's "UCI HAR Dataset" directory is in the working directory.

You can download and unzip the Samsung data set from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip