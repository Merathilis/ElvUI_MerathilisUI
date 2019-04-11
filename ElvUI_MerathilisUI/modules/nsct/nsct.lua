local MER, E, L, V, P, G = unpack(select(2, ...))
local SCT = MER:NewModule("ScrollingCombatText", "AceEvent-3.0", "AceTimer-3.0");
local LibEasing = LibStub("LibEasing-1.0");
local LSM = E.LSM or E.Libs.LSM
SCT.modName = L["Combat Text"]

-- Cache global variables
-- Lua functions
local next, pairs, tostring = next, pairs, tostring
local tinsert, tremove = table.insert, table.remove
local pow, random = math.pow, math.random
local strfind, format = string.find, string.format
local band = bit.band
-- WoW API / Variables
local CreateFrame = CreateFrame
local UIParent = UIParent
local C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local C_Timer_NewTimer = C_Timer.NewTimer
local C_Timer_NewTicker = C_Timer.NewTicker
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local IsAddOnLoaded = IsAddOnLoaded
local UnitGUID = UnitGUID
local UnitIsDead = UnitIsDead
local UnitIsUnit = UnitIsUnit
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

-- CREDIT: Mpstark (-Nameplata Scrolling Combat Text)

SCT.frame = CreateFrame("Frame", nil, UIParent);

------------
-- LOCALS --
------------
local _;
local animating = {};

local playerGUID;
local unitToGuid = {};
local guidToUnit = {};

local targetFrames = {};
for level = 1, 3 do
	targetFrames[level] = CreateFrame("Frame", nil, UIParent);
end

local offTargetFrames = {};
for level = 1, 3 do
	offTargetFrames[level] = CreateFrame("Frame", nil, UIParent);
end

---------------------
-- LOCAL CONSTANTS --
---------------------
local SMALL_HIT_EXPIRY_WINDOW = 30;
local SMALL_HIT_MULTIPIER = 0.5;

local ANIMATION_VERTICAL_DISTANCE = 75;

local ANIMATION_ARC_X_MIN = 50;
local ANIMATION_ARC_X_MAX = 150;
local ANIMATION_ARC_Y_TOP_MIN = 10;
local ANIMATION_ARC_Y_TOP_MAX = 50;
local ANIMATION_ARC_Y_BOTTOM_MIN = 10;
local ANIMATION_ARC_Y_BOTTOM_MAX = 50;

-- local ANIMATION_SHAKE_DEFLECTION = 15;
-- local ANIMATION_SHAKE_NUM_SHAKES = 4;

local ANIMATION_RAINFALL_X_MAX = 75;
local ANIMATION_RAINFALL_Y_MIN = 50;
local ANIMATION_RAINFALL_Y_MAX = 100;
local ANIMATION_RAINFALL_Y_START_MIN = 5
local ANIMATION_RAINFALL_Y_START_MAX = 15;

local ANIMATION_LENGTH = 1;

local DAMAGE_TYPE_COLORS = {
	[SCHOOL_MASK_PHYSICAL] = "FFFF00",
	[SCHOOL_MASK_HOLY] = "FFE680",
	[SCHOOL_MASK_FIRE] = "FF8000",
	[SCHOOL_MASK_NATURE] = "4DFF4D",
	[SCHOOL_MASK_FROST] = "80FFFF",
	[SCHOOL_MASK_SHADOW] = "8080FF",
	[SCHOOL_MASK_ARCANE] = "FF80FF",
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW] = "A330C9", -- Chromatic
	[SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY] = "A330C9", -- Magic
	[SCHOOL_MASK_PHYSICAL + SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_ARCANE + SCHOOL_MASK_NATURE + SCHOOL_MASK_SHADOW + SCHOOL_MASK_HOLY] = "A330C9", -- Chaos
	["melee"] = "FFFFFF",
	["pet"] = "CC8400"
};

