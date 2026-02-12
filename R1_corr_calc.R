rm(list=ls())
library(ncdf4)
library(colormap)
library(oce)
library(rcartocolor)
library(rcolors)
library(cmocean)
library(caret)

# This codes computes correlation, p-values, Rsquared, MAE, and RMSE from two data sets.
################################################################################
# Set output directory
ImageDirectory = "/Users/path/to/output/"

file_path1  = "/Users/path/to/obs/"
file_path2  = "/Users/path/to/model/"

file1_nc <- nc_open(paste(file_path1, 'file1.nc', sep=""))
file2_nc <- nc_open(paste(file_path2, 'file2.nc', sep=""))

var_1      <- ncvar_get(file1_nc, varid = "sst")    
var_2      <- ncvar_get(file2_nc, varid = "TS")     

# Define lon and lat from one of the netcdf files
lats        <- ncvar_get(file2_nc, "lat")
lons        <- ncvar_get(file2_nc, "lon")

# Define dimensions
nlats       <- dim(lats)
nlons       <- dim(lons) 

# Create arrays for the output data
# Correlation 
correlation <- array(NA,c(nlons,nlats))
# Rsquared
rsq         <- array(NA,c(nlons,nlats))
# pvalue
pvalue      <- array(NA,c(nlons,nlats))
# Mean Absolute Error (MAE)
mae         <- array(NA,c(nlons,nlats))
# Root Mean Squared Error (RMSE)
rmse        <- array(NA,c(nlons,nlats))

# Loop over all coordinates
for (jlon in 1:nlons){
  for (jlat in 1:nlats){
    ts_var_1               <- ts(var_1[jlon,jlat,], start=c(1), end=c(40), frequency=1)
    ts_var_2               <- ts(var_2[jlon,jlat,], start=c(1), end=c(40), frequency=1)
    correlation_test       <- cor.test(ts_var_1, ts_var_2, method = "pearson")
    correlation[jlon,jlat] <- correlation_test$estimate
    pvalue[jlon,jlat]      <- correlation_test$p.value
    rsq[jlon,jlat]         <- (correlation[jlon,jlat])^2
    mae[jlon,jlat]         <- mean(abs(ts_var_1 - ts_var_2), na.rm = TRUE)
    rmse[jlon,jlat]        <- sqrt(mean((ts_var_1 - ts_var_2)^2, na.rm = TRUE))
    print(jlon)
  }
}

# Define netcdf output variables
time     <- ncvar_get(file1_nc, "time")
tunits   <- ncatt_get(file1_nc,"time","units")
calendar <- ncatt_get(file1_nc,"time","calendar")$value

xvals    <- lons
yvals    <- lats

nx       <- length(xvals)
ny       <- length(yvals)
xdim     <- ncdim_def( 'lon', 'degrees_east', xvals)
ydim     <- ncdim_def( 'lat', 'degrees_north', yvals)

mv           <- NA     
var_corr     <- ncvar_def("corr", 'corr',     list(xdim,ydim), mv)
var_rsq      <- ncvar_def("rsq", 'rsq',       list(xdim,ydim), mv)
var_pvalue   <- ncvar_def("pvalue", 'pvalue', list(xdim,ydim), mv)
var_mae      <- ncvar_def("mae", 'mae',       list(xdim,ydim), mv)
var_rmse     <- ncvar_def("rmse", 'rmse',     list(xdim,ydim), mv)

# Save to netcdf 
ncout1 <- nc_create(paste(ImageDirectory,"correlation.nc", sep = ""), list(var_corr),   force_v4=TRUE)
ncout2 <- nc_create(paste(ImageDirectory,"rsquare.nc",     sep = ""), list(var_rsq),    force_v4=TRUE)
ncout3 <- nc_create(paste(ImageDirectory,"pvalue.nc",      sep = ""), list(var_pvalue), force_v4=TRUE)
ncout4 <- nc_create(paste(ImageDirectory,"mae.nc",         sep = ""), list(var_mae),    force_v4=TRUE)
ncout5 <- nc_create(paste(ImageDirectory,"rmse.nc",        sep = ""), list(var_rmse),   force_v4=TRUE)

# Put variables
ncvar_put(ncout1, var_corr, correlation, start=c(1,1), count=c(nx,ny), verbose=TRUE)
ncvar_put(ncout2, var_rsq, rsq,          start=c(1,1), count=c(nx,ny), verbose=TRUE)
ncvar_put(ncout3, var_pvalue, pvalue,    start=c(1,1), count=c(nx,ny), verbose=TRUE)
ncvar_put(ncout4, var_mae, mae,          start=c(1,1), count=c(nx,ny), verbose=TRUE)
ncvar_put(ncout5, var_rmse, rmse,        start=c(1,1), count=c(nx,ny), verbose=TRUE)

# Put additional attributes into dimension and data variables
ncatt_put(ncout1,"lon","axis","X") 
ncatt_put(ncout1,"lat","axis","Y")

ncatt_put(ncout2,"lon","axis","X") 
ncatt_put(ncout2,"lat","axis","Y")

ncatt_put(ncout3,"lon","axis","X") 
ncatt_put(ncout3,"lat","axis","Y")

ncatt_put(ncout4,"lon","axis","X") 
ncatt_put(ncout4,"lat","axis","Y")

ncatt_put(ncout5,"lon","axis","X") 
ncatt_put(ncout5,"lat","axis","Y")

# Get global attributes
title        <- ncatt_get(file1_nc,0,"CESM2-MP")
institution  <- ncatt_get(file1_nc,0,"institution")
datasource   <- ncatt_get(file1_nc,0,"source")
references   <- ncatt_get(file1_nc,0,"references")
history      <- ncatt_get(file1_nc,0,"history")
conventions  <- ncatt_get(file1_nc,0,"conventions")

# Add global attributes
ncatt_put(ncout1,0,"title","correlation")
ncatt_put(ncout1,0,"institution","RCCS & PNU, Busan")
ncatt_put(ncout1,0,"source",datasource$value)
ncatt_put(ncout1,0,"references","CESM2-MP")
history <- paste("Karwat, Alexia", date(), sep=", ")
ncatt_put(ncout1,0,"history",history)
ncatt_put(ncout1,0,"conventions",conventions$value)
nc_close(ncout1)

ncatt_put(ncout2,0,"title","Rsquare")
ncatt_put(ncout2,0,"institution","RCCS & PNU, Busan")
ncatt_put(ncout2,0,"source",datasource$value)
ncatt_put(ncout2,0,"references","CESM2-MP")
history <- paste("Karwat, Alexia", date(), sep=", ")
ncatt_put(ncout2,0,"history",history)
ncatt_put(ncout2,0,"conventions",conventions$value)
nc_close(ncout2)

ncatt_put(ncout3,0,"title","pvalue")
ncatt_put(ncout3,0,"institution","RCCS & PNU, Busan")
ncatt_put(ncout3,0,"source",datasource$value)
ncatt_put(ncout3,0,"references","CESM2-MP")
history <- paste("Karwat, Alexia", date(), sep=", ")
ncatt_put(ncout3,0,"history",history)
ncatt_put(ncout3,0,"conventions",conventions$value)
nc_close(ncout3)