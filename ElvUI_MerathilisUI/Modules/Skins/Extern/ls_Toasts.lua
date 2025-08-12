local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack

function module:ls_Toasts()
	if not E.private.mui.skins.addonSkins.enable then
		return
	end

	local LST = unpack(_G.ls_Toasts)
	if not LST then
		return
	end

	LST:RegisterSkin("MerathilisUI", {
		name = MER.Title,
		template = "elv",
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
		if toast and not toast.__MERSkin then
			module:CreateShadow(toast)
			toast.__MERSkin = true
		end
	end)
end

module:AddCallbackForAddon("ls_Toasts")
