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



using System;
using Models.Core;
using Models.Functions;

namespace Models
{
    [Serializable]
    public class Script : Model
    {
        // Link to the Summary model to write messages to the simulation log
        [Link] private Summary summary = null;

        // Subscribe to the 'DoManagement' event, which is triggered daily
        [EventSubscribe("DoManagement")]
        private void OnDoManagement(object sender, EventArgs e)
        {
            summary.WriteMessage(this, "Hello from manager script", MessageType.Diagnostic);
        }
    }
}

```