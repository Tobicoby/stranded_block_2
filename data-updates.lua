local nauvis = data.raw["planet"]["nauvis"]
nauvis.map_gen_settings.property_expression_names["elevation"] = "StrandedBlock_ele"
nauvis.map_gen_settings.autoplace_controls["trees"] = { frequency = 0 }
nauvis.map_gen_settings.autoplace_controls["rocks"] = { frequency = 0 }
nauvis.map_gen_settings.autoplace_controls["nauvis_cliff"] = { frequency = 0 }
nauvis.map_gen_settings.autoplace_controls["enemy-base"] = { frequency = 1000, size = 1000 }

for resource, _ in pairs(data.raw.resource) do
    if nauvis.map_gen_settings.autoplace_settings.entity.settings[resource] then
        nauvis.map_gen_settings.autoplace_settings.entity.settings[resource] = { frequency = 0 }
    end
end
