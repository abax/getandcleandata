Getting and Cleaning Data Course Project
========================================

This repo contains work meant to fulfill the course project requirements of the "Getting and Cleaning Data" Coursera course.

The project consists of obtaining a set of data (provided in the project) and "tidying" it, where "tidy" data has a definition as provided in the course; specifically:

    1. Training and test data sets are merged
    2. A subset (mean, std) of measured data ("features") are included; the rest discarded
    3. Activity labels are descriptive (i.e. human readable rather than, e.g., integers)
    4. The features have descriptive variable names
    5. A second data set consisting of means by subject and activity is included

Usage
-----

There is a document, CodeBook.md, included in this repo which explains the transformations applied to the data and a dictionary describing the data in the final, "tidy" sets.

There is a script, "run_analysis.R", that performs all the work required other than downloading the file (this is trivially accomplished with the `download.file` R command and the appropriate link). This script has a number of functions which do the work:

      * merge_data: merges the test and train feature data and removes the columns we are not interested in
      * merge_subject_data: merges the subject ID information with the merged test/train data frame
      * merge_activity_data: merges the activity label information with the merged test/train data frame
      * make_activity_labels: replaces the integer activity label information with descriptive labels tkane from the data set
      * make_summary_data: takes the mean of each column of measured data grouped by subject and activity
      * analyze: This function calls the other functions to perform the clean-up work required and writes the data to the files specified by the user