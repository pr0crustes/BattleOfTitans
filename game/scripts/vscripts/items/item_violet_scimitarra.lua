
item_violet_scimitarra = class({})


function item_violet_scimitarra:GetIntrinsicModifierName()
    return "modifier_item_violet_scimitarra"
end


function item_violet_scimitarra:OnProjectileHit(target, location)
    if IsServer() then
        local caster = self:GetCaster()

        ApplyDamage({
            attacker = caster,
            victim = target,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage = caster:GetAverageTrueAttackDamage(target) * self:GetSpecialValueFor("attack_damage") * 0.01
        })
    end
end



LinkLuaModifier("modifier_item_violet_scimitarra", "items/item_violet_scimitarra.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_violet_scimitarra = class({})


function modifier_item_violet_scimitarra:IsHidden()
    return true
end


function modifier_item_violet_scimitarra:IsDebuff()
    return false
end


function modifier_item_violet_scimitarra:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
        MODIFIER_EVENT_ON_ATTACK,
    }
end


function modifier_item_violet_scimitarra:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("bonus_strength")
end


function modifier_item_violet_scimitarra:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("bonus_agility")
end


function modifier_item_violet_scimitarra:GetModifierAttackRangeBonusUnique()
    return self:GetAbility():GetSpecialValueFor("base_attack_range")
end


function modifier_item_violet_scimitarra:OnAttack(keys)
    if IsServer() then
        local target = keys.target
        local attacker = keys.attacker
        local ability = self:GetAbility()

        if attacker == self:GetParent() and attacker:IsRangedAttacker() then
            local nearby = FindUnitsInRadius(
                attacker:GetTeam(),
                target:GetAbsOrigin(),
                nil,
                ability:GetSpecialValueFor("extra_attack_radius"),
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                FIND_CLOSEST,
                false
            )

            local extra_attacks = ability:GetSpecialValueFor("extra_attacks")

            for _, enemy in pairs(nearby) do
                if enemy ~= target then
                    ProjectileManager:CreateTrackingProjectile({
                        EffectName = self.projectile_model,
                        Ability = ability,
                        vSpawnOrigin = attacker:GetAbsOrigin(),
                        Target = enemy,
                        Source = attacker,
                        bHasFrontalCone = false,
                        iMoveSpeed = self.projectile_speed * 0.85,
                        bReplaceExisting = false,
                        bProvidesVision = false
                    })

                    extra_attacks = extra_attacks - 1
                end

                if extra_attacks == 0 then
                    break
                end
            end
        end
    end
end

if IsServer() then
    function modifier_item_violet_scimitarra:OnCreated(keys)
        local infos = ProjectileInfoForHero(self:GetParent():GetUnitName())
        self.projectile_model = infos["ProjectileModel"]
        self.projectile_speed = infos["ProjectileSpeed"]
    end
end
