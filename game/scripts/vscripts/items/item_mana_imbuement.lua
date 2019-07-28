-- The values are hardcoded because after the item is consumed it can no longer be used to get the special values.


item_mana_imbuement = class({})


function item_mana_imbuement:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    target:AddNewModifier(caster, self, "modifier_mana_imbuement_first", { duration = 180 })

    self:SpendCharge()
end



LinkLuaModifier("modifier_mana_imbuement_first", "items/item_mana_imbuement.lua", LUA_MODIFIER_MOTION_NONE)

modifier_mana_imbuement_first = class({})


function modifier_mana_imbuement_first:GetTexture()
    return "mercenary_blue"
end

function modifier_mana_imbuement_first:IsHidden()
    return false
end

function modifier_mana_imbuement_first:IsDebuff()
    return false
end

function modifier_mana_imbuement_first:IsPurgable()
    return false
end

function modifier_mana_imbuement_first:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_mana_imbuement_first:OnDeath(keys)
    if IsServer() then
        local unit = keys.unit
        local attacker = keys.attacker

        if self:GetParent() == unit then
            local killer = nil

            if attacker:IsRealHero() then
                killer = attacker
            elseif attacker.GetOwner then
                local owner = attacker:GetOwner()
                if owner:IsRealHero() then
                    killer = owner
                end
            end

            if killer and killer and killer:IsHero() and killer:IsAlive() and killer:GetTeam() ~= unit:GetTeam() and not killer:HasModifier("modifier_mana_imbuement_first") then
                killer:AddNewModifier(unit, self:GetAbility(), "modifier_mana_imbuement_second", { duration = 90 })
            end
        end
    end
end

function modifier_mana_imbuement_first:GetModifierConstantManaRegen()
    return 5
end

if IsServer() then
    function modifier_mana_imbuement_first:OnCreated(keys)
        self:StartIntervalThink(1.0)
    end

    function modifier_mana_imbuement_first:OnIntervalThink()
        local parent = self:GetParent()

        if parent and parent:IsAlive() then
            parent:GiveMana(parent:GetMaxMana() * 0.01)
        end
    end
end



LinkLuaModifier("modifier_mana_imbuement_second", "items/item_mana_imbuement.lua", LUA_MODIFIER_MOTION_NONE)

modifier_mana_imbuement_second = class({})


function modifier_mana_imbuement_second:GetTexture()
    return "mercenary_blue"
end

function modifier_mana_imbuement_second:IsHidden()
    return false
end

function modifier_mana_imbuement_second:IsDebuff()
    return false
end

function modifier_mana_imbuement_second:IsPurgable()
    return false
end

function modifier_mana_imbuement_second:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_mana_imbuement_second:GetModifierConstantManaRegen()
    return 5
end

if IsServer() then
    function modifier_mana_imbuement_second:OnCreated(keys)
        self:StartIntervalThink(1.0)
    end

    function modifier_mana_imbuement_second:OnIntervalThink()
        local parent = self:GetParent()

        if parent and parent:IsAlive() then
            parent:GiveMana(parent:GetMaxMana() * 0.01)
        end
    end
end
