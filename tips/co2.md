---
title: "Setting CO₂ Concentration"
date: "2025-06-06"
output: html_document
---

In APSIM Next Gen, the default CO₂ concentration is **350 ppm** if not explicitly set.  
This value may need to be changed when simulating future climate scenarios or FACE (Free-Air CO₂ Enrichment) experiments.

This guide explains how to modify the CO₂ level using a `Manager` script and the `PreparingNewWeatherData` event.

## Objective

Set a custom CO₂ concentration during simulation by assigning a value through a Manager script.

1. Right-click the `Field` node in your simulation.
2. Select **Add model** from the context menu.
3. Add a **Manager** model under `Field`.
4. Rename it to something like `SetCO2`.
5. Paste the C# script (see below) into the **Script** tab.
6. Set your desired CO₂ value (e.g., `550`) in the **Parameters** tab.

## Implementation

Below is a complete Manager script that demonstrates how to access these variables:


```csharp
using System;
using Models.Core;
using Models.Climate;

namespace Models
{
    [Serializable]
    public class Script : Model
    {
        // Link to the Weather and Clock models
        [Link] private Weather Weather;
        [Link] private Clock Clock;

        // User-defined CO2 value
        [Description("CO2 concentration")]
        public double CO2 { get; set; }

        // Set CO2 before weather data is applied each day
        [EventSubscribe("PreparingNewWeatherData")]
        private void OnPreparingNewWeatherData(object sender, EventArgs e)
        {
            Weather.CO2 = CO2;
        }
    }
}
```

As climate changes, CO2 is increasing in the atmosphere, and this script allows you to dynamically set the CO₂ concentration for your simulation.

```csharp
using System;
using Models.Core;
using Models.Interfaces;
using Models.PMF;
using Models.Climate;
using APSIM.Shared.Utilities;

namespace Models
{
    [Serializable]
    public class Script : Model
    {
        [Link] IClock Clock;
        [Link] ISummary Summary;
        [Link] Weather Weather;

        // CO2 levels from 1959 to 2024 (index 0 corresponds to 1959)
        //
        // Data Source: NOAA GML CO₂ Annual Mean Data, Mauna Loa Observatory
        // https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_annmean_mlo.txt
        // This dataset is released under the Creative Commons Zero v1.0 Universal 
        // Public Domain Dedication (CC0 1.0), allowing unrestricted use. 
        private double[] co2Levels = new double[]
        {
            315.98, 316.91, 317.64, 318.45, 318.99, 319.62, 320.04, 321.37, 322.18, 323.05,
            324.62, 325.68, 326.32, 327.46, 329.68, 330.19, 331.13, 332.03, 333.84, 335.41,
            336.84, 338.76, 340.12, 341.48, 343.15, 344.87, 346.35, 347.61, 349.31, 351.69,
            353.20, 354.45, 355.70, 356.54, 357.21, 358.96, 360.97, 362.74, 363.88, 366.84,
            368.54, 369.71, 371.32, 373.45, 375.98, 377.70, 379.98, 382.09, 384.02, 385.83,
            387.64, 390.10, 391.85, 394.06, 396.74, 398.81, 401.01, 404.41, 406.76, 408.72,
            411.65, 414.21, 416.41, 418.53, 421.08, 424.61
        };

        private int startYear = 1959; // Base year for index calculation


        [EventSubscribe("PreparingNewWeatherData")]
        private void OnPreparingNewWeatherData(object sender, EventArgs e)
        {
            int year = Clock.Today.Year;
            int index = year - startYear;

            if (index >= 0 && index < co2Levels.Length)
                Weather.CO2 = co2Levels[index];
            else
                Weather.CO2 = co2Levels[co2Levels.Length - 1]; // Use the latest CO₂ for future years
        }
   
    }
}
```


## Explanation

The `Weather` model in APSIM contains a `CO2` property, which determines the atmospheric CO₂ concentration used in crop growth and development calculations. This property is normally updated with each day's weather data.

By subscribing to the `PreparingNewWeatherData` event, the script intercepts the process before daily weather values are applied. This allows you to override the CO₂ value dynamically for the duration of the simulation.

This approach is particularly useful for experiments involving elevated CO₂ or simulating long-term climate change effects where static weather files are used but require changes in CO₂ independently.


## Additional Resources

- **[Manager Model Documentation and Examples](https://apsimdev.apsim.info/ApsimX/Releases/2022.2.7020.0/Manager.pdf)**  
  Provides guidance on scripting within the Manager model, including examples of accessing and manipulating model variables.

- **[APSIM Next Gen Training Manuals](https://www.apsim.info/support/apsim-training-manuals/)**  
  A collection of tutorials and manuals covering various aspects of APSIM Next Gen.

- **[APSIM GitHub Discussions](https://github.com/APSIMInitiative/ApsimX/discussions)**  
  A community forum for discussing APSIM-related topics and getting help from other users and developers.
