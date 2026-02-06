local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local _G = _G
local select, strsplit = select, strsplit
local tinsert = tinsert
local mathmax = math.max
local mathmin = math.min

local SetPortraitTexture = SetPortraitTexture
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsDead = UnitIsDead

local Portraits = MER.Portraits
if not Portraits then
	return
end

local colors = {}
local isTrilinear = true
local useTextureColor = false

local bg_textures = {
	[1] = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\bg_1.tga",
	[2] = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\bg_2.tga",
	[3] = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\bg_3.tga",
	[4] = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\bg_4.tga",
	[5] = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\bg_5.tga",
	empty = "Interface\\Addons\\ElvUI_MerathilisUI\\Media\\Portraits\\empty.tga",
	unknown = "Interface\\Addons\\lvUI_MerathilisUI\\Media\\Portraits\\unknown.tga",
}

local bossIDs = I.InternalIDs.BossIDs

local function SetTextures(frame, texture)
	if isTrilinear then
		frame:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
	else
		frame:SetTexture(texture)
	end
end

local function mirrorTexture(texture, mirror, top)
	if texture.classIcons then
		local coords = texture.classCoords
		if #coords == 8 then
			texture:SetTexCoord(unpack((mirror and {
				coords[5],
				coords[6],
				coords[7],
				coords[8],
				coords[1],
				coords[2],
				coords[3],
				coords[4],
			} or coords)))
		else
			texture:SetTexCoord(unpack((mirror and { coords[2], coords[1], coords[3], coords[4] } or coords)))
		end
	else
		texture:SetTexCoord(mirror and 1 or 0, mirror and 0 or 1, top and 1 or 0, top and 0 or 1)
	end
end

local function setColor(texture, color, mirror)
	if not texture or not color then
		return
	end

	if type(color.a) == "table" and type(color.b) == "table" then
		if E.db.mui.portraits.general.gradient then
			local a, b = color.a, color.b
			if mirror and (E.db.mui.portraits.general.ori == "HORIZONTAL") then
				a, b = b, a
			end
			texture:SetGradient(E.db.mui.portraits.general.ori, a, b)
		else
			texture:SetVertexColor(color.a.r, color.a.g, color.a.b, color.a.a)
		end
	elseif color.r and color.g and color.b and color.a then
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	else
		F.Print("Error! - Portraits Color > ")
		F.DebugPrintTable(color)
	end
end

local cachedFaction = {}

local function getColor(unit, isPlayer, isDead)
	local defaultColor = colors.default

	if isPlayer == nil then
		isPlayer = UnitIsPlayer(unit)
	end

	if E.db.mui.portraits.general.deathcolor and isDead then
		return colors.death
	end

	if E.db.mui.portraits.general.default then
		return defaultColor
	end

	if isPlayer or UnitInPartyIsAI(unit) then
		if E.db.mui.portraits.general.reaction then
			local playerFaction = cachedFaction.player or select(1, UnitFactionGroup("player"))
			cachedFaction.player = playerFaction
			local unitFaction = cachedFaction[UnitGUID(unit)] or select(1, UnitFactionGroup(unit))
			cachedFaction[UnitGUID(unit)] = unitFaction

			return colors[(playerFaction == unitFaction) and "friendly" or "enemy"]
		else
			local _, class = UnitClass(unit)
			return colors[class]
		end
	else
		local reaction = UnitReaction(unit, "player")
		return colors[reaction and ((reaction <= 3) and "enemy" or (reaction == 4) and "neutral" or "friendly") or "enemy"]
	end
end

local function adjustColor(color, shift)
	return {
		r = color.r * shift,
		g = color.g * shift,
		b = color.b * shift,
		a = color.a,
	}
end

local function UpdateIconBackground(tx, unit, mirror)
	local portraits = E.db.mui.portraits
	local shadow = portraits.shadow

	SetTextures(tx, bg_textures[portraits.general.bgstyle])

	local color = shadow.classBG and getColor(unit) or shadow.background
	local ColorShift = shadow.bgColorShift

	if color then
		local bgColor
		if type(color.a) == "table" then
			bgColor = {
				a = adjustColor(color.a, ColorShift),
				b = adjustColor(color.b, ColorShift),
			}
		else
			bgColor = adjustColor(color, ColorShift)
		end

		if bgColor then
			setColor(tx, bgColor, mirror)
		end
	end
