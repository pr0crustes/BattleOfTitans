

function shop_spell_factory(modifier_name, net_table, net_table_key)
    local ability = {
        GetIntrinsicModifierName = function()
            return modifier_name
        end,
    }

    function ability:SetupUsedCount()
        if not self.used_count then
            self.used_count = 0
        end
    end

    function ability:UpdateCost()
        self:SetupUsedCount()

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

    function ability:PlayBuyEffect(playerID)
        local caster = self:GetCaster()
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)

        if hero and hero:IsAlive() then
            hero:EmitSound("DOTA_Item.Hand_Of_Midas")
            local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)	
            ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
        end
    end

    function ability:OnSpellStart()
        local playerID = self.buyer
        local cost = self:GetManaCost()

        if cost <= PlayerResource:GetGold(playerID) then
            PlayerResource:ModifyGold(playerID, -1 * cost, false, DOTA_ModifyGold_Building)

            self:SetupUsedCount()

            self.used_count = self.used_count + 1

            self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):SetStackCount(self.used_count)

            self:PlayBuyEffect(playerID)

            if IsServer() then
                self:UpdateCost()
            end
        else
            SendErrorMessage(playerID, "#dota_hud_error_not_enough_gold")
        end

        self:RefundManaCost()
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
