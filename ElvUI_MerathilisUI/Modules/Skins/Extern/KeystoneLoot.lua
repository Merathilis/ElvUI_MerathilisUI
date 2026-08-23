local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

-- Credits: Ndui_Plus

local function HandleItemButton(self)
	S:HandleIcon(self.Icon, true)
	S:HandleIconBorder(self.IconBorder, self.Icon.backdrop)
end

local function ReskinTabSystem(self)
	if not self.TabSystem then
		return
	end

	for _, tab in ipairs(self.TabSystem.tabs) do
		S:HandleTab(tab)
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")
		tab.Text.SetPoint = E.noop
		tab.leftPadding = -16
	end
end

local function ReskinIconButton(self)
	local frame = self.Content
	if frame and not self.IsSkinned then
		HandleItemButton(frame)
		frame.IconEmpty:SetAlpha(0)

		self.IsSkinned = true
	end
end

local function ReskinSubFrame(self)
	self.Inset:StripTextures()
	self.BorderFrame:StripTextures()
end

local function ReskinEntryFrame(self)
	if self.Background then
		self.Background:SetAlpha(0)
	end

	local button = self.TeleportButton
	if button then
		S:HandleIcon(button.Icon, true)
		button.IconBorder:SetAlpha(0)
		button.HL = button:CreateTexture(nil, "HIGHLIGHT")
		button.HL:SetColorTexture(1, 1, 1, 0.25)
		button.HL:SetInside(button.backdrop)
	end
end

local function ReskinReminderSpec(self)
	self:StripTextures()
	self.Bg:CreateBackdrop("Transparent")
	S:HandleButton(self.LootSpecButton)
end

local function ReskinReminderIcon(self)
	if not self.IsSkinned then
		HandleItemButton(self)

		self.IsSkinned = true
	end
end

local function rowOnEnter(self)
	self.backdrop:SetBackdropBorderColor(F.r, F.g, F.b)
end

local function rowOnLeave(self)
	self.backdrop:SetBackdropBorderColor(0, 0, 0)
end

local function ReskinNotificationRow(self)
	if not self.rowPool then
		return
	end

	for row in self.rowPool:EnumerateActive() do
		if not row.styled then
			row:StripTextures()
			row:CreateBackdrop("Transparent")
			row:HookScript("OnEnter", rowOnEnter)
			row:HookScript("OnLeave", rowOnLeave)
			HandleItemButton(row.IconFrame)

			local button = row.WhisperButton
			S:HandleButton(button)
			button.backdrop:SetInside(nil, 2, 2)
			button.Icon = button:CreateTexture(nil, "ARTWORK")
			button.Icon:SetTexture([[Interface\CHATFRAME\UI-ChatWhisperIcon]])
			button.Icon:SetPoint("CENTER")
			button.Icon:SetSize(24, 24)

			row.styled = true
		end
	end
end

function module:KeystoneLoot()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.klf then
		return
	end

	local frame = _G.KeystoneLootFrame
	if not frame then
		return
	end

	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	S:HandleDropDownBox(frame.SlotDropdown)
	S:HandleDropDownBox(frame.ClassDropdown)
	S:HandleDropDownBox(frame.ItemLevelDropdown)
	MER:SecureHook(frame, "InitializeTabSystem", ReskinTabSystem)

	local SettingsDropdown = frame.SettingsDropdown
	if SettingsDropdown then
		SettingsDropdown:ClearAllPoints()
		SettingsDropdown:SetPoint("TOPRIGHT", -28, -6)
	end

	local CatalystFrame = frame.CatalystFrame
	if CatalystFrame then
		CatalystFrame:ClearAllPoints()
		CatalystFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -40)
		CatalystFrame.Border:StripTextures()
		CatalystFrame:CreateBackdrop("Transparent")
		CatalystFrame.backdrop:SetInside()
	end

	MER:SecureHook(_G.KeystoneLootLootIconButtonMixin, "Init", ReskinIconButton)
	MER:SecureHook(_G.KeystoneLootDungeonsFrameMixin, "OnLoad", ReskinSubFrame)
	MER:SecureHook(_G.KeystoneLootRaidBlockMixin, "OnLoad", ReskinSubFrame)
	MER:SecureHook(_G.KeystoneLootEntryFrameMixin, "OnLoad", ReskinEntryFrame)

	-- ReminderFrame
	local ReminderFrame = _G.KeystoneLootReminderFrame
	if ReminderFrame then
		S:HandlePortraitFrame(ReminderFrame)
	end

	MER:SecureHook(_G.KeystoneLootReminderSpecMixin, "OnLoad", ReskinReminderSpec)
	MER:SecureHook(_G.KeystoneLootReminderIconMixin, "Init", ReskinReminderIcon)

	-- NotificationFrame
	local NotificationFrame = _G.KeystoneLootDropNotificationFrame
	if NotificationFrame then
		S:HandlePortraitFrame(NotificationFrame)
		MER:SecureHook(NotificationFrame, "Refresh", ReskinNotificationRow)
	end

	-- KSLMenu
	local KSLMenu = _G.KSLMenu
	if not KSLMenu then
		return
	end

	-- from NDui
	local menuManagerProxy = KSLMenu.GetManager()

	local backdrops = {}

	local function skinMenu(menuFrame)
		menuFrame:StripTextures()

		if backdrops[menuFrame] then
			menuFrame.backdrop = backdrops[menuFrame]
		else
			menuFrame:CreateBackdrop("Transparent")
			backdrops[menuFrame] = menuFrame.backdrop
		end

		local framelevel = menuFrame:GetFrameLevel() - 1
		menuFrame.backdrop:SetFrameLevel(framelevel < 0 and 0 or framelevel)

		if not menuFrame.ScrollBar.styled then
			S:HandleTrimScrollBar(menuFrame.ScrollBar)
			menuFrame.ScrollBar.styled = true
		end

		for i = 1, menuFrame:GetNumChildren() do
			local child = select(i, menuFrame:GetChildren())

			local minLevel = child.MinLevel
			if minLevel and not minLevel.styled then
				S:HandleEditBox(minLevel)
				minLevel.styled = true
			end

			local maxLevel = child.MaxLevel
			if maxLevel and not maxLevel.styled then
				S:HandleEditBox(maxLevel)
				maxLevel.styled = true
			end
		end
	end

	local function setupMenu(manager, _, menuDescription)
		local menuFrame = manager:GetOpenMenu()
		if menuFrame then
			skinMenu(menuFrame)
			menuDescription:AddMenuAcquiredCallback(skinMenu)
		end
	end

	hooksecurefunc(menuManagerProxy, "OpenMenu", setupMenu)
	hooksecurefunc(menuManagerProxy, "OpenContextMenu", setupMenu)
end

module:AddCallbackForAddon("KeystoneLoot")
