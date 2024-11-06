function disableRecipie(recipeName)
	if data.raw["recipe"][recipeName]~= nil then
		data.raw["recipe"][recipeName].enabled = false
	end
end

require("prototypes.recipe")

data.raw['noise-expression']['cliffiness'].expression = 0

table.insert(data.raw["technology"]["uranium-processing"].effects, {type = "unlock-recipe", recipe = "uranium-extraction"})
table.insert(data.raw["technology"]["oil-processing"].effects, {type = "unlock-recipe", recipe = "oil-extraction"})

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
			}
		},
		research_trigger =
		{
			type = "craft-item",
			item = "pumpjack"
		}
	},
})

data.raw.recipe['burner-mining-drill'].enabled = false
data.raw.recipe['electric-mining-drill'].enabled = false
data.raw.recipe['chemical-plant'].enabled = true
data.raw.recipe['landfill'].ingredients = {{type = "item", name = "stone", amount = 5}}
data.raw.item['landfill'].stack_size = 500