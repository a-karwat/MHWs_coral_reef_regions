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

# This code plots time series of MHW statistics for coral reef regions.
################################################################################
dir_path1 = "/Users/path/to/data/obs/"
dir_path2 = "/Users/path/to/data/unin/"
dir_path3 = "/Users/path/to/data/hindly1/"
dir_path4 = "/Users/path/to/data/hindly2/"
dir_path5 = "/Users/path/to/data/hindly3/"
dir_path6 = "/Users/path/to/data/hindly4/"
dir_path7 = "/Users/path/to/data/hindly5/"

nc1 = "file1.nc"
nc2 = "file2.nc"
nc3 = "file3.nc"
nc4 = "file4.nc"
nc5 = "file5.nc"
nc6 = "file6.nc"
nc7 = "file7.nc"

file1 <- nc_open(paste(dir_path1,nc1,sep=""))
file2 <- nc_open(paste(dir_path2,nc2,sep=""))
file3 <- nc_open(paste(dir_path3,nc3,sep=""))
file4 <- nc_open(paste(dir_path4,nc4,sep=""))
file5 <- nc_open(paste(dir_path5,nc5,sep=""))
file6 <- nc_open(paste(dir_path6,nc6,sep=""))
file7 <- nc_open(paste(dir_path7,nc7,sep=""))

pdf(file = "/path/to/output/timeseries_Galapagos.pdf", width = 10, height = 5) 

