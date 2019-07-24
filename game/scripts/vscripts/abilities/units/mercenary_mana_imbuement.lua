
mercenary_mana_imbuement = class({})

function mercenary_mana_imbuement:GetIntrinsicModifierName()
    return "modifier_mercenary_mana_imbuement"
end


LinkLuaModifier("modifier_mercenary_mana_imbuement", "abilities/units/mercenary_mana_imbuement.lua", LUA_MODIFIER_MOTION_NONE)

modifier_mercenary_mana_imbuement = class({})

function modifier_mercenary_mana_imbuement:IsHidden()
    return true
end

function modifier_mercenary_mana_imbuement:IsDebuff()
    return false
end

function modifier_mercenary_mana_imbuement:IsPurgable()
    return false
end

function modifier_mercenary_mana_imbuement:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_mercenary_mana_imbuement:OnDeath(keys)
    if IsServer() then
        local unit = keys.unit
        local attacker = keys.attacker

        if self:GetParent() == unit then
            
        end
    end
end
