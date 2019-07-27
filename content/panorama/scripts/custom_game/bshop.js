
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
    var panel = $("#buy_" + shop_name);
    if (panel) {
        panel.FindChildTraverse("bshop_cost").SetDialogVariableInt("cost", cost);
        panel.FindChildTraverse("bshop_own").SetDialogVariableInt("own", own);
    }
}


function OnBShopChange(table, key, data) {
    if (!data || key !== "upgrades") {
		return;
    }

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
    function CreateShops() {
        var shops = ["health", "armor", "magical_res", "damage", "ancient_armor"];

        var bshop_panel = find_hud_element("bshop_shops_container");

        $.Each(shops, function(shop_name) {
            var panel_id =  "buy_" + shop_name;

            if (bshop_panel.FindChildTraverse(panel_id) == null) {
                var shop_panel = $.CreatePanel("Panel", bshop_panel, panel_id);
                shop_panel.BLoadLayoutSnippet("bshop_entry");

                shop_panel.FindChildTraverse("image_icon").SetImage("file://{images}/custom_game/shops/shop_" + shop_name + ".png");
                shop_panel.FindChildTraverse("bshop_description").text = $.Localize("bshop_" + shop_name + "_description");
                shop_panel.FindChildTraverse("bshop_buy_button").SetPanelEvent("onactivate", function() {
                    BuyBuff(shop_name);
                });
            }
        });
    }

    function SubscribeAndInit(table, key, handle) {
        CustomNetTables.SubscribeNetTableListener(table, handle);
        OnBShopChange(table, key, CustomNetTables.GetTableValue(table, key))
    }

    CreateShops();
    SubscribeAndInit("bshops", "upgrades", OnBShopChange);
}());
