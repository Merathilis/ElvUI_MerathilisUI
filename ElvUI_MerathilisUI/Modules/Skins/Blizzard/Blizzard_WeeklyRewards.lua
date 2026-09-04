local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local ipairs, unpack = ipairs, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local C_Item_GetItemQualityByID = C_Item.GetItemQualityByID
local C_Timer_After = C_Timer.After
local C_WeeklyRewards_GetItemHyperlink = C_WeeklyRewards.GetItemHyperlink

local LOCK_TEXTURE = [[Interface\LFGFrame\UI-LFG-ICON-LOCK]]

local FrameData = setmetatable({}, { __mode = "k" })
local function GetData(object)
	local data = FrameData[object]
	if not data then
		data = {}
		FrameData[object] = data
	end
	return data
end

local STYLE = {
	inset = 4,
	cardInset = 5,
	iconPad = 2,
	barHeight = 3,
	lockSize = 26,
	fontSizes = {
		itemName = 10,
		threshold = 10,
		progress = 11,
		headerTitle = 14,
		overlayTitle = 18,
		overlayText = 11,
	},
	colors = {
		complete = { r = 0.20, g = 0.80, b = 0.35 },
		locked = { r = 0.80, g = 0.60, b = 0.20 },
		inactive = { r = 0.55, g = 0.55, b = 0.55 },
		defaultBorder = { r = 0.35, g = 0.35, b = 0.35 },
		header = { r = 1, g = 0.82, b = 0 },
	},
}

local function Strip(region)
	if not region or region._MEROwned then
		return
	end
	if region.SetTexture then
		region:SetTexture(nil)
	end
	if region.SetAlpha then
		region:SetAlpha(0)
	end
end

local function StripItemButtonChrome(button)
	if not button then
		return
	end
	for _, key in ipairs({
		"Border",
		"Background",
		"IconBorder",
		"IconOverlay",
		"IconOverlay2",
		"SlotBackground",
		"Highlight",
		"Glow",
		"NormalTexture",
		"PushedTexture",
	}) do
		Strip(button[key])
	end
	if button.GetNormalTexture then
		Strip(button:GetNormalTexture())
	end
	if button.GetPushedTexture then
		Strip(button:GetPushedTexture())
	end
	if button.GetHighlightTexture then
		Strip(button:GetHighlightTexture())
	end
end

local function ResolveItemLink(activityFrame, itemFrame)
	if itemFrame then
		if itemFrame.itemLink then
			return itemFrame.itemLink
		end
		if itemFrame.itemHyperlink then
			return itemFrame.itemHyperlink
		end
		if itemFrame.itemDBID and C_WeeklyRewards and C_WeeklyRewards_GetItemHyperlink then
			local link = C_WeeklyRewards_GetItemHyperlink(itemFrame.itemDBID)
			if link then
				return link
			end
		end
	end

	local rewards = activityFrame and activityFrame.info and activityFrame.info.rewards
	if type(rewards) ~= "table" then
		return nil
	end

	for _, reward in ipairs(rewards) do
		if reward and reward.itemDBID and C_WeeklyRewards and C_WeeklyRewards_GetItemHyperlink then
			local link = C_WeeklyRewards_GetItemHyperlink(reward.itemDBID)
			if link then
				return link
			end
		end
	end
end

local function GetItemBorderColor(itemLink)
	if not itemLink then
		local c = STYLE.colors.defaultBorder
		return c.r, c.g, c.b
	end

	local quality = C_Item and C_Item_GetItemQualityByID and C_Item_GetItemQualityByID(itemLink)
	if not quality then
		local _, _, itemQuality = GetItemInfo(itemLink)
		quality = itemQuality
	end

	if quality then
		local r, g, b
		if C_Item and C_Item_GetItemQualityColor then
			r, g, b = C_Item_GetItemQualityColor(quality)
		elseif GetItemQualityColor then
			r, g, b = GetItemQualityColor(quality)
		end
		if r then
			return r, g, b
		end
	end

	local c = STYLE.colors.defaultBorder
	return c.r, c.g, c.b
