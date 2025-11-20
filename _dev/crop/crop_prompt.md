PlantName: Oats
Component: Phenology
Subcomponent: ThermalTime

Task:

1. Use the template located at /_template/crop_template.qmd to generate a new QMD file.  
2. File location rules:
   - If Subcomponent is empty, create/update: /docs/Plant/<PlantName>/<Component>.qmd
   - If Subcomponent is not empty, create/update: /docs/Plant/<PlantName>/<Component>/<Subcomponent>.qmd
3. If the file already exists, preserve as much existing content as possible and update it with new information.

Source:

- Use the APSIM NG crop model JSON file located at _apsimx/Models/Resources/<PlantName>.json
- Extract information for <Component> and <Subcomponent> as the source of the documentation.

Instructions:

- Generate science documentation for APSIM NG targeted at scientists and researchers who are not familiar with APSIM NG.  
- Output in **raw Markdown** (QMD format).  
- Use $$ ... $$ for block math and $ ... $ for inline math.  
- Do not include code blocks.  
- Focus on biological explanation, model purpose, equations, cultivar-specific parameters, and practical examples.  
