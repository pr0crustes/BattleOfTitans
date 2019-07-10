require "lib/shop_spell_factory"


shop_buy_armor_dire = shop_spell_factory("modifier_shop_bought_armor_dire", "custom_shops", "shop_buy_armor_dire")


LinkLuaModifier("modifier_shop_bought_armor_dire", "abilities/units/shop/shop_buy_armor_dire.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shop_bought_armor_dire = shop_spell_factory_factory("dragon_knight_dragon_tail")
