local MER = unpack(ElvUI_MerathilisUI)

MER.Changelog[728] = {
	RELEASE_DATE = "29.08.2026",
	FIXES = {
		"[Misc]: Fixed an issue with a database change in the Status Report",
		"[Misc]: Fixed a potential error in the CopyMog frame",
		"[Theme]: Fixed a reference to frame.__unit in the Castbar",
		"[Skins]: Fixed a C Stack Overflow caused by a conflict between the Cooldown Viewer skin and WindTools",
	},
	NEW = {
		"[Skins]: Added an own Skin for the Weekly Rewards frame",
	},
	IMPROVEMENTS = {
		"[NameHover]: Try to avoid a possible database error",
		"[Core]: Added some additional secret value checks",
		"[Core]: Several modules now use the shared function to grab the database",
		"[Theme]: Added an extra safety check for gradient colors",
		"[Loot]: Display the Item Sets tab again in the Adventure Guide",
		"[Skins]: Updated the KeystoneLoot skin",
		"[Armory]: Different solution to prevent a nil error",
		"[Core]: Updated and protected some gradient functions. Thx to Co2Noss from Discord for pointing it out <3",
		"[Theme]: Updated the gradient handling for Castbar, Health, Power and Update",
		"[Core]: Added a safeguard against a possible MawBuffs taint",
		"[Skins]: Manually applied the MerathilisUI style to ls_Toasts",
		"[NameHover]: A few more secret checks",
		"[Core]: General cleanup",
	},
}
