require "titan_buff_calculator"


modifier_titan_round_buff = class({})


function modifier_titan_round_buff:IsHidden()
    return true
end


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
    self.buffs = {}
    if IsServer() then
        self.buffs = TitanBuffCalculator:CalculateBuffs(keys.round)
    end
    if IsClient() then
        self.buffs = TitanBuffCalculator:GetBuffsOnClient()
    end

    self.bonus_damage = self.buffs.bonus_damage or 0
    self.bonus_armor = self.buffs.bonus_armor or 0
    self.bonus_magic_res = self.buffs.bonus_magic_res or 0
    self.bonus_health_regen = self.buffs.bonus_health_regen or 0
    self.bonus_mana_regen = self.buffs.bonus_mana_regen or 0
    self.bonus_health = self.buffs.bonus_health or 0
end


function modifier_titan_round_buff:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end


function modifier_titan_round_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
end


function modifier_titan_round_buff:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end


function modifier_titan_round_buff:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


function modifier_titan_round_buff:GetModifierMagicalResistanceBonus()
    return self.bonus_magic_res
end


function modifier_titan_round_buff:GetModifierConstantHealthRegen()
    return self.bonus_health_regen
end


function modifier_titan_round_buff:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end


function modifier_titan_round_buff:GetModifierHealthBonus()
    return self.bonus_health
end


function modifier_titan_round_buff:GetModifierProvidesFOWVision()
    return 1
end
