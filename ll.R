
data_weekday_final <- data.frame(MinInterval_weekday,AveDailyActivity_weekday)
names(data_weekday_final) <- c("MinInterval","AveDailyActivity")
data_weekend_final <- data.frame(MinInterval_weekend,AveDailyActivity_weekend)
names(data_weekend_final) <- c("MinInterval","AveDailyActivity")

data_final <- rbind(data_weekday_final,data_weekend_final)
week <- factor(rep(c("weekday","weekend"),each = length(MinInterval_weekend)))
data_final <- cbind(data_final,week)
library(lattice)
xyplot(data_final$AveDailyActivity ~ data_final$MinInterval | data_final$week, layout = c(1,2) ,type = "l")