end

local function DeadDesaturation(self)
	if self.unit_is_dead then
		self.portrait:SetDesaturated(true)
		self.isDesaturated = true
	elseif self.isDesaturated then
		self.portrait:SetDesaturated(false)
		self.isDesaturated = false
	end
end

local function SetPortraits(frame, unit, masking, mirror)
	if E.db.mui.portraits.general.classicons and (UnitIsPlayer(unit) or UnitInPartyIsAI(unit)) then
		local class = select(2, UnitClass(unit))
		if not class then
			return
		end

		local style = E.db.mui.portraits.general.classiconstyle
		local classIcons = MER.ClassIcons.mMT[style] or MER.ClassIcons.Custom[style]

		if not classIcons then
			SetPortraitTexture(frame.portrait, unit, true)
		else
			local defaultTexCoords = MER.ClassIcons.data
			local coords = classIcons.texCoords and classIcons.texCoords[class] or defaultTexCoords[class].texCoords
			if not coords then
				return
			end

			SetTextures(frame.portrait, classIcons.texture)

			frame.portrait.classIcons = unit
			frame.portrait.classCoords = coords
			frame.portrait:SetTexCoord(unpack(coords))
		end
	else
		if frame.portrait.classIcons then
			frame.portrait.classIcons = nil
			frame.portrait.classCoords = nil
		end
		SetPortraitTexture(frame.portrait, unit, true)
	end

	if frame.iconbg then
		UpdateIconBackground(frame.iconbg, unit, mirror)
	end

	if E.db.mui.portraits.general.desaturation then
		DeadDesaturation(frame)
	end

	mirrorTexture(frame.portrait, mirror)
end

local function GetOffset(size)
	local offset = E.db.mui.portraits.zoom
	if offset == 0 or not offset then
		return 0
	else
		local maxOffset = size / 2
		local zoom = (1 - offset) * size / 2

		zoom = mathmax(-maxOffset, mathmin(zoom, maxOffset))
		return zoom
	end
end

local function UpdateTexture(portraitFrame, textureType, texture, level, color, reverse)
	if not portraitFrame[textureType] then
		portraitFrame[textureType] =
			portraitFrame:CreateTexture("mMT_" .. textureType .. "-" .. portraitFrame.name, "OVERLAY", nil, level)
		portraitFrame[textureType]:SetAllPoints(portraitFrame)
	end

	local mirror = portraitFrame.settings.mirror
	SetTextures(portraitFrame[textureType], texture)
	if reverse ~= nil then
		mirror = reverse
	end
	mirrorTexture(portraitFrame[textureType], mirror, portraitFrame.textures.flip)

	if color then
		setColor(portraitFrame[textureType], color, mirror)
	end
end

local function UpdateExtraTexture(portraitFrame, classification)
	classification = (classification == "rareelite") and "rare" or classification
	local extraTextures = portraitFrame.textures[classification] and portraitFrame.textures[classification].texture
	SetTextures(portraitFrame.extra, extraTextures)

	-- Border
	if E.db.mui.portraits.shadow.border then
		extraTextures = portraitFrame.textures[classification].border
		SetTextures(portraitFrame.extraBorder, extraTextures)
	end

	-- Shadow
	if E.db.mui.portraits.shadow.enable then
		extraTextures = portraitFrame.textures[classification].shadow
		SetTextures(portraitFrame.extraShadow, extraTextures)
	end
end

local function GetNPCID(unit)
	local guid = UnitGUID(unit or "npc")
	return tonumber(E:NotSecretValue(guid) and guid or "") and select(6, strsplit("-", guid))
end

local function HideRareElite(frame)
	if E.db.mui.portraits.shadow.enable and frame.extraShadow then
		frame.extraShadow:Hide()
	end
	if E.db.mui.portraits.shadow.border and frame.extraBorder then
		frame.extraBorder:Hide()
	end
	frame.extra:Hide()
end

local simpleClassification = {
	worldboss = "boss",
	rareelite = "rareelite",
	elite = "elite",
	rare = "rare",
}

