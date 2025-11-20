# Function related with phenology calculations in APSIM Next Generation


plot_cardinal_temperature <- function(x, y) {
    x_out <- seq(-5, 40)
    df <- data.frame(Temperature = x_out, 
                        Response = weaana::interpolationFunction(x, y, values = x_out))


    ggplot2::ggplot(df, ggplot2::aes(x = Temperature, y = Response)) +
        ggplot2::geom_line(color = "darkorange", size = 1.2) +
        ggplot2::geom_vline(xintercept = x, linetype = "dashed", color = "grey50") +
        ggplot2::annotate("text", x = x[1], y = max(df$Response), 
                label = "Base", vjust = -0.5, hjust = -0.1, size = 3) +
        ggplot2::annotate("text", x = x[2] - 3, y = max(df$Response), 
                label = "Optimum", vjust = -0.5, hjust = 0.5, size = 3) +
        ggplot2::annotate("text", x = x[3], y = max(df$Response), 
                label = "Maximum", vjust = -0.5, hjust = 1.1, size = 3) +
        ggplot2::labs(
            x = "Temperature (°C)",
            y = "Thermal Response"
        ) +
        ggplot2::theme_minimal()
}



plot_3_hour_interpolation <- function(tmin = 10, tmax = 30) {
    # Define 3-hour periods (1 to 8)
    periods <- 1:8

    # Calculate temperature range
    range <- tmax - tmin

    # Compute TRF and corresponding sub-daily temperatures
    TRF <- 0.92105 + 0.1140 * periods - 0.0703 * periods^2 + 0.0053 * periods^3
    T_subdaily <- tmin + TRF * range

    # Create a data frame for plotting
    df <- data.frame(
        Hour = periods, # center of each 3-hour period
        Temperature = T_subdaily
    )

    # Plot
    ggplot(df, aes(x = Hour, y = Temperature)) +
        geom_line(color = "steelblue", size = 1.2) +
        geom_point(size = 3, color = "steelblue") +
        scale_x_continuous(breaks = seq(0, 24, by = 3)) +
        labs(
            title = "Sub-daily Air Temperature Interpolation",
            x = "Period",
            y = "Temperature (°C)"
        ) +
        scale_x_continuous(breaks = 1:8) +
        theme_bw()

}