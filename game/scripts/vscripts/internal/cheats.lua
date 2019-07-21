
if Cheats == nil then
    Cheats = class({})
end


function Cheats:IsEnabled()
    return GameRules:IsCheatMode()
end


function Cheats:spawntitans(player, args)
    if GameRules.GameMode then
        GameRules.GameMode.titan_countdown = 1
    end
end


function Cheats:noloose(player, args)
    if GameRules.GameMode then
        if GameRules.GameMode.ancient_radiant then
            GameRules.GameMode.ancient_radiant:SetPhysicalArmorBaseValue(99999)
        end
        if GameRules.GameMode.ancient_dire then
            GameRules.GameMode.ancient_dire:SetPhysicalArmorBaseValue(99999)
        end
    end
end
