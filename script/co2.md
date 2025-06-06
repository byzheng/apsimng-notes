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
