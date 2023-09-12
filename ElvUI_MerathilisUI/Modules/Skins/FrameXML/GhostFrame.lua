local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local GhostFrame = _G.GhostFrame

	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end

	GhostFrame:Styling()
	module:CreateGradient(GhostFrame)
	GhostFrame:SetHighlightTexture(E.media.normTex)
	GhostFrame:GetHighlightTexture():SetVertexColor(F.r, F.g, F.b, 0.35)
end

S:AddCallback("GhostFrame", LoadSkin)