local function CheckRareElite(frame, unit, unitColor)
	local c = UnitClassification(unit) --"worldboss", "rareelite", "elite", "rare", "normal", "trivial", or "minus"
	local npcID = GetNPCID(unit)
	local classification = (bossIDs[npcID] and "boss" or simpleClassification[c])

	if classification then
		local color = useTextureColor and (unitColor or colors[classification]) or colors[classification]

		UpdateExtraTexture(frame, classification)
		setColor(frame.extra, color)
		if E.db.mui.portraits.shadow.enable then
			if frame.extraShadow then
				frame.extraShadow:Show()
			end
			if E.db.mui.portraits.shadow.border and frame.extraBorder then
				local borderColor = colors.border[classification] or colors.border.default
				setColor(frame.extraBorder, borderColor)
				frame.extraBorder:Show()
			end
		end
		frame.extra:Show()
	else
		HideRareElite(frame)
	end
end

local function UpdatePortrait(portraitFrame, force)
	-- get textures
	portraitFrame.textures = module:GetTextures(portraitFrame.settings.texture)
	portraitFrame.unit = portraitFrame.parent.unit

	local texture, offset
	local setting = portraitFrame.settings
	local unit = force and "player"
		or (UnitExists(portraitFrame.unit) and portraitFrame.unit or (portraitFrame.parent.unit or "player"))
	local parent = portraitFrame.parent
	local unitColor = getColor(unit)

	-- Portraits Frame
	if not InCombatLockdown() and (setting and setting.point) then
		portraitFrame:SetSize(setting.size, setting.size)
		portraitFrame:ClearAllPoints()
		portraitFrame:SetPoint(setting.point, parent, setting.relativePoint, setting.x, setting.y)

		if setting.strata ~= "AUTO" then
			portraitFrame:SetFrameStrata(setting.strata)
		end
		portraitFrame:SetFrameLevel(setting.level)
	end

	-- Portrait Texture
	texture = portraitFrame.textures.texture
	UpdateTexture(portraitFrame, "texture", texture, 4, unitColor)

	-- Unit Portrait
	offset = GetOffset(setting.size)
	UpdateTexture(portraitFrame, "portrait", bg_textures.unknown, 1)
	SetPortraits(portraitFrame, unit, false, setting.mirror)
	portraitFrame.portrait:SetPoint("TOPLEFT", 0 + offset, 0 - offset)
	portraitFrame.portrait:SetPoint("BOTTOMRIGHT", 0 - offset, 0 + offset)

	-- Portrait Mask
	if portraitFrame.textures.extraMask then
		if setting.mirror then
			texture = portraitFrame.textures.mask.b
		else
			texture = portraitFrame.textures.mask.a
		end
	else
		texture = portraitFrame.textures.mask
	end

	if not portraitFrame.mask then
		portraitFrame.mask = portraitFrame:CreateMaskTexture()
		portraitFrame.mask:SetAllPoints(portraitFrame)
		portraitFrame.portrait:AddMaskTexture(portraitFrame.mask)
	end

	portraitFrame.mask:SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

	--local color = (E.db.mui.portraits.shadow.classBG and unitColor or E.db.mui.portraits.shadow.background)
	UpdateTexture(portraitFrame, "iconbg", bg_textures[E.db.mui.portraits.general.bgstyle], -5)
	portraitFrame.iconbg:AddMaskTexture(portraitFrame.mask)
	--end

	-- Portrait Shadow
	if E.db.mui.portraits.shadow.enable then
		texture = portraitFrame.textures.shadow
		UpdateTexture(portraitFrame, "shadow", texture, -4, E.db.mui.portraits.shadow.color)
		portraitFrame.shadow:Show()
	elseif portraitFrame.shadow then
		portraitFrame.shadow:Hide()
	end

	-- Inner Portrait Shadow
	if E.db.mui.portraits.shadow.inner then
		texture = portraitFrame.textures.inner
		UpdateTexture(portraitFrame, "innerShadow", texture, 2, E.db.mui.portraits.shadow.innerColor)
		portraitFrame.innerShadow:Show()
	elseif portraitFrame.innerShadow then
		portraitFrame.innerShadow:Show()
	end

	-- Portrait Border
	if E.db.mui.portraits.shadow.border then
		texture = portraitFrame.textures.border
		UpdateTexture(portraitFrame, "border", texture, 2, colors.border.default)
	end

	-- Rare/Elite Texture
	if setting.extraEnable then
		-- Texture
		texture = portraitFrame.textures.rare.texture
		UpdateTexture(portraitFrame, "extra", texture, -6, colors.border.default, not portraitFrame.settings.mirror)

		-- Border
		if E.db.mui.portraits.shadow.border then
			texture = portraitFrame.textures.rare.border
			UpdateTexture(
				portraitFrame,
				"extraBorder",
				texture,
				-7,
				colors.border.default,
				not portraitFrame.settings.mirror
			)
			portraitFrame.extraBorder:Hide()
		end

		-- Shadow
		if E.db.mui.portraits.shadow.enable then
			texture = portraitFrame.textures.rare.shadow
			UpdateTexture(
				portraitFrame,
				"extraShadow",
				texture,
				-8,
				E.db.mui.portraits.shadow.color,
				not portraitFrame.settings.mirror
			)
			portraitFrame.extraShadow:Hide()
		end

		CheckRareElite(portraitFrame, unit, unitColor)
	end

	-- Corner
	if portraitFrame.textures.corner then
		texture = portraitFrame.textures.corner.texture
		UpdateTexture(portraitFrame, "corner", texture, 5, unitColor)

		-- Border
		if E.db.mui.portraits.shadow.border then
			texture = portraitFrame.textures.corner.border
			UpdateTexture(portraitFrame, "cornerBorder", texture, 6, colors.border.default)
			portraitFrame.cornerBorder:Show()
		end

		portraitFrame.corner:Show()
	elseif portraitFrame.corner then
		portraitFrame.corner:Hide()

		if portraitFrame.cornerBorder then
			portraitFrame.cornerBorder:Hide()
		end
	end
