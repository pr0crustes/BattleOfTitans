
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
