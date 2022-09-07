library(tidyverse)
library(ggplot2)
library(readr)
library(data.table)  

# Dplyr verbs reminders: select, filter, arrange, mutate, summarize(subfunctions)
# Dplyr func: bind_rows,bind_columns   
# Tidyr reminders: 
#               gather >> multiple columns into 1
#               separate >> separate values into multiple columns
#               spread >> spread one column into multiple


url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile = "data//dataset.zip")



# 
# files <- c("y_train.txt", "X_train.txt")
# 
# temp <- lapply(files, fread, sep=" ")
# 
# data <- do.call(cbind, temp)


Xtrain_df <- read_delim("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
ytrain_df <- read_tsv("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
Xtest_df <- read_delim("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
ytest_df <- read_tsv("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)

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

features = tbl_df(features)
features = t(features) #transpose

rm(aux,aux2,ytest_df,ytrain_df,Xtest_df,Xtrain_df)

colnames(Xdf) <- features[1,]


colnames(Xdf)
