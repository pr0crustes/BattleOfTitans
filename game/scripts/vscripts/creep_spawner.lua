
if CreepSpawner == nil then
	CreepSpawner = class({})

	CreepSpawner.SPAWNERS = LoadKeyValues("scripts/config/creeps.txt")
end


function CreepSpawner:MinSpawnAmount(round)
	if round <= 4 then
		return 1
	end
	if round <= 16 then
		return 2
	end
	if round <= 26 then
		return 3
	end
	if round <= 36 then
		return 4
	end
	return 5
end


function CreepSpawner:MaxSpawnAmount(round)
	if round <= 3 then
		return 1
	end
	return CreepSpawner:MinSpawnAmount(round) + 1
end


function CreepSpawner:SpawnCreeps(round)
	--print("CreepSpawner:SpawnCreeps")

	local min_count = CreepSpawner:MinSpawnAmount(round)
	local max_count = CreepSpawner:MaxSpawnAmount(round)

	for i, spawner_info in pairs(CreepSpawner.SPAWNERS) do
		local spawner_name = spawner_info["spawner_name"]
		local disable_amount = spawner_info["disable_amount"]
		local creeps = spawner_info["creeps"]

		CreepSpawner:SpawnCreepsAtPoint(spawner_name, creeps, min_count, max_count, disable_amount, round)
	end
end


function CreepSpawner:SpawnCreepsAtPoint(point_name, creep_list, min_count, max_count, disable_amount, round)
	--print("CreepSpawner:SpawnCreepsAtPoint")

	local points = Entities:FindAllByName(point_name)

	for i, point in pairs(points) do
		local spawn_pos = point:GetAbsOrigin()
		local foward_vector = point:GetForwardVector()

		local nearby_creeps = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, spawn_pos, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false)

		if #nearby_creeps < disable_amount then
			local count = RandomInt(min_count, max_count)
			CreepSpawner:SpawnCreepsAtPos(spawn_pos, foward_vector, creep_list, count, round)
		end
	end
end


function CreepSpawner:SpawnCreepsAtPos(pos, foward_vector, creep_list, count, round)
	--print("CreepSpawner:SpawnCreepsAtPos")

	local stats_multiplier = 1 + ((round - 1) * 0.04)
	local bounty_multiplier = 1 + ((round - 1) * 0.08)

	for i = 1, count do
		local creep_name = random_from_table(values_from_dict(creep_list))
		--print("Spawning creep ", creep_name)
		local creep = CreateUnitByName(creep_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)

		if creep then
			creep.is_custom_spawned_creep = true

			creep:SetForwardVector(foward_vector)

			creep:SetDeathXP(creep:GetDeathXP() * bounty_multiplier)

			creep:SetMinimumGoldBounty(creep:GetMinimumGoldBounty() * bounty_multiplier + round)
			creep:SetMaximumGoldBounty(creep:GetMaximumGoldBounty()  * bounty_multiplier + round)

			creep:SetMaxHealth(creep:GetMaxHealth() * stats_multiplier)
			creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() * stats_multiplier)
			creep:SetHealth(creep:GetMaxHealth() * stats_multiplier)

			creep:SetBaseDamageMin(creep:GetBaseDamageMin() * stats_multiplier)
			creep:SetBaseDamageMax(creep:GetBaseDamageMax() * stats_multiplier)
			creep:SetBaseMoveSpeed(creep:GetBaseMoveSpeed() * stats_multiplier)

			creep:SetPhysicalArmorBaseValue(creep:GetPhysicalArmorBaseValue() + ((round - 1) * 0.4))
		end
	end
end


function CreepSpawner:OnSpawnedCreepDeath(event)
	--print("CreepSpawner:OnSpawnedCreepDeath(event)")
end
