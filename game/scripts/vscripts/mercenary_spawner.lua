LinkLuaModifier("modifier_mercenary", "modifiers/modifier_mercenary.lua", LUA_MODIFIER_MOTION_NONE)


if MercenarySpawner == nil then
    MercenarySpawner = class({})
end


function MercenarySpawner:SetupSpawners()
    print("MercenarySpawner:SetupSpawners")
    MercenarySpawner:SpawnFromPointName("spawner_mercenary_1", "npc_dota_neutral_prowler_shaman", 60 * 6)
    MercenarySpawner:SpawnFromPointName("spawner_mercenary_2", "npc_dota_neutral_satyr_trickster", 60 * 5)
end


function MercenarySpawner:SpawnFromPointName(point_name, mercenary_name, respawn_time)
	local points = Entities:FindAllByName(point_name)
	for i, point in pairs(points) do
		MercenarySpawner:Spawn(point:GetAbsOrigin(), mercenary_name, respawn_time)
	end
end


function MercenarySpawner:Spawn(pos, mercenary_name, respawn_time)
	local mercenary = CreateUnitByName(mercenary_name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)
	mercenary:AddNewModifier(mercenary, nil, "modifier_mercenary", {
        spawn_pos_x = pos.x,
        spawn_pos_y = pos.y,
        spawn_pos_z = pos.z,
        respawn_time = respawn_time,
    })
end
