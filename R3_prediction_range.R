library(ggplot2)
library(PCICt)
library(ncdf4)
library(metR)
library(data.table)
library(udunits2)
library(plyr)
library(dplyr)
require(lubridate)
library(easyNCDF)
library(stringr)
options(max.print=1000000)

# This code plots the prediction range.
################################################################################
dir_path1 = "/path/to/corr/actual_skill/ly1/"
dir_path2 = "/path/to/corr/skill_from_forcing/"
dir_path3 = "/path/to/corr/skill_from_intvar/"
dir_path4 = "/path/to/corr/actual_skill/ly2/"
dir_path5 = "/path/to/corr/skill_from_intvar/ly2"

# File extensions
nc1 = "Irish.nc"
nc2 = "Irish.nc"
nc3 = "Irish.nc"

nc4 = "Med.nc"
nc5 = "Med.nc"
nc6 = "Med.nc"

nc7 = "Okinawa.nc"
nc8 = "Okinawa.nc"
nc9 = "Okinawa.nc"

nc10 = "Hawaii.nc"
nc11 = "Hawaii.nc"
nc12 = "Hawaii.nc"

nc13 = "Cold_Caribb.nc"
nc14 = "Cold_Caribb.nc"
nc15 = "Cold_Caribb.nc"

nc16 = "Warm_Caribb.nc"
nc17 = "Warm_Caribb.nc"
nc18 = "Warm_Caribb.nc"

nc19 = "GoG.nc"
nc20 = "GoG.nc"
nc21 = "GoG.nc"

nc22 = "Indian.nc"
nc23 = "Indian.nc"
nc24 = "Indian.nc"

nc25 = "Triangle.nc"
nc26 = "Triangle.nc"
nc27 = "Triangle.nc"

nc28 = "Gala.nc"
nc29 = "Gala.nc"
nc30 = "Gala.nc"

nc31 = "Australia.nc"
nc32 = "Australia.nc"
nc33 = "Australia.nc"

nc34 = "Tasman.nc"
nc35 = "Tasman.nc"
nc36 = "Tasman.nc"

# Open netcdf files
file1 <- nc_open(paste(dir_path1,nc1,sep=""))
file2 <- nc_open(paste(dir_path2,nc2,sep=""))
file3 <- nc_open(paste(dir_path3,nc3,sep=""))

file4 <- nc_open(paste(dir_path1,nc4,sep=""))
file5 <- nc_open(paste(dir_path2,nc5,sep=""))
file6 <- nc_open(paste(dir_path3,nc6,sep=""))

file7 <- nc_open(paste(dir_path1,nc7,sep=""))
file8 <- nc_open(paste(dir_path2,nc8,sep=""))
file9 <- nc_open(paste(dir_path3,nc9,sep=""))

file10 <- nc_open(paste(dir_path1,nc10,sep=""))
file11 <- nc_open(paste(dir_path2,nc11,sep=""))
file12 <- nc_open(paste(dir_path3,nc12,sep=""))

file13 <- nc_open(paste(dir_path1,nc13,sep=""))
file14 <- nc_open(paste(dir_path2,nc14,sep=""))
file15 <- nc_open(paste(dir_path3,nc15,sep=""))

file16 <- nc_open(paste(dir_path1,nc16,sep=""))
file17 <- nc_open(paste(dir_path2,nc17,sep=""))
file18 <- nc_open(paste(dir_path3,nc18,sep=""))

file19 <- nc_open(paste(dir_path1,nc19,sep=""))
file20 <- nc_open(paste(dir_path2,nc20,sep=""))
file21 <- nc_open(paste(dir_path3,nc21,sep=""))

file22 <- nc_open(paste(dir_path1,nc22,sep=""))
file23 <- nc_open(paste(dir_path2,nc23,sep=""))
file24 <- nc_open(paste(dir_path3,nc24,sep=""))

file25 <- nc_open(paste(dir_path1,nc25,sep=""))
file26 <- nc_open(paste(dir_path2,nc26,sep=""))
file27 <- nc_open(paste(dir_path3,nc27,sep=""))

file28 <- nc_open(paste(dir_path1,nc28,sep=""))
file29 <- nc_open(paste(dir_path2,nc29,sep=""))
file30 <- nc_open(paste(dir_path3,nc30,sep=""))

file31 <- nc_open(paste(dir_path1,nc31,sep=""))
file32 <- nc_open(paste(dir_path2,nc32,sep=""))
file33 <- nc_open(paste(dir_path3,nc33,sep=""))

