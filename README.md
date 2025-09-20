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
- [1 Dataset Selection](#1-dataset-selection)
- [Visualization and Exploratory Analysis](#visualization-and-exploratory-analysis)
  - [Import data in R](#import-data-in-r)  

## 1 Dataset Selection

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
