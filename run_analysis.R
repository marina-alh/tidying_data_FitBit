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
