
var open = false;

function OnBonusShopButtonClick() {
    find_hud_element("bonus_shop_button").GetParent().style.transform = (open ? "translateX(-460px)" : "translateX(0)");
    open = !open;
}


