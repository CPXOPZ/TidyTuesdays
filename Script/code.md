Just a collection of R codes.  

>不论做什么图最最重要的是如何通过这张图说明突出你想要传达的内容，你想要告诉读者什么结论，那么就是你这张图所需要展示的，千万不要一味追求图形的好看或者复杂而忘记了你做图的目的，不论任何形式的图都只是数据的可视化，而可视化是为了增强数据的可读性。要玩方法不要被方法玩。


数据(data)：数据才是图形的灵魂，这点无需解释。

几何对象(geom)：也就是图形本身，这是可视化的外形。根据数据特征，选择最合适的图形。

映射(mapping)：映射即使把数据和图形给连接起来。映射什么数据变量，它是连续的还是离散的？

标度(scale)：这个是从数据中剥离，但是控制数据如何映射到图形上的属性。图形中用什么通道来映射？常用的有颜色、长度、面积、形状、透明度等通道。

坐标系(coord)：坐标系不一定非得是直角笛卡尔坐标系，比如对于地图并不适合，所以要做专门的投影操作。转换坐标系也有造成不同的视觉效果，比如把柱状图的坐标系转换成极坐标系就变成了玫瑰图。

统计变换(stat)：对数据进行常规的统计操作，不过也可以先把数据处理好，可视化的时候就不再做变换。

分面(facet)：如果图形维度较高，并不是一张图能说明的，那么就分面处理。分面实际上是多加了一个维度，就像一页纸和一页书的区别。

位置(position)：一般来说图形各个元素的位置是由数据决定的，不过在不影响分析的前提下为了视觉美观也可以做一些微调。比如有的散点图只看它在y轴的高度，这个时候就可以在x轴上加扰动，没必要很多点都挤在一起。

```R
summary()
#最小值、最大值、四分位数和数值型变量均值以及因子向量和逻辑型向量的频数统计

pastecs::stat.desc()
stat.desc(x, basic=TRUE, desc=TRUE, norm=FALSE, p=0.95)
#x是一个数据框或时间序列,basic=T计算其中所有值、空值、缺失值的数量，以及最大值、最小值、值域还有总和。desc=T计算中位数、平均数、平均数的标准误、平均数置信度为95%的置信区间、方差、标准差以及变异系数。若norm=T（不是默认哈）则返回正态分布统计量，包括偏度和峰度（以及它们的统计显著程度）和Shapiro-Wilk正态检验结果。（使用p值计算的平均数的置信区间）

#分组计算描述性统计量

table()
xtabs()
#生成简单的频数统计表
table(A, B) #A为行变量，B为列变量

#独立性检验

#相关性

#t检验
#独立样本t检验
t.test(y ~ x, data) #y,x是data数据集中的变量
t.test(y1, y2) #自己输入的了
#非独立样本的t检验
t.test(y1, y2, paired=TRUE)

#组间差异的非参数检验
wilcox.test(y ~ x, data)
wilcox.test(y1, y2)
#多于两组
#如果各组独立，使用Kruskal-Wallis检验：
kruskal.test(y ~ A, data)
#如果不独立，使用Friedman检验：
friedman.test(y ~ A | B, data)

```

