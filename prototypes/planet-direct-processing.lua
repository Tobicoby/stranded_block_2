-- Space Age: the per-planet counterpart of Advanced Water Smelting. Where a
-- planet's resource has a first processing step that takes nothing but the
-- resource (smelting it, or recycling it), a researched recipe makes the
-- outcome of that step straight from the planet's fluid.

local planets = require("prototypes.planets")

-- Yields follow iron-smelting: twice the processing recipe's results.
local FLUID_IN = 100
local MULTIPLIER = 2
local ENERGY = 3.2

-- Nauvis already has these hand written recipes.
local nauvis_recipes = { "iron-smelting", "copper-smelting", "brick-smelting" }

-- Science pack made on each planet, added to the cost when it exists.
local planet_science = {
    vulcanus = "metallurgic-science-pack",
    fulgora = "electromagnetic-science-pack",
    gleba = "agricultural-science-pack",
    aquilo = "cryogenic-science-pack",
}

local hand_written = {}
for _, name in ipairs(nauvis_recipes) do
    local recipe = data.raw.recipe[name]
    for _, result in ipairs(recipe and recipe.results or {}) do hand_written[result.name] = true end
end

local function recipe_categories(recipe)
    return recipe.categories or { recipe.category or "crafting" }
end

-- 1 for smelting, 2 for recycling, nil for anything else.
local function processing_rank(recipe)
    local rank
    for _, category in ipairs(recipe_categories(recipe)) do
        if category == "smelting" then return 1 end
        if category:find("recycling", 1, true) then rank = 2 end
    end
    return rank
end

-- Recycling recipes the recycler derived from another recipe do not count.
local function derived_recycling(recipe)
    local base = recipe.name:match("^(.*)%-recycling$")
    return recipe.hidden or (base and data.raw.recipe[base] ~= nil)
end

-- The recipe that turns the item, and only the item, into something else.
local function processing_recipe(item_name)
    local best, best_rank
    for _, name in ipairs(planets.sorted_keys(data.raw.recipe)) do
        local recipe = data.raw.recipe[name]
        local ingredients = recipe.ingredients or {}
        local rank = not derived_recycling(recipe) and processing_rank(recipe)
        if rank and #ingredients == 1 and ingredients[1].name == item_name and #(recipe.results or {}) > 0 then
            local makes_itself = false
            for _, result in ipairs(recipe.results) do
                if result.name == item_name then makes_itself = true end
            end
            if not makes_itself and (not best or rank < best_rank) then
                best, best_rank = recipe, rank
            end
        end
    end
    return best
end

local function scaled_results(recipe)
    local results = table.deepcopy(recipe.results)
    for _, result in ipairs(results) do
        for _, field in ipairs({ "amount", "amount_min", "amount_max" }) do
            if result[field] then result[field] = result[field] * MULTIPLIER end
        end
    end
    return results
end

local function technology_for(planet)
    local template = data.raw.technology["advanced-water-smelting"]
    local technology = {
        type = "technology",
        name = "advanced-extraction-" .. planet.name,
        localised_name = { "technology-name.stranded-block-direct-processing", planets.planet_name(planet) },
        localised_description = { "technology-description.stranded-block-direct-processing", planets.planet_name(planet) },
        icon = template.icon,
        icon_size = template.icon_size,
        effects = {},
        prerequisites = { "advanced-water-smelting" },
        unit = table.deepcopy(template.unit),
        upgrade = true,
        order = template.order,
    }
    if planet.discovery then table.insert(technology.prerequisites, planet.discovery.name) end
    for _, pack in ipairs({ "space-science-pack", planet_science[planet.name] }) do
        if planets.find_item(pack) and data.raw.technology[pack] then
            table.insert(technology.unit.ingredients, { pack, 1 })
            table.insert(technology.prerequisites, pack)
        end
    end
    return technology
end

for _, planet in ipairs(planets.planets()) do
    local technology
    for _, product in ipairs(planet.products) do
        local source = product.type == "item" and processing_recipe(product.name)
        local covered = source and planet.name == "nauvis" and hand_written[source.results[1].name]
        if source and not covered then
            local icon_source = source
            if not (source.icon or source.icons) then
                icon_source = planets.find_product(source.results[1])
            end
            local recipe = {
                type = "recipe",
                name = "direct-" .. product.name .. "-processing-" .. planet.name,
                localised_name = { "recipe-name.stranded-block-direct-processing", planets.product_name(product), planets.planet_name(planet) },
                energy_required = ENERGY,
                enabled = false,
                ingredients = { { type = "fluid", name = planet.fluid, amount = FLUID_IN } },
                results = scaled_results(source),
                icons = planets.planet_icons(icon_source, planet),
                categories = planets.categories(),
                subgroup = "fluid-recipes",
                order = "z[stranded-block]-" .. planet.name .. "-b[" .. product.name .. "]",
                surface_conditions = table.deepcopy(planet.conditions),
                allow_productivity = source.allow_productivity,
                auto_recycle = false,
            }
            if #recipe.results > 1 then recipe.main_product = "" end
            if not technology then
                technology = technology_for(planet)
                data:extend({ technology })
            end
            table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe.name })
            data:extend({ recipe })
            planets.share_productivity("iron-smelting", recipe.name)
        end
    end
end
