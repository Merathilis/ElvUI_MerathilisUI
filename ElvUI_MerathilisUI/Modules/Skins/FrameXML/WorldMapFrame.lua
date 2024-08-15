local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local select = select

local CreateFrame = CreateFrame
local GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local GetMaxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept
local hooksecurefunc = hooksecurefunc

local MAX_QUESTS = 35 -- manually increase it

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function SkinDialog(_, dialog)
	if not dialog.__MERSkin then
		module:CreateBackdropShadow(dialog)
		dialog.__MERSkin = true
	end
end

function module:WorldMapFrame()
	if not module:CheckDB("worldmap", "worldmap") then
		return
	end

	module:CreateBackdropShadow(_G.WorldMapFrame)

	local frame = CreateFrame("Frame", nil, _G.QuestScrollFrame)
	frame:Size(230, 20)
	frame:SetPoint("BOTTOM", _G.QuestScrollFrame.SearchBox, "TOP", 0, 0)

	frame.text = frame:CreateFontString(nil, "ARTWORK")
	frame.text:FontTemplate()
	frame.text:SetTextColor(r, g, b)
	frame.text:SetAllPoints()

	frame.text:SetText(
		select(2, GetNumQuestLogEntries())
			.. "/" --[[GetMaxNumQuestsCanAccept()]]
			.. MAX_QUESTS
			.. " "
			.. L["Quests"]
	)

	frame:SetScript("OnEvent", function(self, event)
		frame.text:SetText(
			select(2, GetNumQuestLogEntries())
				.. "/" --[[GetMaxNumQuestsCanAccept()]]
				.. MAX_QUESTS
				.. " "
				.. L["Quests"]
		)
	end)

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
