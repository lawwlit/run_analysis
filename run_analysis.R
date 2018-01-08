########################
## run_analysis.R by Lalit Ojha

#downloaded and extracted the zip file manually

#Load activity lables as tables
Labels <- read.table("activity_labels.txt")

#Convert the class of activity as characters
Labels[,2] <- as.character(Labels[,2])

#Load features as tables 
features <- read.table("features.txt")

#convert the class of features as characters
features[,2] <- as.character(features[,2])

#Extracts only the measurements on the mean and standard deviation for each measurement

featuresextracted <- grep(".*mean.*|.*std.*", features[,2])
featuresextracted.names <- features[featuresextracted,2]
featuresextracted.names = gsub('-mean', 'Mean', featuresextracted.names)
featuresextracted.names = gsub('-std', 'Std', featuresWanted.names)
featuresextracted.names <- gsub('[-()]', '', featuresWanted.names)


#Load the training datasets
train <- read.table("X_train.txt")[featuresextracted]

#Load the training lables 
trainActivities <- read.table("Y_train.txt")

#Load the subject who performed the activity window sample
trainSubjects <- read.table("subject_train.txt")



#Merge Training dataset, Activities and Subjects

train <- cbind(trainSubjects, trainActivities, train)

#Load the testing datasets, testing lables and subject who performed the activity window sample (ranges from 1 to 30)

test <- read.table("X_test.txt")[featuresextracted]
testActivities <- read.table("Y_test.txt")
testSubjects <- read.table("subject_test.txt")


#Merge Testing dataset, Activities and Subjects

test <- cbind(testSubjects, testActivities, test)


#Merge the training and the testing data sets to create one data set

CombinedData <- rbind(train, test)


#Appropriately labels the data set with descriptive variable names

colnames(CombinedData) <- c("subject", "activity", featuresextracted.names)


#Convert activities & subjects into factors from activityLabels

CombinedData$activity <- factor(CombinedData$activity, 
                                levels = Labels[,1], 
                                labels = Labels[,2])

CombinedData$subject <- as.factor(CombinedData$subject)


#Convert Combineddata into a molten data frame

library(reshape2)

CombinedData.melted <- melt(CombinedData, id = c("subject", "activity"))

#Cast a molten data frame into data frame subject and activities are breaked by variables and averaged Basically, this creates a independent tidy data set with the average of each variable for each activity and each subject.

CombinedData.mean <- dcast(CombinedData.melted, 
                           subject + activity ~ variable, mean)


#write complete data set as a txt file created with write.table() using row.name=FALSE

write.table(CombinedData.mean, file = "TidyDataSet.txt", 
            row.names = FALSE, quote = FALSE)

