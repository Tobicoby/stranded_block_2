function substitute_prerequisite(prerequisite_name, new_prerequisites)
	for _, tech in pairs(data.raw["technology"]) do
		local prerequisites = tech.prerequisites or {}
		for prerequisite_index, name in ipairs(prerequisites) do
			if name == prerequisite_name then
				table.remove(prerequisites, prerequisite_index)
				for new_prerequisites_index, new_prerequisite in ipairs(new_prerequisites) do
					table.insert(prerequisites, prerequisite_index + new_prerequisites_index - 1, new_prerequisite)
				end

				break
			end
		end
	end
end

function remove_technology(technologyName)
	if not data.raw["technology"][technologyName] then return end
	local prerequisites = data.raw["technology"][technologyName].prerequisites
	data.raw["technology"][technologyName] = nil
	substitute_prerequisite(technologyName, prerequisites)
end

require("prototypes.recipe")
require("prototypes.noise-expresion")

data.raw.recipe['burner-mining-drill'].enabled = false
data.raw.recipe['chemical-plant'].enabled = true
data.raw.recipe['landfill'].ingredients = { { type = "item", name = "stone", amount = 5 } }
data.raw.recipe['landfill'].enabled = true
data.raw.item['landfill'].stack_size = 500


data.raw.technology["oil-gathering"].effects = { { type = "unlock-recipe", recipe = "oil-extraction" } }
data.raw.technology["oil-processing"].research_trigger = { type = "craft-fluid", fluid = "crude-oil", amount = 1 }
data.raw.technology["uranium-mining"].effects = {
	{ type = "mining-with-fluid", modifier = true },
	{ type = "unlock-recipe",     recipe = "uranium-extraction" }
}
data.raw.technology["uranium-processing"].research_trigger = { type = "craft-item", item = "uranium-ore" }

remove_technology("landfill")
remove_technology("electric-mining-drill")

if mods["space-age"] then
	local tech = data.raw.technology["space-platform-thruster"]
	table.insert(tech.effects, { type = "unlock-recipe", recipe = "burner-mining-drill" })
	table.insert(tech.effects, { type = "unlock-recipe", recipe = "electric-mining-drill" })
	table.insert(tech.effects, { type = "unlock-recipe", recipe = "pumpjack" })
end
