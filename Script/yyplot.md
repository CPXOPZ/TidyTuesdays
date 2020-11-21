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

### ggplotify 插入 图例 legend

```R
col = colorspace::rainbow_hcl(3)
names(col) = unique(iris$Species)

library(ggplotify)
color = col[iris$Species]

# 转换为ggolot对象
p = as.ggplot(~plot(iris$Sepal.Length, iris$Sepal.Width, col=color, pch=15))

library(ggplot2)
p2 = ggplot(iris, aes(Sepal.Length, Sepal.Width, color=Species)) +
    geom_point() + scale_color_manual(values=col, name="")

legend = cowplot::get_legend(p2)

# 嵌套
p + ggimage::geom_subview(x=.7, y=.6, subview=legend)

#这里用base plot画了一个图，又用ggplot2画了一个，用cowplot把legend抽出来，然后再用我的另一个包ggimage进行图上嵌图
```

