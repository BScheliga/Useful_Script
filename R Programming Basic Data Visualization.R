###  Basic Data Visualization using ggplot2
### Author: Bernhard Scheliga
### Date: 09/12/2021


### all material linked below was accessed: 09/12/2021


### loading ggplot2 directly
library(ggplot2)

### Loading ggplot2 indirectly through tidyverse
library(tidyverse)

### loading data set
df_cars <- mtcars
 head(df_cars)

##### Basic ggplot syntax
#### Declaring or defining which data is used

#Note: 3 ways to do this, yielding the same result 

### Option 1
ggplot(df_cars)+geom_point(aes(cyl,mpg))# Data set defined "globally", Variable defined "locally"
### Option 2
ggplot(df_cars, aes(cyl,mpg)) + geom_point() + ggtitle("Option 2")# Data set and variables defined "globally" 

### Option 3
ggplot() + geom_point(aes(cyl,mpg),df_cars) +ggtitle("Option 3")# Data set and variables defined "locally"

# I would choose either option 2  or option 1


### difference between Option 1 & 2

## Option 1 Data set global & Var local

### Scatterplot

# link: https://ggplot2.tidyverse.org/reference/geom_point.html

## Option 1 Data set global & Var local
ggplot(df_cars)+geom_point(aes(cyl,mpg))+ggtitle("Option 1")

## Option 2: Data set & Var global
ggplot(df_cars, aes(cyl,mpg))+geom_point() +ggtitle("Option 2")


### Boxplot
# link: http://www.sthda.com/english/wiki/ggplot2-box-plot-quick-start-guide-r-software-and-data-visualization

## Option 1 Data set global & Var local
ggplot(df_cars)+geom_boxplot(aes(cyl,mpg))+ggtitle("Option 1")
## Note ggplot does not know, you want cylinders separate

# use either group
ggplot(df_cars)+geom_boxplot(aes(cyl,mpg, group=cyl))+ggtitle("Option 1")
# or define cyl as factor
ggplot(df_cars)+geom_boxplot(aes(as.factor(cyl),mpg))+ggtitle("Option 1")


## Option 2: Data set & Var global
ggplot(df_cars, aes(cyl,mpg))+geom_boxplot()+ggtitle("Option 2 - No Group")
ggplot(df_cars, aes(cyl,hp))+geom_boxplot(aes(group=cyl))+ggtitle("Option 2 - Group")

# Violin
ggplot(df_cars, aes(cyl,mpg))+
  geom_violin(aes(group=cyl))+
  geom_point()+
  ggtitle("Option 2 - Violin + point")

# Violin
ggplot(df_cars, aes(cyl,mpg))+
  geom_violin(aes(group=cyl))+
  geom_jitter()+
  ggtitle("Option 2 - Violin + Jitter")

## line plot 
## Option 1 Data set global & Var local
ggplot(df_cars)+geom_line(aes(cyl,mpg))+ggtitle("Option 1")
## Option 2: Data set & Var global
ggplot(df_cars, aes(cyl,mpg))+geom_line() +ggtitle("Option 2")
## if it looks funny, try grouping or as.factor
ggplot(df_cars, aes(cyl,mpg))+geom_line(aes(group=cyl))+ggtitle("Option 2")

ggplot(df_cars, aes(cyl,mpg))+
  geom_line(aes(group=cyl))+
  geom_point()+
  ggtitle("Option 2")

# plotting order
#Note: You can save the plot as object in the Global Environment
ggplot(df_cars, aes(cyl,mpg))+geom_line()

#adding Points
ggplot(df_cars, aes(cyl,mpg))+geom_line()+
  geom_point()

# adding boxplot
ggplot(df_cars, aes(cyl,mpg))+geom_line()+
  geom_point()+
  geom_boxplot()

# Rearranging plotting order (aka "layers", I think)
ggplot(df_cars, aes(cyl,mpg))+
  geom_boxplot()+
  geom_line()+
  geom_point(aes(colour="blue"))
# that is not blue

ggplot(df_cars, aes(cyl,mpg))+
  geom_boxplot()+
  geom_line()+
  geom_point(colour="blue")


### aesthetic aes()
#source: https://ggplot2.tidyverse.org/reference/geom_point.html

#Note you can save your plot as an object
p <- ggplot(mtcars, aes(wt, mpg))
p + geom_point()
# Add aesthetic mappings
p + geom_point(aes(colour = factor(cyl)))
p + geom_point(aes(shape = factor(cyl)))
# A "bubblechart":
p + geom_point(aes(size = qsec))

# Set aesthetics to fixed value
ggplot(mtcars, aes(wt, mpg)) + geom_point(colour = "darkred", size = 3)


# Varying alpha (transparency) is useful for large datasets
d <- ggplot(diamonds, aes(carat, price))
d + geom_point()

d + geom_point(alpha = 1/10)

d + geom_point(alpha = 1/100)

#For shapes that have a border (like 21), you can colour the inside and
# outside separately
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "red", size = 5, stroke = 1)



p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl)))

p + geom_point(colour = "black", size = 4.5) +
  geom_point(colour = "pink", size = 4) +
  geom_point(aes(shape = factor(cyl)))

# save in a new object
p2<- p + geom_point(colour = "black", size = 4.5) +
  geom_point(colour = "pink", size = 4) +
  geom_point(aes(shape = factor(cyl)))

# Colour or Fill based on value

set.seed(366) # need to run that before, so we always get the same random numbers
df_temp <- data.frame(Date = seq.Date(as.Date("2020/01/01"),as.Date("2020/12/31"),by="1 day"), Temp_C = round(runif(366,min= -20,max= 35),2))

