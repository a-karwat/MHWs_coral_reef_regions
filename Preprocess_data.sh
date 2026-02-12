#!/bin/bash

# Compute yearly running mean of 90th percentile with duration of 5 days
cdo -L -ydrunpctl,90,5 infile.nc \
    -ydrunmin,5 infile.nc \
    -ydrunmax,5 infile.nc \
    p90_5d.nc

# Compute daily events above the 90th percentile
cdo -L -gtc,0 -sub infile.nc p90_5d.nc \
    above_p90_daily.nc

# Aggregate by year
cdo -L -seassum -selseas,DJF \
    above_p90_daily.nc \
    yearly_sum_DJF.nc

# Compute mean number of days per season
cdo -timmean yearly_sum_DJF.nc mean_DJF.nc

# Compute std. deviation from the yearly events
cdo -timstd yearly_sum_DJF.nc std_DJF.nc

# Compute anomalies
cdo -L -ensmean input_*.nc ensmean.nc
cdo -L -timmean ensmean.nc clim_mean.nc
cdo -L -sub ensmean.nc clim_mean.nc anomaly.nc