```R
1. 测试集和训练集3、7分组

australian <- read.csv("australian.csv",as.is = T,sep=",",header=TRUE)
#读取行数
N = length(australian$Y)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
#ind=1的是0.7概率出现的行，ind=2是0.3概率出现的行
ind=sample(2,N,replace=TRUE,prob=c(0.7,0.3))
#生成训练集(这里训练集和测试集随机设置为原数据集的70%，30%)
aus_train <- australian[ind==1,]
#生成测试集
aus_test <- australian[ind==2,]


2.生成模型，结果导出

#生成logis模型，用glm函数
#用训练集数据生成logis模型，用glm函数
#family：每一种响应分布（指数分布族）允许各种关联函数将均值和线性预测器关联起来。常用的family：binomal(link='logit')--响应变量服从二项分布，连接函数为logit，即logistic回归
pre <- glm(Y ~.,family=binomial(link = "logit"),data = aus_train)
summary(pre)
#测试集的真实值
real <- aus_test$Y
#predict函数可以获得模型的预测值。这里预测所需的模型对象为pre，预测对象newdata为测试集,预测所需类型type选择response,对响应变量的区间进行调整
predict. <- predict.glm(pre,type='response',newdata=aus_test)
#按照预测值为1的概率，>0.5的返回1，其余返回0
predict =ifelse(predict.>0.5,1,0)
#数据中加入预测值一列
aus_test$predict = predict
#导出结果为csv格式
#write.csv(aus_test,"aus_test.csv")

3.模型检验

##模型检验
res <- data.frame(real,predict)
#训练数据的行数，也就是样本数量
n = nrow(aus_train)      
#计算Cox-Snell拟合优度
R2 <- 1-exp((pre$deviance-pre$null.deviance)/n)    
cat("Cox-Snell R2=",R2,"\n")
#计算Nagelkerke拟合优度，我们在最后输出这个拟合优度值
R2<-R2/(1-exp((-pre$null.deviance)/n))  
cat("Nagelkerke R2=",R2,"\n")
##模型的其他指标
#residuals(pre)     #残差
#coefficients(pre)  #系数，线性模型的截距项和每个自变量的斜率，由此得出线性方程表达式。或者写为coef(pre)
#anova(pre)         #方差

4.准确率和精度

true_value=aus_test[,15]
predict_value=aus_test[,16]
#计算模型精确度
error = predict_value-true_value
accuracy = (nrow(aus_test)-sum(abs(error)))/nrow(aus_test) #精确度--判断正确的数量占总数的比例
#计算Precision，Recall和F-measure
#一般来说，Precision就是检索出来的条目（比如：文档、网页等）有多少是准确的，Recall就是所有准确的条目有多少被检索出来了
#和混淆矩阵结合，Precision计算的是所有被检索到的item（TP+FP）中,"应该被检索到的item（TP）”占的比例；Recall计算的是所有检索到的item（TP）占所有"应该被检索到的item（TP+FN）"的比例。
precision=sum(true_value & predict_value)/sum(predict_value)  #真实值预测值全为1 / 预测值全为1 --- 提取出的正确信息条数/提取出的信息条数
recall=sum(predict_value & true_value)/sum(true_value)  #真实值预测值全为1 / 真实值全为1 --- 提取出的正确信息条数 /样本中的信息条数
#P和R指标有时候会出现的矛盾的情况，这样就需要综合考虑他们，最常见的方法就是F-Measure（又称为F-Score）
F_measure=2*precision*recall/(precision+recall)    #F-Measure是Precision和Recall加权调和平均，是一个综合评价指标
#输出以上各结果
print(accuracy)
print(precision)
print(recall)
print(F_measure)
#混淆矩阵，显示结果依次为TP、FN、FP、TN
table(true_value,predict_value)

5.ROC曲线的几个方法


#ROC曲线
# 方法1
#install.packages("ROCR")  
library(ROCR)     
pred <- prediction(predict.,true_value)   #预测值(0.5二分类之前的预测值)和真实值   
performance(pred,'auc')@y.values        #AUC值
perf <- performance(pred,'tpr','fpr')
plot(perf)
#方法2
#install.packages("pROC")
library(pROC)
modelroc <- roc(true_value,predict.)
plot(modelroc, print.auc=TRUE, auc.polygon=TRUE,legacy.axes=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)        #画出ROC曲线，标出坐标，并标出AUC的值
#方法3，按ROC定义
TPR=rep(0,1000)
FPR=rep(0,1000)
p=predict.
for(i in 1:1000)
  { 
  p0=i/1000;
  ypred<-1*(p>p0)  
  TPR[i]=sum(ypred*true_value)/sum(true_value)  
  FPR[i]=sum(ypred*(1-true_value))/sum(1-true_value)
  }
plot(FPR,TPR,type="l",col=2)
points(c(0,1),c(0,1),type="l",lty=2)


6.更换测试集和训练集的选取方式，采用十折交叉验证


australian <- read.csv("australian.csv",as.is = T,sep=",",header=TRUE)
#将australian数据分成随机十等分
#install.packages("caret")
#固定folds函数的分组
set.seed(7)
require(caret)
folds <- createFolds(y=australian$Y,k=10)
#构建for循环，得10次交叉验证的测试集精确度、训练集精确度
max=0
num=0
for(i in 1:10){
  fold_test <- australian[folds[[i]],]   #取folds[[i]]作为测试集
  fold_train <- australian[-folds[[i]],]   # 剩下的数据作为训练集
  print("***组号***")
  fold_pre <- glm(Y ~.,family=binomial(link='logit'),data=fold_train)
  fold_predict <- predict(fold_pre,type='response',newdata=fold_test)
  fold_predict =ifelse(fold_predict>0.5,1,0)
  fold_test$predict = fold_predict
  fold_error = fold_test[,16]-fold_test[,15]
  fold_accuracy = (nrow(fold_test)-sum(abs(fold_error)))/nrow(fold_test) 
  print(i)
  print("***测试集精确度***")
  print(fold_accuracy)
  print("***训练集精确度***")
  fold_predict2 <- predict(fold_pre,type='response',newdata=fold_train)
  fold_predict2 =ifelse(fold_predict2>0.5,1,0)
  fold_train$predict = fold_predict2
  fold_error2 = fold_train[,16]-fold_train[,15]
  fold_accuracy2 = (nrow(fold_train)-sum(abs(fold_error2)))/nrow(fold_train) 
  print(fold_accuracy2)
  if(fold_accuracy>max)
    {
    max=fold_accuracy  
    num=i
    }
  
}
print(max)
print(num)
##结果可以看到，精确度accuracy最大的一次为max,取folds[[num]]作为测试集，其余作为训练集。

7.得到十折交叉验证的精确度，结果导出

#十折里测试集最大精确度的结果
testi <- australian[folds[[num]],]
traini <- australian[-folds[[num]],]   # 剩下的folds作为训练集
prei <- glm(Y ~.,family=binomial(link='logit'),data=traini)
predicti <- predict.glm(prei,type='response',newdata=testi)
predicti =ifelse(predicti>0.5,1,0)
testi$predict = predicti
#write.csv(testi,"ausfold_test.csv")
errori = testi[,16]-testi[,15]
accuracyi = (nrow(testi)-sum(abs(errori)))/nrow(testi) 
 
#十折里训练集的精确度
predicti2 <- predict.glm(prei,type='response',newdata=traini)
predicti2 =ifelse(predicti2>0.5,1,0)
traini$predict = predicti2
errori2 = traini[,16]-traini[,15]
accuracyi2 = (nrow(traini)-sum(abs(errori2)))/nrow(traini) 
 
#测试集精确度、取第i组、训练集精确
accuracyi;num;accuracyi2
#write.csv(traini,"ausfold_train.csv")

```

