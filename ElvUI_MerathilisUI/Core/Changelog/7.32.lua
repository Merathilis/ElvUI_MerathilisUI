local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[732] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		'[Actionbars]: Fixed SpecBar not showing a distinct border color when Loot Specialization is set to "Current Specialization"',
		"[Actionbars]: Fixed SpecBar's border color reverting to the default color shortly after login/reload",
		"[Notification]: Fixed toast notifications never reusing pooled frames, creating a new frame for every notification instead",
		"[Notification]: Fixed a potential error when a Paragon reputation toast fired for a faction with no cached data",
		"[Core]: Fixed potential Lua errors and incorrect unit checks (name coloring, unit color, class/reaction) when a unit's identity is protected by Blizzard's secret-value API",
		"[NameHover]: Fixed potential Lua errors and incorrect player/reaction detection for mouseover units protected by Blizzard's secret-value API",
		"[Misc]: Fixed the raid role counter miscounting when a raid member's role is protected by Blizzard's secret-value API",
		"[Theme]: Fixed a potential Lua error in the health color update when a unit's dead/ghost state is protected by Blizzard's secret-value API",
		"[BuffReminder]: Fixed group buff coverage skipping a raid/party member whose dead/ghost state is protected by Blizzard's secret-value API",
	},
	NEW = {
		"[Notification]: Added a Great Vault notification when new weekly rewards become available to claim",
		"[Notification]: Added a Currency Cap Warning that tracks any currency by ID and warns when it nears its weekly or total cap",
		"[Notification]: Added a Test Notification button to preview the toast style directly from the options",
		"[Loot]: Added a standalone Loot Roll module that replaces ElvUI's Need/Greed/Pass bars with a bigger, movable, quality-colored bar with an inline roller list and a Test button in the options",
	},
	IMPROVEMENTS = {
		"[Options]: Changed the button/edit box/dropdown/color picker widgets' mouseover backdrop from a flat gray to a blue-tinted Accent color matching the tab strip's selected-tab color",
	},
}
