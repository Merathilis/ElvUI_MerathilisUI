local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")
local LSM = E.Libs.LSM

-- Copied from ElvUI

local _G = _G
local next = next

local hooksecurefunc = hooksecurefunc

function module:CooldownManager_PositionViewerTab(_, _, _, x, y)
	if x ~= 1 or y ~= -10 then
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", _G.CooldownViewerSettings, "TOPRIGHT", 1, -10)
	end
end

function module:CooldownManager_PositionTabIcons(point)
	if point == "CENTER" then
		return
	end

	self:ClearAllPoints()
	self:SetPoint("CENTER")
end

function module:CooldownManager_HandleHeaders(header)
	if header.HighlightMiddle then
		header.HighlightMiddle:SetAlpha(0)
	end
	if header.HighlightLeft then
		header.HighlightLeft:SetAlpha(0)
	end
	if header.HighlightRight then
		header.HighlightRight:SetAlpha(0)
	end
	if header.Middle then
		header.Middle:Hide()
	end
	if header.Left then
		header.Left:Hide()
	end
	if header.Right then
		header.Right:Hide()
	end

	S:HandleButton(header)

	header.IsSkinned = true
end

function module:CooldownManager_HandleSettingItem(item)
	if item.IsSkinned then
		return
	end

	local icon = item.Icon
	if icon then
		local highlight = item.Highlight
		if highlight then
			highlight:SetColorTexture(1, 1, 1, 0.25)
			highlight:SetAllPoints(icon)
		end

		S:HandleIcon(icon, true)
	end

	item.IsSkinned = true
end

function module:CooldownManager_HandleSettingItemPool()
	for frame in self:EnumerateActive() do
		module:CooldownManager_HandleSettingItem(frame)
	end
end

function module:CooldownManager_CountText(text)
	local db = E.db.general.cooldownManager
	if not db then
		return
	end

	text:SetIgnoreParentScale(true)
	text:ClearAllPoints()
	text:Point(db.countPosition, db.countxOffset, db.countyOffset)
	text:FontTemplate(LSM:Fetch("font", db.countFont), db.countFontSize, db.countFontOutline)

	local color = db.countFontColor
	if color then
		text:SetTextColor(color.r, color.g, color.b)
	end
end

function module:CooldownManager_UpdateTextContainer(container)
	local applicationText = container.Applications and container.Applications.Applications
	if applicationText then
		module:CooldownManager_CountText(applicationText)
	end

	local countText = container.Count
	if countText then
		module:CooldownManager_CountText(countText)
	end

	local chargeText = container.ChargeCount and container.ChargeCount.Current
	if chargeText then
		module:CooldownManager_CountText(chargeText)
	end
end

function module:CooldownManager_UpdateTextBar(bar)
	local db = E.db.general.cooldownManager
	if not db then
		return
	end

	if bar.Name then
		bar.Name:ClearAllPoints()
		bar.Name:Point(db.namePosition, db.namexOffset, db.nameyOffset)
		bar.Name:FontTemplate(LSM:Fetch("font", db.nameFont), db.nameFontSize, db.nameFontOutline)

		local color = db.nameFontColor
		if color then
			bar.Name:SetTextColor(color.r, color.g, color.b)
		end
	end

	if bar.Duration then
		bar.Duration:ClearAllPoints()
		bar.Duration:Point(db.durationPosition, db.durationxOffset, db.durationyOffset)
		bar.Duration:FontTemplate(LSM:Fetch("font", db.durationFont), db.durationFontSize, db.durationFontOutline)

		local color = db.durationFontColor
		if color then
			bar.Duration:SetTextColor(color.r, color.g, color.b)
		end
	end
end

function module:CooldownManager_SkinIcon(container, icon)
	module:CooldownManager_UpdateTextContainer(container)
	S:HandleIcon(icon, true)

	for _, region in next, { container:GetRegions() } do
		if region:IsObjectType("Texture") then
			local texture = region:GetTexture()
			local atlas = region:GetAtlas()

			if E:NotSecretValue(texture) and texture == 6707800 then
				region:SetTexture(E.media.blankTex)
			elseif E:NotSecretValue(atlas) and atlas == "UI-HUD-CoolDownManager-IconOverlay" then -- 6704514
				region:SetAlpha(0)
			end
		end
	end
end

