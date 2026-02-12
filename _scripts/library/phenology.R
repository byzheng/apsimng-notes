# Function related with phenology calculations in APSIM Next Generation


plot_cardinal_temperature <- function(response_df) {
    
    interplorate <- function(df) {
        x_out <- seq(-5, 45)
        df <- data.frame(Temperature = x_out, 
                        Response = weaana::interpolationFunction(df$x, df$y, values = x_out))
        return(df)
    }
    pd <- response_df |> 
        dplyr::group_by(Phase) |> 
        dplyr::do(interplorate(.))
    

    ggplot2::ggplot(pd, ggplot2::aes(x = Temperature, y = Response, color = Phase)) +
        ggplot2::geom_line(size = 1.2) +
        # ggplot2::geom_vline(xintercept = x, linetype = "dashed", color = "grey50") +
        # ggplot2::annotate("text", x = x[1], y = max(df$Response), 
        #         label = "Base", vjust = -0.5, hjust = -0.1, size = 3) +
        # ggplot2::annotate("text", x = x[2] - 3, y = max(df$Response), 
        #         label = "Optimum", vjust = -0.5, hjust = 0.5, size = 3) +
        # ggplot2::annotate("text", x = x[3], y = max(df$Response), 
        #         label = "Maximum", vjust = -0.5, hjust = 1.1, size = 3) +
        ggplot2::labs(
            x = "Temperature (°C)",
            y = "Thermal Response"
        ) +
        ggplot2::theme_bw() +
        ggplot2::theme(legend.position = "bottom")
}

three_hourly_t <- function(tmin, tmax) {
    periods <- 1:8
    range <- tmax - tmin
    TRF <- 0.92105 + 0.1140 * periods - 0.0703 * periods^2 + 0.0053 * periods^3
    T_subdaily <- tmin + TRF * range
    # Create a data frame for plotting
    df <- data.frame(
        Hour = periods, # center of each 3-hour period
        Temperature = T_subdaily
    )
    return(df)
}

plot_3_hour_interpolation <- function(tmin = 10, tmax = 30) {
    df <- three_hourly_t(tmin, tmax)
    # Plot
    ggplot2::ggplot(df, ggplot2::aes(x = Hour, y = Temperature)) +
        ggplot2::geom_line(color = "steelblue", size = 1.2) +
        ggplot2::geom_point(size = 3, color = "steelblue") +
        ggplot2::labs(
            title = "Sub-daily Air Temperature Interpolation",
            x = "Period",
            y = "Temperature (°C)"
        ) +
        ggplot2::scale_x_continuous(breaks = 1:8) +
        ggplot2::theme_bw()

}
