local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local S = MER:GetModule("MER_Skins")

local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local tremove = tremove
local setmetatable = setmetatable

local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local GetActionInfo = GetActionInfo
local GetActionTexture = GetActionTexture
local GetMacroSpell = GetMacroSpell
local GetActionCooldown = GetActionCooldown
local HasAction = HasAction
local IsPlayerSpell = IsPlayerSpell
local GetSpellInfo = C_Spell.GetSpellInfo
local CooldownFrame_Set = CooldownFrame_Set

local CreateFrame = CreateFrame
local UIParent = UIParent
local hooksecurefunc = hooksecurefunc

-- Credits: https://github.com/rgd87/NugKeyFeedback
module.keyFeedback = CreateFrame("Frame", MER.Title .. "KeyFeedback", UIParent)
local keyFeedback = module.keyFeedback
keyFeedback:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end)

keyFeedback:RegisterEvent("PLAYER_LOGIN")
keyFeedback:RegisterEvent("PLAYER_LOGOUT")

local getSpellInfo = function(spellId)
	local info = GetSpellInfo(spellId)
	if info then
		return info.name, nil, info.iconID
	end
end

function keyFeedback:PLAYER_LOGIN()
	self.db = E.db.mui.actionbars.keyfeedback
	if not E.db.mui or not E.db.mui.actionbars or not self.db then
		self.db = {}
	end

	if not E.private.actionbar.enable or not self.db.enable then
		return
	end

	if self.db.forceUseActionHook then
		self.mirror = self:CreateFeedbackButton(true)
		self:HookUseAction()
	else
		self.mirror = self:CreateFeedbackButton()
		self:HookDefaultBindings()
	end

	local getActionSpellID = function(action)
		local actionType, id = GetActionInfo(action)
		if actionType == "spell" then
			return id
		elseif actionType == "macro" then
			return GetMacroSpell(id)
		end
	end

	self.mirror.UpdateAction = function(self, fullUpdate)
		local action = self.action
		if not action then
			return
		end

		local tex = GetActionTexture(action)
		if not tex then
			return
		end
		self.icon:SetTexture(tex)
		self.icon:SetTexCoord(unpack(E.TexCoords))

		if fullUpdate then
			self:UpdateCooldownOrCast()
		end
	end

	self.mirror.UpdateCooldownOrCast = function(self)
		local action = self.action
		if not action then
			return
		end

		local isCastingLastSpell = self.castSpellID == getActionSpellID(action)
		local cooldownStartTime, cooldownDuration, enable, modRate = GetActionCooldown(action)

		local cooldownFrame = self.cooldown
		local castDuration = self.castDuration or 0

		if
			keyFeedback.db.enableCast
			and self.castSpellID
			and self.castSpellID == getActionSpellID(action)
			and castDuration > cooldownDuration
		then
			cooldownFrame:SetDrawEdge(true)
			cooldownFrame:SetReverse(self.castInverted)
			CooldownFrame_Set(cooldownFrame, self.castStartTime, castDuration, true, true, 1)
		elseif keyFeedback.db.enableCooldown then
			cooldownFrame:SetDrawEdge(false)
			cooldownFrame:SetReverse(false)
			CooldownFrame_Set(cooldownFrame, cooldownStartTime, cooldownDuration, enable, false, modRate)
		else
			cooldownFrame:Hide()
		end
	end

	self:SetSize(32, 32)
	self:SetPoint("CENTER", UIParent, 0, -270)

	E:CreateMover(self, "SpellFeedback", L["SpellFeedback"], nil, nil, nil, "ALL,ACTIONBARS,MERATHILISUI", function()
		return E.db.mui.actionbars.keyfeedback
	end, "mui,modules,actionbars")
	self:RefreshSettings()
end

function keyFeedback:PLAYER_LOGOUT()
	if self.iconPool then
		self.iconPool:ReleaseAll()
	end
end