# Define the regions by grid points and read netcdf data
region1 <- ReadNetCDF(file1, vars="SST", out="data.frame",
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region2 <- ReadNetCDF(file2, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region3 <- ReadNetCDF(file3, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region4 <- ReadNetCDF(file4, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region5 <- ReadNetCDF(file5, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region6 <- ReadNetCDF(file6, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region7 <- ReadNetCDF(file7, vars="SST", out="data.frame", 
                      subset = list(lon = -88:-92, lat = 0:-2,
                                    time = c("1981-12-01 00:00:00",
                                             "2020-02-29 00:00:00")))

region1_new <- na.omit(region1)
region2_new <- na.omit(region2)
region3_new <- na.omit(region3)
region4_new <- na.omit(region4)
region5_new <- na.omit(region5)
region6_new <- na.omit(region6)
region7_new <- na.omit(region7)

years            <- as.character(c(1981:2020))

df_noaa_year     <- list()
df_cesm2_year    <- list()
df_hind_ly1_year <- list()
df_hind_ly2_year <- list()
df_hind_ly3_year <- list()
df_hind_ly4_year <- list()
df_hind_ly5_year <- list()

i <- 1

repeat{
  df_noaa_year[[i]]    <-  region1_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_cesm2_year[[i]]    <- region2_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_hind_ly1_year[[i]] <- region3_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_hind_ly2_year[[i]] <- region4_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_hind_ly3_year[[i]] <- region5_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_hind_ly4_year[[i]] <- region6_new %>%
    filter(str_detect(time, years[[i]]))
  
  df_hind_ly5_year[[i]] <- region7_new %>%
    filter(str_detect(time, years[[i]]))
  
  i <- i + 1
  
  if(i>40) {
    break
  }
}


# Compute the yearly means
noaa_yearly_mean     <- list()
cesm2_yearly_mean    <- list()
hind_ly1_yearly_mean <- list()
hind_ly2_yearly_mean <- list()
hind_ly3_yearly_mean <- list()
hind_ly4_yearly_mean <- list()
hind_ly5_yearly_mean <- list()

j <- 1

repeat{
  noaa_yearly_mean[[j]]     <- mean(df_noaa_year[[j]]$SST)
  cesm2_yearly_mean[[j]]    <- mean(df_cesm2_year[[j]]$TS)
  hind_ly1_yearly_mean[[j]] <- mean(df_hind_ly1_year[[j]]$TS)
  hind_ly2_yearly_mean[[j]] <- mean(df_hind_ly2_year[[j]]$TS)
  hind_ly3_yearly_mean[[j]] <- mean(df_hind_ly3_year[[j]]$TS)
  hind_ly4_yearly_mean[[j]] <- mean(df_hind_ly4_year[[j]]$TS)
  hind_ly5_yearly_mean[[j]] <- mean(df_hind_ly5_year[[j]]$TS)
  
  j <- j + 1
  
  if(j>40) {
    break
  }
}

# Climatology
clim1991_2020_noaa     <- mean(unlist(noaa_yearly_mean)[1:40])
clim1991_2020_cesm2    <- mean(unlist(cesm2_yearly_mean)[1:40])
clim1991_2020_hind_ly1 <- mean(unlist(hind_ly1_yearly_mean)[1:40])
clim1991_2020_hind_ly2 <- mean(unlist(hind_ly2_yearly_mean)[1:40])
clim1991_2020_hind_ly3 <- mean(unlist(hind_ly3_yearly_mean)[1:40])
clim1991_2020_hind_ly4 <- mean(unlist(hind_ly4_yearly_mean)[1:40])
clim1991_2020_hind_ly5 <- mean(unlist(hind_ly5_yearly_mean)[1:40])

# Unlist the data
region1_ymeans <- unlist(noaa_yearly_mean)-clim1991_2020_noaa   
region2_ymeans <- unlist(cesm2_yearly_mean)-clim1991_2020_cesm2 
region3_ymeans <- unlist(hind_ly1_yearly_mean)-unlist(cesm2_yearly_mean)
region4_ymeans <- unlist(hind_ly2_yearly_mean)-unlist(cesm2_yearly_mean)
region5_ymeans <- unlist(hind_ly3_yearly_mean)-unlist(cesm2_yearly_mean)
region6_ymeans <- unlist(hind_ly4_yearly_mean)-unlist(cesm2_yearly_mean)
region7_ymeans <- unlist(hind_ly5_yearly_mean)-unlist(cesm2_yearly_mean)
# seasonal means of HIND - seasonal means of CESM2-LE

# Prepare the x-axis
x <- c(1982, NA, NA, 1985, NA, NA, NA, NA, 1990, NA, NA, NA, NA,
       1995, NA, NA, NA, NA, 2000, NA, NA, NA, NA, 2005, NA, NA, NA, NA, 
       2010, NA, NA, NA, NA, 2015, NA, NA, NA, NA, 2020)

y1 <- round(region1_ymeans)
y2 <- round(region2_ymeans)
y3 <- round(region3_ymeans)
y4 <- round(region4_ymeans)
y5 <- round(region5_ymeans)
y6 <- round(region6_ymeans)
y7 <- round(region7_ymeans)

# Start plotting
par(mar = c(5,6.2,3,2))

matplot(cbind(y1,y2,y3,y4), type="l", xaxt="n", yaxt="n", cex.lab=1.6,
        ylim=c(-60,60), 
        main="Galápagos Islands",
        cex.main=2.2,
        xlab="", ylab="anomaly of MHW frequency/year")

abline(h=0, col="black", lwd=3.5, lty=1)

matplot(cbind(y1,y2,y3,y4), 
        type="l", xaxt="n", yaxt="n", cex.lab=1.6,
        main="Warm-water Coral Reefs around Galápagos Islands (88°-92°W and 0°-2°S)",
        xlab="boreal winter (DJF)", ylab="anomaly of MHW frequency/year", 
        ylim=c(-60,60),
        las=1, lty=c(1,1,1,1,1,1,1), lwd=c(5,5,5,5,5,5), 
        col=c("blue", "red", "hotpink", "orange"), add = TRUE)

axis(1, at=c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,40), cex.axis=1.6,
     labels=c("1982", "1984", "1986", "1988", "1990", "1992", "1994", 
              "1996", "1998", "2000", "2002", "2004", "2006", "2008", 
              "2010", "2012", "2014", "2016", "2018", "2020"))
axis(2, at=seq(-60, 60, by=20), labels=seq(-60, 60, by=20), las=1, cex.axis=1.6)
dev.off()