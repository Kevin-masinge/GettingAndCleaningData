# Getting and Cleaning Data - Course Project

## Overview

This repository contains the script and documentation for the final
project of the *Getting and Cleaning Data* course. The goal of the
project is to take the raw **Human Activity Recognition Using
Smartphones Dataset** (collected from accelerometer and gyroscope
data on a Samsung Galaxy S smartphone) and produce a tidy data set
suitable for further analysis.

## Files in this repository

| File             | Description                                                                 |
|------------------|------------------------------------------------------------------------------|
| `run_analysis.R` | R script that downloads (if needed), merges, cleans, and summarizes the data |
| `CodeBook.md`    | Describes the variables, data, and transformations used to clean the data    |
| `tidy_data.txt`  | The resulting tidy data set (output of `run_analysis.R`)                     |
| `README.md`      | This file                                                                     |

## Source data

The raw data used in this project comes from the UCI Human Activity
Recognition Using Smartphones Dataset, available here:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

A full description of the original data is available at:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## How to run the script

1. Place `run_analysis.R` in your working directory (or simply run it
   — it will download and unzip the data automatically if the
   `UCI HAR Dataset` folder is not already present).
2. Make sure the `dplyr` package is installed:
   ```r
   install.packages("dplyr")
   ```
3. Run the script in R:
   ```r
   source("run_analysis.R")
   ```
4. The script will produce `tidy_data.txt` in the working directory.

## What the script does

The script `run_analysis.R` performs the following steps, in order:

1. **Downloads and unzips the raw data** (if not already present in
   the working directory).
2. **Reads in** the training set, test set, subject identifiers,
   activity labels, and feature (column) names.
3. **Assigns descriptive column names** to the measurement data using
   `features.txt`.
4. **Merges the training and test sets** into one combined data set,
   including subject ID and activity ID as columns.
5. **Extracts only the columns** corresponding to the mean and
   standard deviation for each measurement (i.e. columns containing
   `mean()` or `std()` in their names), plus `subject` and
   `activity_id`.
6. **Replaces the numeric activity IDs** with descriptive activity
   names (e.g. `WALKING`, `SITTING`) using `activity_labels.txt`.
7. **Cleans up the variable names** to be more descriptive (e.g.
   expanding abbreviations like `Acc` to `Accelerometer`, `t` to
   `Time`, `f` to `Frequency`, etc.) and removes punctuation.
8. **Creates a second, independent tidy data set** that contains the
   average of each variable, grouped by `subject` and
   `activity_name`. This is written out to `tidy_data.txt`.

See `CodeBook.md` for a full description of each variable in the
final tidy data set.

## Reading the tidy data set back into R

```r
tidyData <- read.table("tidy_data.txt", header = TRUE)
```
