library(data.table)
#library(dplyr)
#library(plyr)
library(reshape2)

# Download and unzip the file.
file <- "humanactivity.zip"
if (!file.exists(file)){
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",file)
}
unzip(file)

# Get activity and feature labels.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)
features <- fread("UCI HAR Dataset/features.txt")$V2

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
### 3. Uses descriptive activity names to name the activities in the data set.
featureslogical <- grepl(".*mean.*|.*std.*", features) # Mean and standard deviation labels locations.
write_activities <- function(x){
	x[,1] <- factor(x[,1], levels=activity_labels[,1], labels=activity_labels[,2])
	return(x)
	# The below operation does not give the right order in the output. Factor values must be used.
	# for(i in 1:nrow(activity_labels)){x[x==activity_labels[i,1],1] <- as.character(activity_labels[i,2])}
}
training_set <- as.data.frame(fread("UCI HAR Dataset/train/X_train.txt"))[,featureslogical]
training_activities <- write_activities(read.table("UCI HAR Dataset/train/y_train.txt"))
training_subjects <- fread("UCI HAR Dataset/train/subject_train.txt")
relevance <- rep("training",nrow(training_activities))
training <- cbind(relevance, training_subjects, training_activities, training_set)
testing_set <- as.data.frame(fread("UCI HAR Dataset/test/X_test.txt"))[,featureslogical]
testing_activities <- write_activities(read.table("UCI HAR Dataset/test/y_test.txt"))
testing_subjects <- fread("UCI HAR Dataset/test/subject_test.txt")
relevance <- rep("testing",nrow(testing_activities))
testing <- cbind(relevance, testing_subjects, testing_activities, testing_set)

### 1. Merges the training and the test sets to create one data set.
### 4. Appropriately labels the data set with descriptive variable names.
Data <- rbind(training, testing)
rm(training,testing)
gc()
colnames(Data) <- c("Relevance", "Subject", "Activity", features[featureslogical])

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data <- as.data.frame(Data)
# Takes too long without melting because R works best with longform.
Data2 <- melt(Data, id.vars=c("Relevance", "Subject", "Activity"),variable.name="Features",value.name="Value")
# Find the average values and present them in the regular wide format. 
Data <- dcast(Data2, Subject + Relevance + Activity ~ Features,mean)
write.table(Data, "tidy.txt", row.names=FALSE, quote=FALSE, sep="\t")

# This Step 5 was taking too long.
# temp3 <- data.frame(matrix(ncol=ncol(Data)-1,nrow=0))
# colnames(temp3) <- c("Subject", "Activity", features[featureslogical])
# for(i in Data$Subject){
	# temp1 <- as.data.frame(Data[Data$Subject==i,])
	# for(j in temp1$Activity){
		# temp2 <- temp1[temp1$Activity==j,]
		# temp3 <- rbind(temp3, c(i,j,colMeans(temp2[,3:ncol(temp2)])))
	# }
# }
# Data <- temp3