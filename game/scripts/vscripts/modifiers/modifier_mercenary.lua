
modifier_mercenary = class({})

function modifier_mercenary:GetTexture()
    return "mercenary"
end

function modifier_mercenary:IsHidden()
    return false
end


function modifier_mercenary:IsDebuff()
    return false
end


function modifier_mercenary:IsPurgable()
    return false
end


function modifier_mercenary:IsPermanent()
    return true
end


if IsServer() then
    function modifier_mercenary:DeclareFunctions()
        return {
            MODIFIER_EVENT_ON_DEATH,
        }
    end

    function modifier_mercenary:OnCreated(keys)
        self.spawn_pos_x = keys.spawn_pos_x
        self.spawn_pos_y = keys.spawn_pos_y
        self.spawn_pos_z = keys.spawn_pos_z
        self.respawn_time = keys.respawn_time

        self.parent = self:GetParent()

        self.init_health = self.parent:GetMaxHealth()
        self.init_regen = self.parent:GetHealthRegen()
        self.init_damage = self.parent:GetBaseDamageMax()
        self.init_armor = self.parent:GetPhysicalArmorValue(false)

        self.last_calculated_time = -1

        self:StartIntervalThink(1.0)
    end


    function modifier_mercenary:UpdateStats(time)
        local time_scale = 1 + (time * 0.1)

        local health = self.init_health * time_scale
        self.parent:SetMaxHealth(health)
        self.parent:SetBaseMaxHealth(health)
        self.parent:SetHealth(health * self.parent:GetHealthPercent())

        local damage = self.init_damage * time_scale
        self.parent:SetBaseDamageMin(damage)
        self.parent:SetBaseDamageMax(damage)

        self.parent:SetPhysicalArmorBaseValue(self.init_armor * time_scale)

        self.parent:SetBaseHealthRegen(self.init_regen + time)
    end


    function modifier_mercenary:ThinkUpdateStats()
        local time_in_min = math.floor(GameRules:GetGameTime() / 60)

        if time_in_min ~= self.last_calculated_time and self.parent:GetTeam() == DOTA_TEAM_NEUTRALS then
            self:UpdateStats(time_in_min)

            self.last_calculated_time = time_in_min
        end
    end


    function modifier_mercenary:OnIntervalThink()
        self:ThinkUpdateStats()
    end


    function modifier_mercenary:OnDeath(keys)
        local unit = keys.unit
        local attacker = keys.attacker

        if self.parent == unit then
            local name = self.parent:GetUnitName()
            local pos = Vector(self.spawn_pos_x, self.spawn_pos_y, self.spawn_pos_z)

            Timers:CreateTimer(
                self.respawn_time,
                function()
                    local mercenary = CreateUnitByName(name, pos, true, nil, nil, DOTA_TEAM_NEUTRALS)
                    mercenary:AddNewModifier(mercenary, nil, "modifier_mercenary", {
                        spawn_pos_x = self.spawn_pos_x,
                        spawn_pos_y = self.spawn_pos_y,
                        spawn_pos_z = self.spawn_pos_z,
                        respawn_time = self.respawn_time,
                    })
                end
            )
        end
    end
end
