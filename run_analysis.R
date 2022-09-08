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






Xtrain_df <- read_delim("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
ytrain_df <- read_tsv("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
subject_train <- read_tsv("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)


Xtest_df <- read_delim("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
ytest_df <- read_tsv("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
subject_test <- read_tsv("UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)



features <- read_tsv("UCI HAR Dataset/features.txt", col_names = FALSE)





# TASK1: Merge train and test df by columns will not work. They have different number of columns 



Xtrain_df <- Xtrain_df %>% 
        select(1:561)
        
        
Xtest_df <- Xtest_df %>% 
        select(1:561) 


# Merging clean train and test data sets in Xdf

Xdf <- bind_rows(Xtrain_df,Xtest_df) # Xdf contains all observations
ydf <- bind_rows(ytrain_df,ytest_df) # ydf contains all activities labeled by their numbers

#merging train and test subject column

subjectdf<- bind_rows(subject_train,subject_test) 
colnames(subjectdf) <- "SUBJECT"



features = tbl_df(features)
features = t(features) #transpose


# making the features data set as Variable Names 
colnames(Xdf) <- features[1,]







# TASK 2: Extracts only the measurements on the mean and standard deviation for each measurement. 


Xdf <- Xdf %>% 
        select(contains(c("mean()","std()")))


# TASK 3: Uses descriptive activity names to name the activities in the data set

colnames(ydf) <- "ACTIVITIES"

ydf <- ydf %>% 
        mutate(ACTIVITIES = case_when(
                ACTIVITIES == 1 ~ "WALKING",
                ACTIVITIES == 2 ~ "WALKING_UPSTAIRS",
                ACTIVITIES == 3 ~ "WALKING_DOWNSTAIRS",
                ACTIVITIES == 4 ~ "SITTING",
                ACTIVITIES == 5 ~ "STANDING",
                ACTIVITIES == 6 ~ "LAYING",
        ))


final_df <- bind_cols(ydf, Xdf)


# TASK 4: Appropriately labels the data set with descriptive variable names. 



colnames(final_df)<- gsub("[0-9]","",colnames(final_df)) %>% trimws()
        
final_df <- bind_cols(subjectdf,final_df)



rm(aux,aux2,url,features,Xdf,Xtest_df,ydf,ytest_df,Xtrain_df,ytrain_df,subject_test,subject_train,subjectdf,not_all_na)


# TASK 5: From the data set in step 4, creates a second, independent tidy data set with 
#               the average of each variable 
#               for each activity and each subject.

summary_data <- final_df %>% 
        group_by(SUBJECT,ACTIVITIES) %>% 
        summarise_all(mean, na.rm=TRUE)


write.table(summary_data,"mydata.txt",row.names = FALSE)

