
if TitanBuffCalculator == nil then
    TitanBuffCalculator = class({})
end


function TitanBuffCalculator:GetBuffsOnClient()
    return CustomNetTables:GetTableValue("titans", "titan_buff")
end


function TitanBuffCalculator:CalculateBuffs(round)
    function bonus_life_for_round(n)
        if n <= 1 then
            return 1000
        end
        return (n * 1000) + bonus_life_for_round(n - 1)
    end

    if round ~= TitanBuffCalculator.last_calculated_round then
        TitanBuffCalculator.last_calculated_values = {
            bonus_damage = round * 100,
            bonus_armor = round * 2,
            bonus_magic_res = round * 2,
            bonus_health_regen = round * 10,
            bonus_mana_regen = round * 10,
            bonus_health = bonus_life_for_round(round),
        }

        TitanBuffCalculator.last_calculated_round = round

        CustomNetTables:SetTableValue("titans", "titan_buff", TitanBuffCalculator.last_calculated_values)
    end

    return TitanBuffCalculator.last_calculated_values
end