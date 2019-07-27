
if BShop == nil then
    BShop = class({})
end


function BShop:Init()
    CustomGameEventManager:RegisterListener("bshop_event_buy_buff", Dynamic_Wrap(BShop, "BuyBuff"))

    function bonus_dict()
        return {
            ["health"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 1000,
                ["cost"] = 500,  -- Base cost
                ["cost_increase"] = 300,
                ["own"] = 0,
                ["max"] = -1,
                ["on_change"] = NO_HANDLER,
            },
            ["armor"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 1,
                ["cost"] = 300,  -- Base cost
                ["cost_increase"] = 600,
                ["own"] = 0,
                ["max"] = -1,
                ["on_change"] = NO_HANDLER,
            },
            ["ancient_armor"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 1,
                ["cost"] = 500,  -- Base cost
                ["cost_increase"] = 700,
                ["own"] = 0,
                ["max"] = -1,
                ["on_change"] = ShopHandler_OnAncientArmorChange,
            },
            ["damage"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 100,
                ["cost"] = 1000,  -- Base cost
                ["cost_increase"] = 250,
                ["own"] = 0,
                ["max"] = -1,
                ["on_change"] = NO_HANDLER,
            },
            ["magical_res"] = {
                ["bonus"] = 0,
                ["bonus_per_own"] = 10,
                ["cost"] = 1300,  -- Base cost
                ["cost_increase"] = 1000,
                ["own"] = 0,
                ["max"] = 6,
                ["on_change"] = NO_HANDLER,
            },
        }
    end

    BShop.upgrades = {
        [DOTA_TEAM_GOODGUYS] = bonus_dict(),
        [DOTA_TEAM_BADGUYS] = bonus_dict(),
    }

    BShop:NotifyUpdateTable()
end


function BShop:GetBonus(team, key)
    local info = BShop:GetInfo(team, key)
    if info then
        return info["bonus"]
    end
    print("Fatal error at BShop:GetBonus, failed to find team :", team, " | key :", key)
    return nil
end


function BShop:GetInfo(team, key)
    if BShop.upgrades and BShop.upgrades[team] then
        return BShop.upgrades[team][key]
    end
    print("Fatal error at BShop:GetInfo, failed to find team :", team, " | key :", key)
    return nil
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
        if BShop.upgrades[team][bonus_key]["max"] == -1 or BShop.upgrades[team][bonus_key]["own"] < BShop.upgrades[team][bonus_key]["max"] then
            PlayerResource:ModifyGold(playerID, -1 * cost, false, DOTA_ModifyGold_Building)

            BShop.upgrades[team][bonus_key]["own"] = BShop.upgrades[team][bonus_key]["own"] + 1
            BShop.upgrades[team][bonus_key]["cost"] = BShop.upgrades[team][bonus_key]["cost"] + BShop.upgrades[team][bonus_key]["cost_increase"]
            BShop.upgrades[team][bonus_key]["bonus"] = BShop.upgrades[team][bonus_key]["bonus"] + BShop.upgrades[team][bonus_key]["bonus_per_own"]

            BShop.upgrades[team][bonus_key]["on_change"](team, bonus_key)

            BShop:PlayBuyEffect(playerID)

            BShop:NotifyUpdateTable()
        else
            SendErrorMessage(playerID, "#dota_hud_error_max_buff_own")
        end
    else
        SendErrorMessage(playerID, "#dota_hud_error_not_enough_gold")
    end
end


function BShop:BuyBuff(data)
    if data then
        BShop:DoBuy(data.player_id, data.team, data.shop_buff)
    end
end

