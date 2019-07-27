
if AICore == nil then
    AICore = class({})
end


function AICore:GetDistance(unit_a, unit_b)
    return (unit_a:GetAbsOrigin() - unit_b:GetAbsOrigin()):Length2D()
end


function AICore:GetAncient(team)
    if team == DOTA_TEAM_GOODGUYS then
        return Entities:FindByName(nil, "dota_goodguys_fort")
    end
    if team == DOTA_TEAM_BADGUYS then
        return Entities:FindByName(nil, "dota_badguys_fort")
    end
    return nil
end


function AICore:GetEnemyAncient(team)
    if team == DOTA_TEAM_BADGUYS then
        return Entities:FindByName(nil, "dota_goodguys_fort")
    end
    if team == DOTA_TEAM_GOODGUYS then
        return Entities:FindByName(nil, "dota_badguys_fort")
    end
    return nil
end


function AICore:GetWaypointsForTeam(team)
    return AICore:WaypointsFromList(TITAN_WAYPOINTS[team])
end


function AICore:WaypointsFromList(waypoints_names)
    local as_entities = {}

    for i = 1, #waypoints_names do
        local name = waypoints_names[i]
        local waypoint = Entities:FindByName(nil, name)
        if waypoint then
            table.insert(as_entities, waypoint)
        else
            print("[ERROR] : AICore:WaypointsFromList failed to find waypoint with name ", name)
        end
    end

    return as_entities
end
