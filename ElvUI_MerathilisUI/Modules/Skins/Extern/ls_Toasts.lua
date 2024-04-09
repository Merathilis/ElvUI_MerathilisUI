local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local unpack = unpack
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
if not C_AddOns_IsAddOnLoaded("ls_Toasts") then
	return
end

local LST = unpack(ls_Toasts)

LST:RegisterSkin("MerathilisUI", {
	name = MER.Title,
	template = "elv-no-art",
	border = {
		texture = { 0, 0, 0, 0.75 },
	},
	icon = {
		tex_coords = { 0.08, 0.92, 0.08, 0.92 },
	},
	icon_border = {
		offset = 1,
		texture = { 1, 1, 1, 1 },
	},
	icon_highlight = {
		hidden = true,
	},
	icon_text_1 = {
		flags = "SHADOWOUTLINE",
	},
	icon_text_2 = {
		flags = "SHADOWOUTLINE",
	},
	dragon = {
		hidden = true,
	},
	slot = {
		tex_coords = { 0.08, 0.92, 0.08, 0.92 },
	},
	slot_border = {
		color = { 0, 0, 0 },
		offset = 0,
		size = 1,
		texture = { 1, 1, 1, 1 },
	},
	shine = {
		tex_coords = { 403 / 512, 465 / 512, 15 / 256, 61 / 256 },
		size = { 67, 50 },
		point = {
			y = -1,
		},
	},
	bg = {
		default = {
			color = { 0, 0, 0, 0.75 },
			texture = { 0, 0, 0, 0.75 },
			tex_coords = { 1 / 512, 449 / 512, 1 / 128, 97 / 128 },
			tile = true,
		},
	},
})

LST.RegisterCallback({}, "SetSkin", function(_, toast)
	if toast and not toast.skinned then
		module:CreateShadow(toast)
		toast.skinned = true
	end
end)
