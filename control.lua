research_landfill = function(force)
	if not force.technologies['landfill'].researched then
		force.technologies['landfill'].researched = true
	end
end

script.on_event(defines.events.on_player_joined_game, function(e)
	local player = game.players[e.player_index]
	research_landfill(game.players[e.player_index].force)
	if player.surface.name == "nauvis" then
		game.players[e.player_index].force.set_spawn_position({x=0,y=0}, game.surfaces["nauvis"])
	end
end)

script.on_event(defines.events.on_player_created, function(e)
	local player = game.players[e.player_index]
	player.remove_item({name="burner-mining-drill", count=99})
	player.remove_item({name="wood", count=99})
	player.remove_item({name="iron-plate", count=99})
	player.remove_item({name="stone-furnace", count=99})
end)

script.on_init(function()
	remote.call("freeplay", "set_disable_crashsite", true)
end)

script.on_event(defines.events.on_chunk_generated, function(e)
	local minx = e.area.left_top.x
	local maxx = e.area.right_bottom.x
	local miny = e.area.left_top.y
	local maxy = e.area.right_bottom.y

	function get_random_enemy(e)
		local enemies = {
			{ name = "small-worm-turret", chance = 0.05 },
			{ name = "medium-worm-turret", chance = 0.025 },
			{ name = "big-worm-turret", chance = 0.001 },
			{ name = "behemoth-worm-turret", chance = 0.00042 },
			{ name = "biter-spawner", chance = 0.4 },
			{ name = "spitter-spawner", chance = 0.3 },
		}
		local total_chance = 0
		for _, enemy in ipairs(enemies) do
			total_chance = total_chance + enemy.chance
		end
		local random_value = math.random() * total_chance
		local cumulative_chance = 0
		for _, enemy in ipairs(enemies) do
			cumulative_chance = cumulative_chance + enemy.chance
			if random_value <= cumulative_chance then
				return enemy.name
			end
		end
	end

	local area = e.area
    local enemy = get_random_enemy(e)

	while true do
		local position = e.surface.find_non_colliding_position_in_box("biter-spawner", area, 0.75, false)
		if not position then
			break
		end
		e.surface.create_entity({name=enemy, position=position, force=game.forces.enemy})
		local distance_from_spawn = math.sqrt(position.x * position.x + position.y * position.y)
		if distance_from_spawn > 250 then
			break
		end
	end

	local radius = e.surface.map_gen_settings.starting_area * 150 -- radius of the starting circle
	local limit = (radius+64) * (radius+64) -- add some slop to catch the chunks around the circle

	if (minx*minx + miny*miny > limit) then
		return
	end

	local forced_map = {
		{
			center = {x=0, y=0},
			radius = 1.6,
			tile = "grass-1",
			remove_resources = true,
		},
	}

	local function in_list (needle, haystack)
		for _,v in pairs(haystack) do
			if needle == v then
				return true
			end
		end
		return false
	end

	local starting_tile = false
	local tiles = {}
	for x=minx-1, maxx do
		for y=miny-1, maxy do
			for _,v in pairs(forced_map) do
				local dx = x - v.center.x
				local dy = y - v.center.y

				if dx*dx+dy*dy <= (v.radius * v.radius) then
					local existing = e.surface.get_tile(x,y).name
					if v.remove_resources then
						for _,r in pairs(e.surface.find_entities_filtered{area={{x-1, y-1},{x+1, y+1}}, type="resource"}) do
							r.destroy()
						end
					end
					if not v.tile_whitelist or not in_list(existing, v.tile_whitelist) then
						table.insert(tiles, {name=v.tile, position={x,y}})
						break
					end
				end
			end

			if x == 1 and y == 1 then
				starting_tile = true
			end
		end
	end

	e.surface.set_tiles(tiles)
	if starting_tile then
		local chest = e.surface.create_entity({name="iron-chest", position = {0, 0}, force=game.forces.player})
		if chest == nil then
			return
		end
		chest.insert({name="landfill", count=800})
		chest.insert({name="offshore-pump", count=1})
		chest.insert({name="chemical-plant", count=4})
		chest.insert({name="pipe", count=20})
		chest.insert({name="coal", count=50})
		chest.insert({name="solar-panel", count=1})
		chest.insert({name="small-electric-pole", count=8})
		chest.insert({name="boiler", count=1})
		chest.insert({name="steam-engine", count=2})
	end
end)
