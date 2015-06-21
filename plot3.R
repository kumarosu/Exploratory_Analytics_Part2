## Unzip the file (This code assumes that the file exists in the R workspace) 

## unzip ("./exdata-data-NEI_data.zip", exdir = "./") 

## Loading the Unzipped RDS files as Dataframe 

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Loading sqldf R and ggplot2 package 

library(sqldf)
library(ggplot2)

## The code address the following question - Of the four types of sources indicated by the type 
## (point, nonpoint, onroad, nonroad) variable,which of these four sources have seen decreases 
## nin emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? 
## Use the ggplot2 plotting system to make a plot answer this question.


## Preparing the data to answer the question 

Emission_Baltimore_by_type<-sqldf("select year,type, sum(Emissions)/1000 as Total_Emissions from NEI where fips = 24510 group by year,type")

## qplot to plot the graph 

qplot(year,Total_Emissions,data=Emission_Baltimore_by_type, facets=.~type,binwidth=2, geom=c("point","smooth"),method="lm",
      xlab = "Year",
      ylab = "Total_PM2.5_Emission_Baltimore (In 1000's Tons)",
      main = "PM2.5 Emission by Type in Baltimore"
      )

## Saving the png image 
dev.copy(png,filename="./Project_2/plot3.png", width=480,height=480)

## Closing the graphics device

dev.off()
