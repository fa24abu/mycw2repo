# Cannabis Benefits Analysis - Complete Working Code
# Load libraries
library(ggplot2)
library(dplyr)

# Load data
data <- read.csv("CanabisBenefits.csv", stringsAsFactors = FALSE)

# Clean column names
colnames(data)[4] <- "evidence_score"
colnames(data)[5] <- "popular_interest"

# Display basic information
cat("CANNABIS BENEFITS STATISTICAL ANALYSIS")
cat("Total health conditions analyzed:", nrow(data) )

cat("Evidence Score Distribution: ")
print(table(data$evidence_score))

cat("\nPopular Interest Summary Statistic: ")
print(summary(data$popular_interest))
