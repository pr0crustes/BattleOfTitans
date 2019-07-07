
item_dev_blink = class({})


function item_dev_blink:OnSpellStart()
    self:GetParent():SetAbsOrigin(self:GetCursorPosition())
end
