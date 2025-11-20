---
title: "Accessing Internal Model Variables in the Manager Scripts"
format: html
sidebar: false
date: "2025-06-06"
---

In APSIM Next Gen, internal variables such as `[Wheat].Phenology.FloweringDAS` and `[Wheat].Stem.N` are accessible within the `Report` model. However, accessing these variables directly in a `Manager Script` requires a different approach.

To retrieve these values within a `Manager Script`, you can use the `zone.Get()` method to access the specific model. After obtaining the model, cast it to the appropriate type (e.g., `IFunction`, `Plant`, or `IOrgan`) to access its properties or methods. You can determine the model type by hovering over the model name in the APSIM user interface, which will display its full type name.

## Objective

Retrieve internal variables from models (e.g., `[Wheat].Phenology.FloweringDAS` and `[Wheat].Stem.N`) during the simulation using a Manager script.

## Implementation

Below is a complete Manager script that demonstrates how to access these variables:


```csharp

using System;
using Models.Core;
using Models.Functions;
using Models.PMF;
using Models.PMF.Organs;

namespace Models
{
    [Serializable]
    public class Script : Model
    {
        // Link to the simulation's Zone to access other models
        [Link] private Zone zone = null;

        // Link to the Summary model to write messages to the simulation log
        [Link] private Summary summary = null;

        // Subscribe to the 'DoManagement' event, which is triggered daily
        [EventSubscribe("DoManagement")]
        private void OnDoManagement(object sender, EventArgs e)
        {
            // Access the FloweringDAS function from the Wheat model's Phenology
             OnEventFunction floweringEvent = (OnEventFunction)zone.Get("[" + "Wheat" +"].Phenology.FloweringDAS");

            if (floweringEvent != null)
            {
                // Evaluate the function to get the days after sowing to flowering
                double floweringDAS = floweringEvent.Value();

                // Write the retrieved value to the simulation summary for diagnostic purposes
                summary.WriteMessage(this, $"[Wheat].Phenology.FloweringDAS: {floweringDAS}", MessageType.Diagnostic);
            }
            else
            {
                // Handle the case where the function is not found
                summary.WriteMessage(this, "[Wheat].Phenology.FloweringDAS not found.", MessageType.Warning);
            }

       
            // Access the Stem organ
             GenericOrgan Stemorgan = (GenericOrgan)zone.Get("[" + "Wheat" +"].Stem");

            if (Stemorgan != null)
            {
                // Retrieve the Nitrogen amount in the Stem
                double stemN = Stemorgan.N;

                // Write the retrieved value to the simulation summary for diagnostic purposes
                summary.WriteMessage(this, $"[Wheat].Stem.N: {stemN}", MessageType.Diagnostic);
            }
            else
            {
                // Handle the case where the Stem organ is not found
                summary.WriteMessage(this, "[Wheat].Stem.N not found in Wheat model.", MessageType.Warning);
            }
        
        }
    }
}
```

## Explanation

### Accessing `[Wheat].Phenology.FloweringDAS`

The `[Wheat].Phenology.FloweringDAS` variable is typically defined as a `OnEventFunction` function within the `Phenology` component of a `Wheat` model.
  
To access this function within a Manager script:

1. **Retrieve the Function**: Use the `zone.Get()` method with the path to the function, e.g., `"[Wheat].Phenology.FloweringDAS"`.
2. **Cast to OnEventFunction**: Cast the retrieved object to the `OnEventFunction` interface, which provides the `Value()` method to evaluate the function.
3. **Evaluate the Function**: Call the `Value()` method to obtain the current value of `FloweringDAS`.

This approach allows dynamic access to model functions during simulation, enabling custom management decisions based on plant development stages.

### Accessing `[Wheat].Stem.N`

The nitrogen content (`N`) of the `Stem` organ is reportable variable. To access this variable:

1. **Retrieve the Plant Model**: Use `zone.Get("[Wheat].Stem")` to obtain the `Stem` model.
2. **Cast to IOrgan**: Cast the `Stem` organ to the `GenericOrgan` interface, which provides access to the `N` property.
4. **Retrieve Nitrogen Content**: Access the `N` property to get the current nitrogen content of the `Stem` organ.

This method enables monitoring and managing nutrient dynamics within specific plant organs during simulation.


## Additional Resources

- **[Manager Model Documentation and Examples](https://apsimdev.apsim.info/ApsimX/Releases/2022.2.7020.0/Manager.pdf)**  
  Provides guidance on scripting within the Manager model, including examples of accessing and manipulating model variables.

- **[APSIM Next Gen Training Manuals](https://www.apsim.info/support/apsim-training-manuals/)**  
  A collection of tutorials and manuals covering various aspects of APSIM Next Gen.

- **[APSIM GitHub Discussions](https://github.com/APSIMInitiative/ApsimX/discussions)**  
  A community forum for discussing APSIM-related topics and getting help from other users and developers.