file34 <- nc_open(paste(dir_path1,nc34,sep=""))
file35 <- nc_open(paste(dir_path2,nc35,sep=""))
file36 <- nc_open(paste(dir_path3,nc36,sep=""))

# Actual skill in LY2
ly2_01a <- nc_open(paste(dir_path4,nc1,sep=""))
ly2_02a <- nc_open(paste(dir_path4,nc4,sep=""))
ly2_03a <- nc_open(paste(dir_path4,nc7,sep=""))
ly2_04a <- nc_open(paste(dir_path4,nc10,sep=""))
ly2_05a <- nc_open(paste(dir_path4,nc13,sep=""))
ly2_06a <- nc_open(paste(dir_path4,nc16,sep=""))
ly2_07a <- nc_open(paste(dir_path4,nc19,sep=""))
ly2_08a <- nc_open(paste(dir_path4,nc22,sep=""))
ly2_09a <- nc_open(paste(dir_path4,nc25,sep=""))
ly2_10a <- nc_open(paste(dir_path4,nc28,sep=""))
ly2_11a <- nc_open(paste(dir_path4,nc31,sep=""))
ly2_12a <- nc_open(paste(dir_path4,nc34,sep=""))

# Skill from int. var. in LY2
ly2_01i <- nc_open(paste(dir_path5,nc1,sep=""))
ly2_02i <- nc_open(paste(dir_path5,nc4,sep=""))
ly2_03i <- nc_open(paste(dir_path5,nc7,sep=""))
ly2_04i <- nc_open(paste(dir_path5,nc10,sep=""))
ly2_05i <- nc_open(paste(dir_path5,nc13,sep=""))
ly2_06i <- nc_open(paste(dir_path5,nc16,sep=""))
ly2_07i <- nc_open(paste(dir_path5,nc19,sep=""))
ly2_08i <- nc_open(paste(dir_path5,nc22,sep=""))
ly2_09i <- nc_open(paste(dir_path5,nc25,sep=""))
ly2_10i <- nc_open(paste(dir_path5,nc28,sep=""))
ly2_11i <- nc_open(paste(dir_path5,nc31,sep=""))
ly2_12i <- nc_open(paste(dir_path5,nc34,sep=""))

# Define the regions by grid points and read netcdf data
region01 <- ReadNetCDF(file1, vars="topo", out="data.frame")
region02 <- ReadNetCDF(file2, vars="topo", out="data.frame")
region03 <- ReadNetCDF(file3, vars="topo", out="data.frame")

region01 <- data.frame("lat"=region01$lat, "lon"=region01$lon, "topo"=round(region01$topo, 1))
region02 <- data.frame("lat"=region02$lat, "lon"=region02$lon, "topo"=round(region02$topo, 1))
region03 <- data.frame("lat"=region03$lat, "lon"=region03$lon, "topo"=round(region03$topo, 1))

region04 <- ReadNetCDF(file4, vars="topo", out="data.frame")
region05 <- ReadNetCDF(file5, vars="topo", out="data.frame")
region06 <- ReadNetCDF(file6, vars="topo", out="data.frame")

region04 <- data.frame("lat"=region04$lat, "lon"=region04$lon, "topo"=round(region04$topo, 1))
region05 <- data.frame("lat"=region05$lat, "lon"=region05$lon, "topo"=round(region05$topo, 1))
region06 <- data.frame("lat"=region06$lat, "lon"=region06$lon, "topo"=round(region06$topo, 1))

region07 <- ReadNetCDF(file7, vars="topo", out="data.frame")
region08 <- ReadNetCDF(file8, vars="topo", out="data.frame")
region09 <- ReadNetCDF(file9, vars="topo", out="data.frame")

region07 <- data.frame("lat"=region07$lat, "lon"=region07$lon, "topo"=round(region07$topo, 1))
region08 <- data.frame("lat"=region08$lat, "lon"=region08$lon, "topo"=round(region08$topo, 1))
region09 <- data.frame("lat"=region09$lat, "lon"=region09$lon, "topo"=round(region09$topo, 1))

region10 <- ReadNetCDF(file10, vars="topo", out="data.frame")
region11 <- ReadNetCDF(file11, vars="topo", out="data.frame")
region12 <- ReadNetCDF(file12, vars="topo", out="data.frame")

region10 <- data.frame("lat"=region10$lat, "lon"=region10$lon, "topo"=round(region10$topo, 1))
region11 <- data.frame("lat"=region11$lat, "lon"=region11$lon, "topo"=round(region11$topo, 1))
region12 <- data.frame("lat"=region12$lat, "lon"=region12$lon, "topo"=round(region12$topo, 1))

