
if CreepSpawner == nil then
	CreepSpawner = class({})
end


CreepSpawner.CURRENT_ALIVE_CREEPS = 0
CreepSpawner.MAX_CREEP_COUNT = 700

CreepSpawner.SPAWNERS = LoadKeyValues("scripts/config/creeps.txt")


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
	print("CreepSpawner:SpawnCreepsAtPoint")

	local point = Entities:FindByName(nil, point_name)

	local spawn_pos = point:GetAbsOrigin()
	local count = RandomInt(min_count, max_count)
	print("Count ", count, min_count, max_count)

	CreepSpawner:SpawnCreepsAtPos(spawn_pos, creep_list, count, round)
end


function CreepSpawner:SpawnCreepsAtPos(pos, creep_list, count, round)
	print("CreepSpawner:SpawnCreepsAtPos")

	local round_multiplier = 1 + (round * 0.1)

	for i = 1, count do
		if CreepSpawner.CURRENT_ALIVE_CREEPS > CreepSpawner.MAX_CREEP_COUNT then
			return
		end

		local creep_name = random_from_table(values_from_dict(creep_list))
		print("Spawning creep ", creep_name)
		local creep = CreateUnitByName(creep_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)

		if creep then
			creep.is_custom_spawned_creep = true
			CreepSpawner.CURRENT_ALIVE_CREEPS = CreepSpawner.CURRENT_ALIVE_CREEPS + 1

			creep:SetMaxHealth(creep:GetMaxHealth() * round_multiplier)
			creep:SetHealth(creep:GetMaxHealth())
			creep:SetPhysicalArmorBaseValue(creep:GetPhysicalArmorBaseValue() * round_multiplier)

			creep:SetDeathXP(creep:GetDeathXP() * round_multiplier)

			creep:SetMinimumGoldBounty(creep:GetMinimumGoldBounty() * round_multiplier)
			creep:SetMaximumGoldBounty(creep:GetMaximumGoldBounty() * round_multiplier)
		end
	end
end


function CreepSpawner:OnSpawnedCreepDeath(event)
	print("CreepSpawner:OnSpawnedCreepDeath(event)")
	CreepSpawner.CURRENT_ALIVE_CREEPS = CreepSpawner.CURRENT_ALIVE_CREEPS - 1
end
