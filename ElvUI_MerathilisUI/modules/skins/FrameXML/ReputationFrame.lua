local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local hooksecurefunc = hooksecurefunc

local function SkinDetailFrame()
	local ReputationDetailFrame = _G.ReputationDetailFrame

	if ReputationDetailFrame.backdrop then
		if not ReputationDetailFrame.backdrop.styling then
			ReputationDetailFrame.backdrop:Styling()

			ReputationDetailFrame.backdrop.styling = true
		end
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.private.muiSkins.blizzard.character ~= true then return end

	hooksecurefunc("ExpandFactionHeader", SkinDetailFrame)
	hooksecurefunc("CollapseFactionHeader", SkinDetailFrame)
	hooksecurefunc("ReputationFrame_Update", SkinDetailFrame)
end

S:AddCallback("mUIReputation", LoadSkin)