function keyFeedback.UNIT_SPELLCAST_START(self, event, unit, _castID, spellID)
	local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
	if not startTime then
		return
	end

	local mirror = self.mirror
	mirror.castInverted = false
	mirror.castID = castID
	mirror.castSpellID = spellID
	mirror.castStartTime = startTime / 1000
	mirror.castDuration = (endTime - startTime) / 1000
	mirror:BumpFadeOut(mirror.castDuration)
	mirror:UpdateCooldownOrCast()
	-- self:UpdateCastingInfo(name,texture,startTime,endTime)
end

keyFeedback.UNIT_SPELLCAST_DELAYED = keyFeedback.UNIT_SPELLCAST_START
function keyFeedback.UNIT_SPELLCAST_CHANNEL_START(self, event, unit, _castID, spellID)
	local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitChannelInfo(unit)
	local mirror = self.mirror
	mirror.castInverted = true
	mirror.castID = castID
	mirror.castSpellID = spellID
	mirror.castStartTime = startTime / 1000
	mirror.castDuration = (endTime - startTime) / 1000
	mirror:BumpFadeOut(mirror.castDuration)
	mirror:UpdateCooldownOrCast()
	-- self:UpdateCastingInfo(name,texture,startTime,endTime)
end

keyFeedback.UNIT_SPELLCAST_CHANNEL_UPDATE = keyFeedback.UNIT_SPELLCAST_CHANNEL_START
function keyFeedback.UNIT_SPELLCAST_STOP(self, _, _, _, _)
	local mirror = self.mirror
	mirror.castSpellID = nil
	mirror.castDuration = nil
	mirror:UpdateCooldownOrCast()
end

function keyFeedback.UNIT_SPELLCAST_FAILED(self, event, unit, castID)
	if self.mirror.castID == castID then
		keyFeedback.UNIT_SPELLCAST_STOP(self, event, unit, nil)
	end
end

keyFeedback.UNIT_SPELLCAST_INTERRUPTED = keyFeedback.UNIT_SPELLCAST_STOP
keyFeedback.UNIT_SPELLCAST_CHANNEL_STOP = keyFeedback.UNIT_SPELLCAST_STOP

function keyFeedback:SPELL_UPDATE_COOLDOWN()
	self.mirror:UpdateAction(true)
end

local function mirrorActionButtonDown(action)
	if not HasAction(action) then
		return
	end

	if C_PetBattles.IsInBattle() then
		return
	end

	local mirror = keyFeedback.mirror

	if mirror.action ~= action then
		mirror.action = action
		mirror:UpdateAction(true)
	else
		mirror:UpdateAction()
	end

	mirror:Show()
	mirror._elapsed = 0
	mirror:SetAlpha(1)
	mirror:BumpFadeOut()
	mirror.pushed = true
	if mirror:GetButtonState() == "NORMAL" then
		if mirror.pushedCircle then
			if mirror.pushedCircle.grow:IsPlaying() then
				mirror.pushedCircle.grow:Stop()
			end
			mirror.pushedCircle:Show()
			mirror.pushedCircle.grow:Play()
		end
		mirror:SetButtonState("PUSHED")
	end
end

local function mirrorActionButtonUp(action)
	local mirror = keyFeedback.mirror

	if mirror:GetButtonState() == "PUSHED" then
		mirror:SetButtonState("NORMAL")
	end
end

function keyFeedback:HookDefaultBindings()
	local GetActionButtonForID = _G.GetActionButtonForID
	hooksecurefunc("ActionButtonDown", function(id)
		local button = GetActionButtonForID(id)
		if button then
			return mirrorActionButtonDown(button.action)
		end
	end)
	hooksecurefunc("ActionButtonUp", mirrorActionButtonUp)
	hooksecurefunc("MultiActionButtonDown", function(bar, id)
		local button = _G[bar .. "Button" .. id]
		return mirrorActionButtonDown(button.action)
	end)
	hooksecurefunc("MultiActionButtonUp", mirrorActionButtonUp)
end

