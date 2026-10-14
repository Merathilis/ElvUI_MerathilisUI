local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local C_Texture = C_Texture
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local SetPortraitTexture = SetPortraitTexture
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsConnected = UnitIsConnected
local UnitIsBossMob = UnitIsBossMob
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

--[[
	oUF element: MER_Portrait

	A 2D portrait next to the unitframe: cut to a shape, framed by a ring in the
	unit's color, with a soft shadow and the spell icon while the unit casts.
	Elite, rare and boss NPCs get a dragon, a badge or a ring in their classification color.

	Widget: frame.MER_Portrait - a Frame the size of the shape
	Options (set by Configure_Portrait):
		element.cast           - show the spell icon while casting
		element.mirror         - the square corner and the face point to the left
--]]

-- The shape fills 80 % of every texture file, the rest is room for the shadow
local CANVAS = 1 / 0.8

-- Spell icons have a border baked in
local ICON_INSET = 0.08

local INACTIVE_COLOR = 0.5

local GRADIENT_COLOR = I.Enum.GradientMode.Color

-- Classification art is Blizzard's own, nothing of it is shipped
local BADGE_ATLAS = {
	boss = "nameplates-icon-elite-gold",
	elite = "nameplates-icon-elite-gold",
	rareelite = "nameplates-icon-elite-silver",
	rare = "nameplates-icon-elite-silver",
}

-- The dragons of Blizzard's target frame. TargetFrame.xml places them around a 58px portrait,
-- here as size and center offset in portrait widths. They curl around a portrait on the right
-- side of its frame, which is the mirrored side here.
local PORTRAIT = 58
local DRAGON_SMALL = { width = 80 / PORTRAIT, height = 79 / PORTRAIT, x = 4 / PORTRAIT, y = 0.5 / PORTRAIT }
local DRAGON_WINGED = { width = 99 / PORTRAIT, height = 81 / PORTRAIT, x = 13.5 / PORTRAIT, y = -0.5 / PORTRAIT }

