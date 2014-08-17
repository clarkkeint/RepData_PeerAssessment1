# Reproducible Research: Peer Assessment 1

## Loading and preprocessing the data
Unzip and read the data

```r
if (!file.exists("./avtivity.csv")) {unzip(zipfile = "./activity.zip")}
data <- read.csv("./activity.csv")
```
## What is mean total number of steps taken per day?
Calculate the total number of steps taken each day and make a histogram about the total number:

```r
Totalnumber <- sapply(split(data$steps, data$date), sum,na.rm=TRUE)
hist(Totalnumber,xlab = "Total number of steps taken each day",main = "")
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

The mean and median of the total number of steps taken per day can be calculated as follow:

```r
# The mean of the total number of steps taken per day
mean(Totalnumber)
```

```
## [1] 9354
```

```r
# The median of the total number of steps taken per day
median(Totalnumber)
```

```
## [1] 10395
```

## What is the average daily activity pattern?

```r
# Calculate the average number of steps taken across all days
AveDailyActivity <- sapply(split(data$steps, data$interval), mean,na.rm=TRUE)
# Get time series of the 5-minute interval
Min5Interval <- as.numeric(names(split(data$steps, data$interval)))
# Make a time series plot
plot(Min5Interval,AveDailyActivity,type = "l",xlab ="5-minute interval",ylab="The average number of steps taken across all days")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 

The 5-minute interval which contains the maximum number of steps on average across all the days can be calculated as follow:

```r
Min5Interval[AveDailyActivity == max(AveDailyActivity)]
```

```
## [1] 835
```
## Imputing missing values
The number of missing values can be gotten as follow:

```r
summary(data$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     0.0     0.0     0.0    37.4    12.0   806.0    2304
```

A strategy of Using the mean for that 5-minute interval are devised to fill in the missing data.

```r
# library "plyr" package
library(plyr)
# Define a function to Impute the missing values by mean
impute.mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
# Impute the missing values and creat a new dataset
data_new <- ddply(data, ~ interval, transform, steps = impute.mean(steps))
```

Make a histogram of the total number of steps taken each day about the new dataset

```r
Totalnumber_new <- sapply(split(data_new$steps, data_new$date), sum,na.rm=TRUE)
hist(Totalnumber_new,main = "",xlab = "Total number of steps taken each day")
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

Calculate and report the mean and median total number of steps taken per day about the new dataset

```r
# The mean of the total number of steps taken per day
mean(Totalnumber_new)
```

```
## [1] 10766
```

```r
# The median of the total number of steps taken per day
median(Totalnumber_new)
```

```
## [1] 10766
```

We can see that these values are different from the first part of the assignment. Both mean and median augment.

## Are there differences in activity patterns between weekdays and weekends?
Change format

```r
# Use the dataset with the filled-in missing values and Translate date into the classes "POSIXlt"
data_new$date <- as.POSIXlt(data_new$date)

# Create a new factor variable in the dataset with two levels �C ��weekday�� and ��weekend�� indicating whether a given date is a weekday or weekend day
WeekendWeekday <- rep("weekday",length(data_new$steps))
WeekendWeekday[(data_new$date$wday==5)|(data_new$date$wday==6)] <- "weekend"
WeekendWeekday <- factor(WeekendWeekday)

# Add the factor variable into data frame
data_week <- cbind(data,WeekendWeekday)

# Split dataset into two groups "weekday" and "weekend" 
data_weekday <- data_week[data_week$WeekendWeekday == "weekday",]
data_weekend <- data_week[data_week$WeekendWeekday == "weekend",]

# Calculate the average number of steps of group "weekday" and group "weekend"
AveDailyActivity_weekday <- sapply(split(data_weekday$steps, data_weekday$interval), mean,na.rm=TRUE)
AveDailyActivity_weekend <- sapply(split(data_weekend$steps, data_weekend$interval), mean,na.rm=TRUE)

# Get time series of the 5-minute interval of group "weekday" and group "weekend"
Min5Interval_weekday <- names(split(data_weekday$steps, data_weekday$interval))
Min5Interval_weekend <- names(split(data_weekend$steps, data_weekend$interval))

# Combine the average number of steps and time series of the 5-minute interval of group "weekday"
data_weekday_final <- data.frame(Min5Interval_weekday,AveDailyActivity_weekday)
names(data_weekday_final) <- c("Min5Interval","AveDailyActivity")
# Combine the average number of steps and time series of the 5-minute interval of group "weekend"
data_weekend_final <- data.frame(Min5Interval_weekend,AveDailyActivity_weekend)
names(data_weekend_final) <- c("Min5Interval","AveDailyActivity")

# Combine datasets of group "weekday" and group "weekend"
data_final <- rbind(data_weekday_final,data_weekend_final)

# Create a factor variable to show ��weekday�� and ��weekend�� and add into dataset.
week <- factor(rep(c("weekday","weekend"),each = length(Min5Interval_weekday)))
data_final <- cbind(data_final,week)
# Translate time series of the 5-minute interval into numeric
data_final$MinInterval <- as.numeric(as.character((data_final$Min5Interval)))

#Use lattice system to creat a panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends
library(lattice)
xyplot(data_final$AveDailyActivity ~ data_final$MinInterval | data_final$week, layout = c(1,2) ,type = "l",xlab ="5-minute interval",ylab="The average number of steps taken across all days")
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

