local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

function module:StyleLibDropDownMenu(_, prefix)
	if _G[prefix .. "_UIDropDownMenu_CreateFrames"] then
		local bd = _G[prefix .. "_DropDownList1Backdrop"]
		local mbd = _G[prefix .. "_DropDownList1MenuBackdrop"]
		if bd and bd.template then
			MER:CreateShadow(bd)
		end
		if mbd and mbd.template then
			MER:CreateShadow(bd)
		end

		S[prefix .. "_UIDropDownMenuSkinned"] = true
		hooksecurefunc(prefix .. "_UIDropDownMenu_CreateFrames",function()
			local lvls = _G[(prefix == "Lib" and "LIB" or prefix) .. "_UIDROPDOWNMENU_MAXLEVELS"]
			local ddbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "Backdrop"]
			local ddmbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "MenuBackdrop"]
			if ddbd and ddbd.template then
				MER:CreateShadow(bd)
			end
			if ddmbd and ddmbd.template then
				MER:CreateShadow(bd)
			end
		end)
	end
end

module:SecureHook(S, "SkinLibDropDownMenu", "StyleLibDropDownMenu")