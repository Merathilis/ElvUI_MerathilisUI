local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Cursor")

local rad, cos, sin = math.rad, math.cos, math.sin

local CreateFrame = CreateFrame
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
local UnitCastingInfo = UnitCastingInfo or CastingInfo
local UnitChannelInfo = UnitChannelInfo or ChannelInfo
local GetUnitEmpowerHoldAtMaxTime = GetUnitEmpowerHoldAtMaxTime

local Enum_OnUpdateMode_RunWhenVisible = Enum.OnUpdateMode and Enum.OnUpdateMode.RunWhenVisible

-- Reference spell used purely to read the shared (global) cooldown timing;
-- any instant ability works, this one is always known.
local GCD_REFERENCE_SPELL = 61304

-------------------------------------------------------------------------------
--  GCD Ring
-------------------------------------------------------------------------------
function module:CreateGCDRing()
	if self.gcdRoot then
		return
	end

	local radius = (self.db and self.db.gcd and self.db.gcd.radius) or 21
	local root = CreateFrame("Frame", "MER_CursorGCDRoot", E.UIParent)
	root:SetSize(radius * 2, radius * 2)
	root:SetFrameStrata("TOOLTIP")
	root:SetFrameLevel(9990)
	root:EnableMouse(false)

	root.ring = self:CreateRing(root, radius)
	root.ring.idleHidden = true
	root.ring.fg:Hide() -- the GCD ring only appears while actually sweeping

	root:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")

	root:SetScript("OnEvent", function(_, event, unit)
		if unit ~= "player" then
			return
		end

		local db = module.db and module.db.gcd
		if not db or not db.enable then
			return
		end
		if db.instanceOnly and not module:InInstance() then
			return
		end
		if db.combatOnly and not InCombatLockdown() then
			return
		end

		if event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_STOP" then
			local cdData = GetSpellCooldown(GCD_REFERENCE_SPELL)
			if not cdData or not cdData.duration or cdData.duration <= 0 then
				root.ring:StopRing()
			end
			return
		end

		local cdData = GetSpellCooldown(GCD_REFERENCE_SPELL)
		if not cdData or not cdData.startTime then
			return
		end

		local duration, startTime = cdData.duration, cdData.startTime
		if duration and duration > 0 and duration <= 1.6 and startTime and startTime > 0 then
			root.ring:StartRing(GetTime() - startTime, duration)
		end
	end)

	root:Hide()
	self.gcdRoot = root
end

