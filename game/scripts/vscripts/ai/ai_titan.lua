require "ai/ai_core"


function Spawn(entityKeyValues)
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

    thisEntity.think_interval = 0.1

    thisEntity.target_ancient = AICore:GetEnemyAncient(thisEntity:GetTeam())
    thisEntity.waypoints = AICore:GetWaypointsForTeam(thisEntity:GetTeam())
    thisEntity.current_waypoint_index = 1  -- init as 1
    thisEntity.waypoint_radius = 250

	thisEntity:SetContextThink("TitanThink", TitanThink, thisEntity.think_interval)
end


function TitanThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or (not thisEntity:IsAlive()) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.01
	end

	if thisEntity:IsControllableByAnyPlayer() or thisEntity:IsChanneling() then
		return thisEntity.think_interval
	end

    EvaluateActions()

	return thisEntity.think_interval
end


function EvaluateActions()
    --if CalcDistanceBetweenEntityOBB(thisEntity, thisEntity.target_ancient) < 2000 then
    if thisEntity.current_waypoint_index > #thisEntity.waypoints then
        AttackTargetAncient()
    else
        CheckWaypoints()
    end
end


function AttackTargetAncient()
    if AliveAndNonNil(thisEntity.target_ancient) and AliveAndNonNil(thisEntity) then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = thisEntity.target_ancient:entindex()
        })
    end
end


function CheckWaypoints()
    local waypoint = thisEntity.waypoints[thisEntity.current_waypoint_index]

    if AICore:GetDistance(thisEntity, waypoint) <= thisEntity.waypoint_radius then
        -- Achieved this waypoint
        thisEntity.current_waypoint_index = thisEntity.current_waypoint_index + 1
        if thisEntity.current_waypoint_index <= #thisEntity.waypoints then
            CheckWaypoints()
        end
    else
        MoveToPosition(waypoint:GetAbsOrigin())
    end
end


function MoveToPosition(position)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:GetEntityIndex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = position,
    })
end