end

local function SetCastEvents(portrait, unregistering)
	local castEvents = {
		"UNIT_SPELLCAST_START",
		"UNIT_SPELLCAST_CHANNEL_START",
		"UNIT_SPELLCAST_INTERRUPTED",
		"UNIT_SPELLCAST_STOP",
		"UNIT_SPELLCAST_CHANNEL_STOP",
	}
	local empowerEvents = { "UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP" }

	if unregistering then
		for _, event in pairs(castEvents) do
			portrait:UnregisterEvent(event)
		end

		for _, event in pairs(empowerEvents) do
			portrait:UnregisterEvent(event)
		end
	else
		for _, event in pairs(castEvents) do
			if portrait.isPartyFrame then
				portrait:RegisterEvent(event)
			else
				portrait:RegisterUnitEvent(event, portrait.unit)
			end
			tinsert(portrait.allEvents, event)
		end

		for _, event in pairs(empowerEvents) do
			if portrait.isPartyFrame then
				portrait:RegisterEvent(event)
			else
				portrait:RegisterUnitEvent(event, portrait.unit)
			end
			tinsert(portrait.allEvents, event)
		end
	end
end

local function SetScripts(portrait, force)
	if not portrait.isBuild then
		-- party event
		if portrait.isPartyFrame then
			-- events for all party frames
			local partyEvents = {
				"GROUP_ROSTER_UPDATE",
				"PARTY_MEMBER_ENABLE",
				"UNIT_MODEL_CHANGED",
				"UNIT_PORTRAIT_UPDATE",
				"UNIT_CONNECTION",
			}
			for _, event in ipairs(partyEvents) do
				portrait:RegisterEvent(event)
				tinsert(portrait.allEvents, event)
			end

			-- events for cast icon
			if portrait.settings.cast then
				SetCastEvents(portrait)
				portrait.castEventsSet = true
			end
		else
			-- specific events for unit
			local unitEvents = { "UNIT_MODEL_CHANGED", "UNIT_PORTRAIT_UPDATE", "UNIT_CONNECTION" }

			for _, event in ipairs(unitEvents) do
				portrait:RegisterUnitEvent(event, portrait.unit)
				tinsert(portrait.allEvents, event)
			end

			if E.db.mui.portraits.general.desaturation then
				local healthEvent = "UNIT_HEALTH"
				portrait:RegisterUnitEvent(healthEvent, portrait.unit)
				tinsert(portrait.allEvents, healthEvent)
			end

			if portrait.unit == "player" then
				portrait:RegisterEvent("VEHICLE_UPDATE")
				tinsert(portrait.allEvents, "VEHICLE_UPDATE")
				portrait:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", portrait.unit)
				tinsert(portrait.allEvents, "UNIT_ENTERED_VEHICLE")
				portrait:RegisterUnitEvent("UNIT_EXITED_VEHICLE", portrait.unit)
				tinsert(portrait.allEvents, "UNIT_EXITED_VEHICLE")
			end
			if portrait.unit == "pet" then
				portrait:RegisterEvent("VEHICLE_UPDATE")
				tinsert(portrait.allEvents, "VEHICLE_UPDATE")
			end

			if portrait.events then
				for _, event in pairs(portrait.events) do
					portrait:RegisterUnitEvent(event)
					tinsert(portrait.allEvents, event)
				end
			end

			if portrait.unitEvents then
				for _, event in pairs(portrait.unitEvents) do
					portrait:RegisterUnitEvent(event, event == "UNIT_TARGET" and "target" or portrait.unit)
					tinsert(portrait.allEvents, event)
				end
			end

			-- events for cast icon
			if portrait.settings.cast then
				SetCastEvents(portrait)
				portrait.castEventsSet = true
			end
		end

		-- events for all units
		portrait:RegisterEvent("PLAYER_ENTERING_WORLD")
		tinsert(portrait.allEvents, "PLAYER_ENTERING_WORLD")
		portrait:RegisterEvent("PORTRAITS_UPDATED")
		tinsert(portrait.allEvents, "PORTRAITS_UPDATED")

		-- scripts to interact with mouse
		portrait:SetAttribute("unit", portrait.unit)
		portrait:SetAttribute("*type1", "target")
		portrait:SetAttribute("*type2", "togglemenu")
		portrait:SetAttribute("type3", "focus")
		portrait:SetAttribute("toggleForVehicle", true)
		portrait:SetAttribute("ping-receiver", true)
		portrait:RegisterForClicks("AnyUp")

		portrait.isBuild = true
	end

	-- update cast events
	if force then
		if portrait.settings.cast and not portrait.castEventsSet then
			SetCastEvents(portrait)
			portrait.castEventsSet = true
		elseif portrait.castEventsSet then
			SetCastEvents(portrait, true)
			portrait.castEventsSet = false
		end
	end
