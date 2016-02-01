library(dplyr)
setwd("UCI HAR Dataset")
## 1. Merge the training and test sets to create one data set

# Load data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create X data set
xdt <- rbind(x_train, x_test)

# create Y data set
ydt <- rbind(y_train, y_test)

# create SUBJECT data set
subdt <- rbind(subject_train, subject_test)

## 2. Extract only the measurements on the mean and standard deviation for each measurement

# get features names
feat <- read.table("features.txt")

# get only columns with mean or std in their names
meanstd_feat <- grep(".*mean.*|.*std.*", feat$V2)
xdt <- xdt[, meanstd_feat]

# rename columns
names(xdt) <- feat[meanstd_feat, 2]

## 3. Use descriptive activity names to name the activities in the data set

# get activity names
act <- read.table("activity_labels.txt")

# add activity names
ydt[, 1] <- act[ydt[, 1], 2]

# change column name
names(ydt) <- "activity"

## 4. Appropriately label the data set with descriptive variable names

# change column name
names(subdt) <- "subject"

# create a single data set with all the data
alldt <- cbind(xdt, ydt, subdt)

# 5. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

# average by activity and subject
tidydt <- alldt %>% group_by(subject,activity) %>%
                        summarise_each(funs(mean))

# save data set
write.table(tidydt, "tidy_data.txt",row.name=F)

