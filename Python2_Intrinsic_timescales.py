import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cf
import cartopy.util as cutil
import matplotlib.colors as mcolors

datasets = {"OBS": {"file": "/path/to/file1.nc", "var": "sst"},
           "UNIN": {"file": "/path/to/file2.nc", "var": "sst"},
           "ASSM": {"file": "/path/to/file3.nc", "var": "sst"}}

time_name = "time"
dt = 1.0  # months

FIGSIZE = (18, 12)
DPI = 150

CMAP_AR1 = "seismic"
VMIN_AR1, VMAX_AR1 = 0, 1.0

CMAP_TAU = "turbo"
VMIN_TAU, VMAX_TAU = 0, 12
LEVELS_TAU = np.arange(VMIN_TAU, VMAX_TAU + 1, 1)

TITLE_SIZE = 22
PANEL_TITLE_SIZE = 20
CBAR_LABEL_SIZE = 18
CBAR_TICK_SIZE = 16

def remove_monthly_climatology(da):
    clim = da.groupby(f"{time_name}.month").mean(time_name)
    return da.groupby(f"{time_name}.month") - clim

def detrend_da(da):
    p = da.polyfit(dim=time_name, deg=1)
    trend = xr.polyval(da[time_name], p.polyfit_coefficients)
    return da - trend

def lag1_autocorr(x):
    x = x[np.isfinite(x)]
    if x.size < 3 or np.nanstd(x) == 0:
        return np.nan
    return np.corrcoef(x[:-1], x[1:])[0, 1]

def compute_tau(r1):
    return -dt / np.log(r1)

ar1_maps = {}
tau_maps = {}

for name, info in datasets.items():
    ds = xr.open_dataset(info["file"])
    da = ds[info["var"]]
    
    # monthly resample
    da_mon = da.resample({time_name: "1MS"}).mean()
    da_anom = remove_monthly_climatology(da_mon)
    da_anom = detrend_da(da_anom)
    
    # lag-1 autocorrelation
    r1 = xr.apply_ufunc(lag1_autocorr, da_anom, input_core_dims=[[time_name]],
                        vectorize=True, output_dtypes=[float])
    
    ocean_mask = np.isfinite(da_mon.mean(time_name))
    r1 = r1.where(ocean_mask)
    ar1_maps[name] = r1
    
    tau = compute_tau(r1)
    tau = tau.where((r1 > 0) & (r1 < 1))
    tau_maps[name] = tau

proj = ccrs.Robinson(central_longitude=180)
fig = plt.figure(figsize=FIGSIZE, dpi=DPI)

gs = fig.add_gridspec(nrows=2, ncols=3, hspace=0.05, wspace=0.05)

axes_ar1 = {name: fig.add_subplot(gs[0, i], projection=proj) for i, name in enumerate(datasets)}
axes_tau = {name: fig.add_subplot(gs[1, i], projection=proj) for i, name in enumerate(datasets)}

cax_ar1 = fig.add_axes([0.1, 0.53, 0.8, 0.03])  
cax_tau = fig.add_axes([0.1, 0.15, 0.8, 0.03])  

# Define color boundaries 
ar1_bounds = np.arange(0, 1.01, 0.1)  
ar1_cmap = plt.get_cmap(CMAP_AR1)
ar1_norm = mcolors.BoundaryNorm(ar1_bounds, ncolors=ar1_cmap.N, clip=True)

# Plot AR(1) maps
for name, ax in axes_ar1.items():
    r1 = ar1_maps[name]
    data_cyc, lon_cyc = cutil.add_cyclic_point(r1.values, coord=r1.lon.values)
    
    im = ax.contourf(lon_cyc, r1.lat, data_cyc,
                     levels=ar1_bounds,
                     cmap=ar1_cmap, norm=ar1_norm,
                     extend="neither", transform=ccrs.PlateCarree())
    
    ax.coastlines(linewidth=0.8)
    ax.add_feature(cf.LAND, facecolor="white", zorder=3)
    ax.set_title(f"{name} AR(1)", fontsize=PANEL_TITLE_SIZE)

# AR(1) colorbar with aligned ticks
cbar_ar1 = fig.colorbar(im, cax=cax_ar1, orientation="horizontal",
                        ticks=ar1_bounds)
cbar_ar1.set_label("Lag-1 Autocorrelation (AR1)", fontsize=CBAR_LABEL_SIZE)
cbar_ar1.ax.tick_params(labelsize=CBAR_TICK_SIZE)

norm_tau = mcolors.BoundaryNorm(LEVELS_TAU, ncolors=plt.get_cmap(CMAP_TAU).N, clip=True)

for name, ax in axes_tau.items():
    tau = tau_maps[name]
    data_cyc, lon_cyc = cutil.add_cyclic_point(tau.values, coord=tau.lon.values)
    
    im_tau = ax.contourf(lon_cyc, tau.lat, data_cyc, levels=LEVELS_TAU,
                         cmap=CMAP_TAU, norm=norm_tau, extend="max",
                         transform=ccrs.PlateCarree())
    
    ax.coastlines(linewidth=0.8)
    ax.add_feature(cf.LAND, facecolor="white", zorder=3)
    ax.set_title(f"{name} τ (months)", fontsize=PANEL_TITLE_SIZE)

# AR(1) colorbar
cbar_ar1 = fig.colorbar(im, cax=cax_ar1, orientation="horizontal",
                        ticks=np.arange(0, 1.01, 0.1))
cbar_ar1.set_label("Lag-1 Autocorrelation (AR1)", fontsize=CBAR_LABEL_SIZE)
cbar_ar1.ax.tick_params(labelsize=CBAR_TICK_SIZE)

# Tau colorbar
cbar_tau = fig.colorbar(im_tau, cax=cax_tau, orientation="horizontal", ticks=LEVELS_TAU)
cbar_tau.set_label("Intrinsic e-folding timescale (months)", fontsize=CBAR_LABEL_SIZE)
cbar_tau.ax.tick_params(labelsize=CBAR_TICK_SIZE)

fig.suptitle("Lag-1 Autocorrelation (Top) and Intrinsic Timescale (Bottom) of Monthly MHW Frequency",
             fontsize=TITLE_SIZE, y=0.865)

plt.savefig("/path/to/output/AR1_and_tau_maps.png",
            dpi=DPI, pad_inches=0.05, bbox_inches="tight")
plt.show()