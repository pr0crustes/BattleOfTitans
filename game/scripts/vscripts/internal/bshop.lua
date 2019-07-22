
if BShop == nil then
    BShop = class({})
end


function BShop:Init()
    print("INIT")
    CustomGameEventManager:RegisterListener("bshop_event_buy_health", Dynamic_Wrap(BShop, "BuyHealth"))

    function bonus_dict()
        return {
            ["health"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 1000,
                ["cost"] = 500,  -- Base cost
                ["cost_increase"] = 300,
                ["own"] = 0,
            },
        }
    end

    BShop.upgrades = {
        [DOTA_TEAM_GOODGUYS] = bonus_dict(),
        [DOTA_TEAM_BADGUYS] = bonus_dict(),
    }

    BShop:NotifyUpdateTable()
end


function BShop:NotifyUpdateTable()
    if IsServer() then
        CustomNetTables:SetTableValue("bshops", "upgrades", BShop.upgrades)
    end
end


function BShop:PlayBuyEffect(playerID)
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if hero and hero:IsAlive() then
        hero:EmitSound("DOTA_Item.Hand_Of_Midas")
        local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)	
        ParticleManager:SetParticleControlEnt(midas_particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), false)
    end
end


function BShop:DoBuy(playerID, team, bonus_key)
    local cost = BShop.upgrades[team][bonus_key]["cost"]

    if PlayerResource:GetGold(playerID) >= cost then
        PlayerResource:ModifyGold(playerID, -1 * cost, false, DOTA_ModifyGold_Building)

        BShop.upgrades[team][bonus_key]["own"] = BShop.upgrades[team][bonus_key]["own"] + 1
        BShop.upgrades[team][bonus_key]["cost"] = BShop.upgrades[team][bonus_key]["cost"] + BShop.upgrades[team][bonus_key]["cost_increase"]

        BShop:PlayBuyEffect(playerID)

        BShop:NotifyUpdateTable()
    else
        SendErrorMessage(playerID, "#dota_hud_error_not_enough_gold")
    end
end


function BShop:BuyHealth(data)
    print("BuyHealth")
    PrintTable(data)
    if data then
        BShop:DoBuy(data.player_id, data.team, "health")
    end
end

