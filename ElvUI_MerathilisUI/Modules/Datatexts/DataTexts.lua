local MER, E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local PANEL_HEIGHT = 22

local ChatTabFrame = CreateFrame("Frame", "MER_RightChatTopDT", _G.RightChatPanel)
ChatTabFrame:Height(PANEL_HEIGHT)
ChatTabFrame:Width(411)
ChatTabFrame:SetFrameStrata("LOW")
E.FrameLocks["MER_RightChatTopDT"] = true

function MER:InitDataTexts()
	MER_RightChatTopDT:Point("TOPRIGHT", _G.RightChatTab, "TOPRIGHT", 0, E.mult)
	MER_RightChatTopDT:Point("BOTTOMLEFT", _G.RightChatTab, "BOTTOMLEFT", 0, E.mult)

	hooksecurefunc(DT, "UpdatePanelInfo", function(DT, panelName, panel)
		if not panel then return end
		local db = panel.db or P.datatexts.panels[panelName] and DT.db.panels[panelName]
		if not db then return end

		-- Need to find a way to hide my styling if changing the option from a panel
		if panel and not panel.styled then
			if db.backdrop then
				panel:Styling()
			end
			panel.styled = true
		end
	end)
end
