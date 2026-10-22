local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local ipairs = ipairs
local unpack = unpack
local hooksecurefunc = hooksecurefunc

local C_Item_GetItemQualityByID = C_Item.GetItemQualityByID

-- Credits: Ndui_Plus

local function HandleIcon(holder)
	S:HandleIcon(holder.Icon, true)
	holder.IconBorder:SetAlpha(0)
end

-- The addon never tints its quickslot ring, so color the backdrop by item quality instead
local function SetQualityBorder(icon, itemID)
	local quality = itemID and itemID ~= 0 and C_Item_GetItemQualityByID(itemID)
	if quality and quality > 1 then
		icon.backdrop:SetBackdropBorderColor(E:GetItemQualityColor(quality))
	else
		icon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end

local function HoverBorder_OnEnter(self)
	self.backdrop:SetBackdropBorderColor(F.r, F.g, F.b)
end

local function HoverBorder_OnLeave(self)
	self.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

local function AddHoverBorder(frame)
	frame:HookScript("OnEnter", HoverBorder_OnEnter)
	frame:HookScript("OnLeave", HoverBorder_OnLeave)
end

local function ReskinTabSystem(self)
	local tabSystem = self.TabSystem
	for _, tab in ipairs(tabSystem.tabs) do
		S:HandleTab(tab)

		-- Init sized the text with the Blizzard font; free it so the width is measured again
		tab.Text:SetWidth(0)
		tab:UpdateTabWidth()
	end

	tabSystem:MarkDirty()
end

local function ReskinSidePanel(panel, point, relativePoint, x)
	if not panel then
		return
	end

	panel:ClearAllPoints()
	panel:SetPoint(point, _G.KeystoneLootFrame, relativePoint, x, -40)
	panel.Border:StripTextures()
	panel:CreateBackdrop("Transparent")
	WS:CreateShadow(panel.backdrop)
end

local function ReskinPopupFrame(frame)
	if not frame then
		return
	end

	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)
end

local function ReskinLootIcon(self)
	HandleIcon(self.Content)
	self.Content.IconEmpty:SetAlpha(0)
end

local function UpdateLootIcon(self, item)
	SetQualityBorder(self.Content.Icon, item and item.itemId)
end

local function ReskinSubFrame(self)
	self.Inset:StripTextures()
	self.BorderFrame:StripTextures()
end

local function ReskinEntryFrame(self)
	self.Background:SetAlpha(0)

	local button = self.TeleportButton
	HandleIcon(button)

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetColorTexture(1, 1, 1, 0.25)
	highlight:SetAllPoints(button.Icon)
end

local function ReskinReminderSpec(self)
	self:StripTextures()
	self.Bg:CreateBackdrop("Transparent")
	S:HandleButton(self.LootSpecButton)
end

local function UpdateReminderIcon(self, itemID)
	if not self.__MERSkin then
		HandleIcon(self)
		self.__MERSkin = true
	end

	SetQualityBorder(self.Icon, itemID)
end

local function UpdateNotificationRow(self, drop)
	if not self.__MERSkin then
		self:StripTextures()
		self:CreateBackdrop("Transparent")
		AddHoverBorder(self)
		HandleIcon(self.IconFrame)

		local button = self.WhisperButton
		S:HandleButton(button)
		button.backdrop:SetInside(nil, 2, 2)

		local icon = button:CreateTexture(nil, "ARTWORK")
		icon:SetTexture([[Interface\CHATFRAME\UI-ChatWhisperIcon]])
		icon:SetPoint("CENTER")
		icon:SetSize(24, 24)

		self.__MERSkin = true
	end

	SetQualityBorder(self.IconFrame.Icon, drop and drop.itemId)
end

local function ReskinMythicPlusCard(card)
	if not card then
		return
	end

	-- The card keeps its Error and RoleIcon atlases, so only the item-card art is hidden
	for _, region in ipairs({ card:GetRegions() }) do
		local atlas = region:IsObjectType("Texture") and region:GetAtlas()
		if atlas and atlas:find("^looting_itemcard") then
			region:SetAlpha(0)
		end
	end

	card:CreateBackdrop("Transparent")
	AddHoverBorder(card)
	HandleIcon(card)

	-- Card and icon backdrop both land one level below the card; drop the card's so the icon frame stays on top
	local frameLevel = card:GetFrameLevel() - 2
	card.backdrop:SetFrameLevel(frameLevel < 0 and 0 or frameLevel)
