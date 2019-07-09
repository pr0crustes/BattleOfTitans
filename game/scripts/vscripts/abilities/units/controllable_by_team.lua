
function OnCreated(keys)
    local caster = keys.caster

    local heroes = get_team_heroes(caster:GetTeam())

    for k, v in pairs(heroes) do
        print("Setting SetControllableByPlayer")
        caster:SetControllableByPlayer(v:GetPlayerID(), true)
    end
end
