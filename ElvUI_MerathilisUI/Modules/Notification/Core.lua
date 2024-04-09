local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")
local S = MER:GetModule("MER_Skins")

-- Credits RealUI
local unpack, type, pairs = unpack, type, pairs
local table = table
local tinsert, tremove = table.insert, table.remove
local find, gsub = string.find, string.gsub

local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
local PlaySound = PlaySound
local C_Timer = C_Timer
local CreateAnimationGroup = CreateAnimationGroup
local SlashCmdList = SlashCmdList

local bannerWidth = 255
local bannerHeight = 68
local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame

function module:SpawnToast(toast)
	if not toast then
		return
	end

	if #activeToasts >= max_active_toasts then
		tinsert(queuedToasts, toast)

		return false
	end

	if UnitIsAFK("player") then
		tinsert(queuedToasts, toast)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")

		return false
	end

	local YOffset = 0
	if E:GetScreenQuadrant(anchorFrame):find("TOP") then
		YOffset = -54
	else
		YOffset = 54
	end

	toast:ClearAllPoints()
	if #activeToasts > 0 then
		if E:GetScreenQuadrant(anchorFrame):find("TOP") then
			toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -4 - YOffset)
		else
			toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, 4 - YOffset)
		end
	else
		toast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
	end

	tinsert(activeToasts, toast)

	toast:Show()
	toast.AnimIn.AnimMove:SetOffset(0, YOffset)
	toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
	toast.AnimIn:Play()
	toast.AnimOut:Play()

	if module.db.noSound ~= true then
		PlaySound(18019, "Master")
	end
end

function module:RefreshToasts()
	for i = 1, #activeToasts do
		local activeToast = activeToasts[i]
		local YOffset, _ = 0
		if activeToast.AnimIn.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimIn.AnimMove:GetOffset()
		end
		if activeToast.AnimOut.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimOut.AnimMove:GetOffset()
		end

		activeToast:ClearAllPoints()

		if i == 1 then
			activeToast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
		else
			if E:GetScreenQuadrant(anchorFrame):find("TOP") then
				activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -4 - YOffset)
			else
				activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, 4 - YOffset)
			end
		end
	end

	local queuedToast = tremove(queuedToasts, 1)

	if queuedToast then
		self:SpawnToast(queuedToast)
	end
end

function module:HideToast(toast)
	for i, activeToast in pairs(activeToasts) do
		if toast == activeToast then
			tremove(activeToasts, i)
		end
	end
	tinsert(toasts, toast)
	toast:Hide()
	C_Timer.After(0.1, function()
		self:RefreshToasts()
	end)
end

local function ToastButtonAnimOut_OnFinished(self)
	module:HideToast(self:GetParent())
end

function module:CreateToast()
	local toast = tremove(toasts, 1)
	local db = E.db.mui.notification

	toast = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	toast:SetFrameStrata("HIGH")
	toast:SetSize(bannerWidth, bannerHeight)
	toast:SetPoint("TOP", E.UIParent, "TOP")
	toast:Hide()
	toast:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(toast, true)
	S:CreateGradient(toast.backdrop)
	toast:CreateCloseButton(10)

	local icon = toast:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
	S:CreateBG(icon)
	toast.icon = icon

	local sep = toast:CreateTexture(nil, "BACKGROUND")
	sep:SetSize(2, bannerHeight)
	sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
	sep:SetColorTexture(unpack(E["media"].rgbvaluecolor))

	local title = toast:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(title, db.titleFont)
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 3, -5)
	title:SetPoint("TOP", toast, "TOP", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetNonSpaceWrap(true)
	toast.title = title

	local text = toast:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(text, db.textFont)
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 3, 17)
	text:SetPoint("RIGHT", toast, -9, 0)
	text:SetJustifyH("LEFT")
	text:SetWidth(toast:GetRight() - sep:GetLeft() - 5)
	toast.text = text

	toast.AnimIn = CreateAnimationGroup(toast)

	local animInAlpha = toast.AnimIn:CreateAnimation("Fade")
	animInAlpha:SetOrder(1)
	animInAlpha:SetChange(1)
	animInAlpha:SetDuration(0.5)
	toast.AnimIn.AnimAlpha = animInAlpha

	local animInMove = toast.AnimIn:CreateAnimation("Move")
	animInMove:SetOrder(1)
	animInMove:SetDuration(0.5)
	animInMove:SetEasing("Out")
	animInMove:SetOffset(-bannerWidth, 0)
	toast.AnimIn.AnimMove = animInMove

	toast.AnimOut = CreateAnimationGroup(toast)

	local animOutSleep = toast.AnimOut:CreateAnimation("Sleep")
	animOutSleep:SetOrder(1)
	animOutSleep:SetDuration(fadeout_delay)
	toast.AnimOut.AnimSleep = animOutSleep

	local animOutAlpha = toast.AnimOut:CreateAnimation("Fade")
	animOutAlpha:SetOrder(2)
	animOutAlpha:SetChange(0)
	animOutAlpha:SetDuration(0.5)
	toast.AnimOut.AnimAlpha = animOutAlpha

	local animOutMove = toast.AnimOut:CreateAnimation("Move")
	animOutMove:SetOrder(2)
	animOutMove:SetDuration(0.5)
	animOutMove:SetEasing("In")
	animOutMove:SetOffset(bannerWidth, 0)
	toast.AnimOut.AnimMove = animOutMove

	toast.AnimOut.AnimAlpha:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)

	toast:SetScript("OnEnter", function(self)
		self.AnimOut:Stop()
	end)

	toast:SetScript("OnLeave", function(self)
		self.AnimOut:Play()
	end)

	toast:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.clickFunc then
			self.clickFunc()
		end
	end)

	return toast
end

function module:DisplayToast(name, message, clickFunc, texture, ...)
	local toast = self:CreateToast()

	if type(clickFunc) == "function" then
		toast.clickFunc = clickFunc
	else
		toast.clickFunc = nil
	end

	if texture then
		if C_Texture_GetAtlasInfo(texture) then
			toast.icon:SetAtlas(texture)
		else
			toast.icon:SetTexture(texture)

			if ... then
				toast.icon:SetTexCoord(...)
			else
				toast.icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
	else
		toast.icon:SetTexture("Interface\\Icons\\achievement_general")
		toast.icon:SetTexCoord(unpack(E.TexCoords))
	end

	toast.title:SetText(name)
	toast.text:SetText(message)

	self:SpawnToast(toast)
end

function module:PLAYER_FLAGS_CHANGED(event)
	self:UnregisterEvent(event)
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

function module:PLAYER_REGEN_ENABLED()
	for i = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

-- Test function
local function testCallback()
	F.Print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
	module:DisplayToast(
		F.cOption("MerathilisUI:", "gradient"),
		L["This is an example of a notification."],
		testCallback,
		b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil,
		0.08,
		0.92,
		0.08,
		0.92
	)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"

function module:Initialize()
	module.db = E.db.mui.notification
	if not module.db.enable then
		return
	end

	anchorFrame = CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:SetSize(bannerWidth, 50)
	anchorFrame:SetPoint("TOP", 0, -80)
	E:CreateMover(
		anchorFrame,
		"MER_NotificationMover",
		L["Notification Mover"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,Notification"
	)

	self:RegisterEvent("UPDATE_PENDING_MAIL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	self:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterEvent("SOCIAL_QUEUE_UPDATE", "SocialQueueEvent")
	self:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("QUEST_ACCEPTED")

	self.lastMinimapRare = { time = 0, id = nil }
end

MER:RegisterModule(module:GetName())
