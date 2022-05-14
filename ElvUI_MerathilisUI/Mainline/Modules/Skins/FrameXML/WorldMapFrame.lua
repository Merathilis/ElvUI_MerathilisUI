local MER, F, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, select = pairs, select

local CreateFrame = CreateFrame
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetMaxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.mui.skins.blizzard.worldmap ~= true then return end

	_G.WorldMapFrame.backdrop:Styling()
	MER:CreateBackdropShadow(_G.WorldMapFrame)

	local frame = CreateFrame("Frame", nil, _G.QuestScrollFrame)
	frame:Size(230, 20)
	frame:SetPoint("TOP", 0, 21)
	MERS:CreateBD(frame, .25)

	frame.text = frame:CreateFontString(nil, "ARTWORK")
	frame.text:FontTemplate()
	frame.text:SetTextColor(r, g, b)
	frame.text:SetAllPoints()

	frame.text:SetText(select(2, C_QuestLog_GetNumQuestLogEntries()).."/"..C_QuestLog_GetMaxNumQuestsCanAccept().." "..L["Quests"])

	frame:SetScript("OnEvent", function(self, event)
		frame.text:SetText(select(2, C_QuestLog_GetNumQuestLogEntries()).."/"..C_QuestLog_GetMaxNumQuestsCanAccept().." "..L["Quests"])
	end)

	if _G.QuestScrollFrame.Background then
		_G.QuestScrollFrame.Background:Kill()
	end
	if _G.QuestScrollFrame.DetailFrame and _G.QuestScrollFrame.DetailFrame.backdrop then
		_G.QuestScrollFrame.DetailFrame.backdrop:SetTemplate("Transparent")
		MERS:CreateGradient(_G.QuestScrollFrame.DetailFrame.backdrop)
	end

	if _G.QuestMapFrame.DetailsFrame then
		if _G.QuestMapFrame.DetailsFrame.backdrop then
			_G.QuestMapFrame.DetailsFrame.backdrop:SetTemplate("Transparent")
			MERS:CreateGradient(_G.QuestMapFrame.DetailsFrame.backdrop)
		end
		if _G.QuestMapFrame.DetailsFrame.RewardsFrame.backdrop then
			_G.QuestMapFrame.DetailsFrame.RewardsFrame.backdrop:SetTemplate("Transparent")
			MERS:CreateGradient(_G.QuestMapFrame.DetailsFrame.RewardsFrame.backdrop)
		elseif _G.QuestMapFrame.DetailsFrame.RewardsFrame then
			_G.QuestMapFrame.DetailsFrame.RewardsFrame:CreateBackdrop("Transparent")
			MERS:CreateGradient(_G.QuestMapFrame.DetailsFrame.RewardsFrame.backdrop)
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		if not dialog.IsStyled then
			if dialog.backdrop then
				dialog.backdrop:Styling()
			end
			MER:CreateBackdropShadow(dialog)
			dialog.isStyled = true
		end
	end)
end

S:AddCallback("mUISkinWorldMap", LoadSkin)
