library(tidyverse)
library(ggplot2)
library(readr)
library(data.table)  
setwd("data")

# Dplyr verbs reminders: select(look up the special), filter, arrange, mutate, summarize(subfunctions)
# Dplyr func: bind_rows,bind_columns   
# Tidyr reminders: 
#               gather >> multiple columns into 1
#               separate >> separate values into multiple columns
#               spread >> spread one column into multiple
# Fixing character vectors:
#                       toupper()
#                       tolower()
#                       strsplit() - to split variable names
#                       sub() - to substitute a character. Only looks for the 1srt appearence 
#                       gsub() - replace all instances of the character
#                       grep() - look for strings in variable or variable names
#                       grepl() - returns TRUE or FALSE
#                       nchar() - number of characters
#                       substre() - take part of the string
#                       paste(), paste0()
#
# Regular Expressions reminders:
#                       
#
#

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile = "dataset.zip")




features <- read.table("UCI HAR Dataset/features.txt") 
features = features$V2



Xtrain_df <- read.table("UCI HAR Dataset/train/X_train.txt") 
colnames(Xtrain_df) <- features
ytrain_df <- read.table("UCI HAR Dataset/train/y_train.txt") %>% rename("activities" = V1)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt") %>% rename("subject" = V1)

train_dataset <- bind_cols(subject_train,ytrain_df,Xtrain_df)




Xtest_df <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(Xtest_df) <- features
ytest_df <- read.table("UCI HAR Dataset/test/y_test.txt") %>% rename("activities" = V1)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt") %>% rename("subject" = V1)

test_dataset <- bind_cols(subject_test,ytest_df,Xtest_df)






# TASK 1: Marging train and test datasets

dataset <- bind_rows(train_dataset,test_dataset)



# TASK 2: Extracts only the measurements on the mean and standard deviation for each measurement. 


dataset <- dataset %>% 
        
        select(contains(c("subject","activities","mean()","std()")))


# TASK 3: Uses descriptive activity names to name the activities in the data set


dataset <- dataset %>% 
        mutate(activities = case_when(
               activities == 1 ~ "WALKING",
               activities == 2 ~ "WALKING_UPSTAIRS",
               activities == 3 ~ "WALKING_DOWNSTAIRS",
               activities == 4 ~ "SITTING",
               activities == 5 ~ "STANDING",
               activities == 6 ~ "LAYING",
        ))


# TASK 4: Appropriately labels the data set with descriptive variable names. 



colnames(dataset)<- gsub("[0-9]","",colnames(dataset)) %>% trimws()
        



rm(features,Xtest_df,ytest_df,Xtrain_df,ytrain_df,subject_test,subject_train,train_dataset,test_dataset)


# TASK 5: From the data set in step 4, creates a second, independent tidy data set with 
#               the average of each variable 
#               for each activity and each subject.

summary_data <- dataset%>% 
        group_by(subject,activities) %>% 
        summarise_all(mean, na.rm=TRUE)


write.table(summary_data,"mydata.txt",row.names = FALSE)

