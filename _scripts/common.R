suppressPackageStartupMessages({
    library(tidyverse)
    library(knitr)
    library(rapsimng)
})

read_example <- function(file, report = "DailyReport") {
    file_path <- file.path("_examples", file) |> 
        here::here()

    if (!file.exists(file_path)) {
        stop(paste("File not found:", file_path))
    }

    df <- rapsimng::read_report(file_path, report)

    if (has_name(df, "Site")) {
        df$Site <- gsub("\\.met$", "", basename(df$Site))
    }

    df <- df |> 
        dplyr::filter(Wheat.Phenology.Stage > 0)
    return(df)
}


plot_output <- function(file, 
        y, 
        x = "Wheat.Phenology.Stage", report = "DailyReport") {
    df <- read_example(file, report)

    if (nrow(df) == 0) {
        stop("No data found for the specified report.")
    }
    df |> 
        ggplot(aes(x = .data[[x]], y = .data[[y]], color = Cultivar)) +
        geom_line() +
        facet_grid(Site ~ SowingDate) +
        theme_bw() +
        theme(legend.position = "bottom")
}