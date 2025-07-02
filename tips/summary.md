---
title: "Writing Debug Info to Summary"
output: html_document
sidebar: false
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



## Additional Resources

- **[Manager Model Documentation and Examples](https://apsimdev.apsim.info/ApsimX/Releases/2022.2.7020.0/Manager.pdf)**  
  Provides guidance on scripting within the Manager model, including examples of accessing and manipulating model variables.

- **[APSIM Next Gen Training Manuals](https://www.apsim.info/support/apsim-training-manuals/)**  
  A collection of tutorials and manuals covering various aspects of APSIM Next Gen.

- **[APSIM GitHub Discussions](https://github.com/APSIMInitiative/ApsimX/discussions)**  
  A community forum for discussing APSIM-related topics and getting help from other users and developers.
