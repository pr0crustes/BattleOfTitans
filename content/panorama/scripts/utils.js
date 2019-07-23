
function get_hud() {
    var p = $.GetContextPanel();
    while (p !== null && p.id !== "Hud") {
        p = p.GetParent();
    }
    return p;
}


function find_hud_element(find) {
    return get_hud().FindChildTraverse(find)
}


function GetPlayerTeam() {
    return Players.GetTeam(Players.GetLocalPlayer());
}


function FindFirstClass(root, class_name) {
    return root.FindChildrenWithClassTraverse(class_name)[0];
}
