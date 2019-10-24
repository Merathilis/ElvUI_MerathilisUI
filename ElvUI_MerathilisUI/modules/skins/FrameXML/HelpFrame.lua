local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.help ~= true or E.private.muiSkins.blizzard.help ~= true then return end

	local frames = {
		"HelpFrame",
		"HelpFrameKnowledgebase",
	}

	-- skin main frames
	for i = 1, #frames do
		_G[frames[i]]:Styling()
	end

	local HelpFrameHeader = _G.HelpFrameHeader
	if HelpFrameHeader.backdrop then
		HelpFrameHeader.backdrop:Hide()
	end

	MERS:CreateBD(HelpFrameHeader, .65)
	HelpFrameHeader:Styling()
end

S:AddCallback("mUIHelp", LoadSkin)
