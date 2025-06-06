---
title: "Accessing FloweringDAS from a Manager Script"
output: html_document
date: "2025-06-06"
---



In APSIM Next Gen, developmental stages like flowering are managed within the plant model (e.g., Wheat). This feature demonstrates how to retrieve the number of **days after sowing (DAS)** to flowering using a `Manager` script.

##  Goal
To access the value of `FloweringDAS` during the simulation.

## Prerequisites
Ensure your plant model (e.g., `Wheat`) has the `Phenology` module with a function or variable named `FloweringDAS`.

## How It Works
We use an `OnEventFunction` to link to the `Phenology.FloweringDAS` path dynamically.

## Code Example

```csharp
using System;
using Models.Core;
using Models.Functions;

namespace Models
{
    [Serializable]
    public class Script : Model
    {
        // Link to the simulation's Zone to access other models
        [Link] private Zone zone = null;

        // Subscribe to the 'DoManagement' event, which is triggered daily
        [EventSubscribe("DoManagement")]
        private void OnDoManagement(object sender, EventArgs e)
        {
            // Attempt to retrieve the 'FloweringDAS' function from the Wheat model's Phenology
            var floweringFunction = zone.Get("[Wheat].Phenology.FloweringDAS") as IFunction;

            if (floweringFunction != null)
            {
                // Evaluate the function to get the days after sowing to flowering
                double floweringDAS = floweringFunction.Value();

                // Use the retrieved value as needed
                // For example, you might store it, trigger other actions, etc.
            }
            else
            {
                // Handle the case where the function is not found
                // This might involve logging a warning or taking alternative actions
            }
        }
    }
}


```