end

local function UpdateAllPortraits(force)
	local units = {
		"Player",
		"Target",
		"Pet",
		"Focus",
		"TargetTarget",
	}
	for _, name in ipairs(units) do
		if Portraits[name] then
			UpdatePortrait(Portraits[name])

			-- update for demo frames
			if force then
				SetScripts(Portraits[name], force)
			end
		end
	end
end

local function CastIcon(self)
	-- local texture = select(3, UnitCastingInfo(self.unit))

	-- if not texture then texture = select(3, UnitChannelInfo(self.unit)) end
	return select(3, UnitCastingInfo(self.unit)) or select(3, UnitChannelInfo(self.unit))
end

local function AddCastIcon(self)
	local texture = CastIcon(self)
	if texture then
		self.portrait:SetTexture(texture)
		if self.portrait.classIcons then
			self.portrait.classIcons = nil
			self.portrait.classCoords = nil
		end

		mirrorTexture(self.portrait, self.settings.mirror)
	end
end

function module:RemovePortraits(unitPortrait)
	if unitPortrait and unitPortrait.allEvents then
		for _, event in pairs(unitPortrait.allEvents) do
			unitPortrait:UnregisterEvent(event)
		end
	end

	unitPortrait:Hide()
	unitPortrait = nil
end

local castStarted = {
	UNIT_SPELLCAST_START = true,
	UNIT_SPELLCAST_CHANNEL_START = true,
	UNIT_SPELLCAST_EMPOWER_START = true,
}

local castStopped = {
	UNIT_SPELLCAST_INTERRUPTED = true,
	UNIT_SPELLCAST_STOP = true,
	UNIT_SPELLCAST_CHANNEL_STOP = true,
	UNIT_SPELLCAST_EMPOWER_STOP = true,
}

