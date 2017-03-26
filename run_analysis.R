## Read the data

setwd("./UCI HAR Dataset")
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

df_train <- cbind(subject_train,y_train,X_train)

subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

df_test <- cbind(subject_test,y_test,X_test)

##Combine the two datasets
df <- rbind(df_train,df_test)

##Input column names
features <- read.table("features.txt")
col.label <- c("SubjectID", "Activities", as.character(features$V2))

names(df) <- col.label

## Label "Activities" with proper charater strings
df$Activities[df$Activities==1] <- "WALKING"
df$Activities[df$Activities==2] <- "WALKING_UPSTAIRS"
df$Activities[df$Activities==3] <- "WALKING_DOWNSTAIRS"
df$Activities[df$Activities==4] <- "SITTING"
df$Activities[df$Activities==5] <- "STANDING"
df$Activities[df$Activities==6] <- "LAYING"

## Subset the columns for mean or std dev measurements only
df <- df[,c(1,2,grep('mean|std',names(df), ignore.case=TRUE))]

## Make better column labels
clean_label <- make.names(names(df))
clean_label <- gsub("...", "", clean_label, fixed=TRUE)
clean_label <- gsub("..", "", clean_label, fixed=TRUE)
clean_label <- gsub('[.]$', "", clean_label)
clean_label <- gsub('tBody', "timeBody", clean_label)
clean_label <- gsub('tGravity', "timeGravity", clean_label)
clean_label <- gsub('fBody', "FFTBody", clean_label)

names(df) <- clean_label

## Change class of "Activities" to Factor
df$Activities <- as.factor(df_subset$Activities)

## Load the dplyr and tidyr packages
library(dplyr)
library(tidyr)

##Calculate the mean of each variable
df_group <- df %>% group_by(SubjectID, Activities) %>% summarize_each(funs(mean))

##Tidying the data so each row contains only one mean value for each measurement for each SubjectID and each activity
df_tidy <- df_group %>% gather("Measurements", "Mean.Values", 3:88) %>% arrange(SubjectID, Activities)

## Write the result in txt file

write.table(df_tidy, "tidied_data.txt",row.name=FALSE)