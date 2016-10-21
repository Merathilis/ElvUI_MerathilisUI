local E, L, V, P, G = unpack(ElvUI);

--[[
	This is my testing file
	So I can test stuff.
]]

-- Fix World Map taints (by lightspark)
local old_ResetZoom = WorldMapScrollFrame_ResetZoom

WorldMapScrollFrame_ResetZoom = function()
	if InCombatLockdown() then
		WorldMapFrame_Update()
		WorldMapScrollFrame_ReanchorQuestPOIs()
		WorldMapFrame_ResetPOIHitTranslations()
		WorldMapBlobFrame_DelayedUpdateBlobs()
	else
		old_ResetZoom()
	end
end

local old_QuestMapFrame_OpenToQuestDetails = QuestMapFrame_OpenToQuestDetails

QuestMapFrame_OpenToQuestDetails = function(questID)
	if InCombatLockdown() then
		ShowUIPanel(WorldMapFrame);
		QuestMapFrame_ShowQuestDetails(questID)
		QuestMapFrame.DetailsFrame.mapID = nil
	else
		old_QuestMapFrame_OpenToQuestDetails(questID)
	end
end

if WorldMapFrame.UIElementsFrame.BountyBoard.GetDisplayLocation == WorldMapBountyBoardMixin.GetDisplayLocation then
	WorldMapFrame.UIElementsFrame.ActionButton.GetDisplayLocation = function(frame, useAlternateLocation)
		if InCombatLockdown() then
			return
		end

		return WorldMapActionButtonMixin.GetDisplayLocation(frame, useAlternateLocation)
	end
end

if WorldMapFrame.UIElementsFrame.ActionButton.Refresh == WorldMapActionButtonMixin.Refresh then
	WorldMapFrame.UIElementsFrame.ActionButton.Refresh = function(frame)
		if InCombatLockdown() then
			return
		end

		WorldMapActionButtonMixin.Refresh(frame)
	end
end

WorldMapFrame.questLogMode = true
QuestMapFrame_Open(true)