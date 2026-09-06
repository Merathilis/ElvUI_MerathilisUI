local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[731] = {
	RELEASE_DATE = "TBD",
	FIXES = {
		"[Options]: Fixed toggle switches going blank and staying that way after changing an option that requires a UI reload",
		"[Options]: Fixed the options window losing its styled/opaque background when MerathilisUI Style is disabled",
		"[Options]: Fixed the selected-category highlight (ElvUI's own and skin overlays like WindTools') losing its color in the options window after toggling MerathilisUI Style",
		"[Skins]: Fixed ClassCodex's side tabs overlapping/touching the panel border",
		"[Options]: Fixed a Lua error opening the options after toggling LootSpecManager's Enable switch, which corrupted its saved settings",
	},
	NEW = {
		"[Options]: Module \"Enable\" toggle switches now color their label green/red to reflect the on/off state",
		"[Skins]: Added font size/outline options for the Weekly Rewards (Great Vault) skin (#124)",
		"[Options]: Added a custom slider widget matching the toggle-switch style for range options",
		"[Options]: Added a custom dropdown widget matching the toggle-switch/slider style for select options, including LibSharedMedia font pickers (with font-preview list rows)",
		"[Options]: Added a custom edit box widget matching the toggle-switch/slider/dropdown style for text input options",
		"[Options]: Added a custom color picker widget matching the toggle-switch/slider/dropdown/edit box style for color options",
		"[Options]: Added a custom button widget matching the toggle-switch/slider/dropdown/edit box/color picker style for execute options",
		"[Options]: Restyled the tab strip on MerathilisUI's own tabbed category pages (e.g. Modules) to match the flat toggle-switch/slider/dropdown style",
	},
	IMPROVEMENTS = {},
}
