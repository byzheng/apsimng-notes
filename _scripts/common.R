setup_qmd <- function() {
    suppressPackageStartupMessages({
        library(tidyverse)
        library(rapsimng)
        library(purrr)
        library(knitr)
    })

    if (requireNamespace("knitr", quietly = TRUE)) {
        knitr::opts_chunk$set(
            echo = FALSE,
            message = FALSE,
            warning = FALSE,
            fig.align = "center",
            fig.width = 8,
            fig.height = 7,
            out.width = "100%"
        )
    }
}


read_example <- function(file, report = "DailyReport") {
    file_path <- file |> 
        here::here()

    if (!file.exists(file_path)) {
        stop(paste("File not found:", file_path))
    }

    df <- rapsimng::read_report(file_path, report)

    if (rlang::has_name(df, "Site")) {
        df$Site <- gsub("\\.met$", "", basename(df$Site))
    }

    df <- df |> 
        dplyr::filter(Wheat.Phenology.Stage > 0,
                    Wheat.DaysAfterSowing > 0)
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
        ggplot2::ggplot(ggplot2::aes(x = .data[[x]], y = .data[[y]], color = Cultivar)) +
        ggplot2::geom_line() +
        ggplot2::geom_point(ggplot2::aes(shape = Cultivar)) +
        ggplot2::facet_grid(Site ~ SowingDate) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "bottom")
}
