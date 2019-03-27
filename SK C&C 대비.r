
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
library(readr)

#재현
library(rmarkdown)

#모형
library(broom)

#웹/API
library(RCurl)

#시계열
library(lubridate)
library(forecast) #시계열 예측(ggplot2, reshape2 등도 같이 설치됨)

#DB 사용
library(RSQLite) 

#github다운(install_github)
library(devtools)
