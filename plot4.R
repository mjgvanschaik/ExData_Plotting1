# We use the data.table package to read in the whole data frame in a very fast manner with fread() function.
# We use the lubridate package to select the proper dates quickly.
library(data.table)
library(lubridate)
library(tidyr)
library(dplyr)

# Now we will: fread() in the data, convert and select the dates, and set other columns to be numerics.
DT <- fread("household_power_consumption.txt", na.strings='?', colClasses=c("character","character", rep("numeric",7)))
DT$Time <- gsub(":", "/", DT$Time)
DT$Date <- paste(DT$Date, DT$Time, sep="/")
DT$Date <- dmy_hms(DT$Date)
date1 <- ymd_hms("2007-02-01 00:00:00")
date2 <- ymd_hms("2007-02-02 23:59:59")
int <- new_interval(date1, date2)
DT <- select(DT[Date %within% int,], -Time)
DT2 <- as.data.frame(apply(select(DT, -Date), 2, as.numeric))
DT <- cbind(DT$Date, DT2)
setnames(DT, "DT$Date", "Date")
head(DT)
str(DT)

# Plot 4
par(mfrow=c(2,2))
plot(DT$Date, DT$Global_active_power, type='l', xlab="", ylab="Global Active Power (kilowatts)")
plot(DT$Date, DT$Voltage, type='l', xlab="datetime", ylab="Voltage")
plot(DT$Date, DT$Sub_metering_1, type='l', xlab="", ylab="Energy sub metering")
lines(DT$Date, DT$Sub_metering_2, type='l', col='red')
lines(DT$Date, DT$Sub_metering_3, type='l', col='blue')
legend("topright", bty="n", cex=0.75, lwd=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(DT$Date, DT$Global_reactive_power, type='l', ylab="Global_reactive_power", xlab="datetime")

# Save plot 4 to PNG file
png("plot4.png")
par(mfrow=c(2,2))
plot(DT$Date, DT$Global_active_power, type='l', xlab="", ylab="Global Active Power (kilowatts)")
plot(DT$Date, DT$Voltage, type='l', xlab="datetime", ylab="Voltage")
plot(DT$Date, DT$Sub_metering_1, type='l', xlab="", ylab="Energy sub metering")
lines(DT$Date, DT$Sub_metering_2, type='l', col='red')
lines(DT$Date, DT$Sub_metering_3, type='l', col='blue')
legend("topright", bty="n", cex=0.75, lwd=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(DT$Date, DT$Global_reactive_power, type='l', ylab="Global_reactive_power", xlab="datetime")
dev.off()