# Fill
ggplot(df_temp)+
  geom_area(aes(x=Date, y=ifelse(Temp_C<0, Temp_C,0)), fill="darkblue", alpha = 0.7) +
  geom_area(aes(x=Date, y=ifelse(Temp_C>0, Temp_C, 0)), fill="darkgreen", alpha = 0.7)+
  geom_hline(yintercept=0, linetype="dashed")+
  ylab("Daily random Temperatur")+xlab("")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_labels = "%b-%Y", date_breaks = "month")+
  ggtitle("Daily random Temperatur in 2020 - geom_area")

# Colour
ggplot(df_temp)+
  geom_line(aes(x=Date, y=ifelse(Temp_C<0, Temp_C,0)), colour="darkblue", alpha = 0.7) +
  geom_line(aes(x=Date, y=ifelse(Temp_C>0, Temp_C, 0)), colour="darkgreen", alpha = 0.7)+
  geom_hline(yintercept=0, linetype="dashed")+
  ylab("Daily random Temperatur")+xlab("")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_labels = "%b-%Y", date_breaks = "month")+
  ggtitle("Daily random Temperatur in 2020 - geom_line")




####### Themes
#     https://ggplot2.tidyverse.org/reference/ggtheme.html
#     https://ggplot2.tidyverse.org/reference/theme_get.html
library(ggthemes)

theme_set(theme_classic())
# Use theme_set() to completely override the current theme.
p2
theme_set(theme_bw())
p2
theme_set(theme_minimal())
p2
theme_set(theme_dark())
p2
theme_set(theme_bw())
p2

##### Making a plot look nice
# https://ggplot2.tidyverse.org/reference/ggtheme.html


########## Labels 

mtcars2 <- within(mtcars, {
  vs <- factor(vs, labels = c("V-shaped", "Straight"))
  am <- factor(am, labels = c("Automatic", "Manual"))
  cyl  <- factor(cyl)
  gear <- factor(gear)
})


ggplot(mtcars2) +
  geom_point(aes(x = wt, y = mpg, colour = gear))



p1 <- ggplot(mtcars2) +
  geom_point(aes(x = wt, y = mpg, colour = gear)) +
  labs(title = "Fuel economy declines as weight increases",
       subtitle = "(1973-74)",
       caption = "Data from the 1974 Motor Trend US magazine.",
       tag = "Figure 1",
       x = "Weight (1000 lbs)",
       y = "Fuel economy (mpg)",
       colour = "Gears")

# colour and fill

p1 + facet_grid(vs ~ am)

### Special Character in labels



#https://rstudio-pubs-static.s3.amazonaws.com/136237_170402e5f0b54561bf7605bdea98267a.html

#qplot() quick plot
qplot(1,1) + labs(x = expression(paste("NO"[3]^-{}, " (mgN/L)")),
                  y = expression(paste(delta^{15}, " N-NO"[3]^-{}, "(vs air)")))


# Superscript, subscript, isotopes in facets
qplot(wt, mpg, data = mtcars) + facet_grid(. ~ cyl)
# adding a new column to dataset for the new labels
mtcars$cyl2 <- factor(mtcars$cyl, labels = c("delta^{15}*N-NO[3]^-{}", "NO[3]^-{}", "sqrt(x,y)"))
qplot(wt, mpg, data = mtcars) + facet_grid(. ~ cyl2)

# to render these the way we want, we use labeller = label_parsed because we want to parse
qplot(wt, mpg, data = mtcars) + facet_grid(. ~ cyl2,
                                           labeller = label_parsed)


####  Annotate

qplot(c(1,50), c(1,50)) + # Two Point one at 1,1 & one at 50,50
  annotate("text", x = 15, y = 25, parse = TRUE, label = as.character(expression(delta^{15}*"N-NO"[3]^-{}*" (‰ vs air)"))) +
  annotate("text", x = 20, y = 35, size = 7, parse = TRUE, label = as.character(expression(paste(H[2],PO[4]^"-"))))



####### tick mark and labels
#source http://www.sthda.com/english/wiki/ggplot2-axis-ticks-a-guide-to-customize-tick-marks-and-labels




# Convert dose column from numeric to factor variable. It makes plotting easier
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
p <- ggplot(ToothGrowth, aes(x=dose, y=len)) + geom_boxplot()
p

# Change the appearance and the orientation angle
# of axis tick labels
p <- p + theme(axis.text.x = element_text(face="bold", color="#993333", 
                                          size=14, angle=45),
               axis.text.y = element_text(face="bold", color="#993333", 
                                          size=14, angle=45))

# Hide x an y axis tick mark labels
p + theme(
  axis.text.x = element_blank(),
  axis.text.y = element_blank())
# Remove axis ticks and tick mark labels
p + theme(
  axis.text.x = element_blank(),
  axis.text.y = element_blank(),
  axis.ticks = element_blank())

# Change the line type and color of axis lines
p + theme( axis.line = element_line(colour = "red", 
                                    size = 1, linetype = "dashed"))

#### Set axis ticks for discrete and continuous axes
# default plot
p
# Change the order of items
# Change the x axis name
p + scale_x_discrete(name ="Dose (mg)", 
                     limits=c("2","1","0.5"))

##### Dual axis Plot
# run code from dual_axis_plot.R

p1 <- ggplot(df_cars, aes(cyl,mpg))+geom_boxplot(aes(group=cyl), fill="blue", alpha=0.5)+ggtitle("Primary Plot")
p2 <- ggplot(df_cars, aes(cyl,hp))+geom_boxplot(aes(group=cyl), fill="green", alpha=0.5)+ggtitle("Secondary Plot")


library(grid)
library(gtable)
ggplot_dual_axis_fixed.margin(p1,p2,"y")



### Legends
# https://www.r-graph-gallery.com/239-custom-layout-legend-ggplot2.html
