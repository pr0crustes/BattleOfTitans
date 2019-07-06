--[[
    DISCLAIMER:
    This file is heavily inspired and based on the open sourced code from Angel Arena Black Star, respecting their Apache-2.0 License.
    Thanks to Angel Arena Black Star.
]]


if EndScreen == nil then
    EndScreen = class({})
end


function EndScreen:FormatNumber(number)
    local as_string = tostring(math.floor(number))
    if number < 1000 then
        return as_string
    end

    local len = as_string:len()
    local split_point = len - 3

    return as_string:sub(1, split_point) .. "." .. as_string:sub(split_point, len - 3) .. "K"
end



function EndScreen:BuildDataForPlayer(playerID, hero)
    local playerInfo = {
        steamid = tostring(PlayerResource:GetSteamID(playerID)),
        level = hero:GetLevel(),
        heroName = hero:GetName(),

        kills = PlayerResource:GetKills(playerID),
        deaths = PlayerResource:GetDeaths(playerID),
        assists = PlayerResource:GetAssists(playerID),

        gold = EndScreen:FormatNumber(PlayerResource:GetTotalGoldSpent(playerID) + PlayerResource:GetGold(playerID)),

        creepLastHits = PlayerResource:GetLastHits(playerID),

        goldPerMin = EndScreen:FormatNumber(PlayerResource:GetGoldPerMin(playerID)),
        xpPerMin = EndScreen:FormatNumber(PlayerResource:GetXPPerMin(playerID)),

        str = hero:GetStrength(),
        agi = hero:GetAgility(),
        int = hero:GetIntellect(),

        items = {}
    }

    for item_slot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
        local item = hero:GetItemInSlot(item_slot)
        if item then
            playerInfo.items[item_slot] = item:GetAbilityName()
        end
    end

    return playerInfo
end



function EndScreen:BuildData(winner_team)
    local time = GameRules:GetDOTATime(false, true)
    local matchID = tostring(GameRules:GetMatchID())

    local data = {
        version = "1.0.1",
        matchID = matchID,
        mapName = GetMapName(),
        players = {},
        winner = winner_team,
        duration = math.floor(time),
        flags = {}
    }

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) then
            local hero = PlayerResource:GetSelectedHeroEntity(playerID)
            if IsValidEntity(hero) then
                data.players[playerID] = EndScreen:BuildDataForPlayer(playerID, hero)
            end
        end
    end
    return data
end


function EndScreen:Setup(winner_team)
    --print("Winning team is ", winner_team)
    local data = EndScreen:BuildData(winner_team)

    CustomNetTables:SetTableValue("end_game_scoreboard", "game_info", data)
end
