LinkLuaModifier("ancient_armor", "modifiers/ancient_armor", LUA_MODIFIER_MOTION_NONE)

if ShopHandler == nil then
    ShopHandler = class({})
end


function ShopHandler:OnAncientArmorChange(team, bonus_key, bonus_dict)
    local ancient = GetTeamAncient(team)
    local bonus = bonus_dict["bonus"]

    if ancient and bonus then
        if not ancient:HasModifier("ancient_armor") then
            ancient:AddNewModifier(ancient, nil, "ancient_armor", {})
        end

        ancient:FindModifierByName("ancient_armor"):SetStackCount(bonus)
    end
end
