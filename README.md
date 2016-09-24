# Getting and Cleaning Data Course Project

## Introduction

This repository contains a submission for the peer reviewed project for the "Getting and Cleaning Data" course.

## Project scope

The project scope is the data analysis for the [Human Activity Recognition Using Smartphones dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Repository content

1. `run_analsis.R` - R script for data download and analysis
2. `README.md` - project description and running instructions
3. `codebook.md` - resulting dataset format description

## Running instructions

1. clone this project and go to the target folder
2. optional step: create folder `data` in the target folder and copy the Samsung data into it. If you skip this step, a download from the [original source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) will be started.
3. start R and run the script `run_analysis.R`
4. the script produces a new file named `tidy.txt` in the `output` folder of the working directory.

## Result

Result file contains tidy dataset. The file codebook.md contains detailed dataset format description.