local MISS_EVENT_STRINGS = {
	["ABSORB"] = "Absorbed",
	["BLOCK"] = "Blocked",
	["DEFLECT"] = "Deflected",
	["DODGE"] = "Dodged",
	["EVADE"] = "Evaded",
	["IMMUNE"] = "Immune",
	["MISS"] = "Missed",
	["PARRY"] = "Parried",
	["REFLECT"] = "Reflected",
	["RESIST"] = "Resisted",
};

local FRAME_LEVEL_OVERLAY = 3;
local FRAME_LEVEL_ABOVE = 2;
local FRAME_LEVEL_BELOW = 1;


----------------
-- FONTSTRING --
----------------
local function getFontPath(fontName)
	local fontPath = LSM:Fetch("font", fontName);

	if (fontPath == nil) then
		fontPath = "Fonts\\FRIZQT__.TTF";
	end

	return fontPath;
end

local fontStringCache = {};
local function getFontString()
	local db = E.db.mui.nsct
	local fontString;

	if (next(fontStringCache)) then
		fontString = tremove(fontStringCache);
	else
		fontString = SCT.frame:CreateFontString();
	end

	fontString:SetParent(SCT.frame);
	fontString:FontTemplate(getFontPath(db.font), 15, db.fontFlag);
	if db.textShadow then fontString:SetShadowOffset(1,-1) end
	fontString:SetAlpha(1);
	fontString:SetDrawLayer("OVERLAY");
	fontString:SetText("");
	fontString:Show();

	return fontString;
end

local function recycleFontString(fontString)
	local db = E.db.mui.nsct
	fontString:SetAlpha(0);
	fontString:Hide();

	animating[fontString] = nil;

	fontString.distance = nil;
	fontString.arcTop = nil;
	fontString.arcBottom = nil;
	fontString.arcXDist = nil;
	fontString.deflection = nil;
	fontString.numShakes = nil;
	fontString.animation = nil;
	fontString.animatingDuration = nil;
	fontString.animatingStartTime = nil;
	fontString.anchorFrame = nil;

	fontString.unit = nil;
	fontString.guid = nil;

	fontString.pow = nil;
	fontString.startHeight = nil;
	fontString.NSCTFontSize = nil;
	fontString:FontTemplate(getFontPath(db.font), 15, db.fontFlag);
	if db.textShadow then fontString:SetShadowOffset(1,-1) end
	fontString:SetParent(SCT.frame);

	tinsert(fontStringCache, fontString);
end

----------------
-- NAMEPLATES --
----------------
local nameplatePositionTicker;
local guidNameplatePositionX = {}; -- why two tables? Because creating tables creates garbage, at least that's the idea
local guidNameplatePositionY = {};
local function saveNameplatePositions_Awful()
	-- look, this isn't a good way of doing this, but it's quick and easy and I don't
	-- understand why GetCenter of the nameplate isn't actually where it is and why I can't
	-- figure out how to scale it properly with GetEffectiveScale or whatever
	local fontString = getFontString();

	for unit, guid in pairs(unitToGuid) do
		local nameplate = C_NamePlate_GetNamePlateForUnit(unit);
		if (nameplate and not UnitIsDead(unit) and nameplate:IsShown()) then
			fontString:SetPoint("CENTER", nameplate, "CENTER", 0, 0);
			guidNameplatePositionX[guid], guidNameplatePositionY[guid] = fontString:GetCenter();
		end
	end

	recycleFontString(fontString);
end

local function startSavingNameplatePositions()
	if (not nameplatePositionTicker) then
		nameplatePositionTicker =  C_Timer_NewTicker(1/10, saveNameplatePositions_Awful);
	end
end

local function stopSavingNameplatePositions()
	nameplatePositionTicker:Cancel();
	nameplatePositionTicker = nil;
end

