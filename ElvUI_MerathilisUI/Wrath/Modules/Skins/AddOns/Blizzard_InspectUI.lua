local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("inspect", "inspect") then
		return
	end

	local InspectFrame = _G.InspectFrame
	InspectFrame.backdrop:Styling()
	module:CreateBackdropShadow(InspectFrame)
end

S:AddCallbackForAddon("Blizzard_InspectUI", LoadSkin)

