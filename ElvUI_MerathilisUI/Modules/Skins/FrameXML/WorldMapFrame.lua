local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumQuestLogEntries = GetNumQuestLogEntries
local C_QuestLog_GetMaxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end

	_G.WorldMapFrame.backdrop:Styling()

	local frame = CreateFrame("Frame", nil,  _G.QuestScrollFrame)
	frame:Size(230, 20)
	frame:SetPoint("TOP", 0, 21)
	MERS:CreateBD(frame, .25)

	frame.text = frame:CreateFontString(nil, "ARTWORK")
	frame.text:FontTemplate()
	frame.text:SetTextColor(r, g, b)
	frame.text:SetAllPoints()

	frame.text:SetText(select(2, GetNumQuestLogEntries()).."/"..C_QuestLog_GetMaxNumQuestsCanAccept().." "..L["Quests"])

	frame:SetScript("OnEvent", function(self, event)
		frame.text:SetText(select(2, GetNumQuestLogEntries()).."/"..C_QuestLog_GetMaxNumQuestsCanAccept().." "..L["Quests"])
	end)

	if _G.QuestScrollFrame.DetailFrame.backdrop then
		_G.QuestScrollFrame.DetailFrame.backdrop:Hide()
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		if not dialog.IsStyled then
			if dialog.backdrop then
				dialog.backdrop:Styling()
			end
			dialog.isStyled = true
		end
	end)
end

S:AddCallback("mUISkinWorldMap", LoadSkin)
