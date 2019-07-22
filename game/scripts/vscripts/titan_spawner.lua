LinkLuaModifier("modifier_titan", "modifiers/modifier_titan.lua", LUA_MODIFIER_MOTION_NONE)


if TitanSpawner == nil then
	TitanSpawner = class({})
end


function TitanSpawner:CalculateStats(team, round)
	return {
		level = round,
		health = (15000 * round) + BShop:GetBonus(team, "health"),
		damage_min = (100 + 100 * round),
		damage_max = (100 + 100 * round),
		armor = (2 * round),
	}
end


function TitanSpawner:SpawnTitan(team, location, target, round)
	print("TitanSpawner:SpawnTitan")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan:AddNewModifier(titan, nil, "modifier_titan", {})

	local stats = TitanSpawner:CalculateStats(team, round)
	titan:CreatureLevelUp(stats.level)

	titan:SetMaxHealth(stats.health)
	titan:SetBaseMaxHealth(stats.health)
	titan:SetHealth(stats.health)

	titan:SetBaseDamageMin(stats.damage_min)
	titan:SetBaseDamageMax(stats.damage_max)
	titan:SetPhysicalArmorBaseValue(stats.armor)

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
