
ModelName: Biomass

source-file: ApsimX\Models\PMF\Biomass\Biomass.cs



## Task

1. Locate and open the APSIM NG source code file specified by `source-file`.
2. Use the source code as the PRIMARY and authoritative reference.
3. Generate scientific documentation using the embedded QMD template provided below.


## Output Requirements (STRICT)


* Output must be RAW QMD text (no wrapping).
* Do NOT use markdown code blocks (no `or`md).
* Output must start directly with the YAML header (`---`).
* Do NOT include any text before or after the QMD content.
* The YAML header MUST:
  * Start with `"---`
  * Contain:
    * `title: ""`
    * `format: html`
    * `draft: true`
  * End with `---`
* The output MUST begin with the YAML header exactly and immediately.
* Treat the output as the final contents of a `.qmd` file.
* Do NOT wrap, escape, or render any part of the document.
* Preserve the Quarto setup chunk EXACTLY as defined in the template:
  * Do NOT modify it
  * Do NOT remove it


## Template Handling (STRICT)

* The template is provided BELOW in this prompt.
* This embedded template OVERRIDES any external template files.
* You MUST:
  * Copy the template structure EXACTLY
  * Preserve ALL headings, section order, and formatting
  * Use second-level headings (`##`) for all main sections BELOW the YAML header
  * Keep all `{{< include ... >}}` blocks unchanged
* Do NOT:
  * Remove any sections
  * Reorder sections
  * Rename headings
  * Add new sections
* Placeholder handling:
  * Replace ALL text inside `< ... >` with fully developed content
  * Use placeholders only as writing guidance
  * Do NOT leave any `< ... >` in the final output
* Table formatting:
  * Use Markdown tables exactly as defined in the template

## Quarto Preservation Rules (CRITICAL)

* Treat the output as RAW TEXT, not rendered Markdown
* Do NOT interpret, simplify, or “clean up” formatting
* Preserve ALL QMD/Quarto syntax EXACTLY as written
* The following MUST remain unchanged:
  * `setup_qmd()`
  * `{{< include ... >}}`
* Do NOT convert YAML header into Markdown headings
* Do NOT convert QMD into standard Markdown
* Do NOT remove or rewrite QMD-specific syntax
* Do NOT escape or modify template include syntax
* Assume the output will be copied directly into a `.qmd` file



## Content Requirements

Write for scientists unfamiliar with APSIM NG.

Include where relevant:

* Model purpose and scientific role
* Biological interpretation of variables and processes
* Clear mathematical expressions:
  * Block equations: `$$ ... $$`
  * Inline equations: `$ ... $`
* Cultivar-specific parameter discussion (if applicable)
* Practical APSIM usage examples

## Process Rules

* Base ALL content strictly on the source code
* Do NOT invent or assume functionality not present in the code
* If the class has no real processes:
  * Skip the **"Processes and Algorithms"** section entirely

## Formatting Rules

* Output must preserve QMD syntax EXACTLY (Quarto-compatible Markdown)
* Do NOT normalise or simplify syntax to standard Markdown
* Do NOT include additional code blocks inside the output
* Keep formatting literal, stable, and compatible with APSIM documentation


## Goal

Produce a clean, publication-ready APSIM Next Generation documentation page that can be copied directly into VS Code or Copilot workflows without modification.


------------------------------------------------------------
QMD Template

---
title: "<functionname>"
format: html
draft: true
---


```{r setup, echo=FALSE}
setup_qmd()
```

<a short description of the function, its purpose, and how it fits into the APSIM NG framework.>




## Overview

<A longer description of the function, its purpose, and how it fits into the APSIM NG framework.>

## Model Structure

{{< include /_includes/Models/model-structure-intro.md >}}

<List all parent classes>

* [Model](/docs/Models/Core/Model.qmd)
* [IFunction](/docs/Models/Core/IFunction.qmd)
* [IStructureDependency](/docs/Models/Core/IStructureDependency.qmd)


## Connections to Other Components

{{< include /_includes/Models/connections-intro.md >}}


<A table to describe all connections to other models>

| Component | Model | Connection Type | Description                                          |
|-----------|-------|-----------------|------------------------------------------------------|
| Plant | [Plant](/docs/Models/PMF/Plant.qmd) | Link, First Available | Provides structural and lifecycle information for the plant. |
| Phenology | [Phenology](/docs/Models/PMF/Phenology/Phenology.qmd) | Link, First Available | Supplies current growth stage and timing of key events. |
| ThermalTime | [IFunction](/docs/APSIM.Core/IFunction.qmd) | Child, By Name | Calculates accumulated temperature used for leaf and stem development. |

## Model Variables

{{< include /_includes/Models/model-variables-intro.md >}}


**Configurable and Reportable Properties**

<A table below to list all public and read only properties>

| Property             | Type    | Description                                                                 |
|----------------------|---------|-----------------------------------------------------------------------------|
| OutputValueType   | string  | The type of variable for sub-daily values as air temperature                      |

<if no public properties, show the message below>

> No configurable properties are available for this function.

**Read-Only Reportable Properties**

<A table below to list all public and read only properties>

| Property             | Type    | Description                                                                 |
|----------------------|---------|-----------------------------------------------------------------------------|
| OutputValueType   | string  | The type of variable for sub-daily values as air temperature                      |

<if no public properties, show the message below>
> No read-only properties are available for this function.


## Events 

{{< include /_includes/Models/events-intro.md >}}

**Events Listened For**
<show the events listened by this function>

These are signals or notifications that the function listens for from other parts of the simulation:

| Event          | Purpose                                                                                  |
|----------------|------------------------------------------------------------------------------------------|
| [Commencing](/docs/Models/Events.html#Commencing)   | Calculate $\text{TRF}_p$ at starting of simulation |

<if no event listened, show the message below>
> No events are listened by this function.

**Events Raised to**
<show the events raised by this function>
| Event          | Purpose                                                                                  |
|----------------|------------------------------------------------------------------------------------------|
| [Commencing](/docs/Models/Events.html#Commencing)   | Calculate $\text{TRF}_p$ at starting of simulation |


<if no event raised, show the message below>

> No events are raised by this function.


## Processes and Algorithms

{{< include /_includes/Models/processes-intro.md >}}


<Use subsections to describe each process or methods>


## User Interface

<FunctionName> can be added as a child of a <ParentFunctionName> node in the model tree. Right-click the parent node, select "Add Model...", and search for <FunctionName> in the Filter Box.


## Practical Example

<Provide a case study or example of this function>
<Generate R script chunk to demonstrate the function with figure if applicable with echo=FALSE, message=FALSE, warning=FALSE>

<if not applicable, show the message below>
> No practical example is available for this function.

## See Also

* **Source code:** [<FunctionName>.cs on GitHub](http://github.com/APSIMInitiative/ApsimX/blob/master/Models/<FunctionPath-in-apsimx-source-codes>.cs)



