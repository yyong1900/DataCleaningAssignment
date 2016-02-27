
##coursera course work assignment 2/26

library(plyr)


# reading in the activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# reading in the feature column names
feature_names <- read.table("./UCI HAR Dataset/features.txt")
feature_names<-feature_names[,2]

# reading in x and y datas.
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

x_total<-rbind(x_test, x_train)
y_total<-rbind(y_test, y_train)

#merging messes up the sequencing!!! don't do that!!!
#y_total<-merge(y_total, activity_labels, all.x=TRUE)
#y_total<-as.data.frame(y_total[,2])
names(y_total)<-"activities_id"
names(activity_labels)[1]<-"activities_id"

#read in the individual ids
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#combining the data together
subject_total<-rbind(subject_test, subject_train)
names(subject_total)<-"subject"

#changing the feature names so the columns are readable
names(x_total)<-feature_names
x_total<-x_total[,grepl("mean|std", feature_names)]


# combine x and y together
total_data <- cbind(x_total, y_total, subject_total)



#merging in the activities last since merge function messes up the sequencing before
total_data<-merge(total_data, activity_labels)
names(total_data)[names(total_data) == 'V2'] <- 'activity'
total_data<-total_data[2:ncol(total_data)]


#getting the mini dataset
mini_data <- ddply(total_data, c("activity", "subject"), function(x) colMeans(x[,1:79]))

#getting the output into text file
write.table(mini_data, file = "./mini_data.txt", row.name=FALSE)
