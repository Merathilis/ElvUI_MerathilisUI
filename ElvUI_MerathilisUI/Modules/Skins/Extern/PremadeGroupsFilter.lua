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

	local DungeonPanel = _G.PremadeGroupsFilterDungeonPanel
	if not DungeonPanel then return end

	local ArenaPanel = _G.PremadeGroupsFilterArenaPanel
	local RBGPanel = _G.PremadeGroupsFilterRBGPanel
	local RaidPanel = _G.PremadeGroupsFilterRaidPanel
	local ExpressionPanel = _G.PremadeGroupsFilterExpressionPanel
	local PGFDialog = _G.PremadeGroupsFilterDialog

	local names = { "Difficulty", "MPRating", "Members", "Tanks", "Heals", "DPS", "Partyfit", "BLFit", "BRFit", "Defeated", "MatchingId", "PvPRating" }

	local function handleGroup(panel)
		for _, name in pairs(names) do
			local frame = panel.Group[name]
			if frame then
				local check = frame.Act
				if check then
					check:SetSize(26, 26)
					check:SetPoint("TOPLEFT", 5, -1)
					S:HandleCheckBox(check)
				end
				local input = frame.Min
				if input then
					S:HandleEditBox(input)
					S:HandleEditBox(frame.Max)
				end
				if frame.DropDown then
					S:HandleDropDownBox(frame.DropDown)
				end
			end
		end

		S:HandleEditBox(panel.Advanced.Expression)
	end

	local styled
	hooksecurefunc(PGFDialog, "Show", function(self)
		if styled then return end
		styled = true

		self:StripTextures()
		self:CreateBackdrop('Transparent')
		self.backdrop:ClearAllPoints()
		self.backdrop:Point("TOPLEFT", self, "TOPLEFT", -1, 0)
		self.backdrop:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)

		self.backdrop:Styling()
		module:CreateBackdropShadow(self, true)

		S:HandleCloseButton(self.CloseButton)
		S:HandleButton(self.ResetButton)
		S:HandleButton(self.RefreshButton)

		S:HandleEditBox(ExpressionPanel.Advanced.Expression)
		S:HandleEditBox(ExpressionPanel.Sorting.Expression)

		local button = self.MaxMinButtonFrame
		if button.MinimizeButton then
			S:HandleNextPrevButton(button.MinimizeButton, "down")
			button.MinimizeButton:ClearAllPoints()
			button.MinimizeButton:SetPoint("RIGHT", self.CloseButton, "LEFT", -3, 0)
			S:HandleNextPrevButton(button.MaximizeButton, "up")
			button.MaximizeButton:ClearAllPoints()
			button.MaximizeButton:SetPoint("RIGHT", self.CloseButton, "LEFT", -3, 0)
		end

		handleGroup(RaidPanel)
		handleGroup(DungeonPanel)
		handleGroup(ArenaPanel)
		handleGroup(RBGPanel)

		for i = 1, 8 do
			local dungeon = DungeonPanel.Dungeons["Dungeon" .. i]
			local check = dungeon and dungeon.Act
			if check then
				check:SetSize(26, 26)
				check:SetPoint("TOPLEFT", 5, -1)
				S:HandleCheckBox(check)
			end
		end
	end)

	module:SecureHook(PGFDialog, "SetPoint", "PremadeGroupsFilter_SetPoint")
	for i = 1, PGFDialog:GetNumPoints() do
		module:PremadeGroupsFilter_SetPoint(PGFDialog, PGFDialog:GetPoint())
	end

	local button = UsePGFButton
	if button then
		S:HandleCheckBox(button)
		button.text:SetWidth(35)
	end
end

module:AddCallbackForAddon("PremadeGroupsFilter")
