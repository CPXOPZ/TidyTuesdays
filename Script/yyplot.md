## install yyplot

```r
install.packages('devtools')

devtools::install_github('YuLab-SMU/ggtree')

devtools::install_github('GuangchuangYu/yyplot')
```

## pubmed_trend via yyplot

```r
library(yyplot)
term <- c('"H7N9"', '"H5N1"', '"RSV"')
pm <- pubmed_trend(term, year=2001:2014)
plot(pm)
```

## 呈现数据交给R，修图只会PPT

```R
library(ggplotify)
library(eoffice)

f = "~/eoffice.pptx"
# 现目录位于“文档”文件夹
p = as.ggplot(~plot(cars, cex.lab=2, cex.main=2,
              xlab="biobabble", ylab="biobabble",
              main = "Y叔演示专用"))
topptx(p, f)
# 配合Here包，直接替换f为具体路径亦可

# 直接在R里就能打开 【但是未尝试成功】
library(rvcheck)
o(f)
```

