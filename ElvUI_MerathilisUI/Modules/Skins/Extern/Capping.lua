local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local pairs = pairs

local function OnUpdate(s)
	if not s.bars then
		return
	end

	for bar in pairs(s.bars) do
		if not bar._MERSkin then
			bar:SetTemplate("Transparent")

			bar._MERSkin = true
		end
	end
end

function module:Capping()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.cap then
		return
	end

	local frame = _G.CappingFrame
	frame:HookScript("OnUpdate", OnUpdate)
end

module:AddCallbackForAddon("Capping")
