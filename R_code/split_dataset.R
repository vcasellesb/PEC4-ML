#!/usr/bin/env Rscript

# This file sepparates the whole dataset into
#     * 2/3 -> training data
#     * 1/3 -> test data
# If you wish to change this feel free. Just update the probabilities given
# to sample(). Other this to consider is the format of the input dataset.
# Here, we assume that the dataset has a column containing row names as the first
# column. Again, change to your convenience.

args = commandArgs(trailingOnly=TRUE)

if (length(args) < 1){stop("No input dataset has been provided.")}

file <- args[1]
dataset <- read.csv(file = file, row.names = 1)

## Here we will get rid of all column which have NA(s) in them
which_cols <- apply(dataset, MARGIN = 2, FUN = function(x) any(is.na(x)))
if (length(which_cols) >= 1){
  dataset <- dataset[, !which_cols]
}

probs = c(2/3, 1/3)

seed = 123131
set.seed(seed)
sampleton <- sample(c(T, F), size=nrow(dataset), replace=T, prob=probs)

train_data <- dataset[sampleton,]
test_data <- dataset[!sampleton,]

if ((nrow(train_data) + nrow(test_data)) != nrow(dataset)){
  stop('Something has gone terribly wrong.')
}

write.csv(train_data, 'train_data.csv')
write.csv(test_data, 'test_data.csv')