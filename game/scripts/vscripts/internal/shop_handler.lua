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
