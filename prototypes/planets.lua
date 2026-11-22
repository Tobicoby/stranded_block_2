-- Helpers describing each planet at load time: which fluid can be pumped
-- there, which resources generate there natively, and which surface
-- conditions pin a recipe to that planet alone.

local lib = {}

local function sorted_keys(t)
    local keys = {}
    for key in pairs(t or {}) do keys[#keys + 1] = key end
    table.sort(keys)
    return keys
end
lib.sorted_keys = sorted_keys

local function property_value(location, property)
    local value = location.surface_properties and location.surface_properties[property.name]
    if value == nil then value = property.default_value end
    return value
end

-- The smallest set of exact surface property matches that no other planet or
-- surface prototype shares. Pressure is always listed first, like the base
-- game's own planet-locked recipes.
function lib.surface_conditions(planet)
    local properties = {}
    for _, name in ipairs(sorted_keys(data.raw["surface-property"])) do
        if name ~= "pressure" then properties[#properties + 1] = data.raw["surface-property"][name] end
    end
    if data.raw["surface-property"]["pressure"] then
        table.insert(properties, 1, data.raw["surface-property"]["pressure"])
    end

    local others = {}
    for _, kind in ipairs({ "planet", "surface" }) do
        for _, name in ipairs(sorted_keys(data.raw[kind])) do
            local other = data.raw[kind][name]
            if other ~= planet then others[#others + 1] = other end
        end
    end

    local conditions = {}
    for _, property in ipairs(properties) do
        if #conditions > 0 and #others == 0 then break end
        local value = property_value(planet, property)
        local still_matching = {}
        for _, other in ipairs(others) do
            if property_value(other, property) == value then still_matching[#still_matching + 1] = other end
        end
        if #conditions == 0 or #still_matching < #others then
            conditions[#conditions + 1] = { property = property.name, min = value, max = value }
            others = still_matching
        end
    end
    return conditions
end

-- The fluid an offshore pump yields on most of the planet's pumpable tiles.
local function planet_fluid(planet)
    local tiles = planet.map_gen_settings.autoplace_settings
        and planet.map_gen_settings.autoplace_settings.tile
        and planet.map_gen_settings.autoplace_settings.tile.settings
    local counts = {}
    for _, tile_name in ipairs(sorted_keys(tiles)) do
        local tile = data.raw.tile[tile_name]
        if tile and tile.fluid then counts[tile.fluid] = (counts[tile.fluid] or 0) + 1 end
    end
    local best
    for _, fluid in ipairs(sorted_keys(counts)) do
        if not best or counts[fluid] > counts[best] then best = fluid end
    end
    return best
end

function lib.find_item(name)
    for item_type in pairs(defines.prototypes.item) do
        local item = data.raw[item_type] and data.raw[item_type][name]
        if item then return item end
    end
end

function lib.find_product(product)
    if product.type == "fluid" then return data.raw.fluid[product.name] end
    return lib.find_item(product.name)
end

-- Everything mined or pumped from the resources that generate on the planet,
-- as a list of {type = "item"|"fluid", name = ...}, sorted and de-duplicated.
local function planet_products(planet)
    local entities = planet.map_gen_settings.autoplace_settings
        and planet.map_gen_settings.autoplace_settings.entity
        and planet.map_gen_settings.autoplace_settings.entity.settings
    local seen = {}
    local products = {}
    for _, entity_name in ipairs(sorted_keys(entities)) do
        local resource = data.raw.resource[entity_name]
        local minable = resource and resource.minable
        if minable then
            local results = minable.results
            if not results and minable.result then
                results = { { type = "item", name = minable.result } }
            end
            for _, result in ipairs(results or {}) do
                local product = { type = result.type or "item", name = result.name }
                local key = product.type .. "/" .. product.name
                if not seen[key] and lib.find_product(product) then
                    seen[key] = true
                    products[#products + 1] = product
                end
            end
        end
    end
    return products
end

local function discovery_technology(planet)
    for _, name in ipairs(sorted_keys(data.raw.technology)) do
        for _, effect in ipairs(data.raw.technology[name].effects or {}) do
            if effect.type == "unlock-space-location" and effect.space_location == planet.name then
                return data.raw.technology[name]
            end
        end
    end
end

-- One entry per planet that has both a pumpable fluid and native resources.
function lib.planets()
    local planets = {}
    for _, name in ipairs(sorted_keys(data.raw.planet)) do
        local planet = data.raw.planet[name]
        if planet.map_gen_settings then
            local fluid = planet_fluid(planet)
            local products = planet_products(planet)
            if fluid and #products > 0 then
                planets[#planets + 1] = {
                    prototype = planet,
                    name = name,
                    fluid = fluid,
                    products = products,
                    conditions = lib.surface_conditions(planet),
                    discovery = discovery_technology(planet),
                }
            end
        end
    end
    return planets
end

function lib.product_name(product)
    local prototype = lib.find_product(product)
    if prototype.localised_name then return prototype.localised_name end
    return { (product.type == "fluid" and "fluid-name." or "item-name.") .. product.name }
end

function lib.planet_name(planet)
    return planet.prototype.localised_name or { "space-location-name." .. planet.name }
end

-- Icon layers of the given prototype with the planet's icon in the corner.
function lib.planet_icons(prototype, planet)
    local icons
    if prototype.icons then
        icons = table.deepcopy(prototype.icons)
    else
        icons = { { icon = prototype.icon, icon_size = prototype.icon_size } }
    end
    if planet.prototype.icon then
        local size = planet.prototype.icon_size or 64
        icons[#icons + 1] = { icon = planet.prototype.icon, icon_size = size, scale = 16 / size, shift = { -8, -8 } }
    end
    return icons
end

function lib.categories()
    local categories = { "chemistry" }
    if data.raw["recipe-category"]["cryogenics"] then categories[#categories + 1] = "cryogenics" end
    return categories
end

-- Give new_recipe the same productivity research as like_recipe.
function lib.share_productivity(like_recipe, new_recipe)
    for _, technology in pairs(data.raw.technology) do
        local change
        for _, effect in ipairs(technology.effects or {}) do
            if effect.type == "change-recipe-productivity" and effect.recipe == like_recipe then
                change = effect.change
            end
        end
        if change then
            table.insert(technology.effects, { type = "change-recipe-productivity", recipe = new_recipe, change = change })
        end
    end
end

-- Recipes are enabled from the start on planets nobody has to discover.
function lib.unlock(recipe, planet)
    if planet.discovery then
        recipe.enabled = false
        planet.discovery.effects = planet.discovery.effects or {}
        table.insert(planet.discovery.effects, { type = "unlock-recipe", recipe = recipe.name })
    else
        recipe.enabled = true
    end
end

return lib
