
var open = false;

function OnBonusShopButtonClick() {
    find_hud_element("bshop_button").GetParent().style.transform = (open ? "translateX(-460px)" : "translateX(0)");
    open = !open;
}

function BuyHealth() {
    $.Msg("BuyHealth");
}
