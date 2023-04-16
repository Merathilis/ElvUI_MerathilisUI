local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("guide", "guide") then
		return
	end

	local frame = _G.GuideFrame
	frame:Styling()
	module:CreateShadow(frame)
end

S:AddCallbackForAddon("Blizzard_NewPlayerExperienceGuide", LoadSkin)
