
function OnCreated(keys)
    local caster = keys.caster

    for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:GetTeam(playerID) == caster:GetTeam() then
            caster:SetControllableByPlayer(playerID, true)
        end
    end
end
