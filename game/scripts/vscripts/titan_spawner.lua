LinkLuaModifier("modifier_titan", "modifiers/modifier_titan.lua", LUA_MODIFIER_MOTION_NONE)


if TitanSpawner == nil then
	TitanSpawner = class({})
end


function TitanSpawner:CalculateStats(team, round)
	return {
		level = round,
		health = (15000 * round) + BShop:GetBonus(team, "health"),
		damage_min = (100 + 100 * round) + BShop:GetBonus(team, "damage"),
		damage_max = (100 + 100 * round) + BShop:GetBonus(team, "damage"),
		armor = (2 * round) + BShop:GetBonus(team, "armor"),
	}
end


function TitanSpawner:SpawnTitan(team, location, waypoint, target, round)
	--print("TitanSpawner:SpawnTitan")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan.is_titan = true
	titan:AddNewModifier(titan, nil, "modifier_titan", {})

	local stats = TitanSpawner:CalculateStats(team, round)
	titan:CreatureLevelUp(stats.level)

	titan:SetMaxHealth(stats.health)
	titan:SetBaseMaxHealth(stats.health)
	titan:SetHealth(stats.health)

	titan:SetBaseDamageMin(stats.damage_min)
	titan:SetBaseDamageMax(stats.damage_max)
	titan:SetPhysicalArmorBaseValue(stats.armor)

	titan:SetInitialGoalEntity(waypoint)

	titan:SetContextThink(
		DoUniqueString("SpawnTitanAttackThink"),
		function()
			if (target and not target:IsNull() and target:IsAlive()) and (titan and not titan:IsNull() and titan:IsAlive()) then
				if CalcDistanceBetweenEntityOBB(titan, target) < 2000 then
					ExecuteOrderFromTable({
						UnitIndex = titan:entindex(), 
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = target:entindex()
					})
				end

				return 0.5
			end

			return nil
		end,
		0.1
	)
end