region13 <- ReadNetCDF(file13, vars="topo", out="data.frame")
region14 <- ReadNetCDF(file14, vars="topo", out="data.frame")
region15 <- ReadNetCDF(file15, vars="topo", out="data.frame")

region13 <- data.frame("lat"=region13$lat, "lon"=region13$lon, "topo"=round(region13$topo, 1))
region14 <- data.frame("lat"=region14$lat, "lon"=region14$lon, "topo"=round(region14$topo, 1))
region15 <- data.frame("lat"=region15$lat, "lon"=region15$lon, "topo"=round(region15$topo, 1))

region16 <- ReadNetCDF(file16, vars="topo", out="data.frame")
region17 <- ReadNetCDF(file17, vars="topo", out="data.frame")
region18 <- ReadNetCDF(file18, vars="topo", out="data.frame")

region16 <- data.frame("lat"=region16$lat, "lon"=region16$lon, "topo"=round(region16$topo, 1))
region17 <- data.frame("lat"=region17$lat, "lon"=region17$lon, "topo"=round(region17$topo, 1))
region18 <- data.frame("lat"=region18$lat, "lon"=region18$lon, "topo"=round(region18$topo, 1))

region19 <- ReadNetCDF(file19, vars="topo", out="data.frame")
region20 <- ReadNetCDF(file20, vars="topo", out="data.frame")
region21 <- ReadNetCDF(file21, vars="topo", out="data.frame")

region19 <- data.frame("lat"=region19$lat, "lon"=region19$lon, "topo"=round(region19$topo, 1))
region20 <- data.frame("lat"=region20$lat, "lon"=region20$lon, "topo"=round(region20$topo, 1))
region21 <- data.frame("lat"=region21$lat, "lon"=region21$lon, "topo"=round(region21$topo, 1))

region22 <- ReadNetCDF(file22, vars="topo", out="data.frame")
region23 <- ReadNetCDF(file23, vars="topo", out="data.frame")
region24 <- ReadNetCDF(file24, vars="topo", out="data.frame")

region22 <- data.frame("lat"=region22$lat, "lon"=region22$lon, "topo"=round(region22$topo, 1))
region23 <- data.frame("lat"=region23$lat, "lon"=region23$lon, "topo"=round(region23$topo, 1))
region24 <- data.frame("lat"=region24$lat, "lon"=region24$lon, "topo"=round(region24$topo, 1))

region25 <- ReadNetCDF(file25, vars="topo", out="data.frame")
region26 <- ReadNetCDF(file26, vars="topo", out="data.frame")
region27 <- ReadNetCDF(file27, vars="topo", out="data.frame")

region25 <- data.frame("lat"=region25$lat, "lon"=region25$lon, "topo"=round(region25$topo, 1))
region26 <- data.frame("lat"=region26$lat, "lon"=region26$lon, "topo"=round(region26$topo, 1))
region27 <- data.frame("lat"=region27$lat, "lon"=region27$lon, "topo"=round(region27$topo, 1))

region28 <- ReadNetCDF(file28, vars="topo", out="data.frame")
region29 <- ReadNetCDF(file29, vars="topo", out="data.frame")
region30 <- ReadNetCDF(file30, vars="topo", out="data.frame")

region28 <- data.frame("lat"=region28$lat, "lon"=region28$lon, "topo"=round(region28$topo, 1))
region29 <- data.frame("lat"=region29$lat, "lon"=region29$lon, "topo"=round(region29$topo, 1))
region30 <- data.frame("lat"=region30$lat, "lon"=region30$lon, "topo"=round(region30$topo, 1))

region31 <- ReadNetCDF(file31, vars="topo", out="data.frame")
region32 <- ReadNetCDF(file32, vars="topo", out="data.frame")
region33 <- ReadNetCDF(file33, vars="topo", out="data.frame")

region31 <- data.frame("lat"=region31$lat, "lon"=region31$lon, "topo"=round(region31$topo, 1))
region32 <- data.frame("lat"=region32$lat, "lon"=region32$lon, "topo"=round(region32$topo, 1))
region33 <- data.frame("lat"=region33$lat, "lon"=region33$lon, "topo"=round(region33$topo, 1))

region34 <- ReadNetCDF(file34, vars="topo", out="data.frame")
region35 <- ReadNetCDF(file35, vars="topo", out="data.frame")
region36 <- ReadNetCDF(file36, vars="topo", out="data.frame")

