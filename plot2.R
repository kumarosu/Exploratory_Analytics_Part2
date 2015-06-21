## Unzip the file (This code assumes that the file exists in the R workspace) 

## unzip ("./exdata-data-NEI_data.zip", exdir = "./") 

## Loading the Unzipped RDS files as Dataframe 

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Loading sqldf R package 

library(sqldf)

## This code address the below question - Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.


## Preparing the data for the plot..Please note that the Emissions in Tons is being converted to Million Tons

Year_Emissions_Baltimore<-sqldf("select year, sum(Emissions)/1000 as Total_Emissions from NEI where fips = 24510 group by year")

## Calling the base plot to plot the data 

plot(Year_Emissions_Baltimore$year,Year_Emissions_Baltimore$Total_Emissions, 
     type = "l", 
     col = "red", 
     lwd = 3,
     xlab = "Year",
     ylab = "Total_PM2.5_Emission_Baltimore (In 1000's Tons)",
     main = "PM2.5 Emission in Baltimore")

## Plotting a Linear Regression Line to view the Total Emission Trend 

fit1 <- lm (Total_Emissions ~ year, data = Year_Emissions_Baltimore) 
abline(fit1, col = "blue",lty = "dashed", lwd = 3)

legend("bottomleft", col=c("red","blue"), legend=c("Emissions","Emissions_Reg_Line"), lwd=3, lty=c("solid","dashed"), cex=0.6)


## Saving the png image 
dev.copy(png,filename="./Project_2/plot2.png", width=680,height=480)

## Closing the graphics device

dev.off()


