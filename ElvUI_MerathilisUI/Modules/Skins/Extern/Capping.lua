local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local function OnUpdate(s)
	if not s.bars then
		return
	end

	for bar in pairs(s.bars) do
		local icon = bar.candyBarIconFrame
		local db = _G.CappingFrame.db.profile

		if not bar._MERSkin then
			bar:CreateBackdrop("Transparent")

			--[[
				TO DO: Make the Icon position a bit prettier
			--]]
			if db.icon then
				S:HandleIcon(icon)
			end

			bar._MERSkin = true
		end
	end
end

function module:Capping()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.cap then
		return
	end

	if not C_AddOns_IsAddOnLoaded("Capping") then
		return
	end

	local frame = _G.CappingFrame
	frame:HookScript("OnUpdate", OnUpdate)
end

module:AddCallbackForAddon("Capping")