local function setNameplateFrameLevels()
	for _, frame in pairs(targetFrames) do
		frame:SetFrameStrata("LOW");
	end
	targetFrames[FRAME_LEVEL_OVERLAY]:SetFrameLevel(1001);
	targetFrames[FRAME_LEVEL_ABOVE]:SetFrameLevel(1000);
	targetFrames[FRAME_LEVEL_BELOW]:SetFrameLevel(999);

	for _, frame in pairs(offTargetFrames) do
		frame:SetFrameStrata("LOW");
	end
	offTargetFrames[FRAME_LEVEL_OVERLAY]:SetFrameLevel(901);
	offTargetFrames[FRAME_LEVEL_ABOVE]:SetFrameLevel(900);
	offTargetFrames[FRAME_LEVEL_BELOW]:SetFrameLevel(899);
end

---------------
-- ANIMATION --
---------------
local function verticalPath(elapsed, duration, distance)
	return 0, LibEasing.InQuad(elapsed, 0, distance, duration);
end

local function arcPath(elapsed, duration, xDist, yStart, yTop, yBottom)
	local x, y;
	local progress = elapsed/duration;

	x = progress * xDist;

	local a = -2 * yStart + 4 * yTop - 2 * yBottom;
	local b = -3 * yStart + 4 * yTop - yBottom;

	y = -a * pow(progress, 2) + b * progress + yStart;

	return x, y;
end

local function powSizing(elapsed, duration, start, middle, finish)
	local size = finish;
	if (elapsed < duration) then
		if (elapsed/duration < 0.5) then
			size = LibEasing.OutQuint(elapsed, start, middle - start, duration/2);
		else
			size = LibEasing.InQuint(elapsed - elapsed/2, middle, finish - middle, duration/2);
		end
	end
	return size;
end

