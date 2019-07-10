require "lib/shop_spell_factory"


shop_buy_armor = shop_spell_factory("modifier_shop_bought_armor", "custom_shops", "shop_buy_armor_radiant")


LinkLuaModifier("modifier_shop_bought_armor", "abilities/units/shop_buy_armor.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shop_bought_armor = shop_spell_factory_factory("dragon_knight_dragon_tail")
