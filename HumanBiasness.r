# IMPORT LIBRARIES

library(tidyverse)
library(stringr)


# IMPORT DATASET

data <- read.csv("responses.csv", stringsAsFactors = FALSE)


# DATASET OVERVIEW

nrow(data)
head(data)
colnames(data)
str(data)


# RENAME COLUMNS

colnames(data) <- c(
  "timestamp",
  "consent",
  "seq10",
  "seq20",
  "belief",
  "stats_bg",
  "confidence"
)

colnames(data)


# DATA CLEANING

# convert sequences to character
data$seq10 <- as.character(data$seq10)
data$seq20 <- as.character(data$seq20)

# remove non-binary characters
clean_binary <- function(x){
  str_replace_all(x, "[^01]", "")
}

data$seq10 <- clean_binary(data$seq10)
data$seq20 <- clean_binary(data$seq20)

head(data$seq10)
head(data$seq20)


# CHECK SEQUENCE LENGTHS

table(nchar(data$seq10))
table(nchar(data$seq20))


# FILTER VALID SEQUENCES

filtered_data <- data %>%
  filter(
    nchar(seq10) >= 10,
    nchar(seq20) >= 14
  )

nrow(filtered_data)
head(filtered_data)
str(filtered_data)


# FUNCTION TO COUNT RUNS

count_runs <- function(sequence){
  
  chars <- unlist(strsplit(sequence, ""))
  
  runs <- sum(chars[-1] != chars[-length(chars)]) + 1
  
  return(runs)
}

# calculate runs
filtered_data$runs10 <- sapply(filtered_data$seq10, count_runs)
filtered_data$runs20 <- sapply(filtered_data$seq20, count_runs)

head(filtered_data)


# COUNT NUMBER OF 1s

count_ones <- function(seq){
  sum(strsplit(seq,"")[[1]] == "1")
}

filtered_data$ones10 <- sapply(filtered_data$seq10, count_ones)
filtered_data$ones20 <- sapply(filtered_data$seq20, count_ones)

head(filtered_data)


# BASIC STATISTICS

mean(filtered_data$runs10)
mean(filtered_data$runs20)

summary(filtered_data$runs10)
summary(filtered_data$runs20)

summary(filtered_data$ones10)
summary(filtered_data$ones20)


# EXPECTED RUNS (TRUE RANDOMNESS)

expected_runs10 <- 1 + (2 * filtered_data$ones10 * (10 - filtered_data$ones10)) / 10
expected_runs20 <- 1 + (2 * filtered_data$ones20 * (20 - filtered_data$ones20)) / 20

filtered_data$expected_runs10 <- expected_runs10
filtered_data$expected_runs20 <- expected_runs20

# randomness deviation score
filtered_data$rand_dev10 <- abs(filtered_data$runs10 - expected_runs10)
filtered_data$rand_dev20 <- abs(filtered_data$runs20 - expected_runs20)


# DISTRIBUTION OF RUNS

ggplot(filtered_data, aes(x = runs10)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(
    title = "Distribution of Runs in 10-digit Sequences",
    x = "Number of Runs",
    y = "Frequency"
  )

ggplot(filtered_data, aes(x = runs20)) +
  geom_histogram(binwidth = 1, fill = "lightgreen", color = "black") +
  labs(
    title = "Distribution of Runs in 20-digit Sequences",
    x = "Number of Runs",
    y = "Frequency"
  )


# DISTRIBUTION OF 1s

ggplot(filtered_data, aes(x = ones10)) +
  geom_histogram(binwidth = 1, fill = "pink", color = "black") +
  labs(
    title = "Number of 1s in 10-digit Sequences",
    x = "Count of 1s",
    y = "Frequency"
  )

ggplot(filtered_data, aes(x = ones20)) +
  geom_histogram(binwidth = 1, fill = "purple", color = "black") +
  labs(
    title = "Number of 1s in 20-digit Sequences",
    x = "Count of 1s",
    y = "Frequency"
  )


# CONFIDENCE VS RANDOMNESS

cor(as.numeric(filtered_data$confidence), filtered_data$runs10)
cor(as.numeric(filtered_data$confidence), filtered_data$runs20)

# boxplots
ggplot(filtered_data, aes(x = factor(confidence), y = runs10)) +
  geom_boxplot(fill = "skyblue") +
  labs(
    title = "Confidence vs Randomness (10-digit)",
    x = "Confidence Level",
    y = "Number of Runs"
  )

ggplot(filtered_data, aes(x = factor(confidence), y = runs20)) +
  geom_boxplot(fill = "lightgreen") +
  labs(
    title = "Confidence vs Randomness (20-digit)",
    x = "Confidence Level",
    y = "Number of Runs"
  )

# scatter plot
ggplot(filtered_data, aes(x = as.numeric(confidence), y = runs10)) +
  geom_jitter(width = 0.2, alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "Confidence vs Randomness Trend",
    x = "Confidence Level",
    y = "Runs in Sequence"
  )


# RANDOMNESS DEVIATION ANALYSIS

ggplot(filtered_data, aes(x = factor(confidence), y = rand_dev10, fill = factor(confidence))) +
  geom_boxplot() +
  labs(
    title = "Confidence vs Deviation from True Randomness",
    x = "Confidence Level",
    y = "Randomness Deviation"
  )


# STATISTICS BACKGROUND DISTRIBUTION

table(filtered_data$stats_bg)

stats_counts <- filtered_data %>%
  count(stats_bg)

# donut chart
ggplot(stats_counts, aes(x = 2, y = n, fill = stats_bg)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  xlim(0.5, 2.5) +
  theme_void() +
  labs(
    title = "Distribution of Statistics Background",
    fill = "Stats Background"
  )


# RANDOMNESS VS STATS BACKGROUND

ggplot(filtered_data, aes(x = stats_bg, y = runs10, fill = stats_bg)) +
  geom_boxplot() +
  labs(
    title = "Randomness vs Statistics Background",
    x = "Statistics Background",
    y = "Number of Runs"
  )

# mean comparison
filtered_data %>%
  group_by(stats_bg) %>%
  summarise(avg_runs = mean(runs10)) %>%
  ggplot(aes(x = stats_bg, y = avg_runs, fill = stats_bg)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Average Randomness by Statistics Background",
    x = "Statistics Background",
    y = "Average Runs"
  )

# deviation comparison
ggplot(filtered_data, aes(x = stats_bg, y = rand_dev10, fill = stats_bg)) +
  geom_boxplot() +
  labs(
    title = "Statistics Background vs Randomness Deviation",
    x = "Statistics Background",
    y = "Deviation from True Randomness"
  )

# Human Runs vs Theoretical Runs
ggplot(filtered_data, aes(x = expected_runs10, y = runs10)) +
  geom_point(color = "blue", size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(
    title = "Human Randomness vs Expected Randomness",
    x = "Expected Runs (True Random)",
    y = "Observed Runs (Human Generated)"
  ) +
  theme_minimal()

# Confidence vs Randomness Deviation
ggplot(filtered_data, aes(x = as.numeric(confidence), y = rand_dev10)) +
  geom_point(color = "purple", size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", color = "black") +
  labs(
    title = "Confidence vs Deviation from Randomness",
    x = "Confidence Level",
    y = "Randomness Deviation"
  ) +
  theme_minimal()

# Randomness Comparison by Statistics Background
ggplot(filtered_data, aes(x = stats_bg, y = rand_dev10, fill = stats_bg)) +
  geom_boxplot() +
  labs(
    title = "Effect of Statistics Background on Randomness",
    x = "Statistics Background",
    y = "Deviation from True Randomness"
  ) +
  theme_minimal()

