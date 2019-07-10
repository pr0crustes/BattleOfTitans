
if GameMode == nil then
	GameMode = class({})
end



function GameMode:InitGameMode()
	self.titan_round = 1
	self.creep_round = 1

	self.titan_interval = 60 * 5
	self.creep_interval = 60

	self.titan_countdown = self.titan_interval

	self.gold_share = 0.15
	self.experience_share = 0.15

	self.ancient_radiant = Entities:FindByName(nil, "dota_goodguys_fort")
	self.ancient_dire = Entities:FindByName(nil, "dota_badguys_fort")

	self.titan_spawn_radiant = Entities:FindByName(nil, "titan_spawn_radiant")
	self.titan_spawn_dire = Entities:FindByName(nil, "titan_spawn_dire")

	self.radiant_defense_shop = nil
	self.radiant_offense_shop = nil
	self.dire_offense_shop = nil
	self.dire_defense_shop = nil

	GameRules:SetShowcaseTime(0)

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
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)
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


function GameMode:ExperienceFilter(keys)
	local player_id = keys.player_id_const
	local reason = keys.reason_const
	local experience = keys.experience

	local hero = player_id and PlayerResource:GetSelectedHeroEntity(player_id)

	-- Start Share XP
	local team_heroes = get_team_heroes(PlayerResource:GetTeam(player_id))
	local count = #team_heroes

	local share_slice = experience * self.experience_share
	local share_amount = math.ceil(share_slice / count)

	keys.experience = keys.experience - share_slice

	for i, hero in pairs(team_heroes) do
		hero:AddExperience(share_amount, DOTA_ModifyXP_Unspecified, false, true)
	end
	-- End Share XP

	return true
end


function GameMode:GoldFilter(keys)
	local player_id = keys.player_id_const
	local reason = keys.reason_const
	local gold = keys.gold
	local reliable = keys.reliable

	local hero = player_id and PlayerResource:GetSelectedHeroEntity(player_id)

	-- Start Share Gold
	local team_heroes = get_team_heroes(PlayerResource:GetTeam(player_id))
	local count = #team_heroes

	local share_slice = gold * self.gold_share
	local share_amount = math.ceil(share_slice / count)

	keys.gold = keys.gold - share_slice

	for i, hero in pairs(team_heroes) do
		PlayerResource:ModifyGold(hero:GetPlayerID(), share_amount, (1 == keys.reliable), DOTA_ModifyGold_SharedGold)
	end
	-- End Share Gold

	return true
end


-- Only call this after DOTA_GAMERULES_STATE_POST_GAME
function GameMode:GetWinningTeam()
	if not self.ancient_dire:IsAlive() then
		return DOTA_TEAM_GOODGUYS
	end

	if not self.ancient_radiant:IsAlive() then
		return DOTA_TEAM_BADGUYS
	end

	return DOTA_TEAM_NOTEAM
end


function GameMode:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_PRE_GAME then
		self.radiant_defense_shop = CreateUnitByName("radiant_defense_shop", Vector(-5000, -3500, 264), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.radiant_offense_shop = CreateUnitByName("radiant_offense_shop", Vector(-3500, -5000, 264), true, nil, nil, DOTA_TEAM_GOODGUYS)
		self.dire_offense_shop = CreateUnitByName("dire_offense_shop", Vector(5000, 3500, 264), true, nil, nil, DOTA_TEAM_BADGUYS)
		self.dire_defense_shop = CreateUnitByName("dire_defense_shop", Vector(3500, 5000, 264), true, nil, nil, DOTA_TEAM_BADGUYS)

		self.radiant_offense_shop:SetForwardVector(Vector(0, 1, 0))
		self.dire_defense_shop:SetForwardVector(Vector(0, -1, 0))
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:SpawnCreeps()
		GameRules:GetGameModeEntity():SetThink("SpawnCreeps", self, self.creep_interval)
		GameRules:GetGameModeEntity():SetThink("TitanThink", self, 1.0)
	elseif state == DOTA_GAMERULES_STATE_POST_GAME then
		GameRules:SetSafeToLeave(true)
		EndScreen:Setup(self:GetWinningTeam())
	end
end


function GameMode:OrderFilter(keys)
	local ability = keys.entindex_ability and EntIndexToHScript(keys.entindex_ability)
	local target_unit = keys.entindex_target and EntIndexToHScript(keys.entindex_target)
	local playerID = keys.issuer_player_id_const
	local order_type = keys.order_type
	local pos = Vector(keys.position_x, keys.position_y, keys.position_z)
	local queue = keys.queue
	local sequence_number = keys.sequence_number_const
	local units = keys.units

	if order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		if ability and string.find(ability:GetAbilityName(), "shop_buy_") then
			ability.buyer = playerID
		end
	end

	return true
end


function GameMode:TitanThink()

	if self.titan_countdown <= 0 then
		self:SpawnTitans()

		self.titan_countdown = self.titan_interval
	else
		self.titan_countdown = self.titan_countdown - 1
	end

    local minutes = math.floor(self.titan_countdown / 60)
	local seconds = self.titan_countdown - (minutes * 60)

	local m10 = math.floor(minutes / 10)
    local m01 = minutes - (m10 * 10)
    local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)

    local timer_text = m10 .. m01 .. ":" .. s10 .. s01

    local text_color = "#FFFFFF"
    if self.titan_countdown < 20 then
        text_color = "#FF0000"
    end

    local data = {
        string = "#titan_timer",
        time_string = timer_text,
        color = text_color,
	}

    CustomGameEventManager:Send_ServerToAllClients("titan_countdown_update", data)

	return 1.0
end


function GameMode:SpawnTitans()
	Notifications:TopToAll({text="The Titans Are Emerging", duration=6})
	TitanSpawner:SpawnTitan(DOTA_TEAM_GOODGUYS, self.titan_spawn_radiant:GetAbsOrigin(), self.ancient_dire, self.titan_round)
	TitanSpawner:SpawnTitan(DOTA_TEAM_BADGUYS, self.titan_spawn_dire:GetAbsOrigin(), self.ancient_radiant, self.titan_round)

	self.titan_round = self.titan_round + 1
end


function GameMode:SpawnCreeps()
	print("GameMode:SpawnCreeps")
	CreepSpawner:SpawnCreeps(self.creep_round)

	self.creep_round = self.creep_round + 1

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


function GameMode:OnEntitySpawned(keys)
	local unit = EntIndexToHScript(keys.entindex)

	if unit then
		-- Pass
	end
end


function GameMode:OnEntityKilled(keys)
	local killed_unit = EntIndexToHScript(keys.entindex_killed)
	if killed_unit then
		if killed_unit:IsRealHero() and not killed_unit:IsReincarnating() then
			killed_unit:SetTimeUntilRespawn(killed_unit:GetRespawnTime() * 0.20)
		end

		if killed_unit.is_custom_spawned_creep then
			CreepSpawner:OnSpawnedCreepDeath(keys)
		end
	end
end