function keyFeedback:HookUseAction()
	hooksecurefunc("UseAction", function(action)
		return mirrorActionButtonDown(action)
	end)
end

function keyFeedback:UNIT_SPELLCAST_SUCCEEDED(event, unit, lineID, spellID)
	if IsPlayerSpell(spellID) then
		if spellID == 75 then
			return
		end -- Autoshot

		if self.db.enableCastLine then
			local frame, isNew = self.iconPool:Acquire()
			local texture = select(3, getSpellInfo(spellID))
			frame.icon:SetTexture(texture)
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame:Show()
			frame.ag:Play()
		end

		if self.db.enableCastFlash then
			self.mirror.glow:Show()
			self.mirror.glow.blink:Play()
		end
	end
end

function keyFeedback:RefreshSettings()
	local db = self.db
	if not db.enable then
		return
	end

	self.mirror:SetSize(db.mirrorSize, db.mirrorSize)

	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	if db.enableCastLine then
		if not self.iconPool then
			self.iconPool = self:CreateLastSpellIconLine(self.mirror)
		end

		local pool = self.iconPool
		pool:ReleaseAll()
		for _, f in ipairs(pool.inactiveObjects) do
			-- f:SetHeight(db.lineIconSize)
			-- f:SetWidth(db.lineIconSize)
			pool:resetterFunc(f)
		end
	end

	if db.enableCooldown then
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	else
		self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	end

	if db.enableCast then
		self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	else
		self:UnregisterEvent("UNIT_SPELLCAST_START")
		self:UnregisterEvent("UNIT_SPELLCAST_DELAYED")
		self:UnregisterEvent("UNIT_SPELLCAST_STOP")
		self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
		self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	end
end

function keyFeedback:CreateFeedbackButton(autoKeyup)
	local db = self.db

	local mirror = CreateFrame("Button", MER.Title .. "KeyFeedbackMirror", self, "ActionButtonTemplate")
	mirror:SetHeight(db.mirrorSize or 32)
	mirror:SetWidth(db.mirrorSize or 32)

	if mirror.SetNormalTexture then
		mirror:SetNormalTexture(0)
	end
	if mirror.SetPushedTexture then
		mirror:SetPushedTexture(0)
	end

	mirror.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
	mirror.cooldown:SetSwipeColor(0, 0, 0, 0)
	mirror.cooldown:SetHideCountdownNumbers(true)

	local bg = S:CreateBDFrame(mirror)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	S:CreateShadow(bg)

	mirror:Show()
	mirror._elapsed = 0

	local glow = CreateFrame("Frame", nil, mirror)
	glow:SetPoint("TOPLEFT", -16, 16)
	glow:SetPoint("BOTTOMRIGHT", 16, -16)
	local gtex = glow:CreateTexture(nil, "OVERLAY")
	gtex:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	gtex:SetTexCoord(0, 66 / 128, 136 / 256, 202 / 256)
	gtex:SetVertexColor(0, 1, 0)
	gtex:SetAllPoints(glow)
	mirror.glow = glow
	glow:Hide()

	local ag = glow:CreateAnimationGroup()
	glow.blink = ag

	local a2 = ag:CreateAnimation("Alpha")
	a2:SetFromAlpha(1)
	a2:SetToAlpha(0)
	a2:SetSmoothing("OUT")
	a2:SetDuration(0.3)
	a2:SetOrder(2)

	ag:SetScript("OnFinished", function(self)
		self:GetParent():Hide()
	end)

	if db.enablePushEffect then
		local pushedCircle = CreateFrame("Frame", nil, mirror)
		local size = db.mirrorSize
		pushedCircle:SetSize(size, size)
		pushedCircle:SetPoint("CENTER", 0, 0)
		local pctex = pushedCircle:CreateTexture(nil, "OVERLAY")
		pctex:SetTexture(I.Media.Textures.Pushed)
		pctex:SetBlendMode("ADD")
		pctex:SetAllPoints(pushedCircle)
		mirror.pushedCircle = pushedCircle
		pushedCircle:Hide()

		local gag = pushedCircle:CreateAnimationGroup()
		pushedCircle.grow = gag

		local ga1 = gag:CreateAnimation("Scale")
		ga1:SetScaleFrom(0.1, 0.1)
		ga1:SetScaleTo(1.3, 1.3)
		ga1:SetDuration(0.3)
		ga1:SetOrder(2)

		local ga2 = gag:CreateAnimation("Alpha")
		ga2:SetFromAlpha(0.5)
		ga2:SetToAlpha(0)
		-- ga2:SetSmoothing("OUT")
		ga2:SetDuration(0.2)
		ga2:SetStartDelay(0.1)
		ga2:SetOrder(2)

		gag:SetScript("OnFinished", function(self)
			self:GetParent():Hide()
		end)
	end

	mirror.BumpFadeOut = function(self, modifier)
		modifier = modifier or 1.5
		if -modifier < self._elapsed then
			self._elapsed = -modifier
		end
	end

	if autoKeyup then
		mirror:SetScript("OnUpdate", function(self, elapsed)
			self._elapsed = self._elapsed + elapsed

			local timePassed = self._elapsed

			if timePassed >= 0.1 and self.pushed then
				mirror:SetButtonState("NORMAL")
				self.pushed = false
			end

			if timePassed >= 1 then
				local alpha = 2 - timePassed
				if alpha <= 0 then
					alpha = 0
					self:Hide()
				end
				self:SetAlpha(alpha)
			end
		end)
	else
		mirror:SetScript("OnUpdate", function(self, elapsed)
			self._elapsed = self._elapsed + elapsed

			local timePassed = self._elapsed
			if timePassed >= 1 then
				local alpha = 2 - timePassed
				if alpha <= 0 then
					alpha = 0
					self:Hide()
				end
				self:SetAlpha(alpha)
			end
		end)
	end

	mirror:EnableMouse(false)

	mirror:SetPoint("CENTER", self, "CENTER")

	mirror:Hide()

	return mirror
