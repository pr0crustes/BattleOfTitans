
shop_buff = class({})


function shop_buff:GetIntrinsicModifierName()
    return "modifier_shop_buff"
end



LinkLuaModifier("modifier_shop_buff", "abilities/units/shop_buff.lua", LUA_MODIFIER_MOTION_NONE)


modifier_shop_buff = class({})


function modifier_shop_buff:IsHidden()
    return true
end


function modifier_shop_buff:IsDebuff()
    return false
end


function modifier_shop_buff:IsPurgable()
    return false
end


function modifier_shop_buff:IsPermanent()
    return true
end


function modifier_shop_buff:CheckState()
	return {
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end


function modifier_shop_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
end


function modifier_shop_buff:GetModifierProvidesFOWVision()
    return 1
end