end

local function EnsureProgressBar(parent)
	local data = GetData(parent)
	if data.bar then
		return data.bar
	end

	local bar = CreateFrame("Frame", nil, parent)
	bar:SetHeight(STYLE.barHeight)
	bar:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 1, 1)
	bar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)

	local track = bar:CreateTexture(nil, "BACKGROUND")
	track:SetAllPoints()
	track:SetColorTexture(1, 1, 1, 0.12)
	track._MEROwned = true

	local fill = bar:CreateTexture(nil, "ARTWORK")
	fill:SetPoint("TOPLEFT")
	fill:SetPoint("BOTTOMLEFT")
	fill._MEROwned = true

	bar:SetScript("OnSizeChanged", function(self)
		local ratio = self._MERRatio or 0
		fill:SetWidth((self:GetWidth() * ratio) < 1 and 1 or self:GetWidth() * ratio)
		fill:SetShown(ratio > 0)
	end)

	bar._MERFill = fill
	data.bar = bar
	return bar
end

local function SetProgressBar(parent, ratio, r, g, b, a)
	local data = GetData(parent)
	local bar = data.bar
	if not bar then
		return
	end

	ratio = ratio and (ratio < 0 and 0 or (ratio > 1 and 1 or ratio)) or 0
	bar._MERRatio = ratio
	bar._MERFill:SetColorTexture(r or 1, g or 1, b or 1, a or 1)

	local width = bar:GetWidth() * ratio
	bar._MERFill:SetWidth(width < 1 and 1 or width)
	bar._MERFill:SetShown(ratio > 0)
end

local function EnsureLockIcon(parent)
	local data = GetData(parent)
	if data.lock then
		return data.lock
	end

	local lock = parent:CreateTexture(nil, "OVERLAY")
	lock:SetTexture(LOCK_TEXTURE)
	lock:SetSize(STYLE.lockSize, STYLE.lockSize)
	lock:SetPoint("CENTER", parent, "CENTER", 0, -6)
	lock._MEROwned = true

	data.lock = lock
	return lock
end

local function EnsureCardBackdrop(frame, inset)
	local data = GetData(frame)
	if data.card then
		return data.card
	end

	local card = CreateFrame("Frame", nil, frame)
	card:SetPoint("TOPLEFT", frame, "TOPLEFT", inset, -inset)
	card:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset, inset)
	card:CreateBackdrop("Transparent")
	card.backdrop:SetAllPoints()

	data.card = card
	return card
end

local function SetCardBorderColor(card, r, g, b, a)
	if card and card.SetBackdropBorderColor then
		card:SetBackdropBorderColor(r or 1, g or 1, b or 1, a or 1)
	elseif card and card.backdrop then
		card.backdrop:SetBackdropBorderColor(r or 1, g or 1, b or 1, a or 1)
	end
end

local function EnsureItemIconSkin(itemFrame)
	if not itemFrame or not itemFrame.Icon then
		return
	end
	if not itemFrame.Icon.MERSkinned then
		S:HandleIcon(itemFrame.Icon, true)
		itemFrame.Icon.MERSkinned = true
	end
end

local function RefreshItemFrame(itemFrame, activityFrame)
	if not itemFrame then
		return
	end
	StripItemButtonChrome(itemFrame)
	EnsureItemIconSkin(itemFrame)

	if itemFrame.Icon then
		itemFrame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end

	local link = ResolveItemLink(activityFrame, itemFrame)
	local r, g, b = GetItemBorderColor(link)
	if itemFrame.Icon and itemFrame.Icon.backdrop then
		itemFrame.Icon.backdrop:SetBackdropBorderColor(r, g, b, 1)
	end

	if itemFrame.Name then
		itemFrame.Name:FontTemplate(nil, STYLE.fontSizes.itemName, nil)
		itemFrame.Name:SetTextColor(1, 1, 1, 0.95)
	end
end

