import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from matplotlib.colors import BoundaryNorm
from cartopy.util import add_cyclic_point

psl_file = "/path/to/psl.nc"
sst_file = "/path/to/sst.nc"

psl_var = "PSL"
sst_var = "SST"

start = "1980-01"
end   = "2020-12"

lags = [6, 3, 1, 0]

save_path = "/path/to/output/composite_maps.png"

suptitle_size = 18
panel_title_size = 18
colorbar_label_size = 18
colorbar_tick_size = 18

levels = np.arange(-1.5, 2, 0.5)
cmap = plt.get_cmap("RdBu_r")
norm = BoundaryNorm(levels, cmap.N)

psl = xr.open_dataset(psl_file)[psl_var].sel(time=slice(start, end))
sst = xr.open_dataset(sst_file)[sst_var].sel(time=slice(start, end))

psl, sst = xr.align(psl, sst)

if psl.lon.max() > 180:
    psl = psl.assign_coords(lon=((psl.lon + 180) % 360) - 180).sortby("lon")
    sst = sst.assign_coords(lon=((sst.lon + 180) % 360) - 180).sortby("lon")

psl = psl.where(psl["time.seaDJF"] == "DJF", drop=True)
sst = sst.where(sst["time.seaDJF"] == "DJF", drop=True)

psl_anom = psl.groupby("time.month") - psl.groupby("time.month").mean("time")
sst_anom = sst.groupby("time.month") - sst.groupby("time.month").mean("time")

psl_anom = psl_anom / 100

threshold = sst_anom.quantile(0.9, dim="time")
mhw = sst_anom > threshold
onset = mhw & (~mhw.shift(time=1, fill_value=False))

weights = np.cos(np.deg2rad(psl.lat))
weights.name = "weights"

psl_composites = []

for lag in lags:
    comp = (
        psl_anom
        .shift(time=lag)
        .where(onset)
        .weighted(weights)
        .mean("time")
    )
    psl_composites.append(comp)

proj = ccrs.RobinDJF(central_longitude=180)

fig, axes = plt.subplots(
    2, 2,
    figsize=(10, 7.5),
    subplot_kw={"projection": proj})

for ax, comp, lag in zip(axes.flatten(), psl_composites, lags):

    comp_cyc, lon_cyc = add_cyclic_point(comp, coord=comp.lon)

    im = ax.contourf(
        lon_cyc,
        comp.lat,
        comp_cyc,
        levels=levels,
        cmap=cmap,
        norm=norm,
        transform=ccrs.PlateCarree(),
        extend="both")

    ax.add_feature(cfeature.LAND, facecolor="lightgray", zorder=1)
    ax.coastlines()
    ax.set_global()

    ax.set_title(f"{lag} months before MHW onset", fontsize=panel_title_size)

fig.subplots_adjust(
    left=0.04,
    right=0.98,
    bottom=0.10,
    top=0.88,
    wspace=0.1,
    hspace=0.14)

cbar = fig.colorbar(
    im,
    ax=axes.ravel().tolist(),
    orientation="horizontal",
    ticks=levels,
    fraction=0.04,
    shrink=0.6,
    pad=0.04)

cbar.set_label("PSL anomaly (hPa)", fontsize=colorbar_label_size)
cbar.ax.tick_params(labelsize=colorbar_tick_size)

fig.suptitle(
    "PSL composites preceding MHW onset \n (ASSM, DJF 1980-2020)",
    fontsize=suptitle_size)

plt.savefig(save_path, dpi=300)
plt.show()