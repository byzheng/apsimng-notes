---
title: "Writing Debug Info to Summary"
output: html_document
date: "2025-06-06"
---




When developing and debugging `Manager` scripts in APSIM Next Gen, it’s helpful to write custom messages to the **Summary window**.

## Purpose
To output internal script data, such as calculated variables, to the Summary window during simulation.

##  Code Example

```csharp
[Link] private Summary Summary;

Summary.WriteMessage(this, "FloweringDAS " + floweringDAS, MessageType.Diagnostic);

```