local function GetActivityState(frame)
	local info = frame.info
	local progress = (info and info.progress) or 0
	local threshold = (info and info.threshold) or 0
	local hasRewards = frame.hasRewards or false
	local complete = hasRewards or (threshold > 0 and progress >= threshold)
	local ratio = threshold > 0 and (progress / threshold) or 0

	return complete, progress, threshold, ratio
end

local function RefreshActivityCard(frame, selectedActivity)
	if not frame then
		return
	end

	Strip(frame.Background)
	Strip(frame.Border)
	Strip(frame.SelectedTexture)
	Strip(frame.ItemGlow)
	if frame.UnselectedFrame then
		frame.UnselectedFrame:SetAlpha(0)
	end

	local card = EnsureCardBackdrop(frame, STYLE.cardInset)
	local bar = EnsureProgressBar(card)
	local lock = EnsureLockIcon(card)

	local complete, progress, threshold, ratio = GetActivityState(frame)
	local isSelected = selectedActivity == frame and frame.hasRewards

	local col = complete and STYLE.colors.complete or STYLE.colors.locked

	if isSelected then
		local ar, ag, ab = unpack(E.media.rgbvaluecolor or { 1, 0.82, 0 })
		SetCardBorderColor(card, ar, ag, ab, 0.9)
	else
		SetCardBorderColor(card, col.r, col.g, col.b, complete and 0.8 or 0.35)
	end

	if complete then
		SetProgressBar(card, 1, col.r, col.g, col.b, 0.95)
	else
		SetProgressBar(card, ratio, col.r, col.g, col.b, 0.85)
	end

	lock:SetShown(not complete)

	if frame.Threshold then
		frame.Threshold:FontTemplate(nil, STYLE.fontSizes.threshold, nil)
		frame.Threshold:SetTextColor(1, 1, 1, complete and 0.95 or 0.65)
	end

	if frame.Progress then
		frame.Progress:FontTemplate(nil, STYLE.fontSizes.progress, nil)
		frame.Progress:SetTextColor(col.r, col.g, col.b, 1)
	end

	RefreshItemFrame(frame.ItemFrame, frame)
end

local function RefreshConcessionCard(frame, selectedActivity)
	if not frame then
		return
	end

	Strip(frame.Background)
	Strip(frame.SelectedTexture)
	Strip(frame.Divider1)
	Strip(frame.Divider2)
	if frame.UnselectedFrame then
		frame.UnselectedFrame:SetAlpha(0)
	end

	local card = EnsureCardBackdrop(frame, STYLE.cardInset)
	local isSelected = selectedActivity == frame

	if isSelected then
		local ar, ag, ab = unpack(E.media.rgbvaluecolor or { 1, 0.82, 0 })
		SetCardBorderColor(card, ar, ag, ab, 0.9)
	else
		SetCardBorderColor(card, 1, 1, 1, 0.25)
	end

	if frame.RewardsFrame then
		if frame.RewardsFrame.Label then
			frame.RewardsFrame.Label:FontTemplate(nil, STYLE.fontSizes.itemName, nil)
			frame.RewardsFrame.Label:SetTextColor(1, 1, 1, 0.75)
		end
		if frame.RewardsFrame.Text then
			local ar, ag, ab = unpack(E.media.rgbvaluecolor or { 1, 0.82, 0 })
			frame.RewardsFrame.Text:FontTemplate(nil, STYLE.fontSizes.itemName, nil)
			frame.RewardsFrame.Text:SetTextColor(ar, ag, ab, 1)
		end
	end
end

local function RefreshOverlay(overlay)
	if not overlay then
		return
	end
	if not overlay.MERSkinned then
		overlay:StripTextures()
		overlay:CreateBackdrop("Transparent")
		overlay.MERSkinned = true
	end
	if overlay.Title then
		local ar, ag, ab = unpack(E.media.rgbvaluecolor or { 1, 0.82, 0 })
		overlay.Title:FontTemplate(nil, STYLE.fontSizes.overlayTitle, nil)
		overlay.Title:SetTextColor(ar, ag, ab, 1)
	end
	if overlay.Text then
		overlay.Text:FontTemplate(nil, STYLE.fontSizes.overlayText, nil)
		overlay.Text:SetTextColor(1, 1, 1, 0.9)
	end
