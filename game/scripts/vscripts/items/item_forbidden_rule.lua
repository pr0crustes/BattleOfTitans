
item_forbidden_rule = class({})

function item_forbidden_rule:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")

    Notifications:TopToAll({
        text="Forbidden Rule Was Used, TPs Blocked For " .. duration .. " Seconds",
        style={color="red"},
        duration=6,
    })

    if _G.forbidden_rule_active then
        Timers:RemoveTimer("item_forbidden_rule_revert")
    end

    _G.forbidden_rule_active = true

    Timers:CreateTimer("item_forbidden_rule_revert", {
        endTime = duration,
        callback = function()
            Notifications:TopToAll({
                text="Forbidden Rule Ended",
                style={color="red"},
                duration=6,
            })
            _G.forbidden_rule_active = false
            return nil
        end
    })

    self:SpendCharge()
end
