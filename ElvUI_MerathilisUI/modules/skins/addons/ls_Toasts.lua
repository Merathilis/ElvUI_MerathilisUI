local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API / Variables
-- GLOBALS:

if not IsAddOnLoaded("ls_Toasts") then return end
local LST = unpack(ls_Toasts)

LST:RegisterSkin("MerathilisUI", {
	name = "|cffff7d0aMerathilisUI|r",
	template = "elv-no-art",
	border = {
		color = {0, 0, 0, 1},
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\toast-border",
	},
	icon = {
		tex_coords = {.08, .92, .08, .92},
	},
	icon_border = {
		color = {0, 0, 0, 1},
		size = 1,
		offset = 1,
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icon-border",
	},
	icon_highlight = {
		hidden = true,
	},
	dragon = {
		hidden = true,
	},
	bonus = {
		hidden = false,
	},
	skull = {
		hidden = false,
	},
	slot = {
		tex_coords = {.08, .92, .08, .92},
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icon-border",
	},
	bg = {
		alliance = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		archaeology = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		collection = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		default = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		dungeon = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		horde = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		legendary = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		legion = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		recipe = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		store = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		transmog = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		upgrade = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		worldquest = {
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
	},
})
LST:SetSkin("MerathilisUI")