local function UpdatePortraitTexture(self, unit)
	if not InCombatLockdown() and self:GetAttribute("unit") ~= unit then
		self:SetAttribute("unit", unit)
	end
	local isPlayer = UnitIsPlayer(unit)
	local unitColor = getColor(unit, isPlayer, self.unit_is_dead)

	SetPortraits(self, unit, false, self.settings.mirror)
	setColor(self.texture, unitColor, self.settings.mirror)

	if E.db.mui.portraits.general.corner and self.textures.corner then
		setColor(self.corner, unitColor, self.settings.mirror)
	end

	if self.settings.extraEnable and self.extra and not isPlayer then
		CheckRareElite(self, unit, unitColor)
	elseif self.extra then
		HideRareElite(self)
	end
end

local function UnitEvent(self, event)
	local unit = self.unit

	if E.db.mui.portraits.general.desaturation or E.db.mui.portraits.general.deathcolor then
		self.unit_is_dead = UnitIsDead(unit)
	end

	if castStopped[event] or (self.isCasting and not CastIcon(self)) then
		self.isCasting = false
		UpdatePortraitTexture(self, unit)
	elseif self.isCasting or castStarted[event] then
		if self.settings.cast or self.isCasting then
			self.empowering = (event == "UNIT_SPELLCAST_EMPOWER_START")
			self.isCasting = true

			AddCastIcon(self)
		end
	else
		UpdatePortraitTexture(self, unit)
	end
end

local function setColors(sourceColors, targetColors)
	targetColors.default = sourceColors.default
	targetColors.rare = sourceColors.rare
	targetColors.rareelite = sourceColors.rareelite
	targetColors.elite = sourceColors.elite
	colors.border = E.db.mui.portraits.colors.border
end

local function ConfigureColors()
	colors = E.db.mui.portraits.colors
end

local function shouldHandleEvent(event, eventUnit, self)
	return (event == "UNIT_TARGET" and (eventUnit == "player" or eventUnit == "target" or eventUnit == "targettarget"))
		or (event == "PLAYER_TARGET_CHANGED" and (self.unit == "target" or self.unit == "targettarget"))
		or event == "PLAYER_FOCUS_CHANGED" and self.parent.unit == "focus"
		or eventUnit == self.unit
end

local forceUpdateParty = {
	UNIT_CONNECTION = true,
	GROUP_ROSTER_UPDATE = true,
	PARTY_MEMBER_ENABLE = true,
	PORTRAITS_UPDATED = true,
}

local function PartyUnitOnEvent(self, event, eventUnit)
	if not UnitExists(self.parent.unit) then
		return
	end

	if event == "UNIT_HEALTH" and eventUnit == self.unit then
		DeadDesaturation(self)
	end

	self.unit = self.parent.unit

	if E.db.mui.portraits.general.desaturation and not self.eventDesaturationIsSet then
		self:RegisterUnitEvent("UNIT_HEALTH", self.unit)
		tinsert(self.allEvents, "UNIT_HEALTH")
		self.eventDesaturationIsSet = true
	end

	if event == "GROUP_ROSTER_UPDATE" then
		-- force party portraits update
		for i = 1, 5 do
			Portraits["Party" .. i].unit = Portraits["Party" .. i].parent.unit
			UnitEvent(Portraits["Party" .. i], event)
		end
	elseif eventUnit == self.unit or forceUpdateParty[event] then
		UnitEvent(self, event)
	end
end

local function BossUnitOnEvent(self, event, eventUnit)
	if not UnitExists(self.parent.unit) then
		return
	end

	if event == "UNIT_HEALTH" and eventUnit == self.unit then
		DeadDesaturation(self)
	end

	if eventUnit == self.unit or event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" or event == "PORTRAITS_UPDATED" then
		UnitEvent(self, event)
	end
end