function module:CreateGCDMover()
	if self.gcdMoverAnchor then
		return
	end

	local anchor = CreateFrame("Frame", nil, E.UIParent)
	anchor:SetSize(42, 42)
	anchor:SetPoint("CENTER", E.UIParent, "CENTER", -80, 0)
	E:CreateMover(
		anchor,
		"MER_CursorGCDMover",
		MER.Title .. L["Cursor GCD Ring"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,cursor"
	)
	self.gcdMoverAnchor = anchor
end

function module:ApplyGCD()
	local root = self.gcdRoot
	local db = self.db and self.db.gcd
	if not root or not db then
		return
	end

	if not db.enable then
		root:Hide()
		return
	end

	local radius = db.radius or 21
	root.ring:SetRingRadius(radius)
	root:SetSize(radius * 2, radius * 2)

	local r, g, b = self:ResolveColor(db)
	root.ring:SetRingColor(r, g, b, db.alpha or 0.8)

	root:ClearAllPoints()
	if db.attached ~= false then
		root:SetPoint("CENTER", self.tracker, "CENTER")
	else
		self:CreateGCDMover()
		root:SetPoint("CENTER", self.gcdMoverAnchor, "CENTER")
	end

	root:Show()
end

function module:UpdateGCDVisibility()
	local root = self.gcdRoot
	local db = self.db and self.db.gcd
	if not root or not db or not db.enable then
		return
	end

	local blocked = (db.instanceOnly and not self:InInstance()) or (db.combatOnly and not InCombatLockdown())
	if blocked and root:IsShown() then
		root:Hide()
	elseif not blocked and not root:IsShown() then
		root:Show()
	end
end

-------------------------------------------------------------------------------
--  Cast Bar Ring
-------------------------------------------------------------------------------
function module:CreateCastRing()
	if self.castRoot then
		return
	end

	local radius = (self.db and self.db.castCircle and self.db.castCircle.radius) or 30
	local root = CreateFrame("Frame", "MER_CursorCastRoot", E.UIParent)
	root:SetSize(radius * 2, radius * 2)
	root:SetFrameStrata("TOOLTIP")
	root:SetFrameLevel(9988)
	root:EnableMouse(false)

	root.ring = self:CreateRing(root, radius)
	root.ring.idleHidden = true
	root.ring.fg:Hide() -- the cast ring only appears while actually casting

	local sparkLayer = CreateFrame("Frame", nil, root)
	sparkLayer:SetAllPoints(root)
	sparkLayer:SetFrameLevel(root:GetFrameLevel() + 3)

	root.spark = sparkLayer:CreateTexture(nil, "OVERLAY")
	root.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	root.spark:SetBlendMode("ADD")
	root.spark:SetSize(radius * 0.6, radius * 0.6)
	root.spark:Hide()

	if sparkLayer.SetOnUpdateMode and Enum_OnUpdateMode_RunWhenVisible then
		-- Skip the spark sweep tick while the cast ring root is hidden
		sparkLayer:SetOnUpdateMode(Enum_OnUpdateMode_RunWhenVisible)
	end

	sparkLayer:SetScript("OnUpdate", function()
		local spark = root.spark
		if not spark:IsShown() then
			return
		end

		local duration, maxDuration = root.ring.duration, root.ring.maxDuration
		if not maxDuration or maxDuration <= 0 then
			spark:Hide()
			return
		end

		local pct = duration / maxDuration
		if pct <= 0 or pct >= 1 then
			spark:Hide()
			return
		end

		local orbitR = root.ring.radius or radius
		local angleDeg = 90 - (pct * 360)
		local sx, sy = cos(rad(angleDeg)) * orbitR, sin(rad(angleDeg)) * orbitR

		spark:ClearAllPoints()
		spark:SetPoint("CENTER", root, "CENTER", sx, sy)
		spark:SetRotation(rad(angleDeg - 90))
	end)

	root._castID = nil

	root:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
	root:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
	if UnitChannelInfo and GetUnitEmpowerHoldAtMaxTime then
		root:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player")
		root:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", "player")
		root:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", "player")
	end

	root:SetScript("OnEvent", function(self, event, unit, castID)
		if unit ~= "player" then
			return
		end

		local db = module.db and module.db.castCircle
		if not db or not db.enable then
			return
		end
		if db.instanceOnly and not module:InInstance() then
			return
		end
		if db.combatOnly and not InCombatLockdown() then
			return
		end

		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			local name, _, _, startMS, endMS, _, castGUID = UnitCastingInfo("player")
			if name then
				self._castID = castGUID
				root.ring:StartRing(GetTime() - startMS * 0.001, (endMS - startMS) * 0.001)
				if db.sparkEnable then
					root.spark:Show()
				end
			end
		elseif
			event == "UNIT_SPELLCAST_CHANNEL_START"
			or event == "UNIT_SPELLCAST_CHANNEL_UPDATE"
			or event == "UNIT_SPELLCAST_EMPOWER_START"
			or event == "UNIT_SPELLCAST_EMPOWER_UPDATE"
		then
			local name, _, _, startMS, endMS, _, _, _, _, numStages = UnitChannelInfo("player")
			if name then
				self._castID = nil
				if numStages and numStages > 0 and GetUnitEmpowerHoldAtMaxTime then
					endMS = endMS + GetUnitEmpowerHoldAtMaxTime("player")
				end
				root.ring:StartRing(GetTime() - startMS * 0.001, (endMS - startMS) * 0.001)
				if db.sparkEnable then
					root.spark:Show()
				end
			end
		elseif event == "UNIT_SPELLCAST_STOP" then
			if castID == self._castID then
				self._castID = nil
				root.ring:StopRing()
				root.spark:Hide()
			end
		else -- FAILED, INTERRUPTED, CHANNEL_STOP, EMPOWER_STOP
			if not castID or castID == self._castID then
				self._castID = nil
				root.ring:StopRing()
				root.spark:Hide()
			end
		end
	end)

	root:Hide()
	self.castRoot = root
end

function module:CreateCastMover()
	if self.castMoverAnchor then
		return
	end

	local anchor = CreateFrame("Frame", nil, E.UIParent)
	anchor:SetSize(60, 60)
	anchor:SetPoint("CENTER", E.UIParent, "CENTER", 80, 0)
	E:CreateMover(
		anchor,
		"MER_CursorCastMover",
		MER.Title .. L["Cursor Cast Ring"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,cursor"
	)
	self.castMoverAnchor = anchor
end

function module:ApplyCast()
	local root = self.castRoot
	local db = self.db and self.db.castCircle
	if not root or not db then
		return
	end

	if not db.enable then
		root:Hide()
		return
	end

	local radius = db.radius or 30
	root.ring:SetRingRadius(radius)
	root:SetSize(radius * 2, radius * 2)
	root.spark:SetSize(radius * 0.6, radius * 0.6)

	local r, g, b = self:ResolveColor(db)
	root.ring:SetRingColor(r, g, b, db.alpha or 0.8)
	root.spark:SetVertexColor(r, g, b, 1)

	root:ClearAllPoints()
	if db.attached ~= false then
		root:SetPoint("CENTER", self.tracker, "CENTER")
	else
		self:CreateCastMover()
		root:SetPoint("CENTER", self.castMoverAnchor, "CENTER")
	end

	root:Show()
end

function module:UpdateCastVisibility()
	local root = self.castRoot
	local db = self.db and self.db.castCircle
	if not root or not db or not db.enable then
		return
	end

	local blocked = (db.instanceOnly and not self:InInstance()) or (db.combatOnly and not InCombatLockdown())
	if blocked and root:IsShown() then
		root:Hide()
	elseif not blocked and not root:IsShown() then
		root:Show()
	end
end
