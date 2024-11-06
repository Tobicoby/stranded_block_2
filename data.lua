function disableRecipie(recipeName)
	if data.raw["recipe"][recipeName]~= nil then
		data.raw["recipe"][recipeName].enabled = false
	end
end

require("prototypes.recipe")

data.raw['noise-expression']['cliffiness'].expression = 0

data.raw.recipe['burner-mining-drill'].enabled = false
data.raw.recipe['electric-mining-drill'].enabled = false
data.raw.recipe['chemical-plant'].enabled = true
data.raw.recipe['landfill'].ingredients = {{type = "item", name = "stone", amount = 5}}
data.raw.item['landfill'].stack_size = 500