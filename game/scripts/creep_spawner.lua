
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
end


function CreepSpawner:SpawnCreeps(round)
	print("CreepSpawner:SpawnCreeps")

	local titan = CreateUnitByName("npc_team_titan", location, true, nil, nil, team)
	titan:AddNewModifier(titan, nil, "modifier_titan_round_buff", { round = round })
	titan:CreatureLevelUp(round)

	titan:SetContextThink(
		DoUniqueString("SpawnCreepsAttackThink"),
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
	for i = 0, count do
		if CreepSpawner.current_alive_creeeps > CreepSpawner.MAX_CREEP_COUNT then
			return
		end

		local creep = CreateUnitByName(creep_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)

		if creep then
			creep.is_custom_spawned = true
			CreepSpawner.current_alive_creeeps = CreepSpawner.current_alive_creeeps + 1
		end
	end
end
