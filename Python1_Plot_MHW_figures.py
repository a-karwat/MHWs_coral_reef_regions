#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cf
import cartopy.util as cutil

project = '/path/to/file/'
data_path = project + 'correlation.nc'

ds = xr.open_dataset(data_path, decode_times=False)
ds

data = ds['corr']

cyclic_data, cyclic_lons = cutil.add_cyclic_point(data, coord=ds['lon'])

fig = plt.figure(figsize=(26,20))

def fix_extent(ax, extent):
    mlon = np.mean(extent[:2])
    mlat = np.mean(extent[2:])
    xtrm_data    = np.array([[extent[0], mlat], [mlon, extent[2]], [extent[1], mlat], [mlon, extent[3]]])
    proj_to_data = ccrs.PlateCarree()._as_mpl_transform(ax) - ax.transData
    xtrm         = proj_to_data.transform(xtrm_data)
    ax.set_xlim(xtrm[:,0].min(), xtrm[:,0].max())
    ax.set_ylim(xtrm[:,1].min(), xtrm[:,1].max())

extent=(0, 0.01, -65, 65)
ax = plt.axes(projection=ccrs.Robinson(central_longitude=-180))
fix_extent(ax, extent)

ax.coastlines(zorder=1)
ax.add_feature(cf.LAND, zorder=1, facecolor='white', edgecolor='k')
ax.add_feature(cf.OCEAN,facecolor=(0.5,0.5,0.5)) 

states_provinces = cf.NaturalEarthFeature(category='cultural',
                                        name='admin_1_states_provinces_lines',
                                        scale='50m',
                                        facecolor='none')

ax.add_feature(cf.BORDERS, linewidth=0.8, edgecolor='gray', zorder=2)

gl = ax.gridlines(draw_labels=True,
                         linewidth=0, 
                         color='gray',
                         xlocs=range(-180,181,40),
                         ylocs=range(-60,61,20),
                         zorder=4)

gl.top_labels = False

XTEXT_SIZE = 26  
gl.xlabel_style = {'size': XTEXT_SIZE}
gl.xpadding = 12  
YTEXT_SIZE = 26  
gl.ylabel_style = {'size': YTEXT_SIZE}
gl.ypadding = 24  

ax.set_title('COR (DJF, Skill from Forcing)', 
             fontsize=26, fontweight='bold', pad=10)

Tmax = 1; Tmin = -1; delT = 0.1
levels = np.arange(Tmin,Tmax+delT,delT)

cnplot = ax.contourf(cyclic_lons, ds.lat, cyclic_data,  
                                cmap='RdBu_r', 
                                vmin=Tmin, vmax=Tmax,
                                levels=levels, 
                                extend='neither',
                                zorder=0,
                                transform=ccrs.PlateCarree())

project2 = '/path/to/file/'
data_path2 = project2 + 'pvalue.nc'

ds2 = xr.open_dataset(data_path2, decode_times=True)
ds2

data2 = ds2['pvalue']
    
ax.contourf(ds['lon'], ds['lat'], xr.where((data2 >= 0.05), 1.0, np.nan).data, 
             transform=ccrs.PlateCarree(), colors='none', levels=[1.0, 1.5],       
             hatches=['/'], zorder=0)

levels2 = np.arange(-1,1.1,0.2)

cbar = plt.colorbar(cnplot, spacing='uniform', 
                    orientation='horizontal', 
                             ticks=levels2, 
                               pad=0.05, 
                               shrink=0.98, aspect=42)
cbar.ax.tick_params(labelsize=26) 
cbar.set_label("Pearson's r", x=0.96, labelpad=-100, size=26)  

plt.savefig('/path/to/output/figure.png',
                        bbox_inches='tight',
                        dpi=150)