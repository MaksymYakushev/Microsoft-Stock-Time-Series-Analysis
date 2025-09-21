# Microsoft Stock Time Series Analysis

This repository contains time series analysis and forecasting of Microsoft (MSFT) stock prices using R. The dataset, obtained from Kaggle, covers the period from April 2015 to April 2021 and includes daily Open, High, Low, Close prices, and trading Volume. The project demonstrates:

- Exploratory data analysis and visualization of MSFT stock trends
- Stationarity testing with ADF and KPSS
- Transformations (differencing, seasonal differencing, logarithmic, Box–Cox)
- ACF and PACF analysis
- Identification of trends, seasonality, and volatility in stock prices

The main goal is to preprocess the Microsoft stock time series and prepare it for building forecasting models.

Let's start

## Table of Contents
- [Dataset Selection](#dataset-selection)
- [Visualization and Exploratory Analysis](#visualization-and-exploratory-analysis)
  - [Import data in R](#import-data-in-r)
  - [Verification that the Data Represents a Time Series](#verification-that-the-data-represents-a-time-series)
  - [Plotting a Time Series Graph](#plotting-a-time-series-graph)
  - [Basic Time Series Analysis](#basic-time-series-analysis)
  - [Plotting the Correlogram (Autocorrelation Function, ACF)](#plotting-the-correlogram-or-autocorrelation-function)

## Dataset Selection

When selecting a dataset for time series analysis and forecasting, several criteria should be considered:
- **Time coverage** - the dataset should span multiple years to capture long-term trends, seasonal effects, and possible structural changes.
- **Frequency of observations**  - daily or higher-frequency data provides sufficient granularity for detecting short-term dynamics, while still allowing for aggregation into longer intervals if needed.
- **Completeness and consistency** - the dataset should have minimal missing values, consistent formatting of timestamps, and properly aligned variables.
- **Relevant variables** - for stock analysis, the dataset should include key financial indicators such as Open, High, Low, Close prices, and trading Volume. These variables enable both univariate and multivariate modeling.
- **Volatility and variability** - the dataset should exhibit noticeable fluctuations over time, since stationary and non-stationary properties are essential for testing transformations and forecasting models.

By meeting these criteria, the dataset becomes suitable for applying time series methods such as decomposition, stationarity testing, correlation analysis, and forecasting. As result I got it.

Link to the dataset: [click here](https://www.kaggle.com/datasets/vijayvvenkitesh/microsoft-stock-time-series-analysis)

## Visualization and Exploratory Analysis

### Import data in R

Let's take a look at the general structure of the loaded dataset. We will convert the Date column into date format using the as.Date() function

```r
stock <- read.csv("Microsoft_Stock.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
stock$Date <- as.Date(stock$Date, tryFormats = c("%Y-%m-%d", "%m/%d/%Y", "%d.%m.%Y"))

print(head(stock))
```

**Result**

```
##         Date  Open  High   Low Close   Volume
## 1 2015-04-01 40.60 40.76 40.31 40.72 36865322
## 2 2015-04-02 40.66 40.74 40.12 40.29 37487476
## 3 2015-04-06 40.34 41.78 40.18 41.55 39223692
## 4 2015-04-07 41.61 41.91 41.31 41.53 28809375
## 5 2015-04-08 41.48 41.69 41.04 41.42 24753438
## 6 2015-04-09 41.25 41.62 41.25 41.48 25723861
```

### Verification that the Data Represents a Time Series

Let's make sure that the data is correctly recognized: the `Date` column should be of type `date`, and the numerical indicators should be of type `integer` or `numeric`

```r
str(stock)
```

**Result**

```
## 'data.frame':    1511 obs. of  6 variables:
##  $ Date  : Date, format: "2015-04-01" "2015-04-02" ...
##  $ Open  : num  40.6 40.7 40.3 41.6 41.5 ...
##  $ High  : num  40.8 40.7 41.8 41.9 41.7 ...
##  $ Low   : num  40.3 40.1 40.2 41.3 41 ...
##  $ Close : num  40.7 40.3 41.5 41.5 41.4 ...
##  $ Volume: int  36865322 37487476 39223692 28809375 24753438 25723861 28022002 30276692 24244382 27343581 ...
```

### Plotting a Time Series Graph

Let's plot the changes in the closing price (`Close`) over time

```r
msft_ts <- ts(stock$Close, frequency = 252, start = c(2015, 1))
plot(msft_ts, type = "l",
     main = "Microsoft Stock Price Over Time",
     ylab = "Closing Price", xlab = "Date", xaxt = "n")

time_values <- time(msft_ts)
year_positions <- seq(2015, 2021, by = 1)
axis(1, at = year_positions, labels = year_positions)
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Microsoft-Stock-Price-Over-Time.png" width="1200" height="700"> 

### Basic Time Series Analysis

**a) Is there a trend in this series? If so, what kind?**

```r
decomp <- stl(msft_ts, s.window = "periodic")

plot(decomp$time.series[, "trend"], type = "l",
     main = "Trend Microsoft Stock Price",
     ylab = "Closing Price", xlab = "Date")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Trend-Microsoft-Stock-Price.png" width="1200" height="700"> 

When analyzing the time series for the period 2015–2021, it is evident that the closing price (`Close`) shows a clear long-term upward movement. This indicates the presence of an upward trend.

**b) Are seasonal variations characteristic of this series?**

```r
plot(decomp, main = "STL Microsoft Stock Price")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/STL-Microsoft-Stock-Price.png" width="1200" height="700"> 

At first glance, it may seem that seasonal variations are absent. However, applying the STL function allowed us to decompose the time series into separate components and reveal the presence of seasonality. Additionally, the graph highlights the following components: trend, seasonal component, and residual component.

**c) Are there any cycles present in the series?**

As seen from the graph, there are no strict cyclical patterns; if any fluctuations exist, they appear to be random.

**d) Does the variance change over time?**

To assess changes in variance over time, a 63-day rolling standard deviation was calculated for Microsoft’s closing price. The rolling standard deviation plot allows us to evaluate the series’ volatility over time.

```r
library(zoo)

rolling_sd <- rollapply(stock$Close, width = 63, FUN = sd, fill = NA)

plot(stock$Date, rolling_sd, type="l", col="purple", lwd=2,
     main="Rolling Standard Deviation of Microsoft Stock",
     xlab="Date", ylab="SD (63 days)")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Rolling-Standard-Deviation-of-Microsoft-Stock.png" width="1200" height="700"> 

The results show that the variance is not constant: there are periods of relative calm with low volatility, as well as periods of increased price fluctuations. This indicates the presence of heteroskedasticity, meaning that the series’ variance changes over time.

**e) What can be said about the stationarity of this time series? Justify your answer**

By definition, a time series is stationary if its statistical properties do not change over time. That is, the mean is constant, the variance is constant, and the autocovariance depends only on the lag between observations.

As seen from the graph, this time series is non-stationary because both the mean and variance change over time. To confirm this, we can perform the ADF and KPSS tests:

- **ADF (Augmented Dickey-Fuller) test:** the null hypothesis assumes that the series has a unit root (i.e., is non-stationary).
- **KPSS (Kwiatkowski–Phillips–Schmidt–Shin) test:** the null hypothesis assumes that the series is stationary.

```r
library(tseries)

print(adf.test(msft_ts))
print(kpss.test(msft_ts))
```

**Result**

```
## 
##  Augmented Dickey-Fuller Test
## 
## data:  msft_ts
## Dickey-Fuller = -1.6209, Lag order = 11, p-value = 0.7388
## alternative hypothesis: stationary

## 
##  KPSS Test for Level Stationarity
## 
## data:  msft_ts
## KPSS Level = 17.308, Truncation lag parameter = 7, p-value = 0.01
```

**Interpretation of the results:**

**ADF test:** This test showed a $\text{p-value} > 0.05$, so we fail to reject $H_0$. As a result, the series is considered non-stationary.

**KPSS test:** This test showed a $\text{p-value} < 0.05$, so we reject $H_0$. Consequently, the series is also considered non-stationary.

## Plotting the Correlogram or Autocorrelation Function

For this part of the work, we need to answer the following questions:

- What conclusions can be drawn?
- Do the assumptions from the previous section hold?

Thus, the ACF analysis supports the conclusion that the series is non-stationary and exhibits long-term dependence.

```r
acf(msft_ts,lag.max = 24, main = "ACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/ACF.png" width="1200" height="700"> 

**Interpretation of the results:**

The values of the autocorrelation function decrease slowly and remain high even at larger lags. Moreover, the values go beyond the confidence intervals. This confirms that the series is non-stationary. Therefore, the assumption from the previous section is validated.

## Plotting the Partial Autocorrelation Function

To analyze the dependency structure in the time series, we will construct a Partial Autocorrelation Function (PACF) plot and interpret the obtained results.

```r
pacf(msft_ts, lag.max = 24, main = "PACF")
```

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/PACF.png" width="1200" height="700"> 

**Interpretation of the results:**

The values of the Partial Autocorrelation Function indicate a first-order autoregressive process (AR(1)). Only the first lag is significant, which means that each observation depends solely on the previous value, not on more distant past values.