function module:CooldownManager_SkinBar(frame, bar)
	module:CooldownManager_UpdateTextBar(bar)

	local icon = frame.Icon
	if icon then
		bar:Point("LEFT", icon, "RIGHT", 3, 0)

		module:CooldownManager_SkinIcon(icon, icon.Icon)
	end

	if not bar.MERStyle then
		F.CreateStyle(bar)
		WS:CreateShadow(bar)
		bar.MERStyle = true
	end

	local statusBarTex = bar:GetStatusBarTexture()
	if statusBarTex then
		statusBarTex:SetTexture(E.media.normTex)
		statusBarTex:ClearTextureSlice()
		statusBarTex:SetTextureSliceMode(0)
	end

	for _, region in next, { bar:GetRegions() } do
		if region:IsObjectType("Texture") then
			local atlas = region:GetAtlas()

			if atlas == "UI-HUD-CoolDownManager-Bar" then
				region:Point("TOPLEFT", 1, 0)
				region:Point("BOTTOMLEFT", -1, 0)
			elseif atlas == "UI-HUD-CoolDownManager-Bar-BG" and not region.backdrop then
				region:StripTextures()
				region:CreateBackdrop("Transparent", nil, true)
				region.backdrop:SetOutside()
			end
		end
	end
end

function module:CooldownManager_SkinItemFrame(frame)
	if frame.Cooldown then
		E:RegisterCooldown(frame.Cooldown, "cdmanager")
		frame.Cooldown:SetReverse(true)
	end

	if frame.Bar then
		module:CooldownManager_SkinBar(frame, frame.Bar)
	end
end

function module:CooldownManager_AcquireItemFrame(frame)
	module:CooldownManager_SkinItemFrame(frame)
end

function module:CooldownManager_HandleViewer(element)
	hooksecurefunc(element, "OnAcquireItemFrame", module.CooldownManager_AcquireItemFrame)

	for frame in element.itemFramePool:EnumerateActive() do
		module:CooldownManager_SkinItemFrame(frame)
	end
end

do
	local hookedItemPools = {}

	function module:CooldownManager_RefreshLayout()
		local CooldownViewer = _G.CooldownViewerSettings
		if not CooldownViewer or not CooldownViewer.CooldownScroll then
			return
		end

		local content = CooldownViewer.CooldownScroll.Content
		if not content then
			return
		end

		for _, child in next, { content:GetChildren() } do
			local header = child.Header
			if header and not header.IsSkinned then
				module:CooldownManager_HandleHeaders(child.Header)
			end

			local itemPool = child.itemPool
			if itemPool and not hookedItemPools[itemPool] then
				hookedItemPools[itemPool] = true

				module:CooldownManager_HandleSettingItemPool(itemPool)

				hooksecurefunc(itemPool, "Acquire", module.CooldownManager_HandleSettingItemPool)
			end
		end
	end
end

function module:CooldownManager_HandleAbilityTabs(viewer)
	for i, tab in next, { viewer.SpellsTab, viewer.AurasTab } do
		tab:CreateBackdrop()
		tab:Size(30, 40)

		if i == 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", viewer, "TOPRIGHT", 1, -10)

			hooksecurefunc(tab, "SetPoint", module.CooldownManager_PositionViewerTab)
		end

		if tab.Icon then
			tab.Icon:ClearAllPoints()
			tab.Icon:SetPoint("CENTER")

			hooksecurefunc(tab.Icon, "SetPoint", module.CooldownManager_PositionTabIcons)
		end

		if tab.Background then
			tab.Background:SetAlpha(0)
		end

		if tab.SelectedTexture then
			tab.SelectedTexture:SetDrawLayer("ARTWORK")
			tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
			tab.SelectedTexture:SetAllPoints()
		end

		for _, region in next, { tab:GetRegions() } do
			if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
				region:SetColorTexture(1, 1, 1, 0.3)
				region:SetAllPoints()
			end
		end
	end
end

function module:CooldownManager_HandleSettings(viewer)
	if not viewer then
		return
	end

	S:HandlePortraitFrame(viewer)
	S:HandleEditBox(viewer.SearchBox)
	S:HandleTrimScrollBar(viewer.CooldownScroll.ScrollBar)
	S:HandleButton(viewer.UndoButton)
	S:HandleDropDownBox(viewer.LayoutDropdown)

	module:CooldownManager_HandleAbilityTabs(viewer)
	module:CooldownManager_RefreshLayout()

	hooksecurefunc(viewer, "RefreshLayout", module.CooldownManager_RefreshLayout)
end

function module:Blizzard_CooldownViewer()
	if
		not E.private.skins.blizzard.enable and not E.private.skins.blizzard.cooldownManager
		or not E.private.mui.skins.enable
	then
		return
	end

	local db = E.db.general.cooldownManager
	E:UpdateClassColor(db.nameFontColor)
	E:UpdateClassColor(db.durationFontColor)
	E:UpdateClassColor(db.countFontColor)

	module:CooldownManager_HandleViewer(_G.UtilityCooldownViewer)
	module:CooldownManager_HandleViewer(_G.BuffBarCooldownViewer)
	module:CooldownManager_HandleViewer(_G.BuffIconCooldownViewer)
	module:CooldownManager_HandleViewer(_G.EssentialCooldownViewer)
	module:CooldownManager_HandleSettings(_G.CooldownViewerSettings)
end

module:AddCallbackForAddon("Blizzard_CooldownViewer")
