
item_forbidden_rule = class({})

function item_forbidden_rule:OnSpellStart()
    print("USED")

    self:SpendCharge()
end

