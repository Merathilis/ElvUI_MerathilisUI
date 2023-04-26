local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("dressingroom", "dressingroom") then
		return
	end

	local DressUpFrame = _G.DressUpFrame
	if DressUpFrame.backdrop then
		DressUpFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(_G.DressUpFrame)
end

S:AddCallback("DressUpFrame", LoadSkin)
