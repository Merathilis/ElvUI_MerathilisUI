local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local _G = _G
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local UnitGUID = UnitGUID

--[[
	oUF element: MER_PingIndicator

	Shows the ping placed on a unit (attack, warning, on my way, assist) on its unit frame.
	Stand-in until ElvUI ships its own PingIndicator (tukui-org/ElvUI#1880), everything
	here switches itself off once UF.Construct_PingIndicator exists.

	UNIT_PING_PIN_ADDED / UNIT_PING_PIN_REMOVED are secure-only events, addons cannot
	register them. Blizzard's target and focus frames own a PingIconFrame that receives
	them though (ElvUI only unregisters the frames themselves), so we listen there:
	- its OnEvent sees every ping, readable GUIDs (group members) are matched directly
	- its ShowPing/ClearPing only run after Blizzard compared the GUID in secure code,
	  which also covers the secret GUIDs of enemies, stored by unit token instead

	Blizzard clears those two on target/focus changes from events ElvUI unregistered,
	so the changes are handled here.

	Widget: frame.MER_PingIndicator - a Frame with .Background and .Icon textures
--]]

local watched = {}

-- Units whose target is shown on a frame of its own (targettarget, focustarget, pettarget)
local CHAINED_OWNERS = {
	target = true,
	focus = true,
	pet = true,
}

local function GetFrameUnit(frame)
	return frame.__unit or frame.unit or frame:GetAttribute("unit")
end

local function IsReadable(value)
	return value and not E:IsSecretValue(value)
end

local function UnitHasGUID(unit, guid)
	local unitGUID = UnitGUID(unit)
	return IsReadable(unitGUID) and IsReadable(guid) and unitGUID == guid
end

-- Whether the frame still shows the unit the ping was placed on
local function IsStillMatch(frame, element)
	local unit = GetFrameUnit(frame)
	if not unit or frame.isForced then
		return false
	end

	if element.token then
		return ElvUF:UnitIsUnit(unit, element.token) == true
	end

	return element.guid and UnitHasGUID(unit, element.guid)
end

local function ClearPing(element)
	element.guid = nil
	element.token = nil
	element:Hide()
end

local function ShowPing(element, guid, token, textureKit)
	if not IsReadable(textureKit) then
		return
	end

	element.guid = guid
	element.token = token
	element.Background:SetAtlas(("Ping_Frame_BG_%s"):format(textureKit))
	element.Icon:SetAtlas(("Ping_Frame_%s"):format(textureKit))
	element:Show()
end

-- Every other event (oUF's own updates on unit or roster changes) only revalidates
local function Update(self, event, guid, token, textureKit)
	local element = self.MER_PingIndicator

	if element.PreUpdate then
		element:PreUpdate()
	end

	local unit = GetFrameUnit(self)

	if self.isForced or not unit then
		ClearPing(element)
	elseif event == "UNIT_PING_PIN_ADDED" then
		local isMatch
		if token then
			isMatch = ElvUF:UnitIsUnit(unit, token) == true
		else
			isMatch = UnitHasGUID(unit, guid)
		end

		if isMatch then
			ShowPing(element, guid, token, textureKit)
		end
	elseif event == "UNIT_PING_PIN_REMOVED" then
		if (token and element.token == token) or (IsReadable(guid) and element.guid == guid) then
			ClearPing(element)
		end
	elseif element:IsShown() and not IsStillMatch(self, element) then
		ClearPing(element)
	end

	if element.PostUpdate then
		return element:PostUpdate(element.guid, element.token)
	end
end

local function Path(self, ...)
	return (self.MER_PingIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate")
end

local function Dispatch(event, guid, token, textureKit)
	for frame in next, watched do
		Path(frame, event, guid, token, textureKit)
	end
end

local function GetBlizzardPingIcon(frame)
	local content = frame and frame.TargetFrameContent
	local contextual = content and content.TargetFrameContentContextual
	return contextual and contextual.PingIconFrame
end

local listenersRegistered
local function RegisterListeners()
	if listenersRegistered then
		return
	end
	listenersRegistered = true

	local targetPing = GetBlizzardPingIcon(_G.TargetFrame)
	local focusPing = GetBlizzardPingIcon(_G.FocusFrame)

	if targetPing then
		targetPing:HookScript("OnEvent", function(_, event, guid, textureKit)
			-- Secret GUIDs are left to the ShowPing/ClearPing hooks below
			if IsReadable(guid) and (event == "UNIT_PING_PIN_ADDED" or event == "UNIT_PING_PIN_REMOVED") then
				Dispatch(event, guid, nil, textureKit)
			end
		end)
	end

	for token, pingFrame in next, { target = targetPing, focus = focusPing } do
		hooksecurefunc(pingFrame, "ShowPing", function(_, textureKit)
			Dispatch("UNIT_PING_PIN_ADDED", nil, token, textureKit)
		end)
		hooksecurefunc(pingFrame, "ClearPing", function()
			Dispatch("UNIT_PING_PIN_REMOVED", nil, token)
		end)
	end

	local listener = CreateFrame("Frame")
	listener:RegisterEvent("PLAYER_TARGET_CHANGED")
	listener:RegisterEvent("PLAYER_FOCUS_CHANGED")
	listener:RegisterEvent("UNIT_TARGET")
	listener:RegisterEvent("UNIT_PET")
	listener:SetScript("OnEvent", function(_, event, unit)
		-- Only the units behind the chained frames, UNIT_TARGET fires for every raid member
		if (event == "UNIT_TARGET" and not CHAINED_OWNERS[unit]) or (event == "UNIT_PET" and unit ~= "player") then
			return
		end

		-- What Blizzard's own target/focus frames would do on these
		if event == "PLAYER_TARGET_CHANGED" then
			Dispatch("UNIT_PING_PIN_REMOVED", nil, "target")
		elseif event == "PLAYER_FOCUS_CHANGED" then
			Dispatch("UNIT_PING_PIN_REMOVED", nil, "focus")
		end

		-- Chained units (targettarget, focustarget, pettarget) have no ping events of their own
		Dispatch(event)
	end)
end

local function Enable(self)
	local element = self.MER_PingIndicator
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		RegisterListeners()
		watched[self] = true

		return true
	end
end

local function Disable(self)
	local element = self.MER_PingIndicator
	if element then
		watched[self] = nil
		ClearPing(element)
	end
end

ElvUF:AddElement("MER_PingIndicator", Path, Enable, Disable)

-- Pinging a unit frame asks it for the unit's GUID: Blizzard's mixin reads self.unit or
-- the unit attribute, which oUF does not always set, and a secret GUID would break the
-- ping instead of falling back to a hit test ping (also part of tukui-org/ElvUI#1880).
local emptyPingInfo = {}
local unitPingInfo = {}

local function GetUnitFrameTargetInfo(frame)
	local unit = GetFrameUnit(frame)
	if not unit then
		return emptyPingInfo
	end

	local guid = UnitGUID(unit)
	if not IsReadable(guid) then
		return emptyPingInfo
	end

	unitPingInfo.guid = guid
	return unitPingInfo
end

local function FixTargetInfo(frame)
	local mixin = _G.PingableType_UnitFrameMixin
	-- Only replaces Blizzard's default, the player frame has ElvUI's own one
	if frame and mixin and frame.GetTargetInfo == mixin.GetTargetInfo then
		frame.GetTargetInfo = GetUnitFrameTargetInfo
	end
end

-- Unitframe integration, unitframeType to the option key
local UNITS = {
	player = "player",
	target = "target",
	targettarget = "targettarget",
	focus = "focus",
	focustarget = "focustarget",
	pet = "pet",
	pettarget = "pettarget",
	party = "party",
	raid1 = "raid",
	raid2 = "raid",
	raid3 = "raid",
	tank = "tank",
	assist = "assist",
	arena = "arena",
}

local function IsHandledByElvUI()
	return UF.Construct_PingIndicator ~= nil
end

function module:Configure_PingIndicator(frame)
	local unit = frame and UNITS[frame.unitframeType]
	if not unit or IsHandledByElvUI() then
		return
	end

	local db = E.db.mui.unitframes.pingIndicator
	if not (db.enable and db.units[unit]) then
		if frame.MER_PingIndicator and frame:IsElementEnabled("MER_PingIndicator") then
			frame:DisableElement("MER_PingIndicator")
		end
		return
	end

	local element = frame.MER_PingIndicator
	if not element then
		local parent = frame.RaisedElementParent and frame.RaisedElementParent.TextureParent or frame
		element = CreateFrame("Frame", nil, parent)
		element:Hide()

		element.Background = element:CreateTexture(nil, "OVERLAY", nil, 6)
		element.Background:SetAllPoints()

		element.Icon = element:CreateTexture(nil, "OVERLAY", nil, 7)
		element.Icon:SetAllPoints()

		frame.MER_PingIndicator = element
	end

	element:Size(db.size)
	element:ClearAllPoints()
	element:Point(db.position, frame, db.position, db.xOffset, db.yOffset)

	if not frame:IsElementEnabled("MER_PingIndicator") then
		frame:EnableElement("MER_PingIndicator")
	end
end

-- oUF keeps every spawned frame, the group headers' children included
function module:UpdatePingIndicators()
	for _, frame in ipairs(ElvUF.objects) do
		module:Configure_PingIndicator(frame)
	end
end

function module:PingIndicator()
	if not UF.Pingable_GetUnitFrameTargetInfo then
		hooksecurefunc(UF, "PrepareFrame", function(_, frame)
			FixTargetInfo(frame)
		end)

		for _, frame in ipairs(ElvUF.objects) do
			FixTargetInfo(frame)
		end
	end

	if IsHandledByElvUI() then
		return
	end

	hooksecurefunc(UF, "ConfigureFrame", function(_, frame)
		module:Configure_PingIndicator(frame)
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdatePingIndicators()
end