local function AnimationOnUpdate()
	if (next(animating)) then

		for fontString, _ in pairs(animating) do
			local elapsed = GetTime() - fontString.animatingStartTime;
			if (elapsed > fontString.animatingDuration) then
				-- the animation is over
				recycleFontString(fontString);
			else
				local isTarget = false
				if fontString.unit then
				  isTarget = UnitIsUnit(fontString.unit, "target");
				else
				  fontString.unit = "player"
				end
				-- frame level
				if (fontString.frameLevel) then
					if (isTarget) then
						if (fontString:GetParent() ~= targetFrames[fontString.frameLevel]) then
							fontString:SetParent(targetFrames[fontString.frameLevel])
						end
					else
						if (fontString:GetParent() ~= offTargetFrames[fontString.frameLevel]) then
							fontString:SetParent(offTargetFrames[fontString.frameLevel])
						end
					end
				end

				-- alpha
				local startAlpha = SCT.db.formatting.alpha;
				if (SCT.db.useOffTarget and not isTarget and fontString.unit ~= "player") then
					startAlpha = SCT.db.offTargetFormatting.alpha;
				end

				local alpha = LibEasing.InExpo(elapsed, startAlpha, -startAlpha, fontString.animatingDuration);
				fontString:SetAlpha(alpha);

				-- sizing
				if (fontString.pow) then
					if (elapsed < fontString.animatingDuration/6) then
						fontString:SetText(fontString.NSCTTextWithoutIcons);

						local size = powSizing(elapsed, fontString.animatingDuration/6, fontString.startHeight/2, fontString.startHeight*2, fontString.startHeight);
						fontString:SetTextHeight(size);
					else
						fontString.pow = nil;
						fontString:SetTextHeight(fontString.startHeight);
						fontString:FontTemplate(getFontPath(SCT.db.font), fontString.NSCTFontSize, SCT.db.fontFlag);
						if SCT.db.textShadow then fontString:SetShadowOffset(1,-1) end
						fontString:SetText(fontString.NSCTText);
					end
				end

				-- position
				local xOffset, yOffset = 0, 0;
				if (fontString.animation == "verticalUp") then
					xOffset, yOffset = verticalPath(elapsed, fontString.animatingDuration, fontString.distance);
				elseif (fontString.animation == "verticalDown") then
					xOffset, yOffset = verticalPath(elapsed, fontString.animatingDuration, -fontString.distance);
				elseif (fontString.animation == "fountain") then
					xOffset, yOffset = arcPath(elapsed, fontString.animatingDuration, fontString.arcXDist, 0, fontString.arcTop, fontString.arcBottom);
				elseif (fontString.animation == "rainfall") then
					_, yOffset = verticalPath(elapsed, fontString.animatingDuration, -fontString.distance);
					xOffset = fontString.rainfallX;
					yOffset = yOffset + fontString.rainfallStartY;
				-- elseif (fontString.animation == "shake") then
					-- TODO
				end

				if (not UnitIsDead(fontString.unit) and fontString.anchorFrame and fontString.anchorFrame:IsShown()) then
					if fontString.unit == "player" then -- player frame
					  fontString:SetPoint("CENTER", fontString.anchorFrame, "CENTER", SCT.db.xOffsetPersonal + xOffset, SCT.db.yOffsetPersonal + yOffset); -- Only allows for adjusting vertical offset
					else -- nameplate frames
					  fontString:SetPoint("CENTER", fontString.anchorFrame, "CENTER", SCT.db.xOffset + xOffset, SCT.db.yOffset + yOffset);
					end
					-- remember the last position of the nameplate
					local x, y = fontString:GetCenter();
					guidNameplatePositionX[fontString.guid] = x - (SCT.db.xOffset + xOffset);
					guidNameplatePositionY[fontString.guid] = y - (SCT.db.yOffset + yOffset);
				elseif (guidNameplatePositionX[fontString.guid] and guidNameplatePositionY[fontString.guid]) then
					fontString.anchorFrame = nil;
					fontString:ClearAllPoints();
					fontString:SetPoint("CENTER", UIParent, "BOTTOMLEFT", guidNameplatePositionX[fontString.guid] + SCT.db.xOffset + xOffset, guidNameplatePositionY[fontString.guid] + SCT.db.yOffset + yOffset);
				else
					recycleFontString(fontString);
				end
			end
		end
	else
		-- nothing in the animation list, so just kill the onupdate
		SCT.frame:SetScript("OnUpdate", nil);
	end
end

-- SCT.AnimationOnUpdate = AnimationOnUpdate;

local arcDirection = 1;
function SCT:Animate(fontString, anchorFrame, duration, animation)
	animation = animation or "verticalUp";

	fontString.animation = animation;
	fontString.animatingDuration = duration;
	fontString.animatingStartTime = GetTime();
	fontString.anchorFrame = anchorFrame == player and UIParent or anchorFrame;

	if (animation == "verticalUp") then
		fontString.distance = ANIMATION_VERTICAL_DISTANCE;
	elseif (animation == "verticalDown") then
		fontString.distance = ANIMATION_VERTICAL_DISTANCE;
	elseif (animation == "fountain") then
		fontString.arcTop = random(ANIMATION_ARC_Y_TOP_MIN, ANIMATION_ARC_Y_TOP_MAX);
		fontString.arcBottom = -random(ANIMATION_ARC_Y_BOTTOM_MIN, ANIMATION_ARC_Y_BOTTOM_MAX);
		fontString.arcXDist = arcDirection * random(ANIMATION_ARC_X_MIN, ANIMATION_ARC_X_MAX);

		arcDirection = arcDirection * -1;
	elseif (animation == "rainfall") then
		fontString.distance = random(ANIMATION_RAINFALL_Y_MIN, ANIMATION_RAINFALL_Y_MAX);
		fontString.rainfallX = random(-ANIMATION_RAINFALL_X_MAX, ANIMATION_RAINFALL_X_MAX);
		fontString.rainfallStartY = -random(ANIMATION_RAINFALL_Y_START_MIN, ANIMATION_RAINFALL_Y_START_MAX);
	end

	animating[fontString] = true;

	-- start onupdate if it's not already running
	if (SCT.frame:GetScript("OnUpdate") == nil) then
		SCT.frame:SetScript("OnUpdate", AnimationOnUpdate);
	end