local function PlayerPetUnitOnEvent(self, event, eventUnit)
	if not UnitExists(self.parent.unit) then
		return
	end

	if event == "UNIT_HEALTH" and eventUnit == self.unit then
		DeadDesaturation(self)
	end

	if eventUnit == "vehicle" or _G.ElvUF_Player.unit == "vehicle" then
		self.unit = (self.parent.realUnit == "player") and "pet" or "player"
	else
		self.unit = self.parent.unit
	end

	if
		eventUnit == self.unit
		or _G.ElvUF_Player.unit == "vehicle"
		or event == "UNIT_EXITED_VEHICLE"
		or event == "UNIT_ENTERED_VEHICLE"
		or event == "VEHICLE_UPDATE"
	then
		UnitEvent(self, event)
	end
end

local function OtherUnitOnEvent(self, event, eventUnit)
	if not UnitExists(self.unit) then
		return
	end

	if event == "UNIT_HEALTH" and eventUnit == self.unit then
		DeadDesaturation(self)
	end

	if shouldHandleEvent(event, eventUnit, self) then
		UnitEvent(self, event)
	end
end

function module:CreatePortraits(name, unit, parentFrame, unitSettings, events, unitEvents)
	local partyFrames = {
		Party1 = true,
		Party2 = true,
		Party3 = true,
		Party4 = true,
		Party5 = true,
	}
	local bossFrames = {
		Boss1 = true,
		Boss2 = true,
		Boss3 = true,
		Boss4 = true,
		Boss5 = true,
		Boss6 = true,
		Boss7 = true,
		Boss8 = true,
	}

	if not Portraits[name] then
		Portraits[name] = CreateFrame("Button", "mMT_Portrait_" .. name, parentFrame, "SecureUnitButtonTemplate") -- CreatePortrait(parentFrame, unitSettings, unit)
		Portraits[name].parent = parentFrame
		Portraits[name].unit = unit
		Portraits[name].isPartyFrame = partyFrames[name]
		Portraits[name].isBossFrame = bossFrames[name]
		Portraits[name].events = events or nil
		Portraits[name].unitEvents = unitEvents or nil
		Portraits[name].allEvents = {}
		Portraits[name].name = name
	end

	-- update settings
	Portraits[name].settings = unitSettings
	Portraits[name].textures = module:GetTextures(unitSettings.texture)

	-- add event function
	if Portraits[name] and not Portraits[name].scriptsSet then
		if Portraits[name].isPartyFrame then
			Portraits[name]:SetScript("OnEvent", PartyUnitOnEvent)
		elseif Portraits[name].isBossFrame then
			Portraits[name]:SetScript("OnEvent", BossUnitOnEvent)
		elseif name == "Player" or name == "Pet" then
			Portraits[name]:SetScript("OnEvent", PlayerPetUnitOnEvent)
		else
			Portraits[name]:SetScript("OnEvent", OtherUnitOnEvent)
		end

		SetScripts(Portraits[name])
		Portraits[name].scriptsSet = true
	end

	-- Update Portrait
	UpdatePortrait(Portraits[name])
end

local function ToggleForceShowGroupFrames(_, group, numGroup)
	if group == "boss" or group == "arena" then
		local name = (group == "boss") and "Boss" or "Arena"

		for i = 1, numGroup do
			if Portraits[name .. i] then
				UpdatePortrait(Portraits[name .. i], true)
			end
		end
	end
end

local function HeaderConfig(_, header, configMode)
	if header.groups and header.groupName == "party" then
		for i = 1, #header.groups[1] do
			if Portraits["Party" .. i] then
				UpdatePortrait(Portraits["Party" .. i], true)
			end
		end
	end
end

function module:Portraits(force)
	local db = E.db.mui.portraits

	--update settings
	isTrilinear = db.general.trilinear
	useTextureColor = db.general.usetexturecolor

	-- update colors
	ConfigureColors()

	-- initialize portraits
	if db.general.enable then
		-- update all portraits, force = update cast events
		UpdateAllPortraits(force)

		-- for demo frames - party, boss & arena
		if not Portraits.needReloadUI then
			hooksecurefunc(UF, "ToggleForceShowGroupFrames", ToggleForceShowGroupFrames)
			hooksecurefunc(UF, "HeaderConfig", HeaderConfig)
			Portraits.needReloadUI = true
		end
	else
		for _, unitPortrait in pairs(Portraits) do
			if type(unitPortrait) == "table" and unitPortrait.portrait then
				module:RemovePortraits(unitPortrait)
			end
		end
	end

	Portraits.loaded = db.general.enable
end
