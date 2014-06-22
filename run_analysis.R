library(reshape2)


## read feature names from file
featureNames <- read.table("features.txt")

## read train data
xtrain <- read.table("./train/X_train.txt",col.names = featureNames[,2])

## select relevant parameters that include the mean and stdev of a variable        
xtrain <- xtrain[,grep('mean()|std()',names(xtrain))]

## read subject and activity information fro train data set
subjects <- read.table("./train/subject_train.txt",col.names=c("Subject"))
activity <- read.table("./train/Y_train.txt",col.names=c("Activity"))

## merge all columns to complete train data set
trainSet <-cbind(subjects,activity,xtrain)

## read test data from file
xtest <- read.table("./test/X_test.txt",col.names = featureNames[,2])

## select mean and std from all parameters
xtest <- xtest[,grep('mean()|std()',names(xtest))]

## read subject and activity data sets
subjects <- read.table("./test/subject_test.txt",col.names=c("Subject"))
activity <- read.table("./test/Y_test.txt",col.names=c("Activity"))

## merge all columns to create test data set
testSet <-cbind(subjects,activity,xtest)

## merge test and train data
fullset <- rbind(testSet,trainSet)

## replace activity codes with activity labels
activity_labels <- read.table('activity_labels.txt')
fullset$Activity <- factor(fullset$Activity, levels=c(1,2,3,4,5,6), 
                                       labels=activity_labels$V2)

## reshape data to a single row for each subject and activity combination
full.data.melt <- melt(fullset, id = c("Subject", "Activity"))

full.data.cast <- dcast(full.data.melt, Subject + Activity ~ variable, mean)

## write resulting tidy data to file
write.table(full.data.cast, "tidy.txt", row.names = FALSE, quote = FALSE, sep="\t")



