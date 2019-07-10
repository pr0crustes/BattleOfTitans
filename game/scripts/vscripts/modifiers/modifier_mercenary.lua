
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
        self:StartIntervalThink(0.5)
    end

    function modifier_mercenary:OnIntervalThink()
        
    end

    function modifier_mercenary:OnDeath(keys)
        for k, v in pairs(keys) do
            print("OnDeath ", k)
        end
    end
end
