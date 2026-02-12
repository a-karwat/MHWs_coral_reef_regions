library(tibble)
library(gt)
library(gtExtras)
library(formattable)
library(dplyr)
library(scales)
library(gridExtra)

# This code creates the correlation table.
################################################################################

df <- tribble(
  ~name, ~group, ~climate_mode, ~season, ~corr_OBS, ~corr_LE, ~corr_ASSM, ~corr_HIND_LY1, ~corr_HIND_LY2,
  "Caribbean Sea", "Warm-water Coral Reefs", "ENSO", "MAM", 60, 70, 50, 60, 70, 
  "Galapagos Islands", "Warm-water Coral Reefs", "ENSO", "DJF", 50, 70, 50, 70, 80, 
  "", "Warm-water Coral Reefs", "ENSO", "MAM", 50, 60, 60, 70, 70,
  "", "Warm-water Coral Reefs", "ENSO", "JJA", 60, 80, 70, 90, 90,
  "", "Warm-water Coral Reefs", "ENSO", "SON", 60, 70, 60, 70, 80,
  "Gulf of Guinea", "Warm-water Coral Reefs", "ENSO", "MAM", 40, 50, 5, 20, 60, 
  "Indian Ocean", "Warm-water Coral Reefs", "ENSO", "MAM", 50, 50, 40, 40, 60, )

df2 <- plyr::rename(df, c("climate_mode" = "Climate Mode",
                          "season" = "Season",
                          "corr_OBS"="OBS",
                          "corr_LE"="UNIN",
                          "corr_ASSM"="ASSM",
                          "corr_HIND_LY1"="HIND LY1",
                          "corr_HIND_LY2"="HIND LY2"))

df <- df2

df %>%
  
  # make gt table
  gt(rowname_col = "name", groupname_col = "group") %>%
  
  row_group_order(groups = c("Warm-water Coral Reefs")) %>%
  
  data_color(column = "Climate Mode", 
             colors = col_factor(palette = c("lightgrey","grey3"),
                                 domain = c("AMO","ENSO","IPO","ATL3","PDO"))) %>%
  
  gt_plt_bar_pct(
    column = "OBS",
    scaled = TRUE,
    labels = TRUE,
    fill = "blue") %>%
  
  gt_plt_bar_pct(
    column = "UNIN",
    scaled = TRUE,
    labels = TRUE,
    fill = "red") %>%
  
  gt_plt_bar_pct(
    column = "ASSM",
    scaled = TRUE,
    labels = TRUE,
    fill = "orange") %>%
  
  gt_plt_bar_pct(
    column = "HIND LY1",
    scaled = TRUE,
    labels = TRUE,
    fill = "hotpink") %>%
  
  gt_plt_bar_pct(
    column = "HIND LY2",
    scaled = TRUE,
    labels = TRUE,
    fill = "deepskyblue")

#gt(df) %>% 
#  gtsave('/path/to/ouput/table.pdf')