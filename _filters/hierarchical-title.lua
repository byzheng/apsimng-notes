-- Filter to create hierarchical page titles based on file path
-- For files under /docs/, creates titles like: Docs - Plants - Wheat - Phenology - StemElongating

function Meta(meta)
    -- Only process if we have QUARTO_PROJECT_OUTPUT_DIR (rendering context)
    local output_file = quarto.doc.input_file

    if output_file then
        -- Check if the file is under docs/
        if string.match(output_file, "docs[/\\]") then
            -- Get the original title
            local original_title = ""
            if meta.title then
                original_title = pandoc.utils.stringify(meta.title)
            end

            -- Extract path components from the file path
            -- Remove file extension and split by / or \
            local path_without_ext = output_file:gsub("%.qmd$", ""):gsub("%.md$", "")
            local parts = {}

            -- Split by both / and \ (for cross-platform compatibility)
            for part in string.gmatch(path_without_ext, "[^/\\]+") do
                table.insert(parts, part)
            end

            -- Build hierarchical title
            local title_parts = {}
            local in_docs = false

            for i, part in ipairs(parts) do
                if part == "docs" then
                    in_docs = true
                    table.insert(title_parts, "Docs")
                elseif in_docs then
                    -- Skip index files in the path construction
                    if part ~= "index" then
                        -- Capitalize first letter and handle special cases
                        local formatted_part = part:gsub("^%l", string.upper)
                        table.insert(title_parts, formatted_part)
                    end
                end
            end

            -- If we have a non-index file, the last part should be replaced with the actual title
            if #parts > 0 and parts[#parts] ~= "index" and original_title ~= "" then
                title_parts[#title_parts] = original_title
            elseif original_title ~= "" and parts[#parts] == "index" then
                -- For index files, append the original title if it's different from the parent
                table.insert(title_parts, original_title)
            end

            -- Create the hierarchical title
            if #title_parts > 0 then
                local page_title = table.concat(title_parts, " - ")
                meta["pagetitle"] = pandoc.Str(page_title)
                
                -- Add breadcrumb context for search indexing
                -- This creates a hidden div that will be indexed by search
                -- but won't be visible in the rendered page
                local breadcrumb_text = table.concat(title_parts, " ")
                meta["search-breadcrumb"] = pandoc.Str(breadcrumb_text)
            end
        end
    end

    return meta
end

-- Add breadcrumb to document body for search indexing
function Pandoc(doc)
    local breadcrumb = doc.meta["search-breadcrumb"]
    
    if breadcrumb then
        -- Create a hidden div with breadcrumb for search indexing
        local hidden_div = pandoc.Div(
            {pandoc.Plain(pandoc.Str(pandoc.utils.stringify(breadcrumb)))},
            {class = "quarto-include-in-search-index", style = "display:none;"}
        )
        
        -- Insert at the beginning of the document
        table.insert(doc.blocks, 1, hidden_div)
    end
    
    return doc
end
