local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_InspectUI()
	if not module:CheckDB("inspect", "inspect") then
		return
	end

	local InspectFrame = _G.InspectFrame

	for i = 1, 4 do
		module:ReskinTab(_G["InspectFrameTab" .. i])
	end

	if _G.InspectModelFrame.backdrop then
		_G.InspectModelFrame.backdrop:Hide()
	end
end

module:AddCallbackForAddon("Blizzard_InspectUI")