region34 <- data.frame("lat"=region34$lat, "lon"=region34$lon, "topo"=round(region34$topo, 1))
region35 <- data.frame("lat"=region35$lat, "lon"=region35$lon, "topo"=round(region35$topo, 1))
region36 <- data.frame("lat"=region36$lat, "lon"=region36$lon, "topo"=round(region36$topo, 1))

# Define regions for actual skill in LY2
region_ly2a_01 <- ReadNetCDF(ly2_01a, vars="topo", out="data.frame")
region_ly2a_02 <- ReadNetCDF(ly2_02a, vars="topo", out="data.frame")
region_ly2a_03 <- ReadNetCDF(ly2_03a, vars="topo", out="data.frame")
region_ly2a_04 <- ReadNetCDF(ly2_04a, vars="topo", out="data.frame")
region_ly2a_05 <- ReadNetCDF(ly2_05a, vars="topo", out="data.frame")
region_ly2a_06 <- ReadNetCDF(ly2_06a, vars="topo", out="data.frame")
region_ly2a_07 <- ReadNetCDF(ly2_07a, vars="topo", out="data.frame")
region_ly2a_08 <- ReadNetCDF(ly2_08a, vars="topo", out="data.frame")
region_ly2a_09 <- ReadNetCDF(ly2_09a, vars="topo", out="data.frame")
region_ly2a_10 <- ReadNetCDF(ly2_10a, vars="topo", out="data.frame")
region_ly2a_11 <- ReadNetCDF(ly2_11a, vars="topo", out="data.frame")
region_ly2a_12 <- ReadNetCDF(ly2_12a, vars="topo", out="data.frame")

region_ly2a_01 <- data.frame("lat"=region_ly2a_01$lat, "lon"=region_ly2a_01$lon, 
                            "topo"=round(region_ly2a_01$topo, 1))
region_ly2a_02 <- data.frame("lat"=region_ly2a_02$lat, "lon"=region_ly2a_02$lon, 
                             "topo"=round(region_ly2a_02$topo, 1))
region_ly2a_03 <- data.frame("lat"=region_ly2a_03$lat, "lon"=region_ly2a_03$lon, 
                             "topo"=round(region_ly2a_03$topo, 1))
region_ly2a_04 <- data.frame("lat"=region_ly2a_04$lat, "lon"=region_ly2a_04$lon, 
                             "topo"=round(region_ly2a_04$topo, 1))
region_ly2a_05 <- data.frame("lat"=region_ly2a_05$lat, "lon"=region_ly2a_05$lon, 
                             "topo"=round(region_ly2a_05$topo, 1))
region_ly2a_06 <- data.frame("lat"=region_ly2a_06$lat, "lon"=region_ly2a_06$lon, 
                             "topo"=round(region_ly2a_06$topo, 1))
region_ly2a_07 <- data.frame("lat"=region_ly2a_07$lat, "lon"=region_ly2a_07$lon, 
                             "topo"=round(region_ly2a_07$topo, 1))
region_ly2a_08 <- data.frame("lat"=region_ly2a_08$lat, "lon"=region_ly2a_08$lon, 
                             "topo"=round(region_ly2a_08$topo, 1))
region_ly2a_09 <- data.frame("lat"=region_ly2a_09$lat, "lon"=region_ly2a_09$lon, 
                             "topo"=round(region_ly2a_09$topo, 1))
region_ly2a_10 <- data.frame("lat"=region_ly2a_10$lat, "lon"=region_ly2a_10$lon, 
                             "topo"=round(region_ly2a_10$topo, 1))
region_ly2a_11 <- data.frame("lat"=region_ly2a_11$lat, "lon"=region_ly2a_11$lon, 
                             "topo"=round(region_ly2a_11$topo, 1))
region_ly2a_12 <- data.frame("lat"=region_ly2a_12$lat, "lon"=region_ly2a_12$lon, 
                             "topo"=round(region_ly2a_12$topo, 1))

# Define regions for actual skill in LY2
region_ly2i_01 <- ReadNetCDF(ly2_01i, vars="topo", out="data.frame")
region_ly2i_02 <- ReadNetCDF(ly2_02i, vars="topo", out="data.frame")
region_ly2i_03 <- ReadNetCDF(ly2_03i, vars="topo", out="data.frame")
region_ly2i_04 <- ReadNetCDF(ly2_04i, vars="topo", out="data.frame")
region_ly2i_05 <- ReadNetCDF(ly2_05i, vars="topo", out="data.frame")
region_ly2i_06 <- ReadNetCDF(ly2_06i, vars="topo", out="data.frame")
region_ly2i_07 <- ReadNetCDF(ly2_07i, vars="topo", out="data.frame")
region_ly2i_08 <- ReadNetCDF(ly2_08i, vars="topo", out="data.frame")
region_ly2i_09 <- ReadNetCDF(ly2_09i, vars="topo", out="data.frame")
region_ly2i_10 <- ReadNetCDF(ly2_10i, vars="topo", out="data.frame")
region_ly2i_11 <- ReadNetCDF(ly2_11i, vars="topo", out="data.frame")
region_ly2i_12 <- ReadNetCDF(ly2_12i, vars="topo", out="data.frame")

