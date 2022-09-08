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

download.file(url, destfile = "data//dataset.zip")



# 
# files <- c("y_train.txt", "X_train.txt")
# 
# temp <- lapply(files, fread, sep=" ")
# 
# data <- do.call(cbind, temp)


## TASK 1: Merges the training and the test sets to create one data set.

Xtrain_df <- read_delim("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
ytrain_df <- read_tsv("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
subject_train <- read_tsv("UCI HAR Dataset/train/subject_train.txt", col_names = FALSE)


Xtest_df <- read_delim("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
ytest_df <- read_tsv("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
subject_test <- read_tsv("UCI HAR Dataset/test/subject_test.txt", col_names = FALSE)


tbl_df(Xtest_df)
tbl_df(Xtrain_df)
tbl_df(ytest_df)
tbl_df(ytrain_df)


features <- read_tsv("UCI HAR Dataset/features.txt", col_names = FALSE)





# Merge train and test df by columns will not work. They have different number of oolumns 

# manualy inspecting Xtrain_df
sum(is.na(Xtrain_df$X1)) # Apparently first column is empty

# testing by trying to drop all NA columns

not_all_na <- function(x) {!all(is.na(x))}



# The number of features droped by one but they are still different

# I will remove a exceeding features from test and train to match the number of features in the file 

aux <- Xtrain_df %>% 
        select(where(not_all_na)) %>% 
        select(1:561)
        
        
aux2 <- Xtest_df %>% 
        select(where(not_all_na)) %>% 
        select(1:561) 

Xdf <- bind_rows(aux,aux2)
ydf <- bind_rows(ytrain_df,ytest_df)
subjectdf<- bind_rows(subject_train,subject_test)
colnames(subjectdf) <- "SUBJECT"

features = tbl_df(features)
features = t(features) #transpose


colnames(Xdf) <- features[1,]


colnames(Xdf)





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

final_df


rm(aux,aux2,actv,features,Xdf,Xtest_df,ydf,ytest_df,Xtrain_df,ytrain_df,subject_test,subject_train,subjectdf)


# TASK 5: From the data set in step 4, creates a second, independent tidy data set with 
#               the average of each variable 
#               for each activity and each subject.

summary_data <- final_df %>% 
        group_by(SUBJECT,ACTIVITIES) %>% 
        summarise_all(mean, na.rm=TRUE)