end

local function RefreshWarningDialog()
	local dialog = _G.WeeklyRewardExpirationWarningDialog
	if not dialog or dialog.MERSkinned then
		return
	end

	dialog:StripTextures()
	dialog:CreateBackdrop("Transparent")
	dialog.MERSkinned = true

	if dialog.Description then
		dialog.Description:FontTemplate(nil, STYLE.fontSizes.itemName, nil)
		dialog.Description:SetTextColor(1, 1, 1, 0.85)
	end

	if dialog.WarningIcon and dialog.WarningIcon.SetDesaturated then
		dialog.WarningIcon:SetDesaturated(true)
	end

	for _, btnKey in ipairs({ "Button1", "Button2" }) do
		if dialog[btnKey] then
			S:HandleButton(dialog[btnKey])
		end
	end
end

local function RefreshTypeFrameState(frame)
	if not frame then
		return
	end
	if frame.Name then
		local col = STYLE.colors.header
		frame.Name:SetTextColor(col.r, col.g, col.b, 1)

		local d = GetData(frame)
		if not d.nameRaised then
			d.nameRaised = true
			local raiseFrame = CreateFrame("Frame", nil, frame)
			raiseFrame:SetAllPoints()
			raiseFrame:SetFrameLevel(frame:GetFrameLevel() + 20)
			frame.Name:SetParent(raiseFrame)
		end
	end
end

local function RefreshWindow(frame)
	if not frame or frame:IsForbidden() then
		return
	end

	if not frame.MERSkinned then
		frame:StripTextures()
		frame:CreateBackdrop("Transparent")
		frame.MERSkinned = true

		if frame.CloseButton then
			S:HandleCloseButton(frame.CloseButton)
		end

		if frame.SelectRewardButton then
			S:HandleButton(frame.SelectRewardButton)
		end
	end

	if frame.HeaderFrame and frame.HeaderFrame.Text then
		frame.HeaderFrame.Text:FontTemplate(nil, STYLE.fontSizes.headerTitle, nil)
	end

	for _, typeFrame in ipairs({ frame.RaidFrame, frame.MythicFrame, frame.PVPFrame, frame.WorldFrame }) do
		if typeFrame and typeFrame:IsShown() then
			if typeFrame.Background then
				typeFrame.Background.backdrop:SetAlpha(0)
			end
			if typeFrame.Name then
				RefreshTypeFrameState(typeFrame)
			end
		end
	end

	local concessionType = Enum
		and Enum.WeeklyRewardChestThresholdType
		and Enum.WeeklyRewardChestThresholdType.Concession

	if frame.Activities then
		for _, activityFrame in ipairs(frame.Activities) do
			if activityFrame.type == concessionType then
				RefreshConcessionCard(activityFrame, frame.selectedActivity)
			else
				RefreshActivityCard(activityFrame, frame.selectedActivity)
			end
		end
	end

	RefreshOverlay(frame.Overlay)
	RefreshWarningDialog()
end

local queued = false
local function QueueRefresh(frame)
	if queued then
		return
	end
	queued = true
	C_Timer_After(0, function()
		queued = false
		RefreshWindow(frame)
	end)
end

function module:Blizzard_WeeklyRewards()
	local frame = _G.WeeklyRewardsFrame
	if not frame then
		return
	end

	frame:HookScript("OnShow", function(self)
		QueueRefresh(self)
	end)

	for _, methodName in ipairs({ "Refresh", "UpdateSelection", "SetUpConditionalActivities" }) do
		if frame[methodName] then
			hooksecurefunc(frame, methodName, function(self)
				QueueRefresh(self)
			end)
		end
	end

	if frame:IsShown() then
		QueueRefresh(frame)
	end
end

module:AddCallbackForAddon("Blizzard_WeeklyRewards")
