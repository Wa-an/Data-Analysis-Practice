
##################1.2 감정사전 만들기######################
### KONLP 사용법 ### 

library(rJava)
library(KoNLP)
library(rvest)

### 네이버 뉴스 크롤링

url="https://news.naver.com/main/ranking/read.nhn?mid=etc&sid1=111&rankingType=popular_day&oid=003&aid=0008737816&date=20180802&type=1&rankingSeq=8&rankingSectionId=100" # URL
page <- read_html(url,encoding = "euc-kr") # 인코딩 확인하기 
doc <- page%>%html_nodes("#articleBodyContents")%>%html_text()
doc

### konlp로 품사 구분 후 추출 

## [참고](https://github.com/haven-jeon/KoNLP/blob/master/etcs/figures/konlp_tags.png?raw=true)

words.pa <- function(doc)
{
  doc <- as.character(doc)
  doc2 <- paste(SimplePos22(doc))
  doc3 <- str_match(doc2, "([가-힣]+)/(PA)")
  doc4 <- doc3[,2]
  doc4[!is.na(doc4)]
}

words.nc <- function(doc)
{
  doc <- as.character(doc)
  doc2 <- paste(SimplePos22(doc))
  doc3 <- str_match(doc2, "([가-힣]+)/(NC)")
  doc4 <- doc3[,2]
  doc4[!is.na(doc4)]
}

words.pv <- function(doc)
{
  doc <- as.character(doc)
  doc2 <- paste(SimplePos22(doc))
  doc3 <- str_match(doc2, "([가-힣]+)/(PV)")
  doc4 <- doc3[,2]
  doc4[!is.na(doc4)]
}

### 명사추출
doc.nc=words.nc(doc)

### 형용사추출 
doc.pa=words.pa(doc)

### 동사추출 
doc.pv=words.pv(doc)

### 중복 삭제 
doc.nc=unique(doc.nc)
doc.pa=unique(doc.pa)
doc.pv=unique(doc.pv)

### csv로 저장 

doc.pa.df=as.data.frame(doc.pa)
write.csv(doc.pa.df,"data/doc.pa.csv",fileEncoding = "UTF-8")

doc.nc.df=as.data.frame(doc.nc)
write.csv(doc.nc.df,"data/doc.nc.csv",fileEncoding = "UTF-8")

doc.pv.df=as.data.frame(doc.pv)
write.csv(doc.pv.df,"data/doc.pv.csv",fileEncoding = "UTF-8")

#################1.3 감성분석 방법 1 - 감정 어휘 수로 계산하여 판정하기##############
###################1.3.1 데이터 준비####################
positive <- readLines(file("data/positive.txt", encoding = "EUC-KR"))
positive=positive[-1]

negative <- readLines(file("data/negative.txt", encoding = "EUC-KR"))
negative=negative[-1]
negative

#####################1.3.2 형태소 분석########################
txt <- readLines(file("data/sample_news.txt",encoding = "EUC-KR"))
pos=SimplePos22(txt)

####################1.3.3 문장의 감정어휘 탐색##################
pos.vec=unlist(pos)
pos.vec

pos.vec<-gsub("[[:alpha:]]","",pos.vec) # 영어 삭제
pos.vec

pos.vec<-gsub("/","",pos.vec) # /삭제
pos.vec

pos.vec<-gsub("[+ㄱㄴ]","",pos.vec) # +,ㄱ,ㄴ삭제
pos.vec

pos.matches.num<-match(pos.vec,positive) # 긍정어 벡터 번호
neg.matches.num<-match(pos.vec,negative) # 부정어 벡터 번호 

pos.matches.num ; neg.matches.num

pos.matches <- !is.na(pos.matches.num)
neg.matches <- !is.na(neg.matches.num)

pos.sum=sum(pos.matches)
neg.sum=sum(neg.matches)
pos.sum ; neg.sum

#################1.3.4 결과 출력 1#############
result <- pos.sum-neg.sum

if(result>0){
  print("긍정")
}else if(result==0){
  print("중립")
}else{
  print("부정")
}

###############1.3.5 결과 출력 2########
sigmoid <- function(x){
  1/(1+exp(-x))
}

x=seq(from=-5,to=5,by=0.1)
plot(x,sigmoid(x),col="red")

########1.4 감성분석 방법 2 - 패키지로 판정하기#########
########1.4.1 패키지 설치##################
library(devtools)
install_github("SukJaeChoi/easySenti")
library(easySenti)

#############1.4.2 데이터 준비###################
positive <- readLines(file("data/positive.txt", encoding = "EUC-KR"))
positive=positive[-1]
positive

negative <- readLines(file("data/negative.txt", encoding = "EUC-KR"))
negative=negative[-1]
negative

docs <- readLines(file("data/sample_news.txt",encoding = "EUC-KR"))

#############1.4.3 감성값 계산#############################
easySenti(docs,positive,negative)
easySenti(docs,positive,negative,t=3) # 3초과 긍정 
easySenti(docs,positive,negative,sigmoid = TRUE) # 시그모이드, 경계값 0.3
easySenti(docs,positive,negative,sigmoid = TRUE, t.s=0.5) # 시그모이드, 경계값 0.5