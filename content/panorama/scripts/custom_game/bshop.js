CustomNetTables.SubscribeNetTableListener("bshop_update_health_ui", UpdateHealthUI);


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

function UpdateHealthUI(table, key, data) {
    if (!data || key !== "values") {
		return;
    }

    if (GetPlayerTeam() == data.team) {
        var panel = find_hud_element("buy_health");
        panel.FindChildTraverse("bshop_own").text = data.owned;
        panel.FindChildTraverse("bshop_cost").text = data.cost;
    }
}
