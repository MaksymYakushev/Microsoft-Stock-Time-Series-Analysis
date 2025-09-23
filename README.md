# Microsoft Stock Time Series Analysis

## Introduction

This repository contains a university lab project focused on time series analysis. It also works well as a project for GitHub. This is the first part of the work, serving as the foundation for further extensions. Let's start!!!

## About the Project

This project contains time series analysis and forecasting of Microsoft (MSFT) stock prices using R. The dataset obtained from Kaggle and covers the period from April 2015 to April 2021 and includes daily Open, High, Low, Close prices and trading Volume. The project demonstrates:

- Exploratory data analysis and visualization of MSFT stock trends
- Identification of trends, seasonality, and volatility in stock prices
- Stationarity testing with ADF and KPSS
- ACF and PACF analysis
- Transformations (differencing, seasonal differencing, logarithmic, Box–Cox)
  
🎯 The main goal is to preprocess the Microsoft stock time series and prepare it for building forecasting models.

🔗 **Usefull links:**

.r project: [click here](https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/lab1.r)

.rmd project: [click here](https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/lab1.rmd)

.html project: [click here](https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/lab1.html)

.csv dataset: [click here](https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Microsoft_Stock.csv)

## Table of Contents
- [Dataset Selection](#dataset-selection)
- [Visualization and Exploratory Analysis](#visualization-and-exploratory-analysis)
  - [Import data in R](#import-data-in-r)
  - [Verification that the Data Represents a Time Series](#verification-that-the-data-represents-a-time-series)
  - [Plotting a Time Series Graph](#plotting-a-time-series-graph)
  - [Basic Time Series Analysis](#basic-time-series-analysis)
  - [Plotting the Correlogram or Autocorrelation Function](#plotting-the-correlogram-or-autocorrelation-function)
  - [Plotting the Partial Autocorrelation Function](#plotting-the-partial-autocorrelation-function)
  - [Building and analyzing the first-differenced series of the original data, plotting and correlogram](#building-and-analyzing-the-first-differenced-series-of-the-original-data-plotting-and-correlogram)
  - [Transforming the original series to achieve stationarity and applying additional transformations](#transforming-the-original-series-to-achieve-stationarity-and-applying-additional-transformations)
    - [First Differencing](#first-differencing)
    - [Logarithm Transformation](#logarithm-transformation)
    - [Seasonal Differencing](#seasonal-differencing)
    - [Box–Cox Transformation](#boxcox-transformation)
- [Conclusion](#conclusion)

## Dataset Selection

When selecting a dataset for time series analysis it is important to ensure sufficient time coverage, appropriate frequency of observations, data consistency and the presence of relevant variables. Such datasets allow for testing stationarity, applying transformations, and building forecasting models.

🔗 Link to the original dataset from Kaggle: [click here](https://www.kaggle.com/datasets/vijayvvenkitesh/microsoft-stock-time-series-analysis)

## Visualization and Exploratory Analysis

### Import data in R

Let's import data in R and take a look at the general structure of the imported dataset. I have converted the Date column into date format using the as.Date() function

```r
stock <- read.csv("Microsoft_Stock.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
stock$Date <- as.Date(stock$Date, tryFormats = c("%Y-%m-%d", "%m/%d/%Y", "%d.%m.%Y"))

print(head(stock))
```

📊 **Result**

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

In order to ensure the correctness of data recognition the **Date** column should be of type `Date` while the numerical indicators should be of type `integer`, `numeric` or any other appropriate data type representing numerical values

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

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Microsoft-Stock-Price-Over-Time.png" width="700" height="500"> 

### Basic Time Series Analysis

**a) Is there a trend in this series? If so, what kind?**

```r
decomp <- stl(msft_ts, s.window = "periodic")

plot(decomp$time.series[, "trend"], type = "l",
     main = "Trend Microsoft Stock Price",
     ylab = "Closing Price", xlab = "Date")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Trend-Microsoft-Stock-Price.png" width="700" height="500"> 

When analyzing the time series for the period 2015–2021, it is evident that the closing price (`Close`) shows a clear long-term upward movement. This indicates the presence of an upward trend.

**b) Are seasonal variations characteristic of this series?**

```r
plot(decomp, main = "STL Microsoft Stock Price")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/STL-Microsoft-Stock-Price.png" width="700" height="500"> 

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

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Rolling-Standard-Deviation-of-Microsoft-Stock.png" width="700" height="500"> 

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

**Interpretation of the results**

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

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/ACF.png" width="700" height="500"> 

**Interpretation of the results**

The values of the autocorrelation function decrease slowly and remain high even at larger lags. Moreover, the values go beyond the confidence intervals. This confirms that the series is non-stationary. Therefore, the assumption from the previous section is validated.

## Plotting the Partial Autocorrelation Function

To analyze the dependency structure in the time series, we will construct a Partial Autocorrelation Function (PACF) plot and interpret the obtained results.

```r
pacf(msft_ts, lag.max = 24, main = "PACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/PACF.png" width="700" height="500"> 

**Interpretation of the results**

The values of the Partial Autocorrelation Function indicate a first-order autoregressive process (AR(1)). Only the first lag is significant, which means that each observation depends solely on the previous value, not on more distant past values.

## Building and analyzing the first-differenced series of the original data, plotting and correlogram

To remove the trend and examine the properties of the residuals, the first-differenced series was builded

```r
diff_data <- diff(msft_ts) 

plot(diff_data, type = "l", col = "blue", lwd = 1.5,
     main = "(diff) of Microsoft Close",
     ylab = "diff(Close)", xlab = "Date")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Diff-of-Microsoft-Close.png" width="700" height="500"> 

In the plot, it can be seen that the fluctuations have become more balanced, and the clear upward trend present in the original series has disappeared. Next, we will test the series for stationarity and apply the previous tests

```r
print(adf.test(diff_data))
print(kpss.test(diff_data))
```

**Result**

```
## 
##  Augmented Dickey-Fuller Test
## 
## data:  diff_data
## Dickey-Fuller = -11.873, Lag order = 11, p-value = 0.01
## alternative hypothesis: stationary

## 
##  KPSS Test for Level Stationarity
## 
## data:  diff_data
## KPSS Level = 0.25056, Truncation lag parameter = 7, p-value = 0.1
```

**Interpretation of the results**

**ADF test**. This test showed that $p-value < 0.05$, therefore we reject $H_0$. As a result, the series is stationary.

**KPSS test**. This test showed that $p-value > 0.05$, therefore we fail to reject $H_0$. As a result, the series is stationary.

Next, we will plot the ACF

```r
acf(diff_data,lag.max = 24, main = "ACF after first diff")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/ACF-after-first-diff.png" width="700" height="500"> 

**Interpretation of the results**

After the first differencing, we obtained a stationary series without significant autocorrelations, which indicates that long-term dependencies and the trend component were successfully removed. Next, will plot the PACF

```r
pacf(diff_data,lag.max = 24, main = "PACF after first diff")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/PACF-after-first-diff.png" width="700" height="500"> 

**Interpretation of the results**

After the first differencing, the series became closer to stationarity. The PACF shows a significant negative correlation at lag 1, while the subsequent values decay quickly and remain within the confidence intervals.

## Transforming the original series to achieve stationarity and applying additional transformations

### First Differencing

After the first differencing, the ADF and KPSS tests confirmed that the series became stationary.

### Logarithm Transformation

```r
log_data <- log(msft_ts)
plot(log_data, main = "Log-transformed Microsoft Close")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Log-transformed-Microsoft-Close.png" width="700" height="500"> 

Next, we have to plot the ACF

```r
acf(log_data, lag.max = 24, main = "ACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Log-transformed-ACF.png" width="700" height="500"> 

**Interpretation of the results**

The ACF remains very high at all lags, with no noticeable decay in autocorrelations. All values significantly exceed the confidence intervals. It is clear that the series is non-stationary.

Next, we will plot the PACF

```r
pacf(log_data, lag.max = 24, main = "PACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Log-transformed-PACF.png" width="700" height="500"> 

**Interpretation of the results**

The partial autocorrelation at lag 1 is approximately 1.0 and significantly exceeds the confidence bounds. All subsequent lags fall within the confidence intervals and are close to zero.

### Seasonal Differencing

```r
diff_season <- diff(msft_ts, lag = 252)
plot(diff_season, main = "Seasonal Difference")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Seasonal-Difference.png" width="700" height="500"> 

Next, we have to plot the ACF

```r
acf(diff_season, lag.max = 24, main = "ACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Seasonal-Difference-ACF.png" width="700" height="500"> 

**Interpretation of the results**

The autocorrelations remain high and gradually decrease as the lag increases. All ACF values significantly exceed the confidence intervals at all lags. The ACF does not show rapid decay. Seasonal transformation did not eliminate the main issue of the series’ non-stationarity.


Next, we will plot the PACF

```r
pacf(diff_season, lag.max = 24, main = "PACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Seasonal-Difference-PACF.png" width="700" height="500"> 

**Interpretation of the results**

The partial autocorrelation at lag 1 is around 1.0 and significantly exceeds the confidence bounds. The high values at the first lags confirm that seasonal differencing did not eliminate the non-stationarity.

### Box–Cox Transformation

```r
library(forecast)

box_ts <- BoxCox(msft_ts, lambda = 0)
plot(box_ts, main = "Box–Cox transformation")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Box–Cox-transformation.png" width="700" height="500"> 

Next, we have to plot the ACF

```r
acf(box_ts, lag.max = 24, main = "ACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Box–Cox-transformation-ACF.png" width="700" height="500"> 

**Interpretation of the results**

The autocorrelations remain very high at all lags, showing no noticeable decrease as the lag increases. The Box–Cox transformation did not eliminate the non-stationarity, so ordinary differencing is required.

Next, we will plot the PACF

```r
pacf(box_ts, lag.max = 24, main = "PACF")
```

**Result**

<img src="https://github.com/MaksymYakushev/Microsoft-Stock-Time-Series-Analysis/blob/main/Data/Box–Cox-transformation-PACF.png" width="700" height="500"> 

**Interpretation of the results**

The partial autocorrelation at lag 1 equals 1.0 and exceeds the confidence bounds. All subsequent lags fall within the confidence intervals and are close to zero. The transformation did not affect the trend component of the time series.

# Conclusion

Several transformation methods were tested to achieve stationarity in the time series: differencing, seasonal differencing, logarithm transformation, and Box–Cox transformation. The results showed that only first differencing produced a stationary series. When logarithm transformation, seasonal differencing, or Box–Cox transformation were applied, the series remained non-stationary. Therefore, it can be concluded that for this time series, the most effective transformation method is differencing.





















