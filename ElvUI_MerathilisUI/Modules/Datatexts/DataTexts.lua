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
E.FrameLocks["MER_RightChatTopDT"] = true
DT:RegisterPanel(ChatTabFrame, 3, "ANCHOR_TOPLEFT", 3, 4)

function MER:InitDataTexts()
	MER_RightChatTopDT:Point("TOPRIGHT", _G.RightChatTab, "TOPRIGHT", 0, E.mult)
	MER_RightChatTopDT:Point("BOTTOMLEFT", _G.RightChatTab, "BOTTOMLEFT", 0, E.mult)
end
