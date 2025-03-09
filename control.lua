local created_items = { ["pistol"] = 1, ["firearm-magazine"] = 10 }

script.on_event(defines.events.on_player_joined_game, function(e)
	local player = game.players[e.player_index]
	if player.surface.name == "nauvis" then
		game.players[e.player_index].force.set_spawn_position({ x = 0, y = 0 }, game.surfaces["nauvis"])
	end
end)

script.on_init(function()
	if remote.interfaces["freeplay"] ~= nil then
		remote.call("freeplay", "set_disable_crashsite", true)
		remote.call("freeplay", "set_created_items", created_items)
	end
	if remote.interfaces["sandbox"] ~= nil then
		remote.call("sandbox", "set_created_items", created_items)
	end
end)

script.on_event(defines.events.on_chunk_generated, function(e)
	if e.surface.name ~= "nauvis" then return end
	if e.position.x ~= 0 or e.position.y ~= 0 then return end
	local chest = e.surface.create_entity({ name = "iron-chest", position = { 0, 0 }, force = game.forces.player })
	if chest == nil then return end
	chest.insert({ name = "landfill", count = 800 })
	chest.insert({ name = "offshore-pump", count = 1 })
	chest.insert({ name = "chemical-plant", count = 4 })
	chest.insert({ name = "pipe", count = 20 })
	chest.insert({ name = "coal", count = 50 })
	chest.insert({ name = "solar-panel", count = 1 })
	chest.insert({ name = "small-electric-pole", count = 8 })
	chest.insert({ name = "boiler", count = 1 })
	chest.insert({ name = "steam-engine", count = 2 })
end)
