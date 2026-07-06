rm(list=ls())
#This script does quantitative stray assignment
library(dplyr)
library(lme4)
library(here)

#ReadInOtos
#Sam_Otos <- read.csv('HYBRID DISPERSAL 1_31_2020.csv',header=T,stringsAsFactors=F)
Sam_Otos <- read.csv(here('DataFiles','Sam_Otos.csv'),header=T,stringsAsFactors=F)
Clint_Otos<-read.csv(here('DataFiles','ClintOtos_NoStrayAssignment.csv'),stringsAsFactors=F) 


#Compute the compound error for the assignement
Analytical <- 5.5E-5
Regression <- 0.001297

Sam_Otos$TotalSD <- sqrt(Analytical^2 + Regression^2 + Sam_Otos$Water_S^2 + Sam_Otos$OTO_S^2)
Clint_Otos$TotalSD<-sqrt(Analytical^2 + Regression^2 + apply(Clint_Otos[,c('Water1','Water2')],1,FUN=sd)^2 + 0.001^2) #Don't have an error value on Clints only otos

#Calculate the probality of home
ProbThreshold<-0.05
Sam_Otos$Prob <- (1-pnorm(abs((Sam_Otos$Oto_M-Sam_Otos$Water_M)),mean=0,sd=Sam_Otos$TotalSD))
Sam_Otos$Stray <- ifelse((1-pnorm(abs((Sam_Otos$Oto_M-Sam_Otos$Water_M)),mean=0,sd=Sam_Otos$TotalSD))<=ProbThreshold,'S','H')
Sam_Otos$StrayBool <- ifelse((1-pnorm(abs((Sam_Otos$Oto_M-Sam_Otos$Water_M)),mean=0,sd=Sam_Otos$TotalSD))<=ProbThreshold,1,0)

#Compute some hybrid RBT stats
logit<-function(x){return(log(x/(1-x)))}
Sam_Otos$pRBT <- Sam_Otos$HIS/78
Sam_Otos$lpRBT<- logit(Sam_Otos$pRBT + 0.01) #logit-transform proportion/ add small value to pures.
Sam_Otos$F1<-ifelse(Sam_Otos$pRBT==0.5,1,0)

Clint_Otos
#Calculate probility of home in Clint's otos.
Clint_Otos$StrayBool <- ifelse((1-pnorm(abs((Clint_Otos$X87Sr.86Sr-Clint_Otos$Mean.water)),mean=0,sd=Clint_Otos$TotalSD))<ProbThreshold,1,0)

#Hybrid categories for clints data
Clint_Otos$HybridClasses3 <- ifelse(Clint_Otos$Species == 'Hybrid','HHyb','WCT')
Clint_Otos$HybridClasses2 <- ifelse(Clint_Otos$Species == 'Hybrid','HHyb','WCT/LHyb')

#Hybrid categories for Sam's data
Sam_Otos$HybridClasses3<-ifelse(Sam_Otos$pRBT==0,'WCT',
                        ifelse(Sam_Otos$pRBT>=0.5,'HHyb','LHyb'))

Sam_Otos$HybridClasses2<-ifelse(Sam_Otos$pRBT<0.5,'WCT/LHyb','HHyb')


write.csv(Clint_Otos,here('DataFiles','ClintOtos_withStrayAssignment.csv'),row.names=F)
write.csv(Sam_Otos,here('DataFiles','SamOtos_withStrayAssignment.csv'),row.names=F)

# StrayList<-Sam_Otos[which(Sam_Otos$StrayBool==1),]
# write.table(StrayList,file='StrayList.csv',sep=',',row.names=F)