end

local function createPoolIcon(pool)
	local db = keyFeedback.db

	local hdr = pool.parent
	local id = pool.idCounter
	pool.idCounter = pool.idCounter + 1
	local f = CreateFrame("Button", MER.Title .. "KeyFeedbackPoolIcon" .. id, hdr, "ActionButtonTemplate")

	if f.SetNormalTexture then
		f:SetNormalTexture(0)
	end

	local bg = S:CreateBDFrame(f)
	bg:SetBackdropBorderColor(0, 0, 0)
	S:CreateShadow(bg)

	f:EnableMouse(false)
	f:SetHeight(db.lineIconSize or 28)
	f:SetWidth(db.lineIconSize or 28)
	f:SetPoint("BOTTOM", hdr, "BOTTOM", 0, -0)

	local t = f.icon
	f:SetAlpha(0)

	t:SetTexture("Interface\\Icons\\Spell_Shadow_SacrificialShield")
	t:SetTexCoord(unpack(E.TexCoords))

	local ag = f:CreateAnimationGroup()
	f.ag = ag

	local scaleOrigin = "RIGHT"
	local translateX = -100
	local translateY = 0

	local s1 = ag:CreateAnimation("Scale")
	s1:SetScale(0.01, 1)
	s1:SetDuration(0)
	s1:SetOrigin(scaleOrigin, 0, 0)
	s1:SetOrder(1)

	local s2 = ag:CreateAnimation("Scale")
	s2:SetScale(100, 1)
	s2:SetDuration(0.5)
	s2:SetOrigin(scaleOrigin, 0, 0)
	s2:SetSmoothing("OUT")
	s2:SetOrder(2)

	local a1 = ag:CreateAnimation("Alpha")
	a1:SetFromAlpha(0)
	a1:SetToAlpha(1)
	a1:SetDuration(0.1)
	a1:SetOrder(2)

	local t1 = ag:CreateAnimation("Translation")
	t1:SetOffset(translateX, translateY)
	t1:SetDuration(1.2)
	t1:SetSmoothing("IN")
	t1:SetOrder(2)

	local a2 = ag:CreateAnimation("Alpha")
	a2:SetFromAlpha(1)
	a2:SetToAlpha(0)
	a2:SetSmoothing("OUT")
	a2:SetDuration(0.5)
	a2:SetStartDelay(0.6)
	a2:SetOrder(2)

	ag.s1 = s1
	ag.s2 = s2
	ag.t1 = t1

	ag:SetScript("OnFinished", function(self)
		local icon = self:GetParent()
		icon:Hide()
		pool:Release(icon)
	end)

	return f
