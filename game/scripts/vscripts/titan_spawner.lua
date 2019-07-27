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


function TitanSpawner:ApplyStats(titan, stats)
	titan:CreatureLevelUp(stats.level)

	titan:SetMaxHealth(stats.health)
	titan:SetBaseMaxHealth(stats.health)
	titan:SetHealth(stats.health)

	titan:SetBaseDamageMin(stats.damage_min)
	titan:SetBaseDamageMax(stats.damage_max)
	titan:SetPhysicalArmorBaseValue(stats.armor)
end


function TitanSpawner:SpawnTitan(team, location, target, round)
	--print("TitanSpawner:SpawnTitan")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan.is_titan = true
	titan:AddNewModifier(titan, nil, "modifier_titan", {})

	local stats = TitanSpawner:CalculateStats(team, round)
	TitanSpawner:ApplyStats(titan, stats)
end