local DRAGON = {
	boss = { atlas = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold-Winged", geometry = DRAGON_WINGED },
	elite = { atlas = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Gold", geometry = DRAGON_SMALL },
	rareelite = { atlas = "ui-hud-unitframe-target-portraiton-boss-rare-silver", geometry = DRAGON_SMALL },
	rare = { atlas = "ui-hud-unitframe-target-portraiton-boss-rare-silver", geometry = DRAGON_SMALL },
}

-- Styles with a corner have a mirrored set of files
local MIRRORED_STYLES = {
	Drop = "DropMirror",
}

local CAST_EVENTS = {
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_STOP",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_CHANNEL_STOP",
	"UNIT_SPELLCAST_EMPOWER_START",
	"UNIT_SPELLCAST_EMPOWER_STOP",
}

local function IsReadable(value)
	return value ~= nil and E:NotSecretValue(value)
end

-- Class token of a player unit, nil for NPCs and unreadable units
local function GetPlayerClass(unit)
	local isPlayer = UnitIsPlayer(unit) or (UnitInPartyIsAI and UnitInPartyIsAI(unit))
	if IsReadable(isPlayer) and isPlayer then
		local _, class = UnitClass(unit)
		if IsReadable(class) then
			return class
		end
	end
end

local function GetReaction(unit)
	local reaction = UnitReaction(unit, "player")
	if IsReadable(reaction) then
		return reaction
	end
end

local function GetUnitColor(unit)
	local db = E.db.mui.unitframes.portraits
	local custom = db.customColor
	if db.colorMode == "CUSTOM" then
		return custom.r, custom.g, custom.b
	end

	local class = GetPlayerClass(unit)
	local color = class and E:ClassColor(class)
	if color then
		return color.r, color.g, color.b
	end

	local reaction = GetReaction(unit)
	color = reaction and ElvUF.colors.reaction[reaction]
	if color then
		return color.r, color.g, color.b
	end

	return custom.r, custom.g, custom.b
end

-- The Theme's gradient colors of the unit, picked like the gradient health bars do
local function GetGradientColors(unit)
	local colorMap, entry
	local class = GetPlayerClass(unit)
	if class then
		colorMap, entry = "classColorMap", class
	else
		local reaction = GetReaction(unit)
		if not reaction then
			return
		end
		colorMap = "reactionColorMap"
		entry = (reaction > 4 and "GOOD") or (reaction > 3 and "NEUTRAL") or "BAD"
	end

	local map = F.Color.GetMap(colorMap)
	if not map then
		F.Color.GenerateCache()
		map = F.Color.GetMap(colorMap)
	end

	local shift = map and map[GRADIENT_COLOR.SHIFT] and map[GRADIENT_COLOR.SHIFT][entry]
	local normal = map and map[GRADIENT_COLOR.NORMAL] and map[GRADIENT_COLOR.NORMAL][entry]
	if shift and normal then
		return shift, normal
	end
end

-- The unit's color on a texture: solid, or the Theme gradient
local function ApplyUnitColor(element, texture, unit)
	if E.db.mui.unitframes.portraits.colorMode == "GRADIENT" then
		local shift, normal = GetGradientColors(unit)
		if shift then
			-- The darker side points away from the unitframe, the bar continues the lighter one
			if element.mirror then
				F.Color.SetGradient(texture, "HORIZONTAL", normal, shift)
			else
				F.Color.SetGradient(texture, "HORIZONTAL", shift, normal)
			end
			return
		end
	end

	texture:SetVertexColor(GetUnitColor(unit))
end

-- Ring (and a unit colored dragon) of a unit that is not dead or offline, also used by the options preview
function module:ColorPortraitRing(element, unit)
	local db = E.db.mui.unitframes.portraits.classification
	local kind = element.classificationKind

	if kind and db.style == "RING" then
		local color = db.colors[kind]
		element.ring:SetVertexColor(color.r, color.g, color.b)
	else
		ApplyUnitColor(element, element.ring, unit)
	end

	if kind and db.style == "DRAGON" and db.dragonColor == "UNIT" then
		ApplyUnitColor(element, element.dragon, unit)
	end
end

-- boss, elite, rareelite or rare, nil for everything else
local function GetClassification(unit)
	local isBoss = UnitIsBossMob and UnitIsBossMob(unit)
	if IsReadable(isBoss) and isBoss then
		return "boss"
	end

	local classification = UnitClassification(unit)
	if not IsReadable(classification) then
		return
	end

	if classification == "worldboss" then
		return "boss"
	elseif BADGE_ATLAS[classification] then
		return classification
	end
end

local function StyleDragon(element, kind, db)
	local dragon = DRAGON[kind]
	local texture = element.dragon
	local geometry = dragon.geometry

	texture:SetAtlas(dragon.atlas)
	if not element.mirror then
		local info = C_Texture.GetAtlasInfo(dragon.atlas)
		if info then
			texture:SetTexCoord(info.rightTexCoord, info.leftTexCoord, info.topTexCoord, info.bottomTexCoord)
		end
	end

	if db.dragonOnTop then
		texture:SetDrawLayer("OVERLAY", 1)
	else
		texture:SetDrawLayer("BACKGROUND", 0)
	end

	local scale = element.size * db.dragonScale
	texture:SetSize(geometry.width * scale, geometry.height * scale)
	texture:ClearAllPoints()
	texture:SetPoint("CENTER", element, "CENTER", geometry.x * scale * (element.mirror and 1 or -1), geometry.y * scale)

	if db.dragonColor == "BLIZZARD" then
		texture:SetDesaturated(false)
		texture:SetVertexColor(1, 1, 1)
	else
		-- Grey art takes the tint, the unit color is applied with the ring
		texture:SetDesaturated(true)
		if db.dragonColor == "CLASSIFICATION" then
			local color = db.colors[kind]
			texture:SetVertexColor(color.r, color.g, color.b)
		end
	end

	texture:Show()
end

local function StyleBadge(element, kind, db)
	local badge = element.badge
	badge:SetAtlas(BADGE_ATLAS[kind])
	badge:SetSize(db.badgeSize, db.badgeSize)
	badge:ClearAllPoints()

	-- The top corner away from the unitframe, the offset points inwards on both sides
	if element.mirror then
		badge:SetPoint("CENTER", element, "TOPRIGHT", -db.badgeXOffset, db.badgeYOffset)
	else
		badge:SetPoint("CENTER", element, "TOPLEFT", db.badgeXOffset, db.badgeYOffset)
	end

	badge:Show()
end

-- Shows the classification of kind (see GetClassification), also used by the options preview.
-- The ring color follows with the next ColorPortraitRing.
function module:ApplyClassification(element, kind)
	local db = E.db.mui.unitframes.portraits.classification

	element.badge:Hide()
	element.dragon:Hide()

	if not (kind and db.enable and db.types[kind]) then
		element.classificationKind = nil
		return
	end

	element.classificationKind = kind
	if db.style == "DRAGON" then
		StyleDragon(element, kind, db)
	elseif db.style == "BADGE" then
		StyleBadge(element, kind, db)
	end
end

-- Dead, ghost or offline: the portrait turns grey
local function IsInactive(unit)
	local dead = UnitIsDeadOrGhost(unit)
	if IsReadable(dead) and dead then
		return true
	end

	local connected = UnitIsConnected(unit)
	return IsReadable(connected) and not connected
end

local function GetCastTexture(unit)
	local _, _, texture = UnitCastingInfo(unit)
	if not texture then
		_, _, texture = UnitChannelInfo(unit)
	end
	return texture
end

local function SetCoords(element, inset)
	local left, right = inset, 1 - inset
	if element.mirror then
		left, right = right, left
	end
	element.portrait:SetTexCoord(left, right, inset, 1 - inset)
end

local function UpdateImage(element, unit)
	local texture = element.cast and GetCastTexture(unit)
	if texture then
		element.portrait:SetTexture(texture)
		SetCoords(element, ICON_INSET)
	else
		SetPortraitTexture(element.portrait, unit, true)
		SetCoords(element, 0)
	end
end

local function UpdateState(element, unit)
	local inactive = IsInactive(unit)
	element.inactive = inactive

	if inactive then
		element.ring:SetVertexColor(INACTIVE_COLOR, INACTIVE_COLOR, INACTIVE_COLOR)
	else
		module:ColorPortraitRing(element, unit)
	end
	element.portrait:SetDesaturated(inactive)
end

local function Update(self, event, unit)
	if unit and unit ~= self.__unit then
		return
	end

	local element = self.MER_Portrait
	unit = self.__unit

	if element.PreUpdate then
		element:PreUpdate(unit)
	end

	UpdateImage(element, unit)
	-- Before the state, the ring may take the classification color
	module:ApplyClassification(element, GetClassification(unit))
	UpdateState(element, unit)

	if element.PostUpdate then
		return element:PostUpdate(unit)
	end
end

local function Path(self, ...)
	return (self.MER_Portrait.Override or Update)(self, ...)
end

-- The events below only touch their own part, the health event fires a lot
local function ImageEvent(self, _, unit)
	if unit == self.__unit then
		UpdateImage(self.MER_Portrait, unit)
	end
end

local function StateEvent(self, _, unit)
	if unit ~= self.__unit then
		return
	end

	local element = self.MER_Portrait
	if IsInactive(unit) ~= element.inactive then
		UpdateState(element, unit)
	end
end

local function ColorEvent(self, _, unit)
	if unit == self.__unit then
		UpdateState(self.MER_Portrait, unit)
	end
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

-- Cast events only while the spell icon is wanted
local function SetCastEvents(self, enable)
	local element = self.MER_Portrait
	enable = enable and true or false
	if (element.castEvents or false) == enable then
		return
	end

	for _, event in ipairs(CAST_EVENTS) do
		if enable then
			self:RegisterEvent(event, ImageEvent)
		else
			self:UnregisterEvent(event, ImageEvent)
		end
	end
	element.castEvents = enable
end

local function Enable(self)
	local element = self.MER_Portrait
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_PORTRAIT_UPDATE", ImageEvent)
		self:RegisterEvent("UNIT_MODEL_CHANGED", ImageEvent)
		self:RegisterEvent("UNIT_HEALTH", StateEvent)
		self:RegisterEvent("UNIT_CONNECTION", ColorEvent)
		self:RegisterEvent("UNIT_FACTION", ColorEvent)
		SetCastEvents(self, element.cast)

		element:Show()

		return true
	end
end

local function Disable(self)
	local element = self.MER_Portrait
	if element then
		element:Hide()

		self:UnregisterEvent("UNIT_PORTRAIT_UPDATE", ImageEvent)
		self:UnregisterEvent("UNIT_MODEL_CHANGED", ImageEvent)
		self:UnregisterEvent("UNIT_HEALTH", StateEvent)
		self:UnregisterEvent("UNIT_CONNECTION", ColorEvent)
		self:UnregisterEvent("UNIT_FACTION", ColorEvent)
		SetCastEvents(self, false)
	end
end

ElvUF:AddElement("MER_Portrait", Path, Enable, Disable)

-- Builds the regions of a portrait, also used by the options preview
function module:CreatePortrait(parent)
	local element = CreateFrame("Frame", nil, parent)

	-- The texture files are bigger than the shape, see CANVAS
	element.canvas = CreateFrame("Frame", nil, element)
	element.canvas:SetPoint("CENTER")

	element.shadow = element.canvas:CreateTexture(nil, "BACKGROUND", nil, -1)
	element.shadow:SetAllPoints(element.canvas)

	element.mask = element.canvas:CreateMaskTexture()
	element.mask:SetAllPoints(element.canvas)

	element.bg = element.canvas:CreateTexture(nil, "BACKGROUND", nil, 1)
	element.bg:SetAllPoints(element)
	element.bg:SetTexture(E.media.blankTex)
	element.bg:AddMaskTexture(element.mask)

	element.portrait = element.canvas:CreateTexture(nil, "ARTWORK")
	element.portrait:SetAllPoints(element)
	element.portrait:AddMaskTexture(element.mask)

	element.inner = element.canvas:CreateTexture(nil, "ARTWORK", nil, 1)
	element.inner:SetAllPoints(element.canvas)

	element.ring = element.canvas:CreateTexture(nil, "OVERLAY")
	element.ring:SetAllPoints(element.canvas)

	-- Draw layer set by the classification settings
	element.dragon = element.canvas:CreateTexture(nil, "OVERLAY", nil, 1)
	element.dragon:Hide()

	element.badge = element.canvas:CreateTexture(nil, "OVERLAY", nil, 2)
	element.badge:Hide()

	return element
end

-- Size, shape and the static colors, shared with the options preview
function module:StylePortrait(element, size, mirror)
	local db = E.db.mui.unitframes.portraits
	local style = (mirror and MIRRORED_STYLES[db.style]) or db.style
	local textures = I.Media.Textures.Portraits

	element:SetSize(size, size)
	element.canvas:SetSize(size * CANVAS, size * CANVAS)
	element.size = size
	element.mirror = mirror

	element.mask:SetTexture(textures[style .. "Mask"], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	element.ring:SetTexture(textures[style .. "Ring"])
	element.inner:SetTexture(textures[style .. "Inner"])
	element.inner:SetShown(db.innerShadow)
	element.shadow:SetTexture(textures[style .. "Shadow"])
	element.shadow:SetAlpha(db.shadowAlpha)
	element.shadow:SetShown(db.shadow)

	local bg = db.backgroundColor
	element.bg:SetVertexColor(bg.r, bg.g, bg.b, 1)
end

-- unitframeType to the option key, the group frames share one
local UNITS = {
	player = "player",
	target = "target",
	focus = "focus",
	targettarget = "targettarget",
	pet = "pet",
	party = "party",
	boss = "boss",
	arena = "arena",
}

function module:Configure_Portrait(frame)
	local unit = frame and UNITS[frame.unitframeType]
	if not unit then
		return
	end

	local db = E.db.mui.unitframes.portraits
	local unitDb = db.enable and db.units[unit]

	if not (unitDb and unitDb.enable) then
		if frame.MER_Portrait and frame:IsElementEnabled("MER_Portrait") then
			frame:DisableElement("MER_Portrait")
		end
		return
	end

	local element = frame.MER_Portrait
	if not element then
		element = module:CreatePortrait(frame)
		frame.MER_Portrait = element
	end

	-- Above the unitframe's own layers, ElvUI raises some elements over the health bar
	element:SetFrameStrata(frame:GetFrameStrata())
	element:SetFrameLevel(frame:GetFrameLevel() + 20)

	module:StylePortrait(element, unitDb.size, unitDb.mirror)
	element:ClearAllPoints()
	element:Point(unitDb.point, frame, unitDb.relativePoint, unitDb.xOffset, unitDb.yOffset)

	element.cast = unitDb.cast

	if frame:IsElementEnabled("MER_Portrait") then
		SetCastEvents(frame, element.cast)
	else
		frame:EnableElement("MER_Portrait")
	end

	element:ForceUpdate()
end

-- oUF keeps every spawned frame, the group headers' children included
function module:UpdatePortraits()
	for _, frame in ipairs(ElvUF.objects) do
		module:Configure_Portrait(frame)
	end
end

local FRAME_UPDATES = {
	"Update_PlayerFrame",
	"Update_TargetFrame",
	"Update_TargetTargetFrame",
	"Update_FocusFrame",
	"Update_PetFrame",
	"Update_PartyFrames",
	"Update_BossFrames",
	"Update_ArenaFrames",
}

function module:Portraits()
	local function Configure(_, frame)
		module:Configure_Portrait(frame)
	end
	for _, update in ipairs(FRAME_UPDATES) do
		if UF[update] then
			hooksecurefunc(UF, update, Configure)
		end
	end

	-- Edited Theme colors rebuild the color cache, the gradient rings follow
	local Theme = MER:GetModule("MER_Theme", true)
	if Theme and Theme.SettingsUpdate then
		hooksecurefunc(Theme, "SettingsUpdate", function()
			if E.db.mui.unitframes.portraits.colorMode == "GRADIENT" then
				module:UpdatePortraits()
			end
		end)
	end

	-- ElvUI spawns its frames before our hooks exist
	module:UpdatePortraits()
end
