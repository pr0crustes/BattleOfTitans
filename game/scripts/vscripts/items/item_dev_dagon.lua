
item_dev_dagon = class({})


function item_dev_dagon:OnSpellStart()
    self:GetCursorTarget():ForceKill(false)
end
