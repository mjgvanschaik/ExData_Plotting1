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

# Plot 1
hist(DT$Global_active_power, col='red', main="Global Active Power", xlab="Global Active Power (kilowatts)")

# Save plot 1 to PNG file
png("plot1.png")
hist(DT$Global_active_power, col='red', main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()