
function OnDeath(keys)
    local attacker = keys.attacker
    local unit = keys.unit
    local caster = keys.caster
    local ability = keys.ability

    if unit == caster then
        local minutes = TimeInMinutes()
        local bonus_gold = ability:GetSpecialValueFor("base_gold") + ability:GetSpecialValueFor("gold_per_minute") * minutes
        local bonus_xp = ability:GetSpecialValueFor("base_experience") + ability:GetSpecialValueFor("experience_per_minute") * minutes

        local heroes = get_team_heroes(attacker:GetTeam())

        for i, hero in pairs(heroes) do
            PlayerResource:ModifyGold(hero:GetPlayerID(), bonus_gold, true, DOTA_ModifyGold_RoshanKill)
            hero:AddExperience(bonus_xp, DOTA_ModifyXP_RoshanKill, false, true)
        end
    end
end
