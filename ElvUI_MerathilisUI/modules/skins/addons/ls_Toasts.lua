local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API / Variables

-- GLOBALS:
if not IsAddOnLoaded("ls_Toasts") then return end
local LST = unpack(ls_Toasts)

-- if E.private.muiSkins.addonSkins.ls ~= true then return end
LST:RegisterSkin("MerathilisUI", {
	name = "|cffff7d0aMerathilisUI|r",
	template = "elv-no-art",
	border = {
		color = {0, 0, 0, .75},
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
	bg = {
		alliance = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		archaeology = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		collection = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		default = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		dungeon = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		horde = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		legendary = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		legion = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		recipe = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		store = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		transmog = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		upgrade = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
		worldquest = {
			color = {0, 0, 0, .5},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\gradient",
		},
	},
})
LST:SetSkin("MerathilisUI")