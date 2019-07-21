
function OnDeath(keys)
    local unit = keys.unit
    local caster = keys.caster
    local ability = keys.ability

    if unit == caster then
        local level = caster:GetLevel()
        local bonus_gold = ability:GetSpecialValueFor("base_gold") + ability:GetSpecialValueFor("gold_per_level") * level
        local bonus_xp = ability:GetSpecialValueFor("base_experience") + ability:GetSpecialValueFor("experience_per_level") * level

        local enemy_heroes = get_team_heroes(caster:GetOpposingTeamNumber())

        for i, hero in pairs(enemy_heroes) do
            PlayerResource:ModifyGold(hero:GetPlayerID(), bonus_gold, true, DOTA_ModifyGold_RoshanKill)
            hero:AddExperience(bonus_xp, DOTA_ModifyXP_RoshanKill, false, true)
        end
    end
end
