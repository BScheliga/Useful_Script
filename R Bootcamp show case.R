############# Script for the R Bootcamp ###############
####
#### to show case R 

# for comment

### for creating a heading / jumping point in your script  #####


# Shows stuff (e.g. console, where to install package, project space)

### some of the following example are from https://intro2r.com/getting-started.html
### which is a superb introduction guide!

(((())))


2+2

2 + 3 * 4

(2+3)*4             # brackets matter

log(1)              # logarithm to base e

log10(1)            # logarithm to base 10

exp(1)              # natural anti log

sqrt(4)             # square root

4^2                   # 4 to the power of 2

pi                    # not a function but useful


##### Objects ####

var1 <- 4
var2 <- 6

var1 + var2

var3 <- c(1,2,3,4)

var4 <- seq(1,4,4) # seq(from,to, by)
var5 <- seq(from = 1, to = 4, by= .1)

##### How to set up your local work directory ####
setwd("C:/brave new world/workshop")
dir()    # shows all files in the folder
dir(pattern= ".csv")

df_filename <-dir(pattern= ".csv")

df_filename
df_filename[1]
df_filename[2]
## load the local files


df_1 <- read.csv("meaningful data.csv") # in " " is the name of the file
df_1 <- read.csv(df_filename[1])

rm(df_1) # removing an object

###### working with data ####

iris  # this data set is one of integrated data set in R

## storing the data in an Object
df_iris <- iris

head(df_iris) # get the first 6 rows of the data set

tail(df_iris) # # get the last 6 rows of the data set

## show auto-correct


## general stats
# for the whole data set
summary(df_iris)

# for single columns
mean(df_iris$Sepal.Length) # best practice
mean(df_iris[,1]) # bad practice 

mean(df_iris$Sepal.Width)  


df_iris[c(2,4,5),1]  # picking row 2,4 & 5 from the 1 first column


max(df_iris$Sepal.Length)

min(df_iris[c(2,4,5),1]) 

### statistical tests
## t test
t.test(df_iris$Sepal.Length)

## correlation 
cor.test(df_iris$Sepal.Length, df_iris$Sepal.Width)



#### visualizing the data #####


plot(df_iris)

#### Note the packages need to be installed, before you can call them via the Library command
#### go to "packages"-tab in the bottom right window and then to install

### packages provide one or more libraries for R which in heaps of useful functions

#### http://jamesmarquezportfolio.com/correlation_matrices_in_r.html#.WP6WeFB-BPd.facebook
library(psych)

pairs.panels(df_iris[,c(1:4)], scale=TRUE)


library(ggplot2)
### scatter plots
ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_point()

ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_point(aes(colour = Species))
### scatter plots plus regression
ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_point(aes(colour = Species))+geom_smooth(method = lm)

ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_point(aes(colour = Species))+geom_smooth(aes(colour = Species), method = lm)

### box plots

ggplot(df_iris,aes(Species,Sepal.Width))+geom_boxplot()

ggplot(df_iris,aes(Species,Petal.Width))+geom_boxplot()

### next level plots !!! This is just for show casing what is possible!

### saving the plot in objects and making the look neater
Plot_scatter <- ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_point(aes(colour = Species))+geom_smooth(aes(colour = Species), method = lm)+
  theme(legend.position =  "none",
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) 

Plot_box_y <-ggplot(df_iris,aes(Species,Petal.Length))+geom_boxplot(aes(fill = Species))+
  theme(legend.position =  "none",
        axis.title.x = element_blank())
Plot_box_x <-ggplot(df_iris,aes(Sepal.Width,Species))+geom_boxplot(aes(fill = Species))+
  theme(legend.position =  "none",
        axis.title.y = element_blank())
## geom_tile gives a nicer legend to extract
Plot_legend <- ggplot(df_iris,aes(Sepal.Width, Petal.Length))+geom_tile(aes(fill = Species))

### function for extracting a legend from ggplot
#http://stackoverflow.com/questions/12041042/how-to-plot-just-the-legends-in-ggplot2
library(gridExtra)
library(grid)

#Extract Legend - function
g_legend<-function(a.gplot){ 
  tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
  legend <- tmp$grobs[[leg]] 
  return(legend)
} 

Plot_legend <- g_legend(Plot_legend)


##  based on this http://www.sthda.com/english/wiki/ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page-r-software-and-data-visualization

A <- Plot_scatter
B <- Plot_box_y
C <- Plot_box_x
D <- Plot_legend

gA <- ggplotGrob(A)
gB <- ggplotGrob(B)
gC <- ggplotGrob(C)
gD <- Plot_legend # already a Grob

##########################
### get dimensions from the plots

maxWidth = grid::unit.pmax(gA$widths, gC$widths)
gA$widths <- as.list(maxWidth)
#gB$widths <- as.list(maxWidth)
gC$widths <- as.list(maxWidth)
#gD$widths <- as.list(maxWidth)
maxHeight = grid::unit.pmax(gA$height, gB$height)
gA$height <- as.list(maxHeight)
gB$height <- as.list(maxHeight)
#gC$height <- as.list(maxHeight)
###### that is the shit
#https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html
gs <- gList(gA, gB, gC, gD)

### the plot layout for 5 by 2 matrix
lay <- rbind(c(2,1),
             c(4,3))

grid.arrange(grobs = gs, layout_matrix = lay)

