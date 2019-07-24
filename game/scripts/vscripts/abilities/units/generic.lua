
function OnDeathDropItem(keys)
    local unit = keys.unit
    local caster = keys.caster
    local ability = keys.ability
    local item_name = keys.item_name

    if unit == caster then
        local item = CreateItem(item_name, nil, nil)
        item:SetPurchaseTime(0)

        local drop = CreateItemOnPositionSync(unit:GetAbsOrigin(), item)
    end
end
