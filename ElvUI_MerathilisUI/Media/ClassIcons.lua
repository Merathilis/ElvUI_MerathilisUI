local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

MER.ClassIcons.mMT = {}
MER.ClassIcons.Custom = {}
MER.ClassIcons.data = {
	WARRIOR = {
		texString = "0:128:0:128",
		texCoords = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
	},
	MAGE = {
		texString = "128:256:0:128",
		texCoords = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
	},
	ROGUE = {
		texString = "256:384:0:128",
		texCoords = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
	},
	DRUID = {
		texString = "384:512:0:128",
		texCoords = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
	},
	EVOKER = {
		texString = "512:640:0:128",
		texCoords = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
	},
	HUNTER = {
		texString = "0:128:128:256",
		texCoords = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
	},
	SHAMAN = {
		texString = "128:256:128:256",
		texCoords = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
	},
	PRIEST = {
		texString = "256:384:128:256",
		texCoords = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
	},
	WARLOCK = {
		texString = "384:512:128:256",
		texCoords = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
	},
	PALADIN = {
		texString = "0:128:256:384",
		texCoords = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
	},
	DEATHKNIGHT = {
		texString = "128:256:256:384",
		texCoords = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
	},
	MONK = {
		texString = "256:384:256:384",
		texCoords = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
	},
	DEMONHUNTER = {
		texString = "384:512:256:384",
		texCoords = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
	},
}

local type = type
local path = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Class\\"

-- style = texture style, textur = path to the texture, table with texture coords for each class, name = optional name to show in dopdown menu
function MER:AddClassIcons(style, texture, texCoords, name)
	if not (style and texture and texCoords) then
		F.Print("|CFFEA1818Error|r:", L["Could not add the texture."])
		return false, "missingArgs"
	end

	local icon = {
		name = name or style,
		texture = texture,
	}

	if texCoords ~= "default" then
		if type(texCoords) ~= "table" then
			F.Print("|CFFEA1818Error|r:", L["The texture coordinates must be passed as a table."])
			return false, "invalidCoords"
		end
		icon.texCoords = texCoords
	end

	if not MER.ClassIcons.mMT[style] then
		MER.ClassIcons.mMT[style] = icon
		return true
	else
		F.Print("|CFFEA1818Error|r:", L["The style already exists."])
		return false, "duplicate"
	end
end

local function AddClassIcons(style, texture, name)
	if not (style and texture) then
		return
	end

	MER.ClassIcons.mMT[style] = {
		name = name or style,
		texture = texture,
	}
end

MER:AddClassIcons("BLIZZARD", "Interface\\WorldStateFrame\\Icons-Classes", CLASS_ICON_TCOORDS, "Blizzard")

AddClassIcons("mmt_hd", path .. "mmt_border.tga", "mMT HD")
AddClassIcons("mmt_hd_black", path .. "mmt_classcolored_border.tga", "mMT HD Black")

AddClassIcons("mmt_transparent", path .. "mmt_transparent.tga", "mMT Transp. A")
AddClassIcons("mmt_transparent_shadow", path .. "mmt_transparent_shadow.tga", "mMT Transp. B")
AddClassIcons("mmt_transparent_colorboost", path .. "mmt_transparent_colorboost.tga", "mMT Transp. C")
AddClassIcons("mmt_transparent_colorboost_shadow", path .. "mmt_transparent_colorboost_shadow.tga", "mMT Transp. D")

AddClassIcons("mmt_transparent_outline", path .. "mmt_transparent_outline.tga", "mMT Outline A")
AddClassIcons("mmt_transparent_outline_shadow", path .. "mmt_transparent_outline_shadow.tga", "mMT Outline B")
AddClassIcons("mmt_transparent_outline_colorboost", path .. "mmt_transparent_outline_colorboost.tga", "mMT Outline C")
AddClassIcons(
	"mmt_transparent_outline_shadow_colorboost",
	path .. "mmt_transparent_outline_shadow_colorboost.tga",
	"mMT Outline D"
)

AddClassIcons("mmt_simple", path .. "mmt_simple.tga", "mMT Simple")
AddClassIcons("mmt_simple_border", path .. "mmt_simple_border.tga", "mMT Simple Border")
AddClassIcons("mmt_simple_class", path .. "mmt_simple_class.tga", "mMT Simple Class")
AddClassIcons("mmt_simple_trans", path .. "mmt_simple_trans.tga", "mMT Simple Transp.")
AddClassIcons("mmt_simple_class_bg", path .. "mmt_simple_class_bg.tga", "mMT Simple Class BG")
