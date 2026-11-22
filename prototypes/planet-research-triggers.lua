-- Space Age: a technology that is researched by mining a resource patch can
-- never be researched on a planet without patches. Mining keeps working, and
-- extracting the resource now counts as well. A technology has room for one
-- trigger only, so a hidden twin technology carries the extraction trigger
-- and control.lua researches the real technology when the twin completes.

local planets = require("prototypes.planets")

-- Products that have an extraction recipe made by planet-extraction.lua.
local extractable = {}
for _, planet in ipairs(planets.planets()) do
    for _, product in ipairs(planet.products) do
        if data.raw.recipe[product.name .. "-extraction-" .. planet.name] then
            extractable[product.type .. "/" .. product.name] = true
        end
    end
end

-- The product to extract in place of mining the entities, or nil when any of
-- them is not a resource patch or cannot be extracted.
local function replacement(entities)
    local first
    for _, entity_name in ipairs(entities) do
        local resource = data.raw.resource[entity_name]
        local minable = resource and resource.minable
        if not minable then return nil end
        local results = minable.results or { { type = "item", name = minable.result } }
        local found
        for _, result in ipairs(results) do
            local product = { type = result.type or "item", name = result.name }
            if not found and extractable[product.type .. "/" .. product.name] then found = product end
        end
        if not found then return nil end
        first = first or found
    end
    return first
end

local twins = {}
for _, name in ipairs(planets.sorted_keys(data.raw.technology)) do
    local technology = data.raw.technology[name]
    local trigger = technology.research_trigger
    local product = trigger and trigger.type == "mine-entity" and replacement(trigger.entities or { trigger.entity })
    if product then
        local twin = {
            type = "technology",
            name = name .. "-by-extraction",
            localised_name = technology.localised_name or { "technology-name." .. name },
            icon = technology.icon,
            icon_size = technology.icon_size,
            icons = table.deepcopy(technology.icons),
            prerequisites = table.deepcopy(technology.prerequisites),
            hidden = true,
        }
        if product.type == "fluid" then
            twin.research_trigger = { type = "craft-fluid", fluid = product.name, amount = 1 }
        else
            twin.research_trigger = { type = "craft-item", item = product.name, count = 1 }
        end
        twins[#twins + 1] = twin

        local note = { "technology-description.stranded-block-or-extract", planets.product_name(product) }
        local description = technology.localised_description or { "technology-description." .. name }
        technology.localised_description = { "?", { "", description, "\n", note }, note }
    end
end
if #twins > 0 then data:extend(twins) end
