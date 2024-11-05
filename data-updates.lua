-- Find and remove the pumpjack unlock from oil-processing
for i = 1, #data.raw.technology["oil-processing"].effects do
    local effect = data.raw.technology["oil-processing"].effects[i]
    if effect.type == "unlock-recipe" and effect.recipe == "pumpjack" then
        table.remove(data.raw.technology["oil-processing"].effects, i)
        break
    end
end

-- Only affect Nauvis
if data.raw["planet"]["nauvis"] then
    for k,v in pairs(data.raw.tree) do
        v.autoplace = {probability_expression = 0}
    end

    for k,v in pairs(data.raw.resource) do
        v.autoplace = {probability_expression = 0}
    end

    for k,v in pairs(data.raw["simple-entity"]) do
        v.autoplace = {probability_expression = 0}
    end
end

data:extend(
    {
        {
            type = "noise-expression",
            name = "StrandedBlock_ele",
            intended_property = "elevation",
            expression = "noise",
            local_expressions = {
                noise = "(terrace(base_noise - 0.76, 1, 1, 1) - starting_area_circle) + (small_island*10)",
                base_noise = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 0, input_scale = 1/50, output_scale = 1}",
                starting_area_circle = "if(x^2 + y^2 < starting_area^2, 1, 0)",
                small_island = "if(x^2 + y^2 < 2^2, 1, 0)",
                starting_area = 250,
            }
        }
    }
)

data.raw["map-gen-presets"]["default"]["strandedblock"] = {
    order = "a",
    basic_settings = {
        property_expression_names = {
            elevation = "StrandedBlock_ele"
        }
    }
}