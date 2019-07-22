CustomNetTables.SubscribeNetTableListener("bshops", OnBShopChange);


var open = false;

function OnBonusShopButtonClick() {
    find_hud_element("bshop_button").GetParent().style.transform = (open ? "translateX(-460px)" : "translateX(0)");
    open = !open;
}

function BuyHealth() {
    $.Msg("BuyHealth ", Players.GetLocalPlayer());

    var data = [];
    data["player_id"] = Players.GetLocalPlayer();
    data["team"] = GetPlayerTeam();

	GameEvents.SendCustomGameEventToServer("bshop_event_buy_health", data);
}


function UpdateBShop(shop_name, cost, own) {
    var panel = find_hud_element("buy_" + shop_name);
    panel.FindChildTraverse("bshop_cost").SetDialogVariable("cost", cost);
    panel.FindChildTraverse("bshop_own").SetDialogVariable("own", own);
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

//    if (GetPlayerTeam() == data.team) {
//        var panel = find_hud_element("buy_health");
//        panel.FindChildTraverse("bshop_own").text = data.owned;
//        panel.FindChildTraverse("bshop_cost").text = data.cost;
//    }
}
