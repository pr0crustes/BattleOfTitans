
NO_HANDLER = function() end

TITAN_WAYPOINTS = {
    [DOTA_TEAM_GOODGUYS] = {
        "waypoint_radiant_1",
        "waypoint_radiant_2",
        "waypoint_radiant_3",
        "waypoint_radiant_4",
        "waypoint_radiant_5",
    },
    [DOTA_TEAM_BADGUYS] = {
        "waypoint_dire_1",
        "waypoint_dire_2",
        "waypoint_dire_3",
        "waypoint_dire_4",
        "waypoint_dire_5",
    },
}


PROJECTILES = {
    ["default"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
        ["ProjectileSpeed"] = "1000",
    },
    ["npc_dota_hero_bane"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_crystal_maiden"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_crystalmaiden/maiden_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_drow_ranger"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_drow/drow_base_attack.vpcf",
        ["ProjectileSpeed"] = "1250",
    },
    ["npc_dota_hero_mirana"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_mirana/mirana_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_nevermore"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_nevermore/nevermore_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_morphling"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
        ["ProjectileSpeed"] = "1300",
    },
    ["npc_dota_hero_puck"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_puck/puck_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_razor"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_razor/razor_base_attack.vpcf",
        ["ProjectileSpeed"] = "2000",
    },
    ["npc_dota_hero_storm_spirit"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_stormspirit/stormspirit_base_attack.vpcf",
        ["ProjectileSpeed"] = "1100",
    },
    ["npc_dota_hero_vengefulspirit"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",
        ["ProjectileSpeed"] = "1500",
    },
    ["npc_dota_hero_windrunner"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
        ["ProjectileSpeed"] = "1250",
    },
    ["npc_dota_hero_zuus"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
        ["ProjectileSpeed"] = "1100",
    },
    ["npc_dota_hero_lina"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
        ["ProjectileSpeed"] = "1000",
    },
    ["npc_dota_hero_lich"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_lich/lich_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_lion"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_lion/lion_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_shadow_shaman"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_shadowshaman/shadowshaman_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_witch_doctor"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_witchdoctor/witchdoctor_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_enigma"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_enigma/enigma_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_tinker"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_tinker/tinker_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_sniper"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf",
        ["ProjectileSpeed"] = "3000",
    },
    ["npc_dota_hero_necrolyte"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_necrolyte/necrolyte_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_warlock"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_warlock/warlock_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_queenofpain"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_queenofpain/queen_base_attack.vpcf",
        ["ProjectileSpeed"] = "1500",
    },
    ["npc_dota_hero_venomancer"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_death_prophet"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_death_prophet/death_prophet_base_attack.vpcf",
        ["ProjectileSpeed"] = "1000",
    },
    ["npc_dota_hero_pugna"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_pugna/pugna_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_templar_assassin"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_viper"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_viper/viper_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_luna"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_luna/luna_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_dazzle"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_dazzle/dazzle_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_leshrac"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_furion"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_furion/furion_base_attack.vpcf",
        ["ProjectileSpeed"] = "1125",
    },
    ["npc_dota_hero_clinkz"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_enchantress"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_huskar"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
        ["ProjectileSpeed"] = "1400",
    },
    ["npc_dota_hero_weaver"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_weaver/weaver_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_jakiro"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_jakiro/jakiro_base_attack.vpcf",
        ["ProjectileSpeed"] = "1100",
    },
    ["npc_dota_hero_batrider"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_batrider/batrider_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_chen"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_chen/chen_base_attack.vpcf",
        ["ProjectileSpeed"] = "1100",
    },
    ["npc_dota_hero_ancient_apparition"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_base_attack.vpcf",
        ["ProjectileSpeed"] = "1250",
    },
    ["npc_dota_hero_gyrocopter"] = {
        ["ProjectileSpeed"] = "3000",
        ["ProjectileModel"] = "particles/units/heroes/hero_gyrocopter/gyro_base_attack.vpcf",
    },
    ["npc_dota_hero_invoker"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_silencer"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",
        ["ProjectileSpeed"] = "1000",
    },
    ["npc_dota_hero_obsidian_destroyer"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_shadow_demon"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_shadow_demon/shadow_demon_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_lone_druid"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_lone_druid/lone_druid_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_rubick"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_rubick/rubick_base_attack.vpcf",
        ["ProjectileSpeed"] = "1125",
    },
    ["npc_dota_hero_disruptor"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_disruptor/disruptor_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_keeper_of_the_light"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_wisp"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_wisp/wisp_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_visage"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_visage/visage_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_medusa"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_troll_warlord"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_skywrath_mage"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf",
        ["ProjectileSpeed"] = "1000",
    },
    ["npc_dota_hero_terrorblade"] = {
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_phoenix"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
        ["ProjectileSpeed"] = "1100",
    },
    ["npc_dota_hero_oracle"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_oracle/oracle_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_techies"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_techies/techies_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_winter_wyvern"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_winter_wyvern/winter_wyvern_base_attack.vpcf",
        ["ProjectileSpeed"] = "700",
    },
    ["npc_dota_hero_arc_warden"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_arc_warden/arc_warden_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },
    ["npc_dota_hero_dark_willow"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf",
        ["ProjectileSpeed"] = "1200",
    },
    ["npc_dota_hero_grimstroke"] = {
        ["ProjectileModel"] = "particles/units/heroes/hero_grimstroke/grimstroke_base_attack.vpcf",
        ["ProjectileSpeed"] = "900",
    },    
}
