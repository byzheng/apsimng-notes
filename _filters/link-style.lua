local path = require("pandoc.path")

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


    if resolved_path:match("/docs/Models") then
        el.attributes["class"] = "model-link"
    elseif resolved_path:match("/docs/Crops") then
        el.attributes["class"] = "crop-link"
    end

    return el
end

