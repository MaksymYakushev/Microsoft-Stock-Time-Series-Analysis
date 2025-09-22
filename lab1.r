# Import data in R
stock <- read.csv("Microsoft_Stock.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
stock$Date <- as.Date(stock$Date, tryFormats = c("%Y-%m-%d", "%m/%d/%Y", "%d.%m.%Y"))

print(head(stock))

# Verification that the Data Represents a Time Series
str(stock)

# Plotting a Time Series Graph
msft_ts <- ts(stock$Close, frequency = 252, start = c(2015, 1))
png("Microsoft-Stock-Price-Over-Time.png", width = 700, height = 500)
plot(msft_ts, type = "l",
     main = "Microsoft Stock Price Over Time",
     ylab = "Closing Price", xlab = "Date", xaxt = "n")
dev.off()

time_values <- time(msft_ts)
year_positions <- seq(2015, 2021, by = 1)
axis(1, at = year_positions, labels = year_positions)

# Basic Time Series Analysis

# a) Is there a trend in this series? If so, what kind?
decomp <- stl(msft_ts, s.window = "periodic")

png("Trend-Microsoft-Stock-Price.png", width = 700, height = 500)
plot(decomp$time.series[, "trend"], type = "l",
     main = "Trend Microsoft Stock Price",
     ylab = "Closing Price", xlab = "Date")
dev.off()

# b) Are seasonal variations characteristic of this series?
png("STL-Microsoft-Stock-Price.png", width = 700, height = 500)
plot(decomp, main = "STL Microsoft Stock Price")
dev.off()

# c) Are there any cycles present in the series?
# As seen from the graph, there are no strict cyclical patterns; if any fluctuations exist, they appear to be random.

# d) Does the variance change over time?

library(zoo)

rolling_sd <- rollapply(stock$Close, width = 63, FUN = sd, fill = NA)

png("Rolling-Standard-Deviation-of-Microsoft-Stock.png", width = 700, height = 500)
plot(stock$Date, rolling_sd, type="l", col="purple", lwd=2,
     main="Rolling Standard Deviation of Microsoft Stock",
     xlab="Date", ylab="SD (63 days)")
dev.off()

# e) What can be said about the stationarity of this time series?
library(tseries)

print(adf.test(msft_ts))
print(kpss.test(msft_ts))

# Plotting the Correlogram or Autocorrelation Function
png("ACF.png", width = 700, height = 500)
acf(msft_ts,lag.max = 24, main = "ACF")
dev.off()

# Plotting the Partial Autocorrelation Function
png("PACF.png", width = 700, height = 500)
pacf(msft_ts,lag.max = 24, main = "PACF")
dev.off()

# Building and analyzing the first-differenced series of the original data, plotting and correlogram
diff_data <- diff(msft_ts) 

png("diff-of-Microsoft-Close.png", width = 700, height = 500)
plot(diff_data, type = "l", col = "blue", lwd = 1.5,
     main = "(diff) of Microsoft Close",
     ylab = "diff(Close)", xlab = "Date")
dev.off()

print(adf.test(diff_data))
print(kpss.test(diff_data))

png("ACF-after-first-diff.png", width = 700, height = 500)
acf(diff_data, lag.max = 24, main = "ACF after first diff")
dev.off()

png("PACF-after-first-diff.png", width = 700, height = 500)
pacf(diff_data, lag.max = 24, main = "PACF after first diff")
dev.off()

# Transforming the original series to achieve stationarity and applying additional transformations

# First Differencing
# After the first differencing, the ADF and KPSS tests confirmed that the series became stationary.

# Logarithm Transformation

log_data <- log(msft_ts)

png("Log-transformed-Microsoft-Close.png", width = 700, height = 500)
plot(log_data, main = "Log-transformed Microsoft Close")
dev.off()

png("Log-transformed-Microsoft-Close-ACF.png", width = 700, height = 500)
acf(log_data, lag.max = 24, main = "ACF")
dev.off()

png("Log-transformed-Microsoft-Close-PACF.png", width = 700, height = 500)
pacf(log_data, lag.max = 24, main = "PACF")
dev.off()

# Seasonal Differencing
diff_season <- diff(msft_ts, lag = 252)

png("Seasonal-Difference.png", width = 700, height = 500)
plot(diff_season, main = "Seasonal Difference")
dev.off()

png("Seasonal-Difference-ACF.png", width = 700, height = 500)
acf(diff_season, lag.max = 24, main = "ACF")
dev.off()

png("Seasonal-Difference-PACF.png", width = 700, height = 500)
pacf(diff_season, lag.max = 24, main = "PACF")
dev.off()

# Box–Cox Transformation
library(forecast)

box_ts <- BoxCox(msft_ts, lambda = 0)

png("Box-Cox-transformation.png", width = 700, height = 500)
plot(box_ts, main = "Box-Cox transformation")
dev.off()

png("Box-Cox-transformation-ACF.png", width = 700, height = 500)
acf(box_ts, lag.max = 24, main = "ACF")
dev.off()

png("Box-Cox-transformation-PACF.png", width = 700, height = 500)
pacf(box_ts, lag.max = 24, main = "PACF")
dev.off()