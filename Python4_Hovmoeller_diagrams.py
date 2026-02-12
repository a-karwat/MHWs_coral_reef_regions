import xarray as xr
import numpy as np
import matplotlib.pyplot as plt

temp_file = "/plot/to/file.nc"
temp_var = "TEMP"

start = "1980-01"
end   = "2020-12"

depths_cm = [5000, 9500, 19500, 30500, 52700]

lags = np.arange(18, -1, -1)

save_base = "/path/to/output/Hovmoeller_"

T = xr.open_dataset(temp_file)[temp_var].sel(time=slice(start,end))

if T.lon.max() > 180:
    newlon = ((T.lon + 180) % 360) - 180
    _, idx = np.unique(newlon, return_index=True)
    T = T.isel(lon=idx).assign_coords(lon=newlon[idx]).sortby("lon")

T = T.where(T.time.dt.season=="DJF", drop=True)
T_anom = T.groupby("time.month") - T.groupby("time.month").mean("time")

SST = T_anom.sel(z_t_2=5000, method="nearest")
SST_zonal = SST.mean("lon")

threshold = SST_zonal.quantile(0.9, dim="time")
mhw = SST_zonal > threshold
onset = mhw & (~mhw.shift(time=1, fill_value=False))

for depth_cm in depths_cm:

    Tsub = T_anom.sel(z_t_2=depth_cm, method="nearest")

    actual_m = float(Tsub.z_t_2) / 100
    
    Tsub_zonal = Tsub.mean("lon")

    hov = xr.concat(
        [
            Tsub_zonal.shift(time=lag)
                      .where(onset)
                      .mean("time")
            for lag in lags
        ],
        dim="lag")

    hov = hov.assign_coords(lag=lags)

    plt.figure(figsize=(10,6))

    plt.xticks(fontsize=15)
    plt.yticks(fontsize=15)

    levels = np.arange(-2.5, 2.75, 0.25)

    im = plt.contourf(
        hov.lag,
        hov.lat,
        hov.T,
        levels=levels,
        cmap="RdBu_r",
        extend="both")

    plt.axvline(0, color="k", lw=2)
    plt.gca().invert_xaxis()

    cbar = plt.colorbar(im, pad=0.03)
    cbar.ax.tick_params(labelsize=14)
    cbar.set_label("Temperature anomaly (°C)", fontsize=15, labelpad=12)

    plt.xlabel("Months before MHW onset", fontsize=15)
    plt.ylabel("Latitude", fontsize=15)

    plt.title(
        f"Zonal-mean temperature anomalies preceding MHW onset\n"
        f"(ASSM, DJF 1980–2020, z ≈ {actual_m:.0f} m)",
        fontsize=16
    )

    plt.tight_layout()

    save_path = f"{save_base}{int(actual_m)}m.png"
    plt.savefig(save_path, dpi=300)
    plt.close()