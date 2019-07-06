
modifier_titan = class({})


function modifier_titan:IsHidden()
    return true
end


function modifier_titan:IsDebuff()
    return false
end


function modifier_titan:IsPurgable()
    return false
end


function modifier_titan:IsPermanent()
    return true
end


function modifier_titan:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end


function modifier_titan:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
end


function modifier_titan:GetModifierMoveSpeed_Absolute()
    return 200
end


function modifier_titan:GetModifierProvidesFOWVision()
    return 1
end


if IsServer() then
    function modifier_titan:OnCreated(keys)
        self:StartIntervalThink(1.0)
    end

    function modifier_titan:OnIntervalThink()
        self:GetParent():RemoveModifierByName("modifier_ursa_fury_swipes_damage_increase")
		self:GetParent():RemoveModifierByName("modifier_maledict")
    end
end
