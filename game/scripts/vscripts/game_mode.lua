
if GameMode == nil then
	GameMode = class({})
end



function GameMode:InitGameMode()
	self.round = 1
	self.titan_interval = 180
	self.creep_interval = 60

	self.ancient_radiant = Entities:FindByName(nil, "dota_goodguys_fort")
	self.ancient_dire = Entities:FindByName(nil, "dota_badguys_fort")

	self.titan_spawn_radiant = Entities:FindByName(nil, "titan_spawn_radiant")
	self.titan_spawn_dire = Entities:FindByName(nil, "titan_spawn_dire")

	GameRules:SetCustomGameSetupAutoLaunchDelay(3.0)
	GameRules:SetTimeOfDay(0.75)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetHeroSelectionTime(40.0)
	GameRules:SetPreGameTime(30.0)
	GameRules:SetStrategyTime(10.0)
	GameRules:SetPostGameTime(30.0)
	GameRules:SetTreeRegrowTime(60.0)

	GameRules:SetGoldPerTick(1.0)
	GameRules:SetGoldTickTime(0.4)

	ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameMode, "OnEntitySpawned"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(GameMode, "OnEntityKilled"), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GameMode, "OnGameRulesStateChange"), self)

	GameRules:GetGameModeEntity():SetThink("OnThink", self, 0.25)

	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
end


function GameMode:DamageFilter(keys)
	if keys.entindex_attacker_const and keys.entindex_victim_const then
		local attacker_unit = EntIndexToHScript(keys.entindex_attacker_const)
		local victim_unit = EntIndexToHScript(keys.entindex_victim_const)
		local damage_type = keys.damagetype_const
		local damage = keys.damage

		if attacker_unit and victim_unit then
			local victim_name = victim_unit:GetUnitName()
			local attacker_name = attacker_unit:GetUnitName()

			if string.find(victim_name, "_fort") and not string.find(attacker_name, "team_titan") then
				return false
			end
		end
	end


	return true
end


function GameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		-- Pass
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:SpawnTitans()
		GameRules:GetGameModeEntity():SetThink("SpawnTitans", self, self.titan_interval)
		self:SpawnCreeps()
		GameRules:GetGameModeEntity():SetThink("SpawnCreeps", self, self.creep_interval)
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
		GameRules:SetSafeToLeave(true)
		end_screen_setup(true)
	end
end


function GameMode:SpawnTitans()
	Notifications:TopToAll({text="The Titans Are Emerging", duration=6})
	TitanSpawner:SpawnTitan(DOTA_TEAM_GOODGUYS, self.titan_spawn_radiant:GetAbsOrigin(), self.ancient_dire, self.round)
	TitanSpawner:SpawnTitan(DOTA_TEAM_BADGUYS, self.titan_spawn_dire:GetAbsOrigin(), self.ancient_radiant, self.round)

	self.round = self.round + 1

	return self.titan_interval
end


function GameMode:SpawnCreeps()
	print("GameMode:SpawnCreeps()")
	CreepSpawner:SpawnCreeps(self.round)

	return self.creep_interval
end


function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- Pass
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end


function GameMode:OnEntitySpawned(event)
	local unit = EntIndexToHScript(event.entindex)

	if unit then
		-- Pass
	end
end


function GameMode:OnEntityKilled(event)
	local killed_unit = EntIndexToHScript(event.entindex_killed)
	if killed_unit then
		if killed_unit:IsRealHero() and not killed_unit:IsReincarnating() then
			killed_unit:SetTimeUntilRespawn(killed_unit:GetRespawnTime() * 0.33)
		end

		if killed_unit.is_custom_spawned_creep then
			CreepSpawner:OnSpawnedCreepDeath(event)
		end
	end
end
