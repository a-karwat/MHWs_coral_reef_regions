import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from matplotlib.colors import BoundaryNorm
from cartopy.util import add_cyclic_point

psl_file = "/path/to/file/PSL.nc"
sst_file = "/path/to/file/SST.nc"

psl_var = "PSL"
sst_var = "SST"

start = "1980-01"
end   = "2020-12"

save_path = "/path/to/output/ElNino_PSL_composite.png"

levels = np.arange(-3, 3.5, 0.5)  # hPa
cmap = plt.get_cmap("RdBu_r")
norm = BoundaryNorm(levels, cmap.N)

suptitle_size = 17
panel_title_size = 16
colorbar_label_size = 15
colorbar_tick_size = 15

psl = xr.open_dataset(psl_file)[psl_var].sel(time=slice(start, end))
sst = xr.open_dataset(sst_file)[sst_var].sel(time=slice(start, end))

psl, sst = xr.align(psl, sst)

def fix_lon(da):
    if da.lon.max() > 180:
        da = da.assign_coords(lon=((da.lon + 180) % 360) - 180).sortby("lon")
    return da

psl = fix_lon(psl)
sst = fix_lon(sst)

psl_anom = psl.groupby("time.month") - psl.groupby("time.month").mean("time")
sst_anom = sst.groupby("time.month") - sst.groupby("time.month").mean("time")
psl_anom = psl_anom / 100  

def get_djf_year(time_array):
    return np.array([t.year + 1 if t.month == 12 else t.year for t in time_array])

psl_anom = psl_anom.assign_coords(DJF_year=("time", get_djf_year(psl_anom['time'].values)))
sst_anom = sst_anom.assign_coords(DJF_year=("time", get_djf_year(sst_anom['time'].values)))

if sst.lon.min() < 0:
    nino34 = sst_anom.sel(lat=slice(-5,5), lon=slice(-170,-120))
else:
    nino34 = sst_anom.sel(lat=slice(-5,5), lon=slice(190,240))

nino34_index = nino34.mean(dim=['lat','lon'])
nino34_index_rm = nino34_index.rolling(time=3, center=True).mean()
nino34_djf = nino34_index_rm.groupby("DJF_year").mean("time")
elnino_years = nino34_djf.where(nino34_djf > 0.5, drop=True)["DJF_year"].values
print("El Niño DJF years:", elnino_years)
if len(elnino_years) == 0:
    raise ValueError("No El Niño years found!")

psl_elnino = psl_anom.sel(time=psl_anom['DJF_year'].isin(elnino_years))
psl_elnino_djf = psl_elnino.groupby("DJF_year").mean("time")
psl_elnino_composite = psl_elnino_djf.mean("DJF_year")

proj = ccrs.Robinson(central_longitude=180)
fig = plt.figure(figsize=(12,5))
ax = fig.add_subplot(1,1,1, projection=proj)

psl_cyc, lon_cyc = add_cyclic_point(psl_elnino_composite, coord=psl_elnino_composite.lon)
im = ax.contourf(lon_cyc, psl_elnino_composite.lat, psl_cyc,
                 levels=levels, cmap=cmap, norm=norm,
                 transform=ccrs.PlateCarree(), extend="both")

ax.add_feature(cfeature.LAND, facecolor="lightgray", zorder=1)
ax.coastlines()
ax.set_global()

gl = ax.gridlines(draw_labels=True, linewidth=0.0005, color='gray', alpha=0.7,
                  linestyle='-', crs=ccrs.PlateCarree(), x_inline=False, y_inline=False)
gl.top_labels = False
gl.right_labels = False
gl.xlabel_style = {'size': 12}
gl.ylabel_style = {'size': 12}

for label in ax.yaxis.get_ticklabels():
    label.set_horizontalalignment('right') 
    label.set_x(-0.03) 

for label in ax.xaxis.get_ticklabels():
    label.set_verticalalignment('top') 
    label.set_y(-0.03) 

fig.suptitle("SLP anomaly composite (El Niño years, ASSM, DJF 1980-2020)",
             fontsize=suptitle_size, y=0.95)

cbar = fig.colorbar(im, orientation="horizontal", fraction=0.06, pad=0.09, ticks=levels)
cbar.set_label("SLP anomaly (hPa)", fontsize=colorbar_label_size)
cbar.ax.tick_params(labelsize=colorbar_tick_size)
desired_labels = np.arange(-3,4,1)
tick_labels = [str(l) if l in desired_labels else "" for l in levels]
cbar.set_ticklabels(tick_labels)

years_str = ", ".join(str(y) for y in elnino_years)
ax.text(0.5, -0.39, f"El Niño DJF years: {years_str}",
        ha='center', va='top', fontsize=15, transform=ax.transAxes)

plt.savefig(save_path, dpi=300, bbox_inches='tight')
plt.show()