region_ly2i_01 <- data.frame("lat"=region_ly2i_01$lat, "lon"=region_ly2i_01$lon, 
                             "topo"=round(region_ly2i_01$topo, 1))
region_ly2i_02 <- data.frame("lat"=region_ly2i_02$lat, "lon"=region_ly2i_02$lon, 
                             "topo"=round(region_ly2i_02$topo, 1))
region_ly2i_03 <- data.frame("lat"=region_ly2i_03$lat, "lon"=region_ly2i_03$lon, 
                             "topo"=round(region_ly2i_03$topo, 1))
region_ly2i_04 <- data.frame("lat"=region_ly2i_04$lat, "lon"=region_ly2i_04$lon, 
                             "topo"=round(region_ly2i_04$topo, 1))
region_ly2i_05 <- data.frame("lat"=region_ly2i_05$lat, "lon"=region_ly2i_05$lon, 
                             "topo"=round(region_ly2i_05$topo, 1))
region_ly2i_06 <- data.frame("lat"=region_ly2i_06$lat, "lon"=region_ly2i_06$lon, 
                             "topo"=round(region_ly2i_06$topo, 1))
region_ly2i_07 <- data.frame("lat"=region_ly2i_07$lat, "lon"=region_ly2i_07$lon, 
                             "topo"=round(region_ly2i_07$topo, 1))
region_ly2i_08 <- data.frame("lat"=region_ly2i_08$lat, "lon"=region_ly2i_08$lon, 
                             "topo"=round(region_ly2i_08$topo, 1))
region_ly2i_09 <- data.frame("lat"=region_ly2i_09$lat, "lon"=region_ly2i_09$lon, 
                             "topo"=round(region_ly2i_09$topo, 1))
region_ly2i_10 <- data.frame("lat"=region_ly2i_10$lat, "lon"=region_ly2i_10$lon, 
                             "topo"=round(region_ly2i_10$topo, 1))
region_ly2i_11 <- data.frame("lat"=region_ly2i_11$lat, "lon"=region_ly2i_11$lon, 
                             "topo"=round(region_ly2i_11$topo, 1))
region_ly2i_12 <- data.frame("lat"=region_ly2i_12$lat, "lon"=region_ly2i_12$lon, 
                             "topo"=round(region_ly2i_12$topo, 1))

################################################################################
# 1. Irish Sea

