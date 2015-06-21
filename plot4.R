## Unzip the file (This code assumes that the file exists in the R workspace) 

## unzip ("./exdata-data-NEI_data.zip", exdir = "./") 

## Loading the Unzipped RDS files as Dataframe 

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Loading sqldf R and ggplot2 package 

library(sqldf)
library(ggplot2)

## The code address the following question - Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999–2008?


## Renaming the columns in SCC

colnames(SCC) <- c("SCC", "Data_Category","Short_Name","EI_Sector", 
                   "Option_Group","Option_Set","SCC_Level_One","SCC_Level_Two","SCC_Level_Three","SCC_Level_Four","Map_To",
                   "Last_Inventory_Year","Created_Date","Revised_Date","Usage_Notes")

## Preparing Coal Combustion data set

SCC_Coal<-sqldf("select * from SCC where EI_Sector like ('%Coal%')")

## Preparing data set for the plot 

Emission_from_coal <- sqldf("select a1.year, sum(Emissions)/1000000 as Total_Emissions from NEI a1
join SCC_Coal a2
on a1.SCC=a2.SCC
      group by a1.year")

## Calling the base plot to plot the data 

plot(Emission_from_coal$year,Emission_from_coal$Total_Emissions, 
     type = "l", 
     col = "red", 
     lwd = 3,
     xlab = "Year",
     ylab = "Total_PM2.5_Emission (In Million Tons)",
     main = "PM2.5 Emission in United States from Coal")

## Plotting a Linear Regression Line to view the Total Emission Trend 

fit1 <- lm (Total_Emissions ~ year, data = Emission_from_coal) 
abline(fit1, col = "blue",lty = "dashed", lwd = 3)

legend("bottomleft", col=c("red","blue"), legend=c("Emissions","Emissions_Reg_Line"), lwd=3, lty=c("solid","dashed"), cex=0.6)


## Saving the png image 
dev.copy(png,filename="./Project_2/plot4.png", width=680,height=480)

## Closing the graphics device

dev.off()
