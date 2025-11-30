# Cannabis Benefits Analysis - Complete Working Code
# Load libraries
library(ggplot2)
library(dplyr)

# Load data
data <- read.csv("CanabisBenefits.csv", stringsAsFactors = FALSE)

# Clean column names
colnames(data)[4] <- "evidence_score"
colnames(data)[5] <- "popular_interest"

print<-head(data, 5)
