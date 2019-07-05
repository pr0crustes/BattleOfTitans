
if CreepSpawner == nil then
	CreepSpawner = class({})

    CreepSpawner.current_alive_creeeps = 0
	CreepSpawner.MAX_CREEP_COUNT = 700

	CreepSpawner.ANCIENT_CREEP_LIST = [
		"npc_dota_neutral_big_thunder_lizard",
		"npc_dota_neutral_black_dragon",
		"npc_dota_neutral_black_drake",
		"npc_dota_neutral_elder_jungle_stalker",
		"npc_dota_neutral_granite_golem",
		"npc_dota_neutral_jungle_stalker",
		"npc_dota_neutral_prowler_acolyte",
		"npc_dota_neutral_prowler_shaman",
		"npc_dota_neutral_rock_golem",
		"npc_dota_neutral_small_thunder_lizard"
	]

	CreepSpawner.NORMAL_CREEP_LIST = [
		"npc_dota_neutral_alpha_wolf",
		"npc_dota_neutral_centaur_khan",
		"npc_dota_neutral_centaur_outrunner",
		"npc_dota_neutral_dark_troll",
		"npc_dota_neutral_dark_troll_warlord",
		"npc_dota_neutral_enraged_wildkin",
		"npc_dota_neutral_fel_beast",
		"npc_dota_neutral_forest_troll_berserker",
		"npc_dota_neutral_forest_troll_high_priest",
		"npc_dota_neutral_ghost",
		"npc_dota_neutral_giant_wolf",
		"npc_dota_neutral_gnoll_assassin",
		"npc_dota_neutral_harpy_scout",
		"npc_dota_neutral_harpy_storm",
		"npc_dota_neutral_kobold",
		"npc_dota_neutral_kobold_taskmaster",
		"npc_dota_neutral_kobold_tunneler",
		"npc_dota_neutral_mud_golem",
		"npc_dota_neutral_mud_golem_split",
		"npc_dota_neutral_ogre_magi",
		"npc_dota_neutral_ogre_mauler",
		"npc_dota_neutral_polar_furbolg_champion",
		"npc_dota_neutral_polar_furbolg_ursa_warrior",
		"npc_dota_neutral_satyr_hellcaller",
		"npc_dota_neutral_satyr_soulstealer",
		"npc_dota_neutral_satyr_trickster",
		"npc_dota_neutral_wildkin",
		"npc_dota_wraith_ghost"
	]

	CreepSpawner.SPAWNERS = LoadKeyValues("scripts/config/creeps.txt")
end


function CreepSpawner:MinSpawnAmount(round)
	if round == 1 then
		return 2
	end
	return math.floor(math.max((round * 0.4) + 1, 10))
end


function CreepSpawner:MaxSpawnAmount(round)
	if round == 1 then
		return 2
	end
	return math.ceil(math.max((round * 0.75) + 1, 10))
end


function CreepSpawner:SpawnCreeps(round)
	print("CreepSpawner:SpawnCreeps")

	local min_count = CreepSpawner:MinSpawnAmount(round)
	local max_count = CreepSpawner:MaxSpawnAmount(round)

	for spawner_name, creep_list in pairs(CreepSpawner.SPAWNERS["radiant"]) do
		CreepSpawner:SpawnCreepsAtPoints(spawner_name, creep_list, min_count, max_count, round)
	end

	for spawner_name, creep_list in pairs(CreepSpawner.SPAWNERS["dire"]) do
		CreepSpawner:SpawnCreepsAtPoints(spawner_name, creep_list, min_count, max_count, round)
	end
end


function CreepSpawner:SpawnCreepsAtPoints(point_name, creep_list, min_count, max_count, round)
    local all_points = Entities:FindAllByName(nil, point_name)

    for k, point in pairs(all_points) do
        local spawn_pos = point:GetAbsOrigin()
		local count = RandomInt(min_count, max_count)
		local creep_name = random_from_table(creep_list)

        CreepSpawner:SpawnCreepsAtPos(spawn_pos, creep_name, count, round)
    end
end


function CreepSpawner:SpawnCreepsAtPos(pos, creep_name, count, round)
	local round_multiplier = 1 + (round * 0.1)

	for i = 0, count do
		if CreepSpawner.current_alive_creeeps > CreepSpawner.MAX_CREEP_COUNT then
			return
		end

		local creep = CreateUnitByName(creep_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)

		if creep then
			creep.is_custom_spawned = true
			CreepSpawner.current_alive_creeeps = CreepSpawner.current_alive_creeeps + 1

			creep:SetMaxHealth(creep:GetMaxHealth() * round_multiplier)
			creep:SetPhysicalArmorBaseValue(creep:GetPhysicalArmorBaseValue() * round_multiplier)

			creep:SetDeathXP(creep:GetDeathXP() * round_multiplier)

			creep:SetMinimumGoldBounty(creep:GetMinimumGoldBounty() * round_multiplier)
			creep:SetMaximumGoldBounty(creep:GetMaximumGoldBounty() * round_multiplier)
		end
	end
end