```R
#提取首列的回归系数
lm$coeff#提取首列-回归系数
lm$coefficients#默认提取首列回归系数
# 提取回归分析的某些其它咧结果
coef(summary(lm))[,c(1-7)]
#其它结果的提取
lm$residuals #提取观察值残差
rstandard(lm) #提取标准化残差
summary(lm)$r.squared#提取 R 方
summary(lm)$adj.r.squared#提取调整 R 方 AdjustedR-squared
summary(lm)$fstatistic#F 统计量


1. 通过残差图来看展回归诊断
plot(fitted(lm), resid(lm))
plot(fitted(lm), resid(lm),
     cex=1.2, pch=21, col="red", bg="orange",
     xlab="FittedValue", ylab="Residuals")
par(mfrow=c(2,2))
plot(lm,which=c(1:4))
2. 残差独立性检验（ car 包）
library(car)
durbinWatsonTest(lm)# 残差独立性检验
3. 共线性诊断
#方差膨胀因子分析
vif(lm)
#特征根分析
XX<-cor(tt1[c("SBP","DBP","TC","sugar","TG","bmi")],,use = "complete.obs")
XX
kappa(XX,exact=TRUE)
eigen(XX)

```

>[数据科学中的R和Python: 生存分析函数小结](https://xccds1977.blogspot.com/2013/08/blog-post.html)  

生存分析(survival analysis)适合于处理时间－事件数据。例如中风病人从首次发病到两次复发，其中就涉及到时间和事件。此例中时间就是复发的时间间隔，事件就是是否复发。如果用普通的线性回归对复发时间进行分析，就需要去除那些没有复发的病人样本。如果用Logistic回归对是否复发进行分析，就没有用到时间这个因素。而生存分析同时考虑时间和事情这两个因素，效果会更好些。

在R语言中我们可以使用survival包进行生存分析，其中主要的函数功能罗列如下：

Surv：用于创建生存数据对象
survfit：创建KM生存曲线或是Cox调整生存曲线
survdiff：用于不同组的统计检验
coxph：构建COX回归模型
cox.zph：检验PH假设是否成立
survreg：构建参数模型



下面是使用一个实例来使用R中的生存分析函数，其中用到的数据集可以在[这里下载](https://app.box.com/s/1yjhc5cvxy1qlw34ust6)。  
[wangshixiang's explaination](https://nbviewer.jupyter.org/github/shixiangwang/masterR/blob/master/RforBioinformatics/survival-analysis-example.ipynb)

```R
# Example from Survival Analysis- A Self-Learning Text, Third Edition 

library(survival)
addicts <- read.table('ADDICTS.txt',T)
names(addicts) <- c('id','clinic','status', 'survt','prison','dose')

# 1. 估计生存函数，观察不同组间的区别

# 建立生存对象
Surv(addicts$survt,addicts$status==1)

# 估计KM生存曲线
y <- Surv(addicts$survt,addicts$status==1)
kmfit1 <- survfit(y~1)
summary(kmfit1)
plot(kmfit1)

# 根据clinic分组估计KM生存曲线
kmfit2 <- survfit(y~addicts$clinic)
plot(kmfit2, lty = c('solid', 'dashed'), col=c('black','blue'),
     xlab='survival time in days',ylab='survival probabilities')
legend('topright', c('Clinic 1','Clinic 2'), lty=c('solid','dashed'),
       col=c('black','blue'))

# 检验显著性
survdiff(Surv(survt,status)~clinic, data=addicts)

# 用strata来控制协变量的影响
survdiff(Surv(survt,status) ~ clinic +strata(prison),data=addicts)

# 2. 用图形方法检验PH假设

plot(kmfit2,fun='cloglog',xlab='time in days using logarithmic
     scale',ylab='log-log survival', main='log-log curves by clinic')
# 不平行，不符合PH假设

#  3. 构建COX PH回归模型

y <- Surv(addicts$survt,addicts$status==1)
coxmodel <- coxph(y~ prison + dose + clinic,data=addicts)
summary(coxmodel)

# 两模型选择
mod1 <- coxph(y ~ prison + dose + clinic,data=addicts)
mod2 <- coxph(y ~ prison + dose + clinic + clinic*prison
           + clinic*dose, data=addicts)

anova(mod1,mod2)
stepAIC(mod2)
# 简洁模型更好

# 风险预测
predict(mod1,newdata=pattern1,
        type='risk')

# 4. 构建一个stratified Cox model.

# 当PH假设在clinic不成立，控制这个变量
mod3 <- coxph(y ~ prison + dose + 
                strata(clinic),data=addicts)
summary(mod3)

#  5.对PH假设进行统计检验

mod1 <- coxph(y ~ prison + dose + clinic,data=addicts)
cox.zph(mod1,transform=rank)
# P值小显示PH假设不符合
# 显示系数变化图
plot(cox.zph(mod1,transform=rank),se=F,var='clinic')

#  6. 得到COX调整后生存曲线

mod1 <- coxph(y ~ prison + dose + clinic,data=addicts)
pattern1 <- data.frame(prison=0,dose=70,clinic=2)
summary(survfit(mod1,newdata=pattern1))
plot(survfit(mod1,newdata=pattern1),conf.int=F)

mod3 <- coxph(y ~ prison + dose + 
                strata(clinic),data=addicts)
pattern2 <- data.frame(prison=.46,dose=60.40)
plot(survfit(mod3,newdata=pattern2),conf.int=F)

# 7. 构建参数模型

modpar1 <- survreg(Surv(addicts$survt,addicts$status) ~
                     prison +dose +clinic,data=addicts,
                   dist='exponential')
summary(modpar1)
```

```
id <- read.csv('id.csv',stringsAsFactors = F)
filename <- list.files(getwd(),pattern = '.txt')
abundance <- list()
for (i in 1:length(filename)){
  var_name <- gsub('?.txt','',filename[i])
  #assign(var_name,read.table(filename[i],sep="\t", header = T,stringsAsFactors = F))
  abundance[[i]] <- read.table(filename[i],sep="\t", header = T,stringsAsFactors = F)
}
library(stringr)
#files <- str_replace(filename,".txt","")
files <- str_replace_all(filename,c(".txt"="","allsample."=""))
alldata <- id
for (i in 1:length(filename)) {
  x <- abundance[[i]]
  rownames(x)=x[,1]
  x=x[,-1]
  x <- t(x)
  x <- as.data.frame(x)
  x <- merge(id, x, by.x="Sample.ID", by.y="row.names")
  csvname <- paste(files[i], 'csv', sep='.')
  write.csv(x,csvname,row.names = F)
  alldata <- merge(alldata,x,by=c("Group","ID","ID.N","ID.U","Sample.ID"))
}
```

# 弹出式 文件选择

```
read.table(file.choose())
```

>header来确定数据文件中第一行是不是标题；
>sep指定分隔符，默认是空格；
>quote是引号，默认就是双引号；
>dec是小数点的表示，默认就是一个点；
>skip是确定是否跳过某些行；
>strip.white确定是否消除空白字符；
>blank.lines.skip确定是否跳过空白行；
>comment.char指定用于表示注释的引导符号。
>check.names变量名转换成唯一的字符型向量取数据时，check.names = T表示检查变量（列）的名称是否唯一且符合语法，如果不符合，列名将会被修正；当不希望列名发生改变时，将check.names参数设置为FALSE

******

>需要先清楚该数据占多大内存，如果不设置其他参数，R会默认将整个数据集都载入内存中。
>如果文件中没有注释行的话，那可以把 comment.char 设置为空，即 comment.char=""
>colClasses 参数很重要，如果不设置，R会扫描每一列数据并判断其类型，非常耗费时间。
>如果所有列都是同一数据类型，可以直接统一设置 colClasses=numeric
>如果所有列的数据类型不统一，可以通过设定 nrow()参数，如下

```
initial <- read.table("datatable.txt", nrows = 100)          #先读前100行
classes <- sapply (initial, class)                           #sapply()遍历每一列，调用class函数告诉你每一列的数据类型，然后将这些信息储存在classes中，
tabALL <- read.table("datatable.txt", colClasses = classes)  #读取整个数据时，使用classes中的信息来指定colClasses）
```

# 读入多个到一个文件

```
temp=list.files(path=getwd(),pattern="*.txt")
data.list<-list()
for(i in 1:length(temp)){
  data.list[[i]]=read.table(temp[i],sep='\t',header = T)
}
```

# 读入多个到多个文件

```
filename <- list.files(getwd(),pattern = '.txt')
for (i in 1:length(filename)){
  var_name <- gsub('?.txt','',filename[i])
  assign(var_name,read.table(filename[i],sep="/t",header=TRUE))
}
```

```r
library(gridExtra)
lay <- rbind(c(1,1),c(2,3),c(4,5))
grid.arrange(grobs=list(p1,p2,p3,p5,p4),
             layout_matrix=lay,
             widths=c(0.5,1))
ppp <- arrangeGrob(grobs=list(p1,p2,p3,p5,p4),
             layout_matrix=lay)
ggsave('ppp1.tiff',plot =ppp,width = 22,height = 30,units = "cm",dpi = 600,compression="lzw")

```

```
#返回x中元素在table中的【位置】
match(x, table, nomatch = NA_integer_, incomparables = NULL)

#返回x中每个元素在table中【是否存在】
x %in% table

#两个对象是否完全一致
identical(a, b)

#比较两个对象的数据和维度以甄别两个对象是否近乎相同，若不同则会返回其原因
all.equal


# 定义一个结果的数据框
output<-data.frame()
# 定义for循环
for(i in nrow(x)){
output<-rbind()
}
```



# 直接安装未安装的包

```r
if(!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
```

# 正态性检验

>个人不大喜欢K-S和卡方这样的“万金油”式的检验，即使他们的创始人是Kolmogrov，Smirnov，Pearson这样的丰碑级人物，毕竟事物的广度与精准不可兼得。
>检验一元正态性还是用Shpiro-Wilk，峰态偏态，Epps-Pulley以及Anderson-Darling，它们都是国家标准推荐的。

```r
shapiro.test(X)

library(car)
qqPlot(XX, main="qq plot", col="blue", col.lines="red")
```

# 方差齐性检验

```r
bartlett.test(y ~ x, data = dat)
```

# 变量转换为因子（分类）

```r
q <- c('A', 'B','C')
dat[q] <- lapply(dat[q], factor)
remove(q)
```

update R

```
install.packages("instalr")
require(installr)
updateR()
```

使用rvcheck包更新所有的包

```R
install.packages("rvcheck")
rvcheck::update_all()
```

```r
windowsFonts(TNR=windowsFont("Times New Roman"))
```

使用plot时设定family参数

```
plot(x, y, family="TNR", main = "title", font=2)
```

ggplot2，我们需要设定主题theme。

```
theme(text=element_text(family="TNR", face="bold", size=12))
```

multiplot() 只可用于tiff（）
由于multiplot是**动作**语句，不能生成对象，与plot()作用相同

```r
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
```

tiff()保存图像，设置分辨率

```r
tiff("Plot.tiff", res = 600)
plot(p)
dev.off()
```

去掉坐标留余

```r
scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0))
```

!duplicate #去重
unique返回对象的不同取值，如unique(c(1,1,2,3)) 返回1 2 3
duplicated 判断对象的每个取值是否重复，如duplicated(c(1,1,2,3)) 返回 FALSE TRUE FALSE FALSE ，其中【T】对应的为重复的值
所以【!】就是【非重复】的值
https://www.datanovia.com/en/lessons/identify-and-remove-duplicate-data-in-r/

merge
  all=false 交集
  all=true 并集
  all.x=true 向左合并
  all.y=true向右合并

几何平均数

```R
gm_mean = function(x, na.rm=TRUE, zero.propagate = FALSE){
    if(any(x < 0, na.rm = TRUE)){
        return(NaN)
    }
    if(zero.propagate){
        if(any(x == 0, na.rm = TRUE)){
            return(0)
        }
        exp(mean(log(x), na.rm = na.rm))
    } else {
        exp(sum(log(x[x > 0]), na.rm=na.rm) / length(x))
    }
}
```

解决：调用R设备绘pdf图第一页是空白页
```r
pdf("test.pdf", onefile=FALSE)
# 此处绘图
dev.off()
```