end

------------
-- EVENTS --
------------
local guidDeletion = {};
local function scheduleGUIDNameplatePositionWipe(guid)
	local deleteGUIDLocation = function()
		guidNameplatePositionX[guid] = nil;
		guidNameplatePositionY[guid] = nil;
	end

	guidDeletion[guid] = C_Timer_NewTimer(1, deleteGUIDLocation);
end

function SCT:NAME_PLATE_UNIT_ADDED(event, unitID)
	local guid = UnitGUID(unitID);

	unitToGuid[unitID] = guid;
	guidToUnit[guid] = unitID;

	if (guidDeletion[guid]) then
		guidDeletion[guid]:Cancel();
	end

	guidNameplatePositionX[guid] = nil;
	guidNameplatePositionY[guid] = nil;

	startSavingNameplatePositions();
end

function SCT:NAME_PLATE_UNIT_REMOVED(event, unitID)
	local guid = unitToGuid[unitID];

	unitToGuid[unitID] = nil;
	guidToUnit[guid] = nil;

	scheduleGUIDNameplatePositionWipe(guid);

	-- stop saving positions if there are no nameplates
	if (not next(guidToUnit)) then
		stopSavingNameplatePositions();
	end
end

function SCT:CombatFilter(_, clue, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _, ...)
	local db = E.db.mui.nsct
	if playerGUID == sourceGUID or (db.personal and playerGUID == destGUID) then -- Player events
		local destUnit = guidToUnit[destGUID];
		if (destUnit) or (destGUID == playerGUID and db.personal) then
			if (strfind(clue, "_DAMAGE")) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (strfind(clue, "SWING")) then
					spellName, amount, overkill, school_ignore, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = "melee", ...;
				elseif (strfind(clue, "ENVIRONMENTAL")) then
					spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...;
				else
					spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = ...;
				end
				self:DamageEvent(destGUID, spellID, amount, school, critical, spellName);
			elseif(strfind(clue, "_MISSED")) then
				local spellID, spellName, spellSchool, missType, isOffHand, amountMissed;

				if (strfind(clue, "SWING")) then
					if destGUID == playerGUID then
					  missType, isOffHand, amountMissed = ...;
					else
					  missType, isOffHand, amountMissed = "melee", ...;
					end
				else
					spellID, spellName, spellSchool, missType, isOffHand, amountMissed = ...;
				end
				self:MissEvent(destGUID, spellID, missType);
			end
		end
	elseif (band(sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 or band(sourceFlags, COMBATLOG_OBJECT_TYPE_PET) > 0)	and band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then -- Pet/Guardian events
		local destUnit = guidToUnit[destGUID];
		if (destUnit) or (destGUID == playerGUID and db.personal) then
			if (strfind(clue, "_DAMAGE")) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (strfind(clue, "SWING")) then
					spellName, amount, overkill, school_ignore, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = "pet", ...;
				elseif (strfind(clue, "ENVIRONMENTAL")) then
					spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...;
				else
					spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = ...;
				end
				self:DamageEvent(destGUID, spellID, amount, "pet", critical, spellName);
			end
		end
	end
end

function SCT:COMBAT_LOG_EVENT_UNFILTERED ()
	return SCT:CombatFilter(CombatLogGetCurrentEventInfo())
end

-------------
-- DISPLAY --
-------------
local function commaSeperate(number)
	-- https://stackoverflow.com/questions/10989788/lua-format-integer
	local _, _, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)');
	int = int:reverse():gsub("(%d%d%d)", "%1,");
	return minus..int:reverse():gsub("^,", "")..fraction;
end