end

local function ReskinMenus()
	local KSLMenu = _G.KSLMenu
	if not KSLMenu then
		return
	end

	-- from NDui
	local backdrops = {}

	local function skinMenu(menuFrame)
		menuFrame:StripTextures()

		if backdrops[menuFrame] then
			menuFrame.backdrop = backdrops[menuFrame]
		else
			menuFrame:CreateBackdrop("Transparent")
			backdrops[menuFrame] = menuFrame.backdrop
		end

		local frameLevel = menuFrame:GetFrameLevel() - 1
		menuFrame.backdrop:SetFrameLevel(frameLevel < 0 and 0 or frameLevel)

		local scrollBar = menuFrame.ScrollBar
		if scrollBar and not scrollBar.__MERSkin then
			S:HandleTrimScrollBar(scrollBar)
			scrollBar.__MERSkin = true
		end
	end

	local function setupMenu(manager, _, menuDescription)
		local menuFrame = manager:GetOpenMenu()
		if menuFrame then
			skinMenu(menuFrame)
			menuDescription:AddMenuAcquiredCallback(skinMenu)
		end
	end

	local menuManagerProxy = KSLMenu.GetManager()
	hooksecurefunc(menuManagerProxy, "OpenMenu", setupMenu)
	hooksecurefunc(menuManagerProxy, "OpenContextMenu", setupMenu)
end

function module:KeystoneLoot()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.klf then
		return
	end

	local frame = _G.KeystoneLootFrame
	if not frame then
		return
	end

	-- Pooled frames are created after this point, so hooking the mixins reaches all of them
	MER:SecureHook(_G.KeystoneLootLootIconButtonMixin, "OnLoad", ReskinLootIcon)
	MER:SecureHook(_G.KeystoneLootLootIconButtonMixin, "Init", UpdateLootIcon)
	MER:SecureHook(_G.KeystoneLootDungeonsFrameMixin, "OnLoad", ReskinSubFrame)
	MER:SecureHook(_G.KeystoneLootRaidBlockMixin, "OnLoad", ReskinSubFrame)
	MER:SecureHook(_G.KeystoneLootEntryFrameMixin, "OnLoad", ReskinEntryFrame)
	MER:SecureHook(_G.KeystoneLootReminderSpecMixin, "OnLoad", ReskinReminderSpec)
	MER:SecureHook(_G.KeystoneLootReminderIconMixin, "Init", UpdateReminderIcon)
	MER:SecureHook(_G.KeystoneLootDropNotificationRowMixin, "Init", UpdateNotificationRow)

	-- Main frame
	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	S:HandleDropDownBox(frame.SlotDropdown)
	S:HandleDropDownBox(frame.ClassDropdown)
	S:HandleDropDownBox(frame.ItemLevelDropdown)

	if frame.DungeonsFrame then
		ReskinTabSystem(frame)
	else
		MER:SecureHook(frame, "InitializeTabSystem", ReskinTabSystem)
	end

	local SettingsDropdown = frame.SettingsDropdown
	if SettingsDropdown then
		SettingsDropdown:ClearAllPoints()
		SettingsDropdown:SetPoint("TOPRIGHT", -28, -6)
	end

	ReskinSidePanel(frame.CatalystFrame, "TOPLEFT", "TOPRIGHT", 3)
	ReskinSidePanel(frame.CustomItemFrame, "TOPRIGHT", "TOPLEFT", -3)

	-- Popups
	ReskinPopupFrame(_G.KeystoneLootReminderFrame)
	ReskinPopupFrame(_G.KeystoneLootDropNotificationFrame)

	local MythicPlusFrame = _G.KeystoneLootMythicPlusNotificationFrame
	if MythicPlusFrame then
		ReskinPopupFrame(MythicPlusFrame)
		ReskinMythicPlusCard(MythicPlusFrame.Card)
	end

	ReskinMenus()
end

module:AddCallbackForAddon("KeystoneLoot")
