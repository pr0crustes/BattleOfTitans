
if CreepSpawner == nil then
	CreepSpawner = class({})

	CreepSpawner.MAX_CREEP_PER_CAMP = 30

	CreepSpawner.SPAWNERS = LoadKeyValues("scripts/config/creeps.txt")
end


function CreepSpawner:MinSpawnAmount(round)
	if round == 1 then
		return 2
	end
	return math.min(math.floor(round * 0.5) + 1, 5)
end


function CreepSpawner:MaxSpawnAmount(round)
	if round == 1 then
		return 2
	end
	return math.min(round + 1, 6)
end


function CreepSpawner:SpawnCreeps(round)
	print("CreepSpawner:SpawnCreeps")

	local min_count = CreepSpawner:MinSpawnAmount(round)
	local max_count = CreepSpawner:MaxSpawnAmount(round)

	for team, spawn_info in pairs(CreepSpawner.SPAWNERS) do
		for spawner_name, creep_list in pairs(spawn_info) do
			CreepSpawner:SpawnCreepsAtPoint(spawner_name, creep_list, min_count, max_count, round)
		end
	end
end


function CreepSpawner:SpawnCreepsAtPoint(point_name, creep_list, min_count, max_count, round)
	--print("CreepSpawner:SpawnCreepsAtPoint")

	local point = Entities:FindByName(nil, point_name)
	local spawn_pos = point:GetAbsOrigin()

	local nearby_creeps = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, spawn_pos, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

	if nearby_creeps and #nearby_creeps < CreepSpawner.MAX_CREEP_PER_CAMP then
		local count = RandomInt(min_count, max_count)
		CreepSpawner:SpawnCreepsAtPos(spawn_pos, creep_list, count, round)
	end
end


function CreepSpawner:SpawnCreepsAtPos(pos, creep_list, count, round)
	--print("CreepSpawner:SpawnCreepsAtPos")

	local round_multiplier = 1 + ((round - 1) * 0.08)
	local round_multiplier_plus = 1 + ((round - 1) * 0.16)

	for i = 1, count do
		local creep_name = random_from_table(values_from_dict(creep_list))
		--print("Spawning creep ", creep_name)
		local creep = CreateUnitByName(creep_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)

		if creep then
			creep.is_custom_spawned_creep = true

			creep:SetDeathXP(creep:GetDeathXP() * round_multiplier_plus)

			creep:SetMinimumGoldBounty(creep:GetMinimumGoldBounty() * round_multiplier_plus)
			creep:SetMaximumGoldBounty(creep:GetMaximumGoldBounty()  * round_multiplier_plus)

			creep:SetMaxHealth(creep:GetMaxHealth() * round_multiplier)
			creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() * round_multiplier)
			creep:SetHealth(creep:GetMaxHealth() * round_multiplier)

			creep:SetBaseDamageMin(creep:GetBaseDamageMin() * round_multiplier)
			creep:SetBaseDamageMax(creep:GetBaseDamageMax() * round_multiplier)
			creep:SetBaseMoveSpeed(creep:GetBaseMoveSpeed() * round_multiplier)

			creep:SetPhysicalArmorBaseValue(creep:GetPhysicalArmorBaseValue() + ((round - 1) * 0.5))
		end
	end
end


function CreepSpawner:OnSpawnedCreepDeath(event)
	--print("CreepSpawner:OnSpawnedCreepDeath(event)")
end
