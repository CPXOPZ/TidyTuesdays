>不论做什么图最最重要的是如何通过这张图说明突出你想要传达的内容，你想要告诉读者什么结论，那么就是你这张图所需要展示的，千万不要一味追求图形的好看或者复杂而忘记了你做图的目的，不论任何形式的图都只是数据的可视化，而可视化是为了增强数据的可读性。要玩方法不要被方法玩。


>数据(data)：数据才是图形的灵魂，这点无需解释。
>
>几何对象(geom)：也就是图形本身，这是可视化的外形。根据数据特征，选择最合适的图形。
>
>映射(mapping)：映射即使把数据和图形给连接起来。映射什么数据变量，它是连续的还是离散的？
>
>标度(scale)：这个是从数据中剥离，但是控制数据如何映射到图形上的属性。图形中用什么通道来映射？常用的有颜色、长度、面积、形状、透明度等通道。
>
>坐标系(coord)：坐标系不一定非得是直角笛卡尔坐标系，比如对于地图并不适合，所以要做专门的投影操作。转换坐标系也有造成不同的视觉效果，比如把柱状图的坐标系转换成极坐标系就变成了玫瑰图。
>
>统计变换(stat)：对数据进行常规的统计操作，不过也可以先把数据处理好，可视化的时候就不再做变换。
>
>分面(facet)：如果图形维度较高，并不是一张图能说明的，那么就分面处理。分面实际上是多加了一个维度，就像一页纸和一页书的区别。
>
>位置(position)：一般来说图形各个元素的位置是由数据决定的，不过在不影响分析的前提下为了视觉美观也可以做一些微调。比如有的散点图只看它在y轴的高度，这个时候就可以在x轴上加扰动，没必要很多点都挤在一起。

# R操作

## R

### update R

```R
install.packages("instalr")
require(installr)
updateR()
```

### 使用rvcheck包更新所有的包

```R
install.packages("rvcheck")
rvcheck::update_all()
```
## 各种操作

### 变量名清洗

```R
janitor::clean_names()
# 空格更改为下划线，[下划线在R变量名称中是合法的（句点也是如此）] 
# 所有以前以数字开头的列名现在都以x开头
```



### 变量转换为因子（分类）

```r
q <- c('A', 'B','C')
dat[q] <- lapply(dat[q], factor)
remove(q)
```
### 简单循环

```R
# 定义一个结果的数据框
output<-data.frame()
# 定义for循环
for(i in nrow(x)){
output<-rbind()
}
```



## 画图

### 细节调整

#### 去掉坐标留余

```r
scale_x_discrete(expand = c(0, 0)) + scale_y_discrete(expand = c(0, 0))
```

### 字体

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

## 拼图

### gridExtra

```R
library(gridExtra)
lay <- rbind(c(1,1),c(2,3),c(4,5))
grid.arrange(grobs=list(p1,p2,p3,p5,p4),
             layout_matrix=lay,
             widths=c(0.5,1))
ppp <- arrangeGrob(grobs=list(p1,p2,p3,p5,p4),
             layout_matrix=lay)
ggsave('ppp1.tiff',plot =ppp,width = 22,height = 30,units = "cm",dpi = 600,compression="lzw")

```

## 存图

### tiff()

tiff()保存图像，设置分辨率

```r
tiff("Plot.tiff", res = 600)
plot(p)
dev.off()
```

### cairo

PDF 字体镶嵌，PNG解决可能问题（其他软件分辨率或尺寸问题）

```R
ggsave(..., filename = "whatever.pdf", ..., device = cairo_pdf)
ggsave(..., filename = "whatever.png", ..., dpi = 300, type = "cairo")
```

### 解决：调用R设备绘pdf图第一页是空白页

```r
pdf("test.pdf", onefile=FALSE)
# 此处绘图
dev.off()
```

### multiplot()

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

#  统计分析

##  基本统计描述

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

### 几何平均数

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

## 正态性检验

>个人不大喜欢K-S和卡方这样的“万金油”式的检验，即使他们的创始人是Kolmogrov，Smirnov，Pearson这样的丰碑级人物，毕竟事物的广度与精准不可兼得。
>检验一元正态性还是用Shpiro-Wilk，峰态偏态，Epps-Pulley以及Anderson-Darling，它们都是国家标准推荐的。

```R
shapiro.test(X)

library(car)
qqPlot(XX, main="qq plot", col="blue", col.lines="red")
```

## 方差齐性检验

```r
bartlett.test(y ~ x, data = dat)
```