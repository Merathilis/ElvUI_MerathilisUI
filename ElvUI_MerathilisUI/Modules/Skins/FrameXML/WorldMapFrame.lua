local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local select = select

local CreateFrame = CreateFrame
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function SkinDialog(_, dialog)
	if not dialog.__MERSkin then
		module:CreateBackdropShadow(dialog)
		dialog.__MERSkin = true
	end
end

function module.UpdateQuestMapFrame()
	local frame = CreateFrame("Frame", nil, _G.QuestScrollFrame)
	QuestMapFrame.QuestCountFrame = frame

	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:Size(240, 20)
	frame:SetPoint("BOTTOM", _G.QuestScrollFrame.SearchBox, "TOP", 0, 0)

	local text = frame:CreateFontString(nil, "ARTWORK")
	text:FontTemplate(E.LSM:Fetch("font", E.db.general.font), 12, "SHADOWOUTLINE")
	text:SetTextColor(r, g, b)
	text:SetAllPoints()

	frame.text = text
	local str = "%d / 35" .. " " .. L["Quests"]
	frame.text:SetFormattedText(str, select(2, C_QuestLog_GetNumQuestLogEntries()))

	frame:SetScript("OnEvent", function()
		local _, quests = C_QuestLog_GetNumQuestLogEntries()

		frame.text:SetFormattedText(str, quests)
	end)
end

function module:WorldMapFrame()
	if not module:CheckDB("worldmap", "worldmap") then
		return
	end

	module:CreateBackdropShadow(_G.WorldMapFrame)
	self.UpdateQuestMapFrame()

	if _G.QuestScrollFrame.Background then
		_G.QuestScrollFrame.Background:Kill()
	end
	if _G.QuestScrollFrame.DetailFrame and _G.QuestScrollFrame.DetailFrame.backdrop then
		_G.QuestScrollFrame.DetailFrame.backdrop:SetTemplate("Transparent")
	end

	if _G.QuestMapFrame.DetailsFrame then
		if _G.QuestMapFrame.DetailsFrame.backdrop then
			_G.QuestMapFrame.DetailsFrame.backdrop:SetTemplate("Transparent")
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", SkinDialog)
end

module:AddCallback("WorldMapFrame")