local numDamageEvents = 0;
local lastDamageEventTime;
local runningAverageDamageEvents = 0;
function SCT:DamageEvent(guid, spellID, amount, school, crit, spellName)
	local text, textWithoutIcons, animation, pow, size, icon, alpha;
	local frameLevel = FRAME_LEVEL_ABOVE;

	local unit = guidToUnit[guid];
	local isTarget = unit and UnitIsUnit(unit, "target");

	if (self.db.useOffTarget and not isTarget and playerGUID ~= guid) then
		size = self.db.offTargetFormatting.size;
		icon = self.db.offTargetFormatting.icon;
		alpha = self.db.offTargetFormatting.alpha;
	else
		size = self.db.formatting.size;
		icon = self.db.formatting.icon;
		alpha = self.db.formatting.alpha;
	end

	-- select an animation
	if (crit) then
		frameLevel = FRAME_LEVEL_OVERLAY;
		animation = guid ~= playerGUID and self.db.animations.crit or self.db.animationsPersonal.crit;
		pow = true;
	else
		animation = guid ~= playerGUID and self.db.animations.normal or self.db.animationsPersonal.normal;
		pow = false;
	end

	if (icon ~= "only") then
		-- truncate
		if (self.db.truncate and amount >= 1000000 and self.db.truncateLetter) then
			text = format("%.1fM", amount / 1000000);
		elseif (self.db.truncate and amount >= 10000) then
			text = format("%.0f", amount / 1000);

			if (self.db.truncateLetter) then
				text = text.."k";
			end
		elseif (self.db.truncate and amount >= 1000) then
			text = format("%.1f", amount / 1000);

			if (self.db.truncateLetter) then
				text = text.."k";
			end
		else
			if (self.db.commaSeperate) then
				text = commaSeperate(amount);
			else
				text = tostring(amount);
			end
		end

		-- color text
		if self.db.damageColor and school and DAMAGE_TYPE_COLORS[school] then
			text = "|Cff"..DAMAGE_TYPE_COLORS[school]..text.."|r";
		elseif self.db.damageColor and spellName == "melee" and DAMAGE_TYPE_COLORS[spellName] then
			text = "|Cff"..DAMAGE_TYPE_COLORS[spellName]..text.."|r";
		else
			text = "|Cff"..self.db.defaultColor..text.."|r";
		end

		-- add icons
		textWithoutIcons = text;
		if (icon ~= "none" and spellID) then
			local iconText = "|T"..GetSpellTexture(spellID)..":14:14:0:0:64:64:4:60:4:60|t";

			if (icon == "both") then
				text = iconText..text..iconText;
			elseif (icon == "left") then
				text = iconText..text;
			elseif (icon == "right") then
				text = text..iconText;
			end
		end
	else
		-- showing only icons
		if (not spellID) then
			return;
		end

		text = "|T"..GetSpellTexture(spellID)..":14:14:0:0:64:64:4:60:4:60|t";
		textWithoutIcons = text; -- since the icon is by itself, the fontString won't have the strange scaling bug
	end

	-- shrink small hits
	if (self.db.sizing.smallHits) and playerGUID ~= guid then
		if (not lastDamageEventTime or (lastDamageEventTime + SMALL_HIT_EXPIRY_WINDOW < GetTime())) then
			numDamageEvents = 0;
			runningAverageDamageEvents = 0;
		end

		runningAverageDamageEvents = ((runningAverageDamageEvents*numDamageEvents) + amount)/(numDamageEvents + 1);
		numDamageEvents = numDamageEvents + 1;
		lastDamageEventTime = GetTime();

		if ((not crit and amount < SMALL_HIT_MULTIPIER*runningAverageDamageEvents)
			or (crit and amount/2 < SMALL_HIT_MULTIPIER*runningAverageDamageEvents)) then
			size = size * self.db.sizing.smallHitsScale;
		end
	end

	-- embiggen crit's size
	if (self.db.sizing.crits and crit) and playerGUID ~= guid then
		size = size * self.db.sizing.critsScale;
	end

	-- make sure that size is larger than 5
	if (size < 5) then
		size = 5;
	end

	self:DisplayText(guid, text, textWithoutIcons, size, animation, frameLevel, pow);
