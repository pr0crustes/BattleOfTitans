
mercenary_forbidden_chaos = class({})


function mercenary_forbidden_chaos:CreateGroundMeteor(target_pos, travel_distance, travel_speed, velocity)
    local caster = self:GetCaster()
    local dummy = CreateDummy(caster, target_pos)

    caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
    dummy:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
    dummy:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

    local meteor_duration = travel_distance / travel_speed

    local projectile_information = {
        EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
        Ability = self,
        vSpawnOrigin = target_pos,
        fDistance = travel_distance,
        fStartRadius = 0,
        fEndRadius = 0,
        Source = dummy,
        bHasFrontalCone = false,
        iMoveSpeed = travel_speed,
        bReplaceExisting = false,
        iVisionTeamNumber = caster:GetTeam(),
        bDrawsOnMinimap = false,
        bVisibleToEnemies = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_NONE ,
        fExpireTime = GameRules:GetGameTime() + meteor_duration,
        vVelocity = velocity,
    }

    local meteor_projectile = ProjectileManager:CreateLinearProjectile(projectile_information)

    dummy:RemoveSelf()
end


function mercenary_forbidden_chaos:OnSpellStart()
    local travel_speed = self:GetSpecialValueFor("travel_speed")
    local land_time = self:GetSpecialValueFor("land_time")
    local travel_distance = self:GetSpecialValueFor("travel_distance")

    local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()

	local normalized_distance = (target_pos - caster_pos):Normalized()
	local velocity = normalized_distance * travel_speed

	caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
	caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

    local flying_pos = (target_pos - (velocity * land_time)) + Vector (0, 0, 1000)

	local particle_meteor = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_meteor, 0, flying_pos)
	ParticleManager:SetParticleControl(particle_meteor, 1, target_pos)
    ParticleManager:SetParticleControl(particle_meteor, 2, Vector(land_time, 0, 0))

    Timers:CreateTimer(
        land_time,
        function()
            self:CreateGroundMeteor(target_pos, travel_distance, travel_speed, velocity)

            -- Damage
            local base_damage = self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("damage_growth") * TimeInMinutes())
            local damage_radius = self:GetSpecialValueFor("damage_radius")
            local units = FindUnitsInRadius(caster:GetTeam(), target_pos, nil, damage_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), 0, 0, false)
            for _, unit in ipairs(units) do
                ApplyDamage({
                    ability = self,
                    attacker = caster,
                    damage = base_damage + (unit:GetMaxHealth() * self:GetSpecialValueFor("damage_max_hp") * 0.01),
                    damage_type = self:GetAbilityDamageType(),
                    victim = unit
                })
            end
		end
    )
end


function mercenary_forbidden_chaos:GetIntrinsicModifierName()
    return "modifier_mercenary_forbidden_chaos"
end


LinkLuaModifier("modifier_mercenary_forbidden_chaos", "abilities/units/mercenary_forbidden_chaos", LUA_MODIFIER_MOTION_NONE)

modifier_mercenary_forbidden_chaos = class({})

function modifier_mercenary_forbidden_chaos:IsHidden()
    return true
end

if IsServer() then
    function modifier_mercenary_forbidden_chaos:DeclareFunctions()
        return {
            MODIFIER_EVENT_ON_ATTACKED
        }
    end

    function modifier_mercenary_forbidden_chaos:OnAttacked(keys)
        local attacker = keys.attacker
        local target = keys.target

        if target == self:GetParent() then
            local ability = self:GetAbility()

            if RollPercentage(ability:GetSpecialValueFor("meteor_chance")) then
                target:SetCursorPosition(attacker:GetAbsOrigin() + RandomVector(ability:GetSpecialValueFor("position_variation")))
                ability:OnSpellStart()
            end
        end
    end
end