data01   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region01$topo, region_ly2a_01$topo,
                               region02$topo, 
                               region03$topo, region_ly2i_01$topo),
                       mins=c(min(region01$topo,na.rm=TRUE),
                              min(region_ly2a_01$topo,na.rm=TRUE),
                              min(region02$topo,na.rm=TRUE), 
                              min(region03$topo,na.rm=TRUE),
                              min(region_ly2i_01$topo,na.rm=TRUE)),
                       maxs=c(max(region01$topo,na.rm=TRUE), 
                              max(region_ly2a_01$topo,na.rm=TRUE),
                              max(region02$topo,na.rm=TRUE), 
                              max(region03$topo,na.rm=TRUE),
                              max(region_ly2i_01$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                   value=c(round(mean(region01$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_01$topo,na.rm=TRUE),1),
                           round(mean(region02$topo,na.rm=TRUE),1), 
                           round(mean(region03$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_01$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data01$name <- factor(data01$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r1 <- ggplot(data01,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data01)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data01)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i1 <- r1+labs(title="a      Irish Sea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("a      Irish Sea")

################################################################################
# 2. Mediterranean Sea

data02   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region04$topo, region_ly2a_02$topo,
                               region05$topo, 
                               region06$topo, region_ly2i_02$topo),
                       mins=c(min(region04$topo,na.rm=TRUE),
                              min(region_ly2a_02$topo,na.rm=TRUE),
                              min(region05$topo,na.rm=TRUE), 
                              min(region06$topo,na.rm=TRUE),
                              min(region_ly2i_02$topo,na.rm=TRUE)),
                       maxs=c(max(region04$topo,na.rm=TRUE), 
                              max(region_ly2a_02$topo,na.rm=TRUE),
                              max(region05$topo,na.rm=TRUE), 
                              max(region06$topo,na.rm=TRUE),
                              max(region_ly2i_02$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                   value=c(round(mean(region04$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_02$topo,na.rm=TRUE),1),
                           round(mean(region05$topo,na.rm=TRUE),1), 
                           round(mean(region06$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_02$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data02$name <- factor(data02$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r2 <- ggplot(data02,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data02)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data02)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i2 <- r2+labs(title="b      Mediterranean Sea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("b      Mediterranean Sea")

################################################################################
# 3. Okinawa Island

data03   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region07$topo, region_ly2a_03$topo,
                               region08$topo, 
                               region09$topo, region_ly2i_03$topo),
                       mins=c(min(region07$topo,na.rm=TRUE),
                              min(region_ly2a_03$topo,na.rm=TRUE),
                              min(region08$topo,na.rm=TRUE), 
                              min(region09$topo,na.rm=TRUE),
                              min(region_ly2i_03$topo,na.rm=TRUE)),
                       maxs=c(max(region07$topo,na.rm=TRUE), 
                              max(region_ly2a_03$topo,na.rm=TRUE),
                              max(region08$topo,na.rm=TRUE), 
                              max(region09$topo,na.rm=TRUE),
                              max(region_ly2i_03$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                   value=c(round(mean(region07$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_03$topo,na.rm=TRUE),1),
                           round(mean(region08$topo,na.rm=TRUE),1), 
                           round(mean(region09$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_03$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data03$name <- factor(data03$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r3 <- ggplot(data03,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data03)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data03)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i3 <- r3+labs(title="c      Okinawa Island", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("c      Okinawa Island")

################################################################################
# 4. Hawaii

data04   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region10$topo, region_ly2a_04$topo,
                               region11$topo, 
                               region12$topo, region_ly2i_04$topo),
                       mins=c(min(region10$topo,na.rm=TRUE),
                              min(region_ly2a_04$topo,na.rm=TRUE),
                              min(region11$topo,na.rm=TRUE), 
                              min(region12$topo,na.rm=TRUE),
                              min(region_ly2i_04$topo,na.rm=TRUE)),
                       maxs=c(max(region10$topo,na.rm=TRUE), 
                              max(region_ly2a_04$topo,na.rm=TRUE),
                              max(region11$topo,na.rm=TRUE), 
                              max(region12$topo,na.rm=TRUE),
                              max(region_ly2i_04$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region10$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_04$topo,na.rm=TRUE),1),
                           round(mean(region11$topo,na.rm=TRUE),1), 
                           round(mean(region12$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_04$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data04$name <- factor(data04$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r4 <- ggplot(data04,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data04)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data04)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i4 <- r4+labs(title="d      Hawaii", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("d      Hawaii")

################################################################################
# 5. Cold-Caribbean Sea

data05   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region13$topo, region_ly2a_05$topo,
                               region14$topo, 
                               region15$topo, region_ly2i_05$topo),
                       mins=c(min(region13$topo,na.rm=TRUE),
                              min(region_ly2a_05$topo,na.rm=TRUE),
                              min(region14$topo,na.rm=TRUE), 
                              min(region15$topo,na.rm=TRUE),
                              min(region_ly2i_05$topo,na.rm=TRUE)),
                       maxs=c(max(region13$topo,na.rm=TRUE), 
                              max(region_ly2a_05$topo,na.rm=TRUE),
                              max(region14$topo,na.rm=TRUE), 
                              max(region15$topo,na.rm=TRUE),
                              max(region_ly2i_05$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region13$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_05$topo,na.rm=TRUE),1),
                           round(mean(region14$topo,na.rm=TRUE),1), 
                           round(mean(region15$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_05$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data05$name <- factor(data05$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r5 <- ggplot(data05,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data05)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data05)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i5 <- r5+labs(title="e      Cold-Caribbean Sea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("e      Cold-Caribbean Sea")

################################################################################
# 6. Warm-Caribbean Sea

data06   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region16$topo, region_ly2a_06$topo,
                               region17$topo, 
                               region18$topo, region_ly2i_06$topo),
                       mins=c(min(region16$topo,na.rm=TRUE),
                              min(region_ly2a_06$topo,na.rm=TRUE),
                              min(region17$topo,na.rm=TRUE), 
                              min(region18$topo,na.rm=TRUE),
                              min(region_ly2i_06$topo,na.rm=TRUE)),
                       maxs=c(max(region16$topo,na.rm=TRUE), 
                              max(region_ly2a_06$topo,na.rm=TRUE),
                              max(region17$topo,na.rm=TRUE), 
                              max(region18$topo,na.rm=TRUE),
                              max(region_ly2i_06$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region16$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_06$topo,na.rm=TRUE),1),
                           round(mean(region17$topo,na.rm=TRUE),1), 
                           round(mean(region18$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_06$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data06$name <- factor(data06$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r6 <- ggplot(data06,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data06)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data06)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i6 <- r6+labs(title="f      Warm-Caribbean Sea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("f      Warm-Caribbean Sea")

################################################################################
# 7. Gulf of Guinea

data07   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region19$topo, region_ly2a_07$topo,
                               region20$topo, 
                               region21$topo, region_ly2i_07$topo),
                       mins=c(min(region19$topo,na.rm=TRUE),
                              min(region_ly2a_07$topo,na.rm=TRUE),
                              min(region20$topo,na.rm=TRUE), 
                              min(region21$topo,na.rm=TRUE),
                              min(region_ly2i_07$topo,na.rm=TRUE)),
                       maxs=c(max(region19$topo,na.rm=TRUE), 
                              max(region_ly2a_07$topo,na.rm=TRUE),
                              max(region20$topo,na.rm=TRUE), 
                              max(region21$topo,na.rm=TRUE),
                              max(region_ly2i_07$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region19$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_07$topo,na.rm=TRUE),1),
                           round(mean(region20$topo,na.rm=TRUE),1), 
                           round(mean(region21$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_07$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data07$name <- factor(data07$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r7 <- ggplot(data07,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data07)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data07)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i7 <- r7+labs(title="g      Gulf of Guinea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("g      Gulf of Guinea")

################################################################################
# 8. Indian Ocean

data08   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region22$topo, region_ly2a_08$topo,
                               region23$topo, 
                               region24$topo, region_ly2i_08$topo),
                       mins=c(min(region22$topo,na.rm=TRUE),
                              min(region_ly2a_08$topo,na.rm=TRUE),
                              min(region23$topo,na.rm=TRUE), 
                              min(region24$topo,na.rm=TRUE),
                              min(region_ly2i_08$topo,na.rm=TRUE)),
                       maxs=c(max(region22$topo,na.rm=TRUE), 
                              max(region_ly2a_08$topo,na.rm=TRUE),
                              max(region23$topo,na.rm=TRUE), 
                              max(region24$topo,na.rm=TRUE),
                              max(region_ly2i_08$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region22$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_08$topo,na.rm=TRUE),1),
                           round(mean(region23$topo,na.rm=TRUE),1), 
                           round(mean(region24$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_08$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data08$name <- factor(data08$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r8 <- ggplot(data08,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data08)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data08)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i8 <- r8+labs(title="h      Indian Ocean", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("h      Indian Ocean")

################################################################################
# 9. Coral Triangle Area

data09   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region25$topo, region_ly2a_09$topo,
                               region26$topo, 
                               region27$topo, region_ly2i_09$topo),
                       mins=c(min(region25$topo,na.rm=TRUE),
                              min(region_ly2a_09$topo,na.rm=TRUE),
                              min(region26$topo,na.rm=TRUE), 
                              min(region27$topo,na.rm=TRUE),
                              min(region_ly2i_09$topo,na.rm=TRUE)),
                       maxs=c(max(region25$topo,na.rm=TRUE), 
                              max(region_ly2a_09$topo,na.rm=TRUE),
                              max(region26$topo,na.rm=TRUE), 
                              max(region27$topo,na.rm=TRUE),
                              max(region_ly2i_09$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region25$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_09$topo,na.rm=TRUE),1),
                           round(mean(region26$topo,na.rm=TRUE),1), 
                           round(mean(region27$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_09$topo,na.rm=TRUE),1))) 

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data09$name <- factor(data09$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r9 <- ggplot(data09,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data09)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data09)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i9 <- r9+labs(title="i      Coral Triangle Area", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("i      Coral Triangle Area")

################################################################################
# 10. Galápagos Islands

data10   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region28$topo, region_ly2a_10$topo,
                               region29$topo, 
                               region30$topo, region_ly2i_10$topo),
                       mins=c(min(region28$topo,na.rm=TRUE),
                              min(region_ly2a_10$topo,na.rm=TRUE),
                              min(region29$topo,na.rm=TRUE), 
                              min(region30$topo,na.rm=TRUE),
                              min(region_ly2i_10$topo,na.rm=TRUE)),
                       maxs=c(max(region28$topo,na.rm=TRUE), 
                              max(region_ly2a_10$topo,na.rm=TRUE),
                              max(region29$topo,na.rm=TRUE), 
                              max(region30$topo,na.rm=TRUE),
                              max(region_ly2i_10$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region28$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_10$topo,na.rm=TRUE),1),
                           round(mean(region29$topo,na.rm=TRUE),1), 
                           round(mean(region30$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_10$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data10$name <- factor(data10$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r10 <- ggplot(data10,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data10)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data10)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i10 <- r10+labs(title="j      Galápagos Islands", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("j      Galápagos Islands")

################################################################################
# 11. Western Australia

data11   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region31$topo, region_ly2a_11$topo,
                               region32$topo, 
                               region33$topo, region_ly2i_11$topo),
                       mins=c(min(region31$topo,na.rm=TRUE),
                              min(region_ly2a_11$topo,na.rm=TRUE),
                              min(region32$topo,na.rm=TRUE), 
                              min(region33$topo,na.rm=TRUE),
                              min(region_ly2i_11$topo,na.rm=TRUE)),
                       maxs=c(max(region31$topo,na.rm=TRUE), 
                              max(region_ly2a_11$topo,na.rm=TRUE),
                              max(region32$topo,na.rm=TRUE), 
                              max(region33$topo,na.rm=TRUE),
                              max(region_ly2i_11$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region31$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_11$topo,na.rm=TRUE),1),
                           round(mean(region32$topo,na.rm=TRUE),1), 
                           round(mean(region33$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_11$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data11$name <- factor(data11$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r11 <- ggplot(data11,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data11)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data11)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))


# Finished line plot
i11 <- r11+labs(title="k      Western Australia", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("k      Western Australia")

################################################################################
# 12. Tasman Sea

data12   <- data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2"),
                       value=c(region34$topo, region_ly2a_12$topo,
                               region35$topo, 
                               region36$topo, region_ly2i_12$topo),
                       mins=c(min(region34$topo,na.rm=TRUE),
                              min(region_ly2a_12$topo,na.rm=TRUE),
                              min(region35$topo,na.rm=TRUE), 
                              min(region36$topo,na.rm=TRUE),
                              min(region_ly2i_12$topo,na.rm=TRUE)),
                       maxs=c(max(region34$topo,na.rm=TRUE), 
                              max(region_ly2a_12$topo,na.rm=TRUE),
                              max(region35$topo,na.rm=TRUE), 
                              max(region36$topo,na.rm=TRUE),
                              max(region_ly2i_12$topo,na.rm=TRUE)))

means = data.frame(name=c("TOT\nLY1","TOT\nLY2","EXT","INT\nLY1","INT\nLY2") , 
                   value=c(round(mean(region34$topo,na.rm=TRUE),1), 
                           round(mean(region_ly2a_12$topo,na.rm=TRUE),1),
                           round(mean(region35$topo,na.rm=TRUE),1), 
                           round(mean(region36$topo,na.rm=TRUE),1),
                           round(mean(region_ly2i_12$topo,na.rm=TRUE),1)))  

desired_order <- c("TOT\nLY1", "TOT\nLY2", "EXT", "INT\nLY1", "INT\nLY2")

data12$name <- factor(data12$name, levels = desired_order)
means$name  <- factor(means$name,  levels = desired_order)

color <- c("black","black","deeppink","purple","purple")


r12 <- ggplot(data12,aes(y=value, x=name)) + 
  
  scale_color_manual(values = rep(color,nrow(data12)/5)) +
  
  geom_point(data = means, color=c("black","black","deeppink","purple","purple"), 
             pch=19, size = 13, alpha=1) +
  
  scale_y_continuous(limits = c(-1, 1), breaks = seq(-1, 1, by = 0.2)) +
  
  geom_errorbar(aes(ymin=mins, ymax=maxs), 
                color=rep(color,nrow(data12)/5),
                width=0.25, size = 3,
                position = position_dodge(0.3))

# Finished line plot
i12 <- r12+labs(title="l      Tasman Sea", x="", y = "COR")+
  theme_light() +
  theme(
    plot.title = element_text(size = 55, face = "bold"),
    
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.title.x = element_text(size = 50),
    axis.title.y = element_text(size = 50),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(color = 'black', size = 50),
    axis.text.y  = element_text(color = 'black', size = 50)) +
  
  xlab("") +
  ylab("COR") +
  ggtitle("l      Tasman Sea")

################################################################################
library(gridExtra)
grid.arrange(i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, ncol = 3)
#grid.arrange(i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, ncol = 4)