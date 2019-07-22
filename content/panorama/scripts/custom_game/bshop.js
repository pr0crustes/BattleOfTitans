
var open = false;

function OnBonusShopButtonClick() {
    find_hud_element("bshop_button").GetParent().style.transform = (open ? "translateX(-460px)" : "translateX(0)");
    open = !open;
}


function BuyBuff(shop_buff) {
    var data = [];
    data["player_id"] = Players.GetLocalPlayer();
    data["team"] = GetPlayerTeam();
    data["shop_buff"] = shop_buff;

	GameEvents.SendCustomGameEventToServer("bshop_event_buy_buff", data);
}


function UpdateBShop(shop_name, cost, own) {
    var panel = find_hud_element("buy_" + shop_name);
    panel.FindChildrenWithClassTraverse("bshop_cost")[0].SetDialogVariableInt("cost", cost);
    panel.FindChildrenWithClassTraverse("bshop_own")[0].SetDialogVariableInt("own", own);
}


function OnBShopChange(table, key, data) {
    if (!data || key !== "upgrades") {
		return;
    }

    $.Msg("OnBShopChange");

    var team_info = data[GetPlayerTeam()];
    if (team_info) {
        Object.keys(team_info).forEach(function(key) {
            var info = team_info[key];

            UpdateBShop(key, info.cost, info.own);
        });
    }
}


// On Init
(function() {
    function SubscribeAndInit(table, key, handle) {
        CustomNetTables.SubscribeNetTableListener(table, handle);
        OnBShopChange(table, key, CustomNetTables.GetTableValue(table, key))
    }

    SubscribeAndInit("bshops", "upgrades", OnBShopChange);
}());
