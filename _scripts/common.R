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

date2doy <- function(date) {
    as.numeric(as.Date(paste(date, "-2011", sep = ""), format = "%d-%b-%Y")) -
        as.numeric(as.Date("2010-12-31"))
}

factor_date <- function(dates) {
    dates_unique <- unique(dates)
    dates_unique <- dates_unique[order(date2doy(dates_unique))]
    factor(dates, levels = dates_unique)
}

read_example <- function(file, 
    report = "DailyReport",
    max_stage = NULL) {
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
        dplyr::filter(
            Wheat.Phenology.Stage > 0,
            Wheat.DaysAfterSowing > 0
        ) |>
        dplyr::mutate(SowingDate = factor_date(SowingDate))

    
    if (!is.null(max_stage)) {
        stopifnot(length(max_stage) == 1)
        stopifnot(is.numeric(max_stage))
        df1 <- df |>
            dplyr::filter(Wheat.Phenology.Stage <= max_stage)
        df2 <- df |>
            dplyr::filter(Wheat.Phenology.Stage > max_stage) |>
            dplyr::group_by(Site, SowingDate, Cultivar) |>
            dplyr::slice(1) |> 
            dplyr::ungroup() 
        df <- dplyr::bind_rows(df1, df2)
    }
    return(df)
}


plot_output <- function(file,
                        y,
                        x = "Wheat.DaysAfterSowing", report = "DailyReport",
                        max_stage = NULL,
                        stage_name = TRUE) {
    stopifnot(is.character(file) && length(file) == 1)
    stopifnot(is.character(y) && length(y) == 1)
    stopifnot(is.character(x) && length(x) == 1)
    stopifnot(is.character(report) && length(report) == 1)
    stopifnot(is.logical(stage_name) && length(stage_name) == 1)

    df <- read_example(file, report, max_stage = max_stage)

    if (nrow(df) == 0) {
        stop("No data found for the specified report.")
    }
    p <- df |>
        ggplot2::ggplot(ggplot2::aes(x = .data[[x]], y = .data[[y]], color = Cultivar)) +
        ggplot2::geom_line() +
        ggplot2::geom_point(ggplot2::aes(shape = Cultivar)) +
        ggplot2::facet_grid(Site ~ SowingDate) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "bottom")
    if (stage_name) {
        pd_label <- df |>
            dplyr::mutate(y = min(.data[[y]], na.rm = TRUE)) |>
            dplyr::select(all_of(c("Site", "SowingDate", "Cultivar", x, "Wheat.Phenology.CurrentStageName", "y"))) |>
            dplyr::filter(nchar(Wheat.Phenology.CurrentStageName) > 0)
        p <- p +
            ggplot2::geom_text(
                data = pd_label,
                ggplot2::aes(y = y, label = Wheat.Phenology.CurrentStageName),
                vjust = 0.5,
                angle = 90,
                hjust = 0,
                size = 3.5
            ) +
            ggplot2::labs(x = x, y = y)
    }
    return(p)
}

calculate_fln <- function(fln_data) {
    fln_long <- fln_data |>
            pivot_wider(names_from = Parameter_FLN, values_from = FLN) |>
            mutate(
                LV = MinLN,
                SV = MinLN + PpLN,
                SN = MinLN + PpLN + VrnLN,
                LN = MinLN + VrnLN + VxPLN
            ) |>
            pivot_longer(
                cols = c("MinLN", "PpLN", "VrnLN", "VxPLN", "LV", "SV", "SN", "LN"),
                names_to = "Parameter_FLN",
                values_to = "FLN"
            )

    return(fln_long)
}

