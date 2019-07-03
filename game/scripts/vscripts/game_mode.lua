
if GameMode == nil then
	GameMode = class({})
end



function GameMode:InitGameMode()
	self.round = 1

	self.ancient_radiant = Entities:FindByName(nil, "dota_goodguys_fort")
	self.ancient_dire = Entities:FindByName(nil, "npc_dota_badguys_fort")

	self.titan_spawn_radiant = Entities:FindByName(nil, "titan_spawn_radiant")
	self.titan_spawn_dire = Entities:FindByName(nil, "titan_spawn_dire")

	GameRules:SetCustomGameSetupAutoLaunchDelay(3.0)
	GameRules:SetTimeOfDay(0.75)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetHeroSelectionTime(40.0)
	GameRules:SetPreGameTime(15.0)
	GameRules:SetStrategyTime(10.0)
	GameRules:SetPostGameTime(30.0)
	GameRules:SetTreeRegrowTime(60.0)

	GameRules:SetGoldPerTick(1.2)
	GameRules:SetGoldTickTime(0.5)

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
			local victim_name = victim_unit:GetName()
			local attacker_name = attacker_unit:GetName()

			if victim_name:find("_fort", 1, true) and not attacker_name:find("team_titan", 1, true) then
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
		GameRules:GetGameModeEntity():SetThink("SpawnTitans", self, 180)
	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
		GameRules:SetSafeToLeave(true)
		end_screen_setup(true)
	end
end


function GameMode:SpawnTitans()
	TitanSpawner:SpawnTitan(DOTA_TEAM_GOODGUYS, self.titan_spawn_radiant:GetAbsOrigin(), self.ancient_dire, self.round)
	TitanSpawner:SpawnTitan(DOTA_TEAM_BADGUYS, self.titan_spawn_dire:GetAbsOrigin(), self.ancient_radiant, self.round)
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
	end
end
