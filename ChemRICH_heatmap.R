chemrich_heatmap <- function(input = "ChemRICH_results.xlsx"){
  if (!require("pacman"))
      install.packages("pacman", repos = "http://cran.rstudio.com/")
  pacman::p_load(readxl)
  pacman::p_load(ggplot2)
  pacman::p_load(dplyr)
  pacman::p_load(purrr)
  pacman::p_load(tidyr)

  
  # Read all the excel sheets into R, except for the first sheet (which is the input)
  read_excel_allsheets <- function(input, tibble = FALSE) {
    sheets <- readxl::excel_sheets(input)[-1]
    x <- lapply(sheets, function(X) readxl::read_excel(input, sheet = X))
    if(!tibble) x <- lapply(x, as.data.frame)
    names(x) <- sheets
    x
  }
  sheets <- readxl::excel_sheets(input)[-1]
  df <- read_excel_allsheets(input)
  
  # Throw out the non-significant compound clusters for each pairwise comparison
  for (j in 1:length(df)) {
    df[[j]] <- dplyr::filter(df[[j]], `p-values` < 0.05)
    df[[j]] <- dplyr::select(df[[j]], `Cluster name`, `Increased ratio`)
  }
  
  # Turn the list of data frames into one merged data frame
  df <- reduce(df, dplyr::full_join, by = "Cluster name")
  colnames(df)[2:ncol(df)] <- sheets
  df <- tidyr::pivot_longer(df, cols = -`Cluster name`)
  df$`Cluster name` <- factor(df$`Cluster name`)
  
  # Make the heat map
  p <- ggplot2::ggplot(df, aes(x = name, y = `Cluster name`, fill = value)) + 
                         geom_tile() +
                         scale_fill_gradient(name = "Effect Direction", 
                                             low = "blue", 
                                             high = "red", 
                                             limits = c(0, 1), 
                                             na.value = "white", 
                                             breaks = c(0, 0.5, 1), 
                                             labels = c("All negative", "Mixed", "All positive")) +
                         theme_classic() +
                         scale_x_discrete(name = "Comparison") +
                         scale_y_discrete(limits = rev(levels(df$`Cluster name`))) +
                         theme(text = element_text(size = 16), axis.text.x = element_text(angle = 90))
  
  ggplot2::ggsave("ChemRICH_heatmap.png", p, height = 8, width = 8, dpi = 300)
  cat("ChemRICH_heatmap.png has been created.\n")
   
}