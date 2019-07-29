LinkLuaModifier("ancient_armor", "modifiers/ancient_armor", LUA_MODIFIER_MOTION_NONE)


function ShopHandler_OnAncientArmorChange(team, bonus_key)
    local ancient = GetTeamAncient(team)
    local bonus = BShop:GetBonus(team, bonus_key)

    if ancient and bonus then
        if not ancient:HasModifier("ancient_armor") then
            ancient:AddNewModifier(ancient, nil, "ancient_armor", {})
        end

        ancient:FindModifierByName("ancient_armor"):SetStackCount(bonus)
    end
end


function ShopHandler_OnAncientHealAuraChange(team, bonus_key)
    local ancient = GetTeamAncient(team)
    local bonus = BShop:GetBonus(team, bonus_key)

    if ancient and bonus and bonus >= 1 then
        if not ancient:FindAbilityByName("shop_ancient_heal_aura") then
            ancient:AddAbility("shop_ancient_heal_aura"):SetLevel(1)
        end
    end
end
