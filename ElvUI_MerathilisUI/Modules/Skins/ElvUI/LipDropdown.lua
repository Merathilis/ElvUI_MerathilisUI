local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

function module:S_SkinLibDropDownMenu(_, prefix)
	if not E.private.mui then
		self:AddCallback("SkinLibDropDown" .. prefix, function()
			self:S_SkinLibDropDownMenu(nil, prefix)
		end)
		return
	end

	if _G[prefix .. "_UIDropDownMenu_CreateFrames"] then
		local bd = _G[prefix .. "_DropDownList1Backdrop"]
		local mbd = _G[prefix .. "_DropDownList1MenuBackdrop"]
		if bd and bd.template then
			self:Styling()
			self:CreateShadow(bd)
		end
		if mbd and mbd.template then
			self:Styling()
			self:CreateShadow(bd)
		end

		S[prefix .. "_UIDropDownMenuSkinned"] = true
		hooksecurefunc(prefix .. "_UIDropDownMenu_CreateFrames", function()
			local lvls = _G[(prefix == "Lib" and "LIB" or prefix) .. "_UIDROPDOWNMENU_MAXLEVELS"]
			local ddbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "Backdrop"]
			local ddmbd = lvls and _G[prefix .. "_DropDownList" .. lvls .. "MenuBackdrop"]
			if ddbd and ddbd.template then
				self:Styling()
				self:CreateShadow(bd)
			end
			if ddmbd and ddmbd.template then
				self:Styling()
				self:CreateShadow(bd)
			end
		end)
	end
end

module:SecureHook(S, 'SkinLibDropDownMenu', 'S_SkinLibDropDownMenu')
