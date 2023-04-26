local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc

local function SkinDetailFrame()
	local ReputationDetailFrame = _G.ReputationDetailFrame

	if ReputationDetailFrame.backdrop then
		if not ReputationDetailFrame.backdrop.styling then
			ReputationDetailFrame.backdrop:Styling()

			ReputationDetailFrame.backdrop.styling = true
		end
	end
	module:CreateBackdropShadow(ReputationDetailFrame)
end

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	hooksecurefunc("ExpandFactionHeader", SkinDetailFrame)
	hooksecurefunc("CollapseFactionHeader", SkinDetailFrame)
	hooksecurefunc("ReputationFrame_Update", SkinDetailFrame)
end

S:AddCallback("ReputationFrame", LoadSkin)
