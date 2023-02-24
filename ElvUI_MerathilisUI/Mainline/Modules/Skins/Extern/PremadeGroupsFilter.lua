local MER, F, E, L, V, P, G = unpack(select(2, ...))
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

	for _, line in pairs(
		{
			"Difficulty",
			"Ilvl",
			"Noilvl",
			"Defeated",
			"Members",
			"Tanks",
			"Heals",
			"Dps",
			"MPRating",
			"PVPRating",
		}
	) do
		if frame[line] then
			if frame[line].Act then
				S:HandleCheckBox(frame[line].Act)
				frame[line].Act:Size(24)
				frame[line].Act:ClearAllPoints()
				frame[line].Act:Point("LEFT", frame[line], "LEFT", 3, -3)
			end

			if line == "Defeated" and frame[line].Title then
				frame[line].Title:SetHeight(18)
			end

			if frame[line].DropDown then
				S:HandleDropDownBox(frame[line].DropDown)
			end

			if frame[line].Min then
				S:HandleEditBox(frame[line].Min)
				frame[line].Min.backdrop:ClearAllPoints()
				frame[line].Min.backdrop:SetOutside(frame[line].Min, 0, 0)
			end

			if frame[line].Max then
				S:HandleEditBox(frame[line].Max)
				frame[line].Max.backdrop:ClearAllPoints()
				frame[line].Max.backdrop:SetOutside(frame[line].Max, 0, 0)
			end
		end
	end

	if frame.Sorting and frame.Sorting.SortingExpression then
		S:HandleEditBox(frame.Sorting.SortingExpression)
		frame.Sorting.SortingExpression.backdrop:ClearAllPoints()
		frame.Sorting.SortingExpression.backdrop:SetOutside(frame.Sorting.SortingExpression, 1, -2)
	end

	if _G.UsePFGButton then
		S:HandleCheckBox(_G.UsePFGButton)
		_G.UsePFGButton:ClearAllPoints()
		_G.UsePFGButton:Point("RIGHT", _G.LFGListFrame.SearchPanel.RefreshButton, "LEFT", -50, 0)
	end
end

module:AddCallbackForAddon("PremadeGroupsFilter")
