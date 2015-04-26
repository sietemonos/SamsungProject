## Creates a tidy data set from the Samsung data set
##
## WARNNING:
## Only works if the "UCI HAR Dataset" directory is in the working directory.
## You can download and unzip the Samsung data set from:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## 
## Inputs:
##   

library(plyr)

dir_path <- dirname(sys.frame(1)$ofile)
DIR_DATA <- "UCI HAR Dataset"
FILE_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

check_script <- function(x, y){
  # Checks working directory matchs with the script and data directory
  #
  # Args: 
  #   x: Directory path of the source file.
  #   y: Directory name of the Samsung data set
  #
  # Returns:
  #   TRUE or FALSE
  
  # a. Check if Samsung data set is in the project directory
  if (file_test("-d", dir_path, DIR_DATA)) {
    
    # b. Check if project directory is the working directory
    if (dir_path != getwd()) {
      setwd(dir_path)  # Set the working directory with dir_path
      
    }
    return (TRUE)
  } else {
    msg <- paste("The Samsung data set is not in the project directory",
                 "Please download the data set from:",
                 FILE_URL, sep = "\n")
    return (msg)
  }
}

proccess_data <- function(){
  # Applies multiple procedures to clean data, including mergin, subseting,
  # variable renaming and mean calculations
  
  # Gets paths for the data main directory and subdirectories test and train.
  data_path <- list.dirs()[which(grepl(DIR_DATA, list.dirs()))[1]]
  
  if (!exists("data_sets")) {
    
    d <- list.dirs(data_path, recursive = FALSE) # Test and train paths
    
    # Reads txt files in test and train directories.
    ft <- list.files(d, pattern = "^.*.txt$", full.names = TRUE)
    data_sets <<- lapply(ft, read.table, header = FALSE)
  }
  
  if (!exists("vn")) {
    # Reads the variable names in features.txt
    vn <<- read.table(file.path(data_path, "features.txt"), header = FALSE)
  }
  
  # Merges with cbind and rbind because data sets there are no common keys
  test_data <- as.data.frame(cbind(data_sets[[3]], data_sets[[1]],
                                   data_sets[[2]]))
  train_data <- as.data.frame(cbind(data_sets[[6]], data_sets[[4]], 
                                    data_sets[[5]]))
  total_data <<- rbind(test_data, train_data)
  
  # Sets the variable names to total_data
  names(total_data) <<- c(list("Activity", "Subject"),
                         c(sapply(vn[[2]], paste, sep = ",")))

  # Extracts only the mean and standard deviation for each measurement.
  filtered_data <<- total_data[, c(1, 2, grep("mean\\(\\)|std\\(\\)", 
                                              names(total_data)))]
  
  # Changes the Activity Labels to a meaningful name
  al <<- read.table(file.path(data_path, "activity_labels.txt"), header = FALSE)
  filtered_data$Activity <<- al$V2[match(filtered_data$Activity, al$V1)]
  
  # Changes the column names for meaninful ones
  names(filtered_data) <<- gsub("\\(\\)", "", names(filtered_data))
  names(filtered_data) <<- gsub("^t", "time", names(filtered_data))
  names(filtered_data) <<- gsub("^f", "frequency", names(filtered_data))
  names(filtered_data) <<- gsub("Acc", "Accelerometer", names(filtered_data))
  names(filtered_data) <<- gsub("Gyro", "Gyroscope", names(filtered_data))
  names(filtered_data) <<- gsub("Mag", "Magnitude", names(filtered_data))
  names(filtered_data) <<- gsub("BodyBody", "Body", names(filtered_data))
  
  # Writes the tidy data
  temp_data <- aggregate(. ~Activity + Subject, filtered_data, mean)
  tidy_data <<- temp_data[order(temp_data$Activity, temp_data$Subject), ]
  write.table(tidy_data, file = "tidydata.txt", quote = FALSE, row.name = FALSE)
}


if (check_script(data_path, DIR_DATA)) {
  proccess_data()
} else {
  stop(msg)  # stops execution and sends an error message
}