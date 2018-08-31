local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleHelp()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.help ~= true or E.private.muiSkins.blizzard.help ~= true then return end

	local frames = {
		"HelpFrame",
		"HelpFrameKnowledgebase",
	}

	-- skin main frames
	for i = 1, #frames do
		_G[frames[i]]:Styling()
	end

	if _G["HelpFrameHeader"].backdrop then
		_G["HelpFrameHeader"].backdrop:Hide()
	end

	MERS:CreateBD(_G["HelpFrameHeader"], .65)
	_G["HelpFrameHeader"]:Styling()
end

S:AddCallback("mUIHelp", styleHelp)