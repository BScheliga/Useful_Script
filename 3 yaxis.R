######################################################################################################
##################Diver data plotting#################################################################
######################################################################################################
library(ggplot2)
library(grid)
library(dplyr)
library(lubridate)
library(reshape2)
library(gtable)


#####deeper Ground water wells########################################################################
setwd()
dat_site3 <- read.csv("site3.CSV", header=TRUE)

#####Precipitation data###############################################################################
setwd()
dat_PP <- read.csv("hillslope.csv")
dat_PP <- dat_PP[,c(1,6)]
colnames(dat_PP) <-c("TIMESTAMP","Precipitation" )

########Soil moistue Site 3##########################################################################
setwd)
dat_soilsite3 <-read.csv("VSM Site 3.csv")
dat_soilsite3 <-data.frame(dat_soilsite3[,c(2,17:19)])
colnames(dat_soilsite3) <-c("TIMESTAMP", "10 cm", "30 cm", "50 cm")


###mutate date
dat_site3 <- mutate(dat_site3, TIMESTAMP = dmy_hm(TIMESTAMP))
dat_PP <-mutate(dat_PP, TIMESTAMP = ymd_hms(TIMESTAMP))
dat_soilsite3 <- mutate(dat_soilsite3, TIMESTAMP = ymd_hms(TIMESTAMP))

##########one date to show them all ... for now
selc_date_start <- '2015-07-08 19:00:00'
selc_date_end <- '2015-09-24 12:45:00'
########### selecting the data depending on the date
dat_PP <- filter(dat_PP, TIMESTAMP >= selc_date_start , TIMESTAMP <= selc_date_end)
dat_soilsite3 <- filter(dat_soilsite3, TIMESTAMP >= selc_date_start , TIMESTAMP <= selc_date_end)


site3 <- qplot(TIMESTAMP, Waterhead, data = dat_site3, geom = 'line',  ylab = "water head [cm]", xlab = "Site 3")+theme_bw()  +
  theme(panel.background = element_rect(fill = NA))
PP <- qplot(TIMESTAMP, Precipitation, data = dat_PP, geom = 'bar',  ylab = "PP [mm]", xlab = "hillslope", stat="identity") + scale_y_reverse() +
  theme(panel.background = element_rect(fill = NA))

dat_soilsite3 <-melt(dat_soilsite3, id="TIMESTAMP")
SM_Site3 <- ggplot(dat_soilsite3, aes(TIMESTAMP,value)) + geom_line(aes(colour = variable))+
  theme_bw()+ # removes the grey background and places black borders
  theme(panel.background = element_rect(fill = NA))

###########dual axis

# extract gtable
g1 <- ggplot_gtable(ggplot_build(site3))
g2 <- ggplot_gtable(ggplot_build(SM_Site3))
g3 <- ggplot_gtable(ggplot_build(PP))
  
  # overlap the panel of 2nd plot on that of 1st plot
  pp <- c(subset(g1$layout, name == "panel", se = t:r))
  g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
                       pp$l, pp$b, pp$l)
  grid.draw(g)
  g <- gtable_add_grob(g1, g2$grobs, pp$t, 
                       pp$l, pp$b, pp$l)
  
  #dummy_table <- ggplot_gtable(ggplot_build(g))
                               
  pp2 <- c(subset(g$layout, name == "panel", se = t:r))
  test <- gtable_add_grob(g, g3$grobs[[which(g3$layout$name == "panel")]], pp$t, 
                          pp$l, pp$b, pp$l)
  
  grid.draw(g)
  grid.draw(test) 
  
  
  # axis tweaks
  ia <- which(g2$layout$name == "axis-l")
  ga <- g2$grobs[[ia]]
  ax <- ga$children[[2]]
  ax$widths <- rev(ax$widths)
  ax$grobs <- rev(ax$grobs)
  ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
  g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
  g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)
  
  grid.draw(g)
  