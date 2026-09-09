local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[732] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		'[Actionbars]: Fixed SpecBar not showing a distinct border color when Loot Specialization is set to "Current Specialization"',
		"[Actionbars]: Fixed SpecBar's border color reverting to the default color shortly after login/reload",
		"[Notification]: Fixed toast notifications never reusing pooled frames, creating a new frame for every notification instead",
		"[Notification]: Fixed a potential error when a Paragon reputation toast fired for a faction with no cached data",
	},
	NEW = {
		"[Notification]: Added a Great Vault notification when new weekly rewards become available to claim",
		"[Notification]: Added a Currency Cap Warning that tracks any currency by ID and warns when it nears its weekly or total cap",
		"[Notification]: Added a Test Notification button to preview the toast style directly from the options",
	},
	IMPROVEMENTS = {
		"[Options]: Changed the button/edit box/dropdown/color picker widgets' mouseover backdrop from a flat gray to a blue-tinted Accent color matching the tab strip's selected-tab color",
	},
}
