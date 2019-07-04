
modifier_titan_round_buff = class({})


function modifier_titan_round_buff:IsDebuff()
    return false
end


function modifier_titan_round_buff:IsPurgable()
    return false
end


function modifier_titan_round_buff:IsPermanent()
    return true
end


function modifier_titan_round_buff:OnCreated(keys)

end


function modifier_titan_round_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end


function modifier_titan_round_buff:GetModifierPreAttack_BonusDamage()
    return 0
end


function modifier_titan_round_buff:GetModifierPhysicalArmorBonus()
    return 0
end


function modifier_titan_round_buff:GetModifierMagicalResistanceBonus()
    return 0
end


function modifier_titan_round_buff:GetModifierConstantHealthRegen()
    return 0
end


function modifier_titan_round_buff:GetModifierPercentageManaRegen()
    return 0
end


function modifier_titan_round_buff:GetModifierHealthBonus()
    return 0
end
