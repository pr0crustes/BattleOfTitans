
LinkLuaModifier("modifier_titan_round_buff", "modifiers/modifier_titan_round_buff.lua", LUA_MODIFIER_MOTION_NONE)



if TitanSpawner == nil then
	TitanSpawner = class({})
end


function TitanSpawner:SpawnTitan(team, location, target, round)
	print("TitanSpawner:SpawnTitan")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan:AddNewModifier(titan, nil, "modifier_titan_round_buff", { round = round })

	titan:SetContextThink(
		DoUniqueString("SpawnTitanAttackThink"),
		function()
			if target and target:IsAlive() and titan:IsAlive() then
				ExecuteOrderFromTable({
					UnitIndex = titan:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = target:entindex()
				})

				return 1.0
			end

			return nil
		end,
		1.0
	)
end
