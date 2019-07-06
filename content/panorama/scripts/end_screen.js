/**
    DISCLAIMER:
    This file is heavily inspired and based on the open sourced code from Angel Arena Black Star, respecting their Apache-2.0 License.
    Thanks to Angel Arena Black Star.
 */
"use strict";
GameUI.CustomUIConfig().team_colors = {};
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = '#008000';
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS] = '#FF0000';


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



var GAME_RESULT = {};
var _ = GameUI.CustomUIConfig()._;


function FinishGame() {
	Game.FinishGame();
}



/**
 * Creates Panel snippet and sets all player-releated information
 *
 * @param {Number} playerId Player ID
 * @param {Panel} rootPanel Panel that will be parent for that player
 */
function Snippet_Player(playerId, rootPanel, index) {
	var panel = $.CreatePanel("Panel", rootPanel, "");
	panel.BLoadLayoutSnippet("Player");
    panel.SetHasClass("IsLocalPlayer", playerId === Game.GetLocalPlayerID());

	var playerData = GAME_RESULT.players[playerId];
	var playerInfo = Game.GetPlayerInfo(playerId);
	panel.FindChildTraverse("PlayerAvatar").steamid = playerInfo.player_steamid;
	panel.FindChildTraverse("PlayerNameScoreboard").steamid = playerInfo.player_steamid;

	panel.index = index; // For backwards compatibility
	panel.style.animationDelay = index * 0.3 + "s";
	$.Schedule(index * 0.3, function() {
		try {
			panel.AddClass("AnimationEnd");
		} catch(e) {};
	});

	panel.FindChildTraverse("HeroIcon").SetImage('file://{images}/heroes/' + playerData.heroName + '.png');
	panel.SetDialogVariableInt("hero_level", playerData.level);
	panel.SetDialogVariable("hero_name", $.Localize(playerData.heroName));
	
	panel.SetDialogVariableInt("kills", playerData.kills);
	panel.SetDialogVariableInt("deaths", playerData.deaths);
	panel.SetDialogVariableInt("assists", playerData.assists);

	panel.SetDialogVariable("goldSpent", playerData.goldSpent);

	panel.SetDialogVariableInt("creepLastHits", playerData.creepLastHits);

	panel.SetDialogVariable("goldPerMin", playerData.goldPerMin);
	panel.SetDialogVariable("xpPerMin", playerData.xpPerMin);

	panel.SetDialogVariableInt("strength", playerData.str);
	panel.SetDialogVariableInt("agility", playerData.agi);
	panel.SetDialogVariableInt("intellect", playerData.int);

	for (var i = 0; i < 9; i++) {
		var item = playerData.items[i];
		var itemPanel = $.CreatePanel("DOTAItemImage", panel.FindChildTraverse(i >= 6 ? "BackpackItemsContainer" : "ItemsContainer"), "");
		if (item) {
			itemPanel.itemname = item;
		}
	}
}



/**
 * Creates Team snippet and all in-team information
 *
 * @param {Number} team Team Index
 */
function Snippet_Team(team) {
	var teamDetails = Game.GetTeamDetails(team);

	var panel = $.CreatePanel("Panel", $("#TeamsContainer"), "");
	panel.BLoadLayoutSnippet("Team");
	panel.SetHasClass("IsRight", team % 2 !== 0);
	panel.SetDialogVariable('team_name', $.Localize(teamDetails["team_name"]));
	panel.SetDialogVariableInt('team_score', teamDetails["team_score"]);
	panel.SetHasClass('IsWinner', GAME_RESULT.winner === team);

	var teamColor = GameUI.CustomUIConfig().team_colors[team];
	panel.FindChildTraverse('TeamName').style.textShadow = '0px 0px 6px 1.0 ' + teamColor;

	var ids = Game.GetPlayerIDsOnTeam(team)
	for(var i = 0; i < ids.length; i++) {
		Snippet_Player(ids[i], panel, i + 1);
	}
}



function OnGameResult(table, key, gameResult) {
	if (!gameResult || key !== "game_info") {
		FinishGame();
		return;
	}

	$("#LoadingPanel").visible = false;
	$("#EndScreenWindow").visible = true;
	$("#TeamsContainer").RemoveAndDeleteChildren();

	if (gameResult.winner === 2) {
		$('#EndScreenVictory').text = $.Localize("dota_game_end_victory_title_radiant");
	} else if (gameResult.winner === 3) {
		$('#EndScreenVictory').text = $.Localize("dota_game_end_victory_title_dire");
	}

	GAME_RESULT = gameResult;

	var teamIds = Game.GetAllTeamIDs();
	for(var i = 0; i < teamIds.length; i++) {
		Snippet_Team(teamIds[i]);
	}
}



(function() {
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME_CHAT, false);
	find_hud_element("GameEndContainer").visible = false;

	$.GetContextPanel().RemoveClass("FadeOut");
	$("#LoadingPanel").visible = true;
	$("#EndScreenWindow").visible = false;

	CustomNetTables.SubscribeNetTableListener("end_game_scoreboard", OnGameResult);
	OnGameResult(null, "game_info", CustomNetTables.GetTableValue("end_game_scoreboard", "game_info"));
})();
