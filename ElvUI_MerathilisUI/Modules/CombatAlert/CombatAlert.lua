local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_CombatText")

local tinsert, tremove, twipe = table.insert, table.remove, table.wipe

local NewTimer = C_Timer.NewTimer
local CreateFrame = CreateFrame

function module:CreateAlert()
	if self.alert then
		return
	end

	local alert = CreateFrame("Frame", "MER_AlertFrame", E.UIParent)
	alert:SetClampedToScreen(true)
	alert:SetSize(300, 65)
	alert:Point("TOP", 0, -280)

	alert.Bg = alert:CreateTexture(nil, "BACKGROUND")
	alert.Bg:SetTexture("Interface\\LevelUp\\MinorTalents")
	alert.Bg:Point("TOP")
	alert.Bg:SetSize(400, 60)
	alert.Bg:SetTexCoord(0, 400 / 512, 341 / 512, 407 / 512)
	alert.Bg:SetVertexColor(1, 1, 1, 0.4)
	alert.Bg:Hide()

	alert.text = alert:CreateFontString(nil)
	alert.text:Point("CENTER", 0, -1)

	self.alert = alert
	self.alert.Bg = alert.Bg
end

function module:RefreshAlert()
	twipe(self.animationQueue)

	self.db = E.db.mui.CombatAlert

	F.SetFontDB(self.alert.text, self.db.font)
	self.alert:SetScale(self.db.style.scale or 0.8)
end

function module:FadeIn(second, func)
	local fadeInfo = {}

	fadeInfo.mode = "IN"
	fadeInfo.timeToFade = second
	fadeInfo.startAlpha = 0
	fadeInfo.endAlpha = 1
	fadeInfo.finishedFunc = function()
		if func then
			func()
		end
	end
	E:UIFrameFade(self.alert, fadeInfo)
end

function module:FadeOut(second, func)
	local fadeInfo = {}

	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = second
	fadeInfo.startAlpha = 1
	fadeInfo.endAlpha = 0
	fadeInfo.finishedFunc = function()
		if func then
			func()
		end
	end
	E:UIFrameFade(self.alert, fadeInfo)
end

local function executeNextAnimation()
	if module.animationQueue and module.animationQueue[1] then
		local func = module.animationQueue[1]
		func()
		tremove(module.animationQueue, 1)
	end
end

function module:AnimateAlert(changeTextFunc)
	local stay_duration = self.db.style.stay_duration
	local animation_duration = self.db.style.animation_duration

	if self.inAnimation then
		if self.animationTimer then
			changeTextFunc()
			return
		else
			twipe(self.animationQueue)
			tinsert(self.animationQueue, function()
				changeTextFunc()
				module:FadeIn(animation_duration, executeNextAnimation)
			end)
		end
	else
		self.inAnimation = true
		changeTextFunc()
		self:FadeIn(animation_duration, executeNextAnimation)
	end

	tinsert(self.animationQueue, function()
		module.animationTimer = NewTimer(stay_duration, executeNextAnimation)
	end)

	tinsert(self.animationQueue, function()
		module.animationTimer = nil
		module:FadeOut(animation_duration, executeNextAnimation)
	end)

	tinsert(self.animationQueue, function()
		module.inAnimation = false
	end)

	self.inAnimation = true
end

function module:PLAYER_REGEN_DISABLED()
	self.db = E.db.mui.CombatAlert
	local color = self.db.style.font_color_enter

	self:AnimateAlert(function()
		self.alert.text:SetText(
			self.db.custom_text.enabled and self.db.custom_text.custom_enter_text or L["Enter Combat"]
		)
		self.alert.text:SetTextColor(color.r, color.g, color.b, color.a)
		if self.db.style.backdrop then
			self.alert.Bg:Show()
		end
	end)
end

function module:PLAYER_REGEN_ENABLED()
	self.db = E.db.mui.CombatAlert
	local color = self.db.style.font_color_leave

	self:AnimateAlert(function()
		self.alert.text:SetText(
			self.db.custom_text.enabled and self.db.custom_text.custom_leave_text or L["Leave Combat"]
		)
		self.alert.text:SetTextColor(color.r, color.g, color.b, color.a)
		if self.db.style.backdrop then
			self.alert.Bg:Show()
		end
	end)
end

function module:Initialize()
	if not E.db.mui.CombatAlert.enable then
		return
	end

	self.db = E.db.mui.CombatAlert

	module.inAnimation = false
	self.animationQueue = {}

	self:CreateAlert()
	self:RefreshAlert()

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	E:CreateMover(
		self.alert,
		"alertFrameMover",
		MER.Title .. L["Enter Combat Alert"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		function()
			return self.db.enable
		end,
		"mui,modules,CombatAlert"
	)
end

MER:RegisterModule(module:GetName())
