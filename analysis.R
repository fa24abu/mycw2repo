library(readr)
library(readxl)

# Load data using readr
data <- read_csv("CanabisBenefits.csv")

# Clean column names
colnames(data)[4] <- "evidence_score"
colnames(data)[5] <- "popular_interest"

# Display basic information
cat("CANNABIS BENEFITS STATISTICAL ANALYSIS\n")
cat("Total health conditions analyzed:", nrow(data), "\n\n")

cat("Evidence Score Distribution:\n")
print(table(data$evidence_score))

cat("\nPopular Interest Summary Statistics:\n")
print(summary(data$popular_interest))

# VISUALIZATION 1: Boxplot
cat("\nCreating boxplot...\n")

png("evidence_vs_interest_boxplot.png", width = 800, height = 600, res = 100)

boxplot(popular_interest ~ evidence_score, 
        data = data,
        col = "#69b3a2",
        main = "Popular Interest in Cannabis Benefits by Evidence Score",
        xlab = "Evidence Score (0=Harmful, 1=Insufficient, 6=Strong)",
        ylab = "Popular Interest (Google Searches)",
        border = "#404080",
        las = 1)
# Add points to show individual data
stripchart(popular_interest ~ evidence_score, 
           data = data,
           vertical = TRUE,
           method = "jitter",
           add = TRUE,
           pch = 16,
           col = rgb(64/255, 64/255, 128/255, 0.5),
           jitter = 0.2)
dev.off()

cat("Boxplot saved: evidence_vs_interest_boxplot.png\n")

# VISUALIZATION 2: Histogram
cat("Creating histogram...\n")

png("popular_interest_histogram.png", width = 800, height = 600, res = 100)

hist(data$popular_interest,
     breaks = 30,
     col = "#69b3a2",
     border = "black",
     main = "Distribution of Popular Interest in Cannabis Health Benefits",
     xlab = "Popular Interest (Google Searches)",
     ylab = "Frequency (Number of Conditions)",
     las = 1)

dev.off()

cat("Histogram saved: popular_interest_histogram.png\n")

