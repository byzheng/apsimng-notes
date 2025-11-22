

ModelName: XYPairs
TargetFile: Models/Functions/XYPairs


Task:

1. Locate the APSIM NG source code file: /_apsimx/<TargetFile>.cs.
2. Open <ModelName>.cs and use its content as the primary source for generating science documentation.

File Handling:

- Use the template `_dev/model/model_template.qmd` to structure the documentation.
- Output a QMD file: /docs/<TargetFile>.qmd
- If <ModelName>.qmd does not exist:
    - Create a new QMD file /docs/<TargetFile>.qmd using the same folder structure as the source code in _apsimx.
- If <ModelName>.qmd already exists:
    - Update it with new content from <ModelName>.cs following the template.
    - Preserve as much existing text as possible.
    - Use the new layout in the template.
- For interfaces or classes with no actual functions, skip the "Processes and Algorithms" section.

Instructions for Documentation:

- Target audience: scientists and researchers unfamiliar with APSIM NG.
- Content should include:
    - Model purpose and overview
    - Biological explanation
    - Equations (block $$ ... $$ and inline $ ... $)
    - Cultivar-specific parameters
    - Practical examples
- Format: raw Markdown (QMD), no code blocks.

