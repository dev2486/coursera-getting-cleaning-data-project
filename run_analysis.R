setwd("D:/R/Coursera/Assignment")
if(!file.exists("./data1")){dir.create("./data1")}
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists("./data1/UCI HAR Dataset.zip")){
  download.file(fileurl,'./data1/UCI HAR Dataset.zip', mode = 'wb')
  #since its not a text file but a zip file, mode is switched to binary
  unzip("./data1/UCI HAR Dataset.zip", exdir = "./data1",overwrite = FALSE)
}

features <- read.csv('./data1/UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
nrow(data.train.x)
ncol(data.train.x)
nrow(data.train.activity)
ncol(data.train.activity)
nrow(data.train.subject)
ncol(data.train.subject)
data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train) <- c(c('subject', 'activity'), features)
ncol(data.train)
data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
#first col named subject, second as activity, and rest 561 are named as features variable list
names(data.test) <- c(c('subject', 'activity'), features)

#merge data
data.all <- rbind(data.train, data.test)
dim(data.all)

#get columns with mean and sd
mean_std.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]
ncol(data.sub)
#give activity names
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
head(activity.labels)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]
#new names
names(data.sub)
name.new
name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "Time_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("BodyBody", "Body", name.new)
name.new <- gsub("angle", "Angle", name.new)
name.new <- gsub("gravity", "Gravity", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new
head(data.sub)
data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
data.tidy
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)

