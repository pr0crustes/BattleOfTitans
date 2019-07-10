
modifier_mercenary = class({})


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


function modifier_mercenary:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_EVENT_ON_DEATH,
    }
end


function modifier_mercenary:GetModifierProvidesFOWVision()
    return 1
end


if IsServer() then
    function modifier_mercenary:OnCreated(keys)
        self.spawn_pos = keys.spawn_pos

        self.parent = self:GetParent()

        self.init_health = self.parent:GetMaxHealth()
        self.init_damage = self.parent:GetBaseDamageMax()
        self.init_armor = self.parent:GetPhysicalArmorValue(false)

        self.last_calculated_time = -1

        self:StartIntervalThink(1.0)
    end


    function modifier_mercenary:UpdateStats(time)
        local time_scale = 1 + (time * 0.1)

        local health = self.init_health * time_scale)
        self.parent:SetMaxHealth(health)
        self.parent:SetBaseMaxHealth(health)
        self.parent:SetHealth(health * self.parent:GetHealthPercent())
    
        local damage = self.init_damage * time_scale
        self.parent:SetBaseDamageMin(damage)
        self.parent:SetBaseDamageMax(damage)

        self.parent:SetPhysicalArmorBaseValue(self.init_armor * time_scale)
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
        for k, v in pairs(keys) do
            print("OnDeath ", k)
        end
    end
end
