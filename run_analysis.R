library(tidyverse)
library(ggplot2)
library(readr)
library(data.table)  


url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url, destfile = "data//dataset.zip")





files <- c("y_train.txt", "X_train.txt")

temp <- lapply(files, fread, sep=" ")

data <- do.call(cbind, temp)