end

local function resetPoolIcon(pool, f)
	local db = keyFeedback.db

	f:SetHeight(db.lineIconSize)
	f:SetWidth(db.lineIconSize)

	f.ag:Stop()

	local scaleOrigin, revOrigin, translateX, translateY
	if db.lineDirection == "RIGHT" then
		scaleOrigin = "LEFT"
		revOrigin = "RIGHT"
		translateX = 100
		translateY = 0
	elseif db.lineDirection == "TOP" then
		scaleOrigin = "BOTTOM"
		revOrigin = "TOP"
		translateX = 0
		translateY = 100
	elseif db.lineDirection == "BOTTOM" then
		scaleOrigin = "TOP"
		revOrigin = "BOTTOM"
		translateX = 0
		translateY = -100
	else
		scaleOrigin = "RIGHT"
		revOrigin = "LEFT"
		translateX = -100
		translateY = 0
	end
	local ag = f.ag
	ag.s1:SetOrigin(scaleOrigin, 0, 0)

	ag.s2:SetOrigin(scaleOrigin, 0, 0)
	ag.t1:SetOffset(translateX, translateY)

	f:ClearAllPoints()
	local parent = pool.parent
	f:SetPoint(scaleOrigin, parent, revOrigin, 0, 0)
end

local framePool = {
	-- creationFunc = function(self)
	--     return self.parent:CreateMaskTexture()
	-- end,
	-- resetterFunc = function(self, mask)
	--     mask:Hide()
	--     mask:ClearAllPoints()
	-- end,
	AddObject = function(self, object)
		local dummy = true
		self.activeObjects[object] = dummy
		self.activeObjectCount = self.activeObjectCount + 1
	end,
	ReclaimObject = function(self, object)
		tinsert(self.inactiveObjects, object)
		self.activeObjects[object] = nil
		self.activeObjectCount = self.activeObjectCount - 1
	end,
	Release = function(self, object)
		local active = self.activeObjects[object] ~= nil
		if active then
			self:resetterFunc(object)
			self:ReclaimObject(object)
		end
		return active
	end,
	Acquire = function(self)
		local object = tremove(self.inactiveObjects)
		local new = object == nil
		if new then
			object = self:creationFunc()
			self:resetterFunc(object, new)
		end
		self:AddObject(object)
		return object, new
	end,
	ReleaseAll = function(self)
		for obj in pairs(self.activeObjects) do
			self:Release(obj)
		end
	end,
	Init = function(self, parent)
		self.activeObjects = {}
		self.inactiveObjects = {}
		self.activeObjectCount = 0
		self.parent = parent
	end,
}
local function createFramePool(frameType, parent, frameTemplate, resetterFunc, frameInitFunc)
	local self = setmetatable({}, { __index = framePool })
	self:Init(parent)
	self.frameType = frameType
	-- self.parent = parent
	self.frameTemplate = frameTemplate

	return self
end

function keyFeedback:CreateLastSpellIconLine(parent)
	local template = nil
	local resetterFunc = resetPoolIcon
	local iconPool = createFramePool("Frame", parent, template, resetterFunc)
	iconPool.creationFunc = createPoolIcon
	iconPool.resetterFunc = resetPoolIcon
	iconPool.idCounter = 1

	return iconPool
end
