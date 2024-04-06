local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

function SkinDetailFrame()
	local ReputationDetailFrame = _G.ReputationDetailFrame

	module:CreateBackdropShadow(ReputationDetailFrame)
end

function module:ReputationFrame()
	if not module:CheckDB("character", "character") then
		return
	end

	hooksecurefunc("ExpandFactionHeader", SkinDetailFrame)
	hooksecurefunc("CollapseFactionHeader", SkinDetailFrame)
	hooksecurefunc("ReputationFrame_Update", SkinDetailFrame)
end

module:AddCallback("ReputationFrame")
