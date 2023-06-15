local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E.Skins

local _G = _G
local pairs = pairs
local strmatch = strmatch

function module:PremadeGroupsFilter_SetPoint(frame, point, relativeFrame, relativePoint, x, y)
	if point == "TOPLEFT" and relativePoint == "TOPRIGHT" then
		if (not x and not y) or (x == 0 and y == 0) then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", relativeFrame, "TOPRIGHT", 5, 0)
		end
	end
end

function module:PremadeGroupsFilter()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pf then
		return
	end

	self:DisableAddOnSkins("PremadeGroupsFilter", false)

	local frame = _G.PremadeGroupsFilterDialog
	S:HandleFrame(frame, true)

	frame.backdrop:SetTemplate("Transparent")
	frame.backdrop:ClearAllPoints()
	frame.backdrop:Point("TOPLEFT", frame, "TOPLEFT", -1, 0)
	frame.backdrop:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

	frame.backdrop:Styling()
	self:CreateBackdropShadow(frame, true)

	self:SecureHook(frame, "SetPoint", "PremadeGroupsFilter_SetPoint")

	for i = 1, frame:GetNumPoints() do
		module:PremadeGroupsFilter_SetPoint(frame, frame:GetPoint())
	end

	if frame.Advanced then
		for _, region in pairs {frame.Advanced:GetRegions()} do
			local name = region.GetName and region:GetName()
			if name and (strmatch(name, "Corner") or strmatch(name, "Border")) then
				region:StripTextures()
			end
		end
	end

	if frame.Expression then
		S:HandleEditBox(frame.Expression)
	end

	if frame.ResetButton then
		S:HandleButton(frame.ResetButton)
	end

	if frame.RefreshButton then
		S:HandleButton(frame.RefreshButton)
	end

	if frame.MaxMinButtonFrame.MinimizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MinimizeButton, "up", nil, true)
		frame.MaxMinButtonFrame.MinimizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MinimizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	if frame.MaxMinButtonFrame.MaximizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MaximizeButton, "down", nil, true)
		frame.MaxMinButtonFrame.MaximizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MaximizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	local dungeonPanel = _G.PremadeGroupsFilterDungeonPanel
	if dungeonPanel then
		-- CheckBoxes
		for _, checkButton in pairs({
			dungeonPanel.Group.Difficulty.Act,
			dungeonPanel.Group.MPRating.Act,
			dungeonPanel.Group.Members.Act,
			dungeonPanel.Group.Tanks.Act,
			dungeonPanel.Group.Heals.Act,
			dungeonPanel.Group.DPS.Act,
			dungeonPanel.Group.Partyfit.Act,
			dungeonPanel.Group.BLFit.Act,
			dungeonPanel.Group.BRFit.Act,
			dungeonPanel.Dungeons.Dungeon1.Act,
			dungeonPanel.Dungeons.Dungeon2.Act,
			dungeonPanel.Dungeons.Dungeon3.Act,
			dungeonPanel.Dungeons.Dungeon4.Act,
			dungeonPanel.Dungeons.Dungeon5.Act,
			dungeonPanel.Dungeons.Dungeon6.Act,
			dungeonPanel.Dungeons.Dungeon7.Act,
			dungeonPanel.Dungeons.Dungeon8.Act,
		}) do
			if checkButton then
				S:HandleCheckBox(checkButton)
			end
		end

		-- EditBox
		for _, editBox in pairs({
			dungeonPanel.Group.MPRating.Min,
			dungeonPanel.Group.MPRating.Max,
			dungeonPanel.Group.Members.Min,
			dungeonPanel.Group.Members.Max,
			dungeonPanel.Group.Tanks.Min,
			dungeonPanel.Group.Tanks.Max,
			dungeonPanel.Group.Heals.Min,
			dungeonPanel.Group.Heals.Max,
			dungeonPanel.Group.DPS.Min,
			dungeonPanel.Group.DPS.Max,
		}) do
			if editBox then
				S:HandleEditBox(editBox)
			end
		end

		-- DropBox
		S:HandleDropDownBox(dungeonPanel.Group.Difficulty.DropDown)

		-- BigEditBox
		S:HandleEditBox(dungeonPanel.Advanced.Expression)

	end

	if frame.Sorting and frame.Sorting.SortingExpression then
		S:HandleEditBox(frame.Sorting.SortingExpression)
		frame.Sorting.SortingExpression.backdrop:ClearAllPoints()
		frame.Sorting.SortingExpression.backdrop:SetOutside(frame.Sorting.SortingExpression, 1, -2)
	end

	local button = _G.UsePFGButton or _G.UsePGFButton
	if button then
		S:HandleCheckBox(button)
		button:ClearAllPoints()
		button:Point("RIGHT", _G.LFGListFrame.SearchPanel.RefreshButton, "LEFT", -50, 0)
	end
end

module:AddCallbackForAddon("PremadeGroupsFilter")
