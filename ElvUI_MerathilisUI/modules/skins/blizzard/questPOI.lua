local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local next = next
-- WoW API / Variables

-- GLOBALS: hooksecurefunc, QuestPOI_GetButton, QuestPOINumericTemplate, QuestPOICompletedTemplate
do
	function QuestPOI_GetButton(parent, questID, style, index)
		if E.private.skins.blizzard.enable ~= true or E.private.muiSkins.blizzard.questPOI ~= true then return; end

		local poiButton
		if style == "numeric" then
			poiButton = parent.poiTable.numeric[index]
			if not poiButton.IsSkinned then
				QuestPOINumericTemplate(poiButton)
			end
		else
			for _, button in next, parent.poiTable.completed do
				if button.questID == questID then
					poiButton = button
					break
				end
			end
			if not poiButton.IsSkinned then
				QuestPOICompletedTemplate(poiButton)
			end
		end
	end
end
hooksecurefunc("QuestPOI_GetButton", QuestPOI_GetButton)

do
	local function QuestPOINumericTemplate(button)
		button:SetSize(20, 20)
		button.Number:SetSize(32, 32)
		button.NormalTexture:SetSize(32, 32)
		button.HighlightTexture:SetSize(32, 32)
		button.PushedTexture:SetSize(32, 32)
	end

	local function QuestPOICompletedTemplate(button)
		button:SetSize(20, 20)
		button.FullHighlightTexture:SetSize(32, 32)
		button.NormalTexture:SetSize(32, 32)
		button.PushedTexture:SetSize(32, 32)
	end
end