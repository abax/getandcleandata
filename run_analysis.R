getmeasures <- function(datadir) {
    xform_label <- function(lbl) {
        l <- gsub("-", "", lbl)
        l <- gsub("(", "", l, fixed=TRUE)
        l <- gsub(")", "", l, fixed=TRUE)
        l <- gsub(",", "", l)
        tolower(l)
    }
    labelsdf <- read.table(paste(datadir, "/features.txt",sep=""));
    labels <- sapply(labelsdf$V2, xform_label)
    mean_std_cols <- labels[grep("(mean$|std$|mean[xyz]$|std[xyz]$)", labels)]
}

## Merge test and train data
merge_data <- function(datadir) {
    xform_label <- function(lbl) {
        l <- gsub("-", "", lbl)
        l <- gsub("(", "", l, fixed=TRUE)
        l <- gsub(")", "", l, fixed=TRUE)
        l <- gsub(",", "", l)
        tolower(l)
    }
    labelsdf <- read.table(paste(datadir, "/features.txt",sep=""));
    labels <- sapply(labelsdf$V2, xform_label)
    traindata <- read.table(paste(datadir,"/train/X_train.txt", sep=""))
    testdata <- read.table(paste(datadir, "/test/X_test.txt", sep=""))
    df <- rbind(traindata, testdata)
    colnames(df) <- labels
    mean_std_cols <- getmeasures(datadir)
    df[,mean_std_cols]
}

merge_subject_data <- function(datadir, featuredf) {
    traindata <- read.table(paste(datadir, "/train/subject_train.txt", sep=""))
    testdata <- read.table(paste(datadir, "/test/subject_test.txt", sep=""))
    subjectdf <- rbind(traindata, testdata)
    colnames(subjectdf) <- c("subjectid")
    cbind(subjectdf, featuredf)
}

merge_activity_data <- function(datadir, df) {
    traindata <- read.table(paste(datadir, "/train/y_train.txt", sep=""))
    testdata <- read.table(paste(datadir, "/test/y_test.txt", sep=""))
    activitydf <- rbind(traindata, testdata)
    colnames(activitydf) <- c("activitylabel")
    cbind(df, activitydf)
}

make_activity_labels <- function(datadir, df) {
    xform <- function(lbl) {
        l <- gsub("_", " ", lbl)
        tolower(l)
    }
    labels <- read.table(paste(datadir, "/activity_labels.txt", sep=""))
    labels$V2 <- sapply(labels$V2, xform)
    colnames(labels) <- c("activitylabel", "activity")
    merge(x=df, y=labels, by="activitylabel", all.y=TRUE)
}

make_summary_data <- function(datadir, df) {
    measures <- getmeasures(datadir)
    meanagg <- by(df[measures], df[c("subjectid","activity")], colMeans)
    cbind(expand.grid(dimnames(meanagg)), do.call(rbind,meanagg))
}

analyze <- function(datadir, featfile, summaryfile) {
    writeLines("Merging train and test feature data")
    featuredf <- merge_data(datadir)
    writeLines("Adding subject IDs to data frame")
    featuredf <- merge_subject_data(datadir, featuredf)
    writeLines("Adding activity labels to data frame")
    featuredf <- merge_activity_data(datadir, featuredf)
    writeLines("Making descriptive activity labels")
    featuredf <- make_activity_labels(datadir, featuredf)
    colstokeep <- append(c("subjectid","activity"), getmeasures(datadir))
    featuredf <- featuredf[,colstokeep]
    writeLines("Generating stats summary of features per subject and activity")
    summarydf <- make_summary_data(datadir, featuredf)
    writeLines("Writing feature data")
    write.csv(featuredf, file=featfile)
    writeLines("Writing summary data")
    write.csv(summarydf, file=summaryfile)
    summarydf
}