end

function SCT:MissEvent(guid, spellID, missType)
	local text, animation, pow, size, icon, alpha;
	local unit = guidToUnit[guid];
	local isTarget = unit and UnitIsUnit(unit, "target");

	if (self.db.useOffTarget and not isTarget and playerGUID ~= guid) then
		size = self.db.offTargetFormatting.size;
		icon = self.db.offTargetFormatting.icon;
		alpha = self.db.offTargetFormatting.alpha;
	else
		size = self.db.formatting.size;
		icon = self.db.formatting.icon;
		alpha = self.db.formatting.alpha;
	end

	-- embiggen miss size
	if self.db.sizing.miss and playerGUID ~= guid then
		size = size * self.db.sizing.missScale;
	end

	if (icon == "only") then
		return;
	end

	animation = playerGUID ~= guid and self.db.animations.miss or self.db.animationsPersonal.miss;
	pow = true;

	text = MISS_EVENT_STRINGS[missType] or "Missed";
	text = "|Cff"..self.db.defaultColor..text.."|r";

	-- add icons
	local textWithoutIcons = text;
	if (icon ~= "none" and spellID) then
		local iconText = "|T"..GetSpellTexture(spellID)..":0|t";

		if (icon == "both") then
			text = iconText..text..iconText;
		elseif (icon == "left") then
			text = iconText..text;
		elseif (icon == "right") then
			text = text..iconText;
		end
	end

	self:DisplayText(guid, text, textWithoutIcons, size, animation, FRAME_LEVEL_ABOVE, pow)
end

function SCT:DisplayText(guid, text, textWithoutIcons, size, animation, frameLevel, pow)
	local db = E.db.mui.nsct
	local fontString;
	local unit = guidToUnit[guid];
	local nameplate;

	if (unit) then
		nameplate = C_NamePlate_GetNamePlateForUnit(unit);
	end

	-- if there isn't an anchor frame, make sure that there is a guidNameplatePosition cache entry
	if playerGUID == guid and not unit then
		  nameplate = player
	elseif (not nameplate and not (guidNameplatePositionX[guid] and guidNameplatePositionY[guid])) then
		return;
	end

	fontString = getFontString();

	fontString.NSCTText = text;
	fontString.NSCTTextWithoutIcons = textWithoutIcons;
	fontString:SetText(fontString.NSCTText);

	fontString.NSCTFontSize = size;
	fontString:FontTemplate(getFontPath(db.font), fontString.NSCTFontSize, db.fontFlag);
	if db.textShadow then fontString:SetShadowOffset(1,-1) end
	fontString.startHeight = fontString:GetStringHeight();
	fontString.pow = pow;
	fontString.frameLevel = frameLevel;

	if (fontString.startHeight <= 0) then
		fontString.startHeight = 5;
	end

	fontString.unit = unit;
	fontString.guid = guid;

	-- if there is no nameplate,
	self:Animate(fontString, nameplate, ANIMATION_LENGTH, animation);
end

function SCT:Initialize()
	if not E.db.mui.nsct.enable or IsAddOnLoaded("NameplateSCT") then return end
	playerGUID = UnitGUID("player")

	self.db = E.db.mui.nsct

	MER:RegisterDB(self, "combattext")

	function SCT:ForUpdateAll()
		self.db = E.db.mui.nsct
	end

	self:ForUpdateAll()

	setNameplateFrameLevels();

	SCT:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	SCT:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	SCT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

local function InitializeCallback()
	SCT:Initialize()
end

MER:RegisterModule(SCT:GetName(), InitializeCallback)
