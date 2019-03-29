
################사용 가능 패키지#####################
# tidyverse packages, including ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, lubridate, broom from conda-forge, 
# plyr, devtools, shiny, rmarkdown, forecast, rsqlite, reshape2, nycflights13, caret, rcurl, randomforest packages from conda-forge


install.packages(c("tidyverse", "ggplot2", "dplyr", "tidyr", "readr", "purrr", "tibble", "stringr", "lubridate", "broom",
"plyr", "devtools", "shiny", "rmarkdown", "forecast", "RSQLite", "reshape2", "nycflights13", "caret", "RCurl","randomForest"))

#데이터 조작
library(tidyverse) #ggplot2 + tibble + tidyr + purrr + dplyr + stringr + forcats
library(dplyr)
library(tidyr)
library(purrr)
library(plyr)
library(reshape2)
library(nycflights13) #관계형 데이터 조작, flights 데이터 셋 사용가능
library(tibble) #R tibble(tbl) 데이터프레임 조작

#기계학습
library(randomForest)
library(caret)

#문자열
library(stringr)

#시각화
library(ggplot2)

#인터랙티브시각화
library(shiny)
library(readr) #접자

#재현
library(rmarkdown)

#모형
library(broom) #X

#웹/API
library(RCurl)

#시계열
library(lubridate)
library(forecast) #시계열 예측(ggplot2, reshape2 등도 같이 설치됨)

#DB 사용
library(RSQLite) 

#github다운(install_github)
library(devtools)

head(flights)

nrow(flights)
F2<-flights[(flights$arr_delay<120),]
head(F2)
nrow(F2)

sum(is.na(F2))
sum(is.na(F2$arr_delay))
F2<-filter(flights,!(arr_delay>120 | dep_delay>120))
nrow(F2)

nrow(filter(flights))

setwd("C:/Users/rladh/Downloads")

getwd()

cs<-read.csv("cs-training.csv",head=T)
head(cs)

na.omit(cs)
head(cs)

ggplot(data= cs, aes(x=age, y=MonthlyIncome)) + 
    geom_point(color = "blue")

df<-iris
head(df)
summary(df)

library(caret)

set.seed(1234)

intrain<-createDataPartition(y=df$Species,p=0.7,list=FALSE)
train<-df[intrain,]
test<-df[-intrain,]
test_x<-test[,-5]

m<-randomForest(Species~.,data=train, importance = TRUE)

m
pred<-predict(m,test_x)

m<-randomForest(iris[,1:4],iris[,5])
m

importance(m) # MDA 는 정확도, MDG는 노드 불순도 개선(클수록 중요)
varImpPlot(m)# var + imp(ortance) + Plot

m

library(caret)
pred<-predict(m,test_x)

confusionMatrix(pred,test$Species)

install.packages("e1071")

pairs(distance~.,data=F2)

broom::tidy(mtcars)

plot(mtcars$mpg,mtcars$disp)
lines(lowess(mtcars$disp~mtcars$mpg))

ymd(20180301)

data<- flights%>%
    select(year,month,day,hour,minute)%>%
    mutate(departure = make_datetime(year,month,day,hour,minute))
data
