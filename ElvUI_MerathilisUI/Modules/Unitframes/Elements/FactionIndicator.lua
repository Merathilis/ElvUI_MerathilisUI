local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local hooksecurefunc = hooksecurefunc
local UnitFactionGroup = UnitFactionGroup
local UnitIsPlayer = UnitIsPlayer

local MAX_ARENA_FRAMES = 5

--[[
	oUF element: MER_FactionIndicator

	Shows the faction crest of players that belong to the opposing faction.
	Shared by the MerathilisUI unitframe and nameplate integrations.

	Widget: frame.MER_FactionIndicator - a Texture
	Options: element.style - key of MER.FactionIndicatorAtlases (defaults to "crest")
--]]

MER.FactionIndicatorAtlases = {
	crest = {
		Alliance = "MountJournalIcons-Alliance",
		Horde = "MountJournalIcons-Horde",
	},
	round = {
		Alliance = "QuestPortraitIcon-Alliance",
		Horde = "QuestPortraitIcon-Horde",
	},
}

local function GetOpposingFaction(unit)
	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local faction = UnitFactionGroup(unit)
	if faction ~= "Alliance" and faction ~= "Horde" then
		return
	end

	if faction ~= UnitFactionGroup("player") then
		return faction
	end
end

local function Update(self, event, unit)
	if unit and unit ~= self.__unit then
		return
	end

	local element = self.MER_FactionIndicator
	unit = self.__unit

	if element.PreUpdate then
		element:PreUpdate(unit)
	end

	local faction = GetOpposingFaction(unit)
	if faction then
		local atlases = MER.FactionIndicatorAtlases[element.style] or MER.FactionIndicatorAtlases.crest
		element:SetAtlas(atlases[faction])
		element:Show()
	else
		element:Hide()
	end

	if element.PostUpdate then
		return element:PostUpdate(unit, faction)
	end
end

local function Path(self, ...)
	return (self.MER_FactionIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_FactionIndicator
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_FACTION", Path)
		-- Neutral pandaren picking a side changes which faction counts as opposing
		self:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT", Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.MER_FactionIndicator
	if element then
		element:Hide()

		self:UnregisterEvent("UNIT_FACTION", Path)
		self:UnregisterEvent("NEUTRAL_FACTION_SELECT_RESULT", Path)
	end
end

ElvUF:AddElement("MER_FactionIndicator", Path, Enable, Disable)

-- Unitframe integration
function module:Configure_FactionIndicator(frame, unit)
	if not frame then
		return
	end

	local db = E.db.mui.unitframes.factionIndicator
	local unitDb = db and db.enable and db.units[unit]

	if not (unitDb and unitDb.enable) then
		if frame.MER_FactionIndicator and frame:IsElementEnabled("MER_FactionIndicator") then
			frame:DisableElement("MER_FactionIndicator")
		end
		return
	end

	local element = frame.MER_FactionIndicator
	if not element then
		local parent = frame.RaisedElementParent or frame
		element = parent:CreateTexture(nil, "OVERLAY", nil, 2)
		element:Hide()
		frame.MER_FactionIndicator = element
	end

	element.style = db.style
	element:Size(unitDb.size)
	element:ClearAllPoints()
	element:Point(unitDb.position, frame.Health or frame, unitDb.position, unitDb.xOffset, unitDb.yOffset)

	if not frame:IsElementEnabled("MER_FactionIndicator") then
		frame:EnableElement("MER_FactionIndicator")
	end

	element:ForceUpdate()
end

local singleUnits = {
	target = "Update_TargetFrame",
	targettarget = "Update_TargetTargetFrame",
	focus = "Update_FocusFrame",
	focustarget = "Update_FocusTargetFrame",
}

function module:UpdateFactionIndicators()
	for unit in pairs(singleUnits) do
		module:Configure_FactionIndicator(UF[unit], unit)
	end

	for i = 1, MAX_ARENA_FRAMES do
		module:Configure_FactionIndicator(UF["arena" .. i], "arena")
	end
end

function module:FactionIndicator()
	for unit, func in pairs(singleUnits) do
		hooksecurefunc(UF, func, function(_, frame)
			module:Configure_FactionIndicator(frame, unit)
		end)
	end

	hooksecurefunc(UF, "Update_ArenaFrames", function(_, frame)
		module:Configure_FactionIndicator(frame, "arena")
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateFactionIndicators()
end
