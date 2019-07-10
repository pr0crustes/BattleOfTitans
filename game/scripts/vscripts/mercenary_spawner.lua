LinkLuaModifier("modifier_mercenary", "modifiers/modifier_mercenary.lua", LUA_MODIFIER_MOTION_NONE)



if MercenarySpawner == nil then
    MercenarySpawner = class({})
end


function MercenarySpawner:SetupSpawners()
    MercenarySpawner:SpawnFromPointName("spawner_mercenary_1", "npc_dota_neutral_prowler_shaman")
    MercenarySpawner:SpawnFromPointName("spawner_mercenary_2", "npc_dota_neutral_elder_jungle_stalker")
end


function MercenarySpawner:SpawnFromPointName(point_name, mercenary_name)
	local points = Entities:FindAllByName(point_name)
	for i, point in pairs(points) do
		MercenarySpawner:Spawn(point:GetAbsOrigin(), mercenary_name)
	end
end


function MercenarySpawner:Spawn(pos, mercenary_name)
	local mercenary = CreateUnitByName(mercenary_name, pos, true, nil, nil, team)
	mercenary:AddNewModifier(mercenary, nil, "modifier_mercenary", {spawn_pos = pos})
end
