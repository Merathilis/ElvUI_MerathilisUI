local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:GhostFrame()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local GhostFrame = _G.GhostFrame

	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end

	GhostFrame:SetHighlightTexture(E.media.normTex)
	GhostFrame:GetHighlightTexture():SetVertexColor(F.r, F.g, F.b, 0.35)
end

module:AddCallback("GhostFrame")
