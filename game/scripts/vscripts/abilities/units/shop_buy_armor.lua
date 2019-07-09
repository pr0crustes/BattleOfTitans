
shop_buy_armor = class({})


function shop_buy_armor:GetIntrinsicModifierName()
    return "modifier_shop_bought_armor"
end


function shop_buy_armor:GetManaCost(iLevel)
    if not self.used_count then
        self.used_count = 0
    end
    return self.used_count * self:GetSpecialValueFor("use_gold_cost_increase") + self:GetSpecialValueFor("base_gold_cost")
end


function shop_buy_armor:OnSpellStart()
    print("On shop_buy_armor Start")

    if not self.used_count then
        self.used_count = 0
    end

    self.used_count = self.used_count + 1

    self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(self.used_count)
end



LinkLuaModifier("modifier_shop_bought_armor", "abilities/units/shop_buy_armor.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shop_bought_armor = class({})


function modifier_shop_bought_armor:IsHidden()
    return false
end


function modifier_shop_bought_armor:IsDebuff()
    return false
end


function modifier_shop_bought_armor:GetTexture()
    return "dragon_knight_dragon_tail"
end
