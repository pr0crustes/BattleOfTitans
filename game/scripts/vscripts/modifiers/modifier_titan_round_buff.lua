


if TitanBuffCalculator == nil then
    TitanBuffCalculator = class({})
end


function TitanBuffCalculator:CalculateBuffs(round)
    function bonus_life_for_round(n)
        if n <= 1 then
            return 1000
        end
        return (n * 1000) + bonus_life_for_round(n - 1)
    end

    print("CalculateBuffs... ", round, TitanBuffCalculator.last_calculated_round)

    if round ~= TitanBuffCalculator.last_calculated_round then
        print("Calculating")
        TitanBuffCalculator.last_calculated_values = {
            bonus_damage = round * 100,
            bonus_armor = round * 2,
            bonus_magic_res = round * 2,
            bonus_health_regen = round * 10,
            bonus_mana_regen = round * 10,
            bonus_health = bonus_life_for_round(round),
        }

        TitanBuffCalculator.last_calculated_round = round
    end

    print("returning...")

    return TitanBuffCalculator.last_calculated_values
end



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
    if IsServer() then
        self.round = keys.round

        self.buffs = TitanBuffCalculator:CalculateBuffs(self.round)
    end
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


function modifier_titan_round_buff:GetModifierConstantManaRegen()
    return 0
end


function modifier_titan_round_buff:GetModifierHealthBonus()
    return 0
end


function modifier_titan_round_buff:GetModifierProvidesFOWVision()
    return 1
end
