local MER, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS:

local PANEL_HEIGHT = 22

local ChatTabFrame = CreateFrame("Frame", "MER_RightChatTopDT", _G.RightChatPanel)
ChatTabFrame:Height(PANEL_HEIGHT)
ChatTabFrame:Width(411)
ChatTabFrame:SetFrameStrata("LOW")

function MER:InitDataTexts()
	MER_RightChatTopDT:Point("TOP", _G.RightChatPanel, "TOP", 0, E.mult)
end
