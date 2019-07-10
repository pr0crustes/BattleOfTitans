require "lib/shop_spell_factory"


-- Start Armor
shop_buy_armor_dire = shop_spell_factory("modifier_shop_bought_armor", "custom_shops", "shop_buy_armor_dire")
shop_buy_armor_radiant = shop_spell_factory("modifier_shop_bought_armor", "custom_shops", "shop_buy_armor_radiant")

LinkLuaModifier("modifier_shop_bought_armor", "abilities/units/shop_buy.lua", LUA_MODIFIER_MOTION_NONE)
modifier_shop_bought_armor = shop_spell_factory_factory("dragon_knight_dragon_tail")
-- End Armor
