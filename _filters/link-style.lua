local path = require("pandoc.path")
local project_dir = quarto.project.directory or "."


-- Function to check if a file exists
function file_exists(name)
    -- Skip if not a .qmd file
    if not name:match("%.qmd$") then
        return true -- treat as valid (e.g., folders or anchors)
    end
    -- Remove leading slash to make it relative
    if name:sub(1, 1) == "/" then
        name = name:sub(2)
    end

    -- Construct full path
    local full_path = path.join({ project_dir, name })

    -- Attempt to open file
    local f = io.open(full_path, "r")
    if f then
        io.close(f)
        return true
    else
        return false
    end
end

function Link(el)
    local href = el.target or ""

    -- Skip external links
    if href:match("^https?://") then
        el.attributes["class"] = "external-link"
        return el
    end

    local resolved_path = href

    -- Resolve absolute path if href is relative
    if href:sub(1, 1) ~= "/" and not href:match("^%a:[/\\]") then
        local current_file = quarto.doc.input_file
        if current_file then
            local current_dir = path.directory(current_file)
            resolved_path = path.normalize(path.join({ current_dir, href })):gsub("\\", "/")
        end
    end
    print(resolved_path)
    -- Check if the file exists
    if not file_exists(resolved_path) then
        el.attributes["class"] = "broken-link"
        return el
    end

    if resolved_path:match("/docs/Models") then
        el.attributes["class"] = "model-link"
    elseif resolved_path:match("/docs/Crops") then
        el.attributes["class"] = "crop-link"
    end

    return el
end
