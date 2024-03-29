# Creating Fake Data Sets to Explore Hypotheses

# Accessing useful packages
library(ggplot2)
library(MASS) 
library(tidyverse)

# Reading the data table
z <- read.table(file="Burnham_field_data_bombus_seasonal_variation_Dataset.csv",header=TRUE,sep=",")
# Converting the data to a log function
z <-z%>%filter(pathogen_load>0)%>%
  mutate(myvar=log(pathogen_load))

# Assuming a normal distribution, the hypothesis is that the pathogen load differs for the different sites

# Creating a data frame for each of the sites
df <- data.frame(z$site_code,z$pathogen_load)
CINDdf <- df[z$site_code=="CIND",]
BOSTdf <- df[z$site_code=="BOST",]
MUDGEdf <- df[z$site_code=="MUDGE",]
FLANdf <- df[z$site_code=="FLAN",]
COLdf <- df[z$site_code=="COL",]

# Expected mean for each site
CINDExpectedMean <- mean(CINDdf$z.pathogen_load)
BOSTExpectedMean <- mean(BOSTdf$z.pathogen_load)
MUDGEExpectedMean <- mean(MUDGEdf$z.pathogen_load)
FLANExpectedMean <- mean(FLANdf$z.pathogen_load)
COLExpectedMean <- mean(COLdf$z.pathogen_load)

# Expected variance for each site
CINDExpectedSD <- sd(CINDdf$z.pathogen_load)
BOSTExpectedSD <- sd(BOSTdf$z.pathogen_load)
MUDGEExpectedSD <- sd(MUDGEdf$z.pathogen_load)
FLANExpectedSD <- sd(FLANdf$z.pathogen_load)
COLExpectedSD <- sd(COLdf$z.pathogen_load)

# I will be using the sample sizes specific to each group

# Write a code to analyze the data

# Independent Variable: categorical
# Dependent Variable: continuous
# Chose ANOVA

# Constructing the random normal distribution data sets

nGroup <- 5 # number of treatment groups
nName <- c("CIND","BOST","MUDGE","FLAN","COL") # names of groups
nSize <- c(53,98,55,140,102) # number of observations in each group
nMean <- c(CINDExpectedMean,BOSTExpectedMean,MUDGEExpectedMean,FLANExpectedMean,COLExpectedMean) # mean of each group
nSD <- c(CINDExpectedSD,BOSTExpectedSD,MUDGEExpectedSD,FLANExpectedSD,COLExpectedSD) # SD of each group

ID <- 1:(sum(nSize)) # ID vector for each row
resVar <- c(rnorm(n=nSize[1],mean=nMean[1],sd=nSD[1]),
            rnorm(n=nSize[2],mean=nMean[2],sd=nSD[2]),
            rnorm(n=nSize[3],mean=nMean[3],sd=nSD[3]),
            rnorm(n=nSize[4],mean=nMean[4],sd=nSD[4]),
            rnorm(n=nSize[5],mean=nMean[5],sd=nSD[5]))
TGroup <- rep(nName,nSize)
ANOdata <- data.frame(ID,TGroup,resVar)
str(ANOdata)

# Creating the ANOVA Model
ANOmodel <- aov(resVar~TGroup,data=ANOdata)
# aov function = analysis of variants
print(ANOmodel)
summary(ANOmodel) # shows that the p-value is not significant
# Plotting the ANOVA
ANOPlot <- ggplot(data=ANOdata) +
  aes(x=TGroup,y=resVar,fill=TGroup) + # aesthetic mapping
  geom_boxplot()
print(ANOPlot)

# Adjusting the means between the groups

# Doubling the mean of the group with the highest mean results in a significant p-value
nMean <- c(CINDExpectedMean,BOSTExpectedMean*2,MUDGEExpectedMean,FLANExpectedMean,COLExpectedMean)
nSize <- c(53,98,55,140,102)
ID <- 1:(sum(nSize)) # ID vector for each row
resVar <- c(rnorm(n=nSize[1],mean=nMean[1],sd=nSD[1]),
            rnorm(n=nSize[2],mean=nMean[2],sd=nSD[2]),
            rnorm(n=nSize[3],mean=nMean[3],sd=nSD[3]),
            rnorm(n=nSize[4],mean=nMean[4],sd=nSD[4]),
            rnorm(n=nSize[5],mean=nMean[5],sd=nSD[5]))
TGroup <- rep(nName,nSize)
ANOdata <- data.frame(ID,TGroup,resVar)
str(ANOdata)
# Creating the ANOVA Model
ANOmodel <- aov(resVar~TGroup,data=ANOdata)
# aov function = analysis of variants
print(ANOmodel)
summary(ANOmodel) 
# Plotting the ANOVA for altered means
ANOPlot <- ggplot(data=ANOdata) +
  aes(x=TGroup,y=resVar,fill=TGroup) + # aesthetic mapping
  geom_boxplot()
print(ANOPlot)

# Increasing the sample size to at least 200 will result in a significant p-value
# Initially tested by manipulating one at a time
nMean <- c(CINDExpectedMean,BOSTExpectedMean,MUDGEExpectedMean,FLANExpectedMean,COLExpectedMean)
nSize <- c(300,300,300,300,300)
ID <- 1:(sum(nSize)) # ID vector for each row
resVar <- c(rnorm(n=nSize[1],mean=nMean[1],sd=nSD[1]),
            rnorm(n=nSize[2],mean=nMean[2],sd=nSD[2]),
            rnorm(n=nSize[3],mean=nMean[3],sd=nSD[3]),
            rnorm(n=nSize[4],mean=nMean[4],sd=nSD[4]),
            rnorm(n=nSize[5],mean=nMean[5],sd=nSD[5]))
TGroup <- rep(nName,nSize)
ANOdata <- data.frame(ID,TGroup,resVar)
ANOmodel <- aov(resVar~TGroup,data=ANOdata)
summary(ANOmodel) # shows that the p-value is significant

# Plotting the ANOVA for the increased sample size
ANOPlot <- ggplot(data=ANOdata) +
  aes(x=TGroup,y=resVar,fill=TGroup) +
  geom_boxplot()
print(ANOPlot)