plot_fln <- function(fln_data) {
    fln_long <- calculate_fln(fln_data)

    # Plot
    p <- fln_long |>
        dplyr::filter(Parameter_FLN %in% c("LV", "SV", "SN", "LN")) |>
        mutate(Parameter_FLN = factor(Parameter_FLN, levels = c("LV", "SV", "SN", "LN"))) |>
        ggplot() +
        geom_col(aes(x = Parameter_FLN, y = FLN, fill = Parameter_FLN), alpha = 0.5, width = 0.5, color = "black") +
        facet_wrap(~Cultivar, ncol = 1) +
        labs(
            y = "Final Leaf Number (FLN)",
            x = "Treatment"
        ) +
        theme_bw() +
        theme() +
        theme(legend.position = "none")
    fln_wide <- fln_long |>
        pivot_wider(names_from = Parameter_FLN, values_from = FLN)
    df_text <- bind_rows(
        fln_wide |>
            mutate(
                Y = MinLN / 2,
                X = 1,
                Label = "MinLN"
            ) |>
            select(Cultivar, Y, X, Label),
        fln_wide |>
            mutate(
                Y = PpLN / 2 + MinLN,
                X = 1.5,
                Label = "PpLN"
            ) |>
            select(Cultivar, Y, X, Label),
        fln_wide |>
            mutate(
                Y = VrnLN / 2 + SV,
                X = 2.5,
                Label = "VrnLN"
            ) |>
            select(Cultivar, Y, X, Label),
        fln_wide |>
            mutate(
                Y = VrnLN / 2 + LV,
                X = 3,
                Label = "VrnLN"
            ) |>
            select(Cultivar, Y, X, Label),
        fln_wide |>
            mutate(
                Y = VxPLN / 2 + LV + VrnLN,
                X = 4,
                Label = "VxPLN"
            ) |>
            select(Cultivar, Y, X, Label)
    )

    df_vertical <- bind_rows(
        fln_wide |>
            mutate(
                y = LV,
                yend = SV,
                x = 1.5,
                xend = 1.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "PpLN"),
        fln_wide |>
            mutate(
                y = SV,
                yend = SN,
                x = 2.5,
                xend = 2.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VrnLN"),
        fln_wide |>
            mutate(
                y = LV,
                yend = SN - SV + LV,
                x = 2.5,
                xend = 2.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VrnLN"),
        fln_wide |>
            mutate(
                y = SN - SV + LV,
                yend = LN,
                x = 3.5,
                xend = 3.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VxPLN")
    )

    df_horizontal <- bind_rows(
        fln_wide |>
            mutate(
                y = LV,
                yend = LV,
                x = 1,
                xend = 1.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "PpLN"),
        fln_wide |>
            mutate(
                y = SV,
                yend = SV,
                x = 1.5,
                xend = 2
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "PpLN"),
        fln_wide |>
            mutate(
                y = SV,
                yend = SV,
                x = 2,
                xend = 2.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VrnLN"),
        fln_wide |>
            mutate(
                y = SN,
                yend = SN,
                x = 2.5,
                xend = 3
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VrnLN"),
        fln_wide |>
            mutate(
                y = LV,
                yend = LV,
                x = 1,
                xend = 2.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VrnLN"),
        fln_wide |>
            mutate(
                y = SN - SV + LV,
                yend = SN - SV + LV,
                x = 2.5,
                xend = 3.5
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VxPLN"),
        fln_wide |>
            mutate(
                y = LN,
                yend = LN,
                x = 3.5,
                xend = 4
            ) |>
            select(Cultivar, y, yend, x, xend) |>
            mutate(Label = "VxPLN")
    )




    # Add LV label
    p <- p + geom_text(
        data = df_text,
        aes(x = X, y = Y, label = Label, color = Label),
        size = 5,
        fontface = "italic",
        vjust = 0.5
    )

    p <- p + geom_segment(
        data = df_vertical,
        aes(
            x = x, xend = xend,
            y = y, yend = yend,
            color = Label,
        ),
        linetype = "dashed",
        arrow = arrow(length = unit(0.2, "cm"), ends = "last", type = "closed")
    )


    p <- p + geom_segment(
        data = df_horizontal,
        aes(
            x = x, xend = xend,
            y = y, yend = yend,
            color = Label
        ),
        linetype = "dashed"
    )

    p <- p + scale_color_manual(
        values = c("MinLN" = "black", "PpLN" = "red", "VrnLN" = "blue", "VxPLN" = "black"),
        guide = "none"
    )
    return(p)
}
