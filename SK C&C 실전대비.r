
library(tidyverse)
library(randomForest)
library(RCurl)
library(reshape2)
library(lubridate)
library(devtools)
library(caret)
library(nycflights13)
library(dplyr)

library(forecast)

setwd("C:/Users/rladh/Downloads")



mydata <- read.csv("titanic3.csv",header=T)
head(mydata)  #생존여부분석예정, survived = y
str(mydata)

#데이터 정제1. missing value
sum(is.na(mydata$body))

sum(is.na(mydata))
str(mydata)

#NA가 너무 많으므로 변수 제거
mydata<-mydata[,-13]
str(mydata)

mydata<-select(mydata,pclass,survived,sex,age,parch,fare,embarked)
sum(is.na(mydata))

colSums(is.na(mydata))
sapply(mydata,mean,1,na.rm=T)

mydata$age<-ifelse(is.na(mydata$age),28,mydata$age)
mydata
sapply(mydata, function(x) ifelse(is.na(x), mean(x, na.rm=TRUE), x)) 

mydata<-na.omit(mydata)
str(mydata)

sum(is.na(mydata))

mydata$survived<-as.factor(mydata$survived)

#데이터 정제2. 이상치제거


#EDA
attach(mydata)



#EDA
ggplot(data=mydata, aes(x= survived))+
    geom_bar(colour="red")



ggplot(data=mydata, aes(group = survived, y= age))+
    geom_boxplot(color="blue")



ggplot(data=mydata, aes(x= age))+
    geom_histogram(colour="red")



ggplot(mydata, aes(x=age, y= fare))+
    geom_point(colour="blue")



#Data partition for validation
set.seed(1234)
part<-createDataPartition(mydata$survived, p=0.7, list=FALSE)

train<-mydata[part,]
test<-mydata[-part,]

#modeling1. randomForest
m <- randomForest(survived~.,train, importance=T)
importance(m)
varImpPlot(m)

pred<-predict(m,test[,-2])
pred

confusionMatrix(pred,test$survived)

##modeling2. logistic regression

m2<-glm(survived~.,train,family="binomial")
summary(m2)
anova(m2, test="Chisq")

pred2<-predict(m2,test[,-2])
as.factor(ifelse(pred2 > 0.5, 1,0))

confusionMatrix(as.factor(ifelse(pred2 > 0.5, 1,0)),test$survived)
