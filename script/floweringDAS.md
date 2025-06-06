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
[Link] Zone zone;

[EventSubscribe("DoManagement")]
private void OnDoManagement(object sender, EventArgs e)
{
    OnEventFunction floweringEvent = 
        (OnEventFunction)zone.Get("[Wheat].Phenology.FloweringDAS");

    double floweringDAS = floweringEvent.Value();
}

```