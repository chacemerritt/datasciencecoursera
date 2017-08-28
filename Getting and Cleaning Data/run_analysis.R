getwd()
setwd()

#loads activity data sets from test and train within working directory

testactivity  <- read.table("test/Y_test.txt" , header = FALSE)
trainactivity <- read.table("train/Y_train.txt", header = FALSE)

#loads subject data sets from test and train

testsubject  <- read.table("test/subject_test.txt", header = FALSE)
trainsubject <- read.table("train/subject_train.txt", header = FALSE)

#loads features data sets from test and train

testfeatures  <- read.table("test/X_test.txt", header = FALSE)
trainfeatures <- read.table("train/X_train.txt", header = FALSE)


 #Looking at the fragmented data in different txt files
head(testactivity);head(trainactivity);head(testsubject);head(trainsubject);head(testfeatures);head(trainfeatures);

#combines activity, subject, and features sets from test and train repectively
#Merges the training and the test sets to create one data set.

activity <- rbind(trainactivity, testactivity)
subject <- rbind(trainsubject, testsubject)
features <- rbind(trainfeatures, testfeatures)

#changes factor levels(1-6) to match activity labels
labels <- read.table("activity_labels.txt", header = FALSE)
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

#names activity and subject columns

names(activity)<- c("activity")
names(subject)<-c("subject")

#names feature columns from features text file

featurestxt <- read.table("features.txt", head=FALSE)
names(features)<- featurestxt$V2

#selects columns with mean and standard deviation data and subsetting

meanstdev<-c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))
subdata<-subset(features,select=meanstdev)

#Combines data sets with activity names and labels

subjectactivity <- cbind(subject, activity)
finaldata <- cbind(subdata, subjectactivity)

#Clarifying time and frequency variables
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))

#Creates new data set with subject and activity means

suppressWarnings(cleandata <- aggregate(finaldata, by = list(finaldata$subject, finaldata$activity), FUN = mean))
colnames(cleandata)[1] <- "Subject"
names(cleandata)[2] <- "Activity"

#removes avg and stdev for non-aggregated sub and act columns
cleandata <- cleandata[1:68]

#Looking at all the data
head(cleandata)

#Writes tidy data to text file
write.table(cleandata, file = "cleandata.txt", row.name = FALSE)
