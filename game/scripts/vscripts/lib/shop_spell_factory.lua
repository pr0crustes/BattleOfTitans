

function shop_spell_factory(modifier_name, net_table, net_table_key)
    local ability = {
        GetIntrinsicModifierName = function()
            return modifier_name
        end,
    }

    function ability:UpdateCost()
        if not self.used_count then
            self.used_count = 0
        end

        local cost = self:GetSpecialValueFor("base_cost") + self:GetSpecialValueFor("cost_increase") * self.used_count

        if cost ~= self.last_calculated_cost then
            self.last_calculated_cost = cost

            CustomNetTables:SetTableValue(net_table, net_table_key, { cost = cost })
        end

        return cost
    end

    function ability:GetManaCost(iLevel)
        if IsServer() then
            return self:UpdateCost()
        else
            local shared_table = CustomNetTables:GetTableValue(net_table, net_table_key)
    
            if shared_table then
                return shared_table.cost
            end
            return 0
        end
    end

    function ability:OnSpellStart()
        if not self.used_count then
            self.used_count = 0
        end

        local buyer_id = self.buyer

        self.used_count = self.used_count + 1

        self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(self.used_count)

        if IsServer() then
            self:UpdateCost()
        end
    end

    return ability
end


function shop_spell_factory_factory(texture)
    return {
        IsHidden = function()
            return false
        end,
        IsDebuff = function()
            return false
        end,
        GetTexture = function()
            return texture
        end,
    }
end
