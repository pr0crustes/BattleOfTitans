
ancient_armor = class({})


function ancient_armor:IsHidden()
    return true
end


function ancient_armor:IsDebuff()
    return false
end


function ancient_armor:IsPurgable()
    return false
end


function ancient_armor:IsPermanent()
    return true
end


function ancient_armor:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


function ancient_armor:GetModifierPhysicalArmorBonus()
    return 1 * self:GetStackCount()
end
