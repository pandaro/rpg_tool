rpg_tool={}

local timer = 0
local tool_set = function(meta, player,caps)

	local new_uses = caps.groupcaps.cracky.uses + player:get_attribute('durability')
	local new_time_3 = caps.groupcaps.cracky.times[3] * 1 - (player:get_attribute('tool')/10)
	local new_time_2 = caps.groupcaps.cracky.times[2] * 1 - (player:get_attribute('tool')/10)
	local new_damage = caps.damage_groups.fleshy * 1 + (player:get_attribute('sword')/10)
	
--print(tostring(caps.groupcaps.cracky.uses))
	meta:set_tool_capabilities({
 		max_drop_level=0,
 		groupcaps={
 			cracky={times={[2]=0.1, [3]=0.1}, uses=new_uses, maxlevel=1}
 		},
 		damage_groups = {fleshy=new_damage},
 	})
	
end	

minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 10 then
		-- Send "Minetest" to all players every 5 seconds
		for i, v in pairs(minetest.get_connected_players())do
			local stack= v:get_wielded_item()
			local stackname = stack:get_name()
			local rt = string.split(stackname,':')[1]
			print(tostring(stackname)..' globalstep')
			print(dump(rt))
			if rt == 'rpg_tool' then
				local meta = stack:get_meta()
				local name = meta:get_string('owner')
				print(tostring('name '..name))
				
				if name ~= v:get_player_name() and name ~= '' then
					local caps = stack:get_definition().tool_capabilities

					v:set_wielded_item({name = stackname,wear = stack:get_wear(),meta=nil})
					print(' global STOP')
					
				end
			end
		end
		timer = 0
	end
end)



minetest.register_tool("rpg_tool:1", {
	description = "rpg_tool 1",
	inventory_image = "default_tool_steelaxe.png",
	--inventory_overlay = 'rpg_adapt.png',
	--color = "0xFFFFFF5A",
	palette='m.png',
	base_tool = 'rpg_tool:2',
	on_use = function(itemstack, user, pointed_thing)
		
		return minetest.node_dig(pointed_thing.above, minetest.get_node(pointed_thing.above), user)
	end,

	on_place = function(itemstack, placer, pointed_thing)
		print('on_placestart')
		local name = placer:get_player_name()
		local meta = itemstack:get_meta()
		meta:set_int('palette_index',1)
		local owner = meta:set_string('owner',name)
		local caps = itemstack:get_definition().tool_capabilities
		tool_set(meta,placer,caps)
		return itemstack
	end,
	tool_capabilities = {
		max_drop_level=0,
		groupcaps={
			cracky={times={[2]=2.00, [3]=2.00}, uses=10, maxlevel=1}
		},
		damage_groups = {fleshy=2},
	},
})