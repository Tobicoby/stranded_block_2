-- Space Age: every planet gets extraction recipes for the resources that
-- generate there, made from the fluid that can be pumped there, and every
-- extraction recipe only works on its own planet.

local planets = require("prototypes.planets")

-- Yields of a generated recipe; solid amounts follow stone-extraction.
local FLUID_IN = 50
local ITEMS_OUT = 5
local FLUID_OUT = 100
local ENERGY = 5

-- The hand written recipes, which all belong to Nauvis.
local nauvis_recipes = {
    "stone-extraction", "wood-extraction", "coal-extraction", "iron-extraction", "copper-extraction",
    "oil-extraction", "uranium-extraction", "iron-smelting", "copper-smelting", "brick-smelting",
}

local nauvis = data.raw.planet["nauvis"]
local hand_written = {}
if nauvis then
    local conditions = planets.surface_conditions(nauvis)
    for _, name in ipairs(nauvis_recipes) do
        local recipe = data.raw.recipe[name]
        if recipe then
            recipe.surface_conditions = table.deepcopy(conditions)
            for _, result in ipairs(recipe.results or {}) do hand_written[result.name] = true end
        end
    end
end

for _, planet in ipairs(planets.planets()) do
    for _, product in ipairs(planet.products) do
        local covered = planet.name == "nauvis" and hand_written[product.name]
        if not covered and product.name ~= planet.fluid then
            local recipe = {
                type = "recipe",
                name = product.name .. "-extraction-" .. planet.name,
                localised_name = { "recipe-name.stranded-block-extraction", planets.product_name(product), planets.planet_name(planet) },
                energy_required = ENERGY,
                ingredients = { { type = "fluid", name = planet.fluid, amount = FLUID_IN } },
                results = { { type = product.type, name = product.name, amount = product.type == "fluid" and FLUID_OUT or ITEMS_OUT } },
                icons = planets.planet_icons(planets.find_product(product), planet),
                categories = planets.categories(),
                subgroup = "fluid-recipes",
                order = "z[stranded-block]-" .. planet.name .. "-a[" .. product.name .. "]",
                surface_conditions = table.deepcopy(planet.conditions),
                auto_recycle = false,
            }
            planets.unlock(recipe, planet)
            data:extend({ recipe })
            planets.share_productivity("stone-extraction", recipe.name)
        end
    end
end
