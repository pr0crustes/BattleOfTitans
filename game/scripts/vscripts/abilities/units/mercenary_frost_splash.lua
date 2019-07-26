LinkLuaModifier("modifier_damageless", "modifiers/damageless.lua", LUA_MODIFIER_MOTION_NONE)

mercenary_frost_splash = class({})


function mercenary_frost_splash:OnSpellStart()
    local caster = self:GetCaster()
    local foward_vector = caster:GetForwardVector()

    local distance = self:GetSpecialValueFor("distance")
    local distance_increase = self:GetSpecialValueFor("distance_increase")
    local amount = self:GetSpecialValueFor("amount")
    local rotation = self:GetSpecialValueFor("rotation")

    self:DoSpawnOrbs(foward_vector, rotation, distance, distance_increase, amount)
    self:DoSpawnOrbs(foward_vector, rotation * -1, distance, distance_increase, amount)
end


function mercenary_frost_splash:DoSpawnOrbs(foward_vector, rotation, distance, distance_increase, amount)
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()

    local angles_plus = {0, 90, 180, 270}

    for i = 1, amount do
        for a = 1, #angles_plus do
            local pos = caster_pos + (foward_vector * (distance + (i * distance_increase)))
            local angle = QAngle(0, (i * rotation) + angles_plus[a], 0)
            local new_pos = RotatePosition(caster_pos, angle, pos)

            Timers:CreateTimer(
                i * 0.2,
                function()
                    self:CreateOrb(new_pos)
                end
            )
        end
    end
end


function mercenary_frost_splash:CreateOrb(pos)
    local caster = self:GetCaster()
    local delay = self:GetSpecialValueFor("delay")

    local orb = CreateUnitByName("mercenary_frost_splash_orb", pos, true, nil, nil, caster:GetTeam())
    orb:AddNewModifier(caster, self, "modifier_damageless", {})

    Timers:CreateTimer(
        delay,
        function()
            self:ExplodeOrb(orb)
        end
    )
end


function mercenary_frost_splash:PlayExplodeEffect(orb, damage_radius, slow_duration)
    local pos = orb:GetAbsOrigin()

	local nova_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_CUSTOMORIGIN, orb)
	ParticleManager:SetParticleControl(nova_pfx, 0, pos)
	ParticleManager:SetParticleControl(nova_pfx, 1, Vector(damage_radius, slow_duration, damage_radius))
	ParticleManager:SetParticleControl(nova_pfx, 2, pos)
	ParticleManager:ReleaseParticleIndex(nova_pfx)

    EmitSoundOnLocationWithCaster(pos, "Hero_Crystal.CrystalNova", orb)
end


function mercenary_frost_splash:ExplodeOrb(orb)
    local caster = self:GetCaster()
    local damage_radius = self:GetSpecialValueFor("damage_radius")
    local slow_duration = self:GetSpecialValueFor("slow_duration")

	self:PlayExplodeEffect(orb, damage_radius, slow_duration)

    local damage = self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("damage_growth") * TimeInMinutes())

    local units = FindUnitsInRadius(caster:GetTeam(), orb:GetAbsOrigin(), nil, damage_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), 0, 0, false)

    for _, unit in ipairs(units) do
        ApplyDamage({
            ability = self,
            attacker = caster,
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            victim = unit
        })
        unit:AddNewModifier(caster, self, "modifier_mercenary_frost_splash_slow", { duration = slow_duration })
    end

    UTIL_Remove(orb)
end


LinkLuaModifier("modifier_mercenary_frost_splash_slow", "abilities/units/mercenary_frost_splash.lua", LUA_MODIFIER_MOTION_NONE)

modifier_mercenary_frost_splash_slow = class({})

function modifier_mercenary_frost_splash_slow:IsHidden()
    return false
end

function modifier_mercenary_frost_splash_slow:IsDebuff()
    return true
end

function modifier_mercenary_frost_splash_slow:IsPurgable()
    return true
end

function modifier_mercenary_frost_splash_slow:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_mercenary_frost_splash_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_mercenary_frost_splash_slow:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("slow_pct")
end

function modifier_mercenary_frost_splash_slow:GetEffectName()
    return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_mercenary_frost_splash_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
