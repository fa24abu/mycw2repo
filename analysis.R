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

# STATISTICAL ANALYSIS: Kruskal-Wallis Test
cat("\n=== STATISTICAL TEST: KRUSKAL-WALLIS H-TEST ===\n")

kruskal_test <- kruskal.test(popular_interest ~ evidence_score, data = data)

cat("Kruskal-Wallis H-statistic:", round(kruskal_test$statistic, 4), "\n")
cat("P-value:", round(kruskal_test$p.value, 6), "\n")
cat("Degrees of freedom:", kruskal_test$parameter, "\n\n")

if (kruskal_test$p.value < 0.05) {
  cat("Decision: REJECT the null hypothesis (p =", round(kruskal_test$p.value, 4), "< 0.05)\n")
  cat("Conclusion: There IS a significant difference in popular interest\n")
  cat("            across different evidence score levels.\n")
} else {
  cat("Decision: FAIL TO REJECT the null hypothesis (p >= 0.05)\n")
  cat("Conclusion: There is NO significant difference in popular interest\n")
  cat("            across different evidence score levels.\n")
}

# CORRELATION ANALYSIS: Spearman's Rank Correlation
cat("\n=== CORRELATION ANALYSIS ===\n")

correlation <- cor.test(data$evidence_score, data$popular_interest, 
                        method = "spearman",
                        exact = FALSE)

cat("Spearman's Rank Correlation Coefficient (ρ):", round(correlation$estimate, 3), "\n")
cat("P-value:", round(correlation$p.value, 3), "\n\n")

if (abs(correlation$estimate) < 0.3) {
  strength <- "weak"
} else if (abs(correlation$estimate) < 0.7) {
  strength <- "moderate"
} else {
  strength <- "strong"
}

cat("Interpretation:", strength, "correlation\n")

if (correlation$p.value < 0.05) {
  cat("Result: Statistically significant correlation (p < 0.05)\n")
} else {
  cat("Result: No statistically significant correlation (p >= 0.05)\n")
}


# SUMMARY STATISTICS BY EVIDENCE SCORE
cat("\n=== SUMMARY STATISTICS BY EVIDENCE SCORE ===\n")

# Calculate summary statistics manually (without dplyr)
evidence_levels <- unique(data$evidence_score)
evidence_levels <- sort(evidence_levels)

summary_stats <- data.frame(
  evidence_score = integer(),
  Count = integer(),
  Mean_Interest = numeric(),
  Median_Interest = numeric(),
  SD_Interest = numeric(),
  Min_Interest = numeric(),
  Max_Interest = numeric()
)

for (level in evidence_levels) {
  subset_data <- data$popular_interest[data$evidence_score == level]
  
  summary_stats <- rbind(summary_stats, data.frame(
    evidence_score = level,
    Count = length(subset_data),
    Mean_Interest = round(mean(subset_data), 0),
    Median_Interest = round(median(subset_data), 0),
    SD_Interest = round(sd(subset_data), 0),
    Min_Interest = min(subset_data),
    Max_Interest = max(subset_data)
  ))
}

print(summary_stats)

# SAVE RESULTS TO FILE
cat("\n=== SAVING RESULTS ===\n")

sink("analysis_results.txt")

