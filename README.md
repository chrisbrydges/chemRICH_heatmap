# chemRICH_heatmap
R code for heatmaps for chemRICH multiple conditons

The chemrich_heatmap function can be used to make heatmaps for chemRICH analyses that have multiple conditions (see https://chemrich.idsl.me/run-chemrich/for-multiple-conditions for more information).

With the default settings, all you need to do is the following:
1) Run the chemRICH multiple conditions R code (see the previous link)
2) Run these  two lines of code:
```r
source("https://raw.githubusercontent.com/chrisbrydges/chemRICH_heatmap/main/ChemRICH_heatmap.R")
chemrich_heatmap(input = "chemrich_results.xlsx")
```
Where chemrich_results.xlsx is the name of the output Excel from the chemRICH analysis. From there, the heat map will be automatically created and saved.

You're also more than welcome to download and edit the code yourself to change figure parameters (e.g., text size, figure dimensions, etc.).
