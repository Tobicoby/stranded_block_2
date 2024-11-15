-- Only affect Nauvis
if data.raw["planet"]["nauvis"] then
    for k,v in pairs(data.raw.tree) do
        v.autoplace = {probability_expression = 0}
    end

    for k,v in pairs(data.raw.resource) do
        v.autoplace = {probability_expression = 0}
    end

    nauvis_rocks = {"big-rock", "huge-rock", "big-sand-rock"}
    for k,v in pairs(nauvis_rocks) do
        data.raw["simple-entity"][v].autoplace = {probability_expression = 0}
    end
end

-- THIS IS STUPID (COPIED FROM planet-fulgora-map-gen)
-- BUT IT SPAWNS SCRAP
if data.raw["planet"]["fulgora"] then
    require("__space-age__/prototypes/planet/planet-fulgora-map-gen")
    data.raw.resource.scrap.autoplace =
    {
    control = "scrap",
    order = "b",
    probability_expression = "(control:scrap:size > 0)\z
                                * (1 - fulgora_starting_mask)\z
                                * (min((fulgora_structure_cells < min(0.1 * frequency, 0.05 + 0.05 * frequency))\z
                                * (1 + fulgora_structure_subnoise) * abs_mult_height_over * fulgora_artificial_mask\z
                                + (fulgora_spots_prebanding < (1.2 + 0.4 * linear_size)) * fulgora_vaults_and_starting_vault * 10,\z
                                0.5) * (1 - fulgora_road_paving_2c))",
    richness_expression = "(1 + fulgora_structure_subnoise) * 1000 * (7 / (6 + frequency) + 100 * fulgora_vaults_and_starting_vault) * richness",
    local_expressions =
    {
        abs_mult_height_over = "fulgora_elevation > (fulgora_coastline + 10)",
        frequency = "control:scrap:frequency",
        size = "control:scrap:size",
        linear_size = "slider_to_linear(size, -1, 1)",
        richness = "control:scrap:richness"
    }
    }
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

data:extend(
    {
        {
            type = "map-gen-presets",
            name = "default",
            default = {
                order = "a",
                default = true,
            },
            ["strandedblock"] =
            {
                order = "b",
                basic_settings = {
                    property_expression_names = {
                        elevation = "StrandedBlock_ele"
                    }
                }
            },
        }
    }
)

data:extend({
	{
		type = "technology",
		name = "oil-processing",
		icon = "__base__/graphics/technology/oil-processing.png",
		icon_size = 256,
		prerequisites = {"oil-gathering"},
		effects =
		{
			{
			type = "unlock-recipe",
			recipe = "oil-refinery"
			},
			{
			type = "unlock-recipe",
			recipe = "chemical-plant"
			},
			{
			type = "unlock-recipe",
			recipe = "basic-oil-processing"
			},
			{
			type = "unlock-recipe",
			recipe = "solid-fuel-from-petroleum-gas"
			},
			{
			type = "unlock-recipe",
			recipe = "oil-extraction"
			}
		},
		research_trigger =
		{
			type = "craft-item",
			item = "pumpjack"
		}
	},
    {
        type = "technology",
        name = "uranium-mining",
        icon = "__base__/graphics/technology/uranium-mining.png",
        icon_size = 256,
        effects =
        {
            {
            type = "mining-with-fluid",
            modifier = true
            },
            {
            type = "unlock-recipe",
            recipe = "uranium-extraction"
            },
        },
        prerequisites = {"chemical-science-pack", "concrete"},
        unit =
        {
          count = 100,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1}
          },
          time = 30
        }
    },
    {
        type = "technology",
        name = "uranium-processing",
        icon = "__base__/graphics/technology/uranium-processing.png",
        icon_size = 256,
        effects =
        {
            {
            type = "unlock-recipe",
            recipe = "centrifuge"
            },
            {
            type = "unlock-recipe",
            recipe = "uranium-processing"
            },
        },
        prerequisites = {"uranium-mining"},
        research_trigger =
        {
          type = "craft-item",
          item = "uranium-ore"
        }
    },
})