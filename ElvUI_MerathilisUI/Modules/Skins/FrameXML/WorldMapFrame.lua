local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local select = select

local CreateFrame = CreateFrame
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:UpdateQuestMapFrame()
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
	self:UpdateQuestMapFrame()

	local QuestMapFrame = _G.QuestMapFrame

	if QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.ScrollFrame then
		local QuestScrollFrame = QuestMapFrame.QuestsFrame.ScrollFrame
		if QuestScrollFrame.Background then
			QuestScrollFrame.Background:Kill()
		end
	end

	if QuestMapFrame.QuestsFrame and QuestMapFrame.QuestsFrame.DetailsFrame then
		local DetailsFrame = QuestMapFrame.QuestsFrame.DetailsFrame
		local RewardsFrameContainer = DetailsFrame.RewardsFrameContainer
		if DetailsFrame.backdrop then
			DetailsFrame.backdrop:SetTemplate("Transparent")
		end
		if RewardsFrameContainer and RewardsFrameContainer.RewardsFrame then
			local RewardsFrame = RewardsFrameContainer.RewardsFrame
			if RewardsFrame.backdrop then
				RewardsFrame.backdrop:SetTemplate("Transparent")
			else
				RewardsFrame:CreateBackdrop("Transparent")
				if RewardsFrame.backdrop then
					module:Reposition(RewardsFrame.backdrop, RewardsFrame, 0, -12, 0, 0, 3)

					if DetailsFrame.backdrop then
						DetailsFrame.backdrop:Point("TOPLEFT", 0, 5)
						DetailsFrame.backdrop:Point("BOTTOMRIGHT", RewardsFrame.backdrop, "TOPRIGHT", -3, 5)
					end
				end
			end
		end
	end

	hooksecurefunc(_G.QuestSessionManager, "NotifyDialogShow", function(_, dialog)
		self:CreateBackdropShadow(dialog)
	end)

	local tabs = {
		QuestMapFrame.QuestsTab,
		QuestMapFrame.EventsTab,
		QuestMapFrame.MapLegendTab,
	}
	for i, tab in pairs(tabs) do
		if tab.backdrop then
			self:CreateBackdropShadow(tab)
			tab.backdrop:SetTemplate("Transparent")
		end

		if i > 1 then
			F.MoveFrameWithOffset(tab, 0, -2)
		end
	end

	if QuestMapFrame.QuestsTab then
		QuestMapFrame.QuestsTab:ClearAllPoints()
		QuestMapFrame.QuestsTab.__MERSetPoint = QuestMapFrame.QuestsTab.SetPoint
		QuestMapFrame.QuestsTab.SetPoint = E.noop
		QuestMapFrame.QuestsTab:__MERSetPoint("TOPLEFT", QuestMapFrame, "TOPRIGHT", 13, -30)
	end
end

module:AddCallback("WorldMapFrame")
