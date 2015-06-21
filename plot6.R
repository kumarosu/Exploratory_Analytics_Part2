## Unzip the file (This code assumes that the file exists in the R workspace) 

## unzip ("./exdata-data-NEI_data.zip", exdir = "./") 

## Loading the Unzipped RDS files as Dataframe 

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Loading sqldf R and ggplot2 package 

library(sqldf)
library(ggplot2)
library(tidyr)


## The code address the following question - Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

## Renaming the columns in SCC

colnames(SCC) <- c("SCC", "Data_Category","Short_Name","EI_Sector", 
                   "Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two","SCC_Level_Three","SCC_Level_Four","Map_To",
                   "Last_Inventory_Year","Created_Date","Revised_Date","Usage_Notes")

## Preparing motor vehicle data set

SCC_Mobile<-sqldf("select * from SCC where EI_Sector like ('%Mobile%')")

## Preparing data set for the plot 

Emission_from_Mobile_City<- sqldf("select a1.year, a1.fips, sum(Emissions)/1000 as Total_Emissions from NEI a1
                             join SCC_Mobile a2
                             on a1.SCC=a2.SCC
                             where a1.fips in ('24510','06037')
                             group by a1.year, a1.fips")

Emission_from_Mobile_City<-spread(Emission_from_Mobile_City, fips, Total_Emissions)

colnames(Emission_from_Mobile_City) <- c("year", "LA","Baltimore")


ggplot(Emission_from_Mobile_City, aes(year)) +                    
geom_line(aes(y=LA), labels = NA, colour="red", lwd=2) +  
geom_line(aes(y=Baltimore), labels = NA, colour="green", lwd=2)  

plot( 
     data = Emission_from_Mobile_City, 
     type = "l", 
     ylim = c(min(Emission_from_Mobile_City[ ,-1]), max(Emission_from_Mobile_City[ ,-1])),
     ylab = "value")
lines(Emission_from_Mobile_City$time, Emission_from_Mobile_City$plus, col = "steelblue")
lines(Emission_from_Mobile_City$time, Emission_from_Mobile_City$noob, col = "pink")

plot(Emission_from_Mobile_City$year, Emission_from_Mobile_City$LA, type='l',ylim=c(0,15), 
     xlab='year', ylab='LA & Baltimore Emission(1000's)')

plot(Emission_from_Mobile_City$year,Emission_from_Mobile_City$LA, 
     type = "l", 
     col = "red", 
     lwd = 3,
     xlab = "Year",
     ylab = "LA & Baltimore Emission(1000's)",ylim=c(0,15),
     main = "PM2.5 Emission")
par(new=T)
plot(Emission_from_Mobile_City$year,Emission_from_Mobile_City$Baltimore, 
     type = "l", 
     col = "green", 
     lwd = 3,
     xlab = "",
     ylab = "",
     ylim=c(0,15),
     main = "")
legend("center", col=c("red","green"), legend=c("LA","Baltimore"), lwd=3, cex=0.8)


## Saving the png image 
dev.copy(png,filename="./Project_2/plot6.png", width=680,height=480)

## Closing the graphics device

dev.off()
