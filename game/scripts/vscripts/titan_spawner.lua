
LinkLuaModifier("modifier_titan", "modifiers/modifier_titan.lua", LUA_MODIFIER_MOTION_NONE)



if TitanSpawner == nil then
	TitanSpawner = class({})
end


function TitanSpawner:SpawnTitan(team, location, target, round)
	print("TitanSpawner:SpawnTitan")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan:AddNewModifier(titan, nil, "modifier_titan", {})
	titan:CreatureLevelUp(round)

	local health = 10000 * round
	titan:SetMaxHealth(health)
	titan:SetBaseMaxHealth(health)
	titan:SetHealth(health)

	titan:SetBaseDamageMin(100 + 100 * round)
	titan:SetBaseDamageMax(100 + 100 * round)
	titan:SetPhysicalArmorBaseValue(2 * round)

	titan:SetContextThink(
		DoUniqueString("SpawnTitanAttackThink"),
		function()
			if (target and not target:IsNull() and target:IsAlive()) and (titan and not titan:IsNull() and titan:IsAlive()) then
				ExecuteOrderFromTable({
					UnitIndex = titan:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = target:entindex()
				})

				return 1.0
			end

			return nil
		end,
		0.05
	)
end
