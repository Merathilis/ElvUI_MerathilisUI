local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_SuperTracker")
local C = MER.Utilities.Color

local _G = _G

local tonumber = tonumber
local tinsert = tinsert

local ClearUserWaypoint = C_Map.ClearUserWaypoint
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetMapInfo = C_Map.GetMapInfo
local HasUserWaypoint = C_Map.HasUserWaypoint
local CanSetUserWaypointOnMap = C_Map.CanSetUserWaypointOnMap
local GetDistance = C_Navigation.GetDistance
local SetSuperTrackedUserWaypoint = C_SuperTrack.SetSuperTrackedUserWaypoint
local UiMapPoint_CreateFromCoordinates = UiMapPoint.CreateFromCoordinates

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local SetUserWaypoint = C_Map.SetUserWaypoint

function module:ReskinDistanceText()
	if not _G.SuperTrackedFrame or not _G.SuperTrackedFrame.DistanceText then
		return
	end

	if not self.db or not self.db.distanceText or not self.db.distanceText.enable then
		return
	end

	F.SetFontDB(_G.SuperTrackedFrame.DistanceText, self.db.distanceText)
	_G.SuperTrackedFrame.DistanceText:SetTextColor(
		self.db.distanceText.color.r,
		self.db.distanceText.color.g,
		self.db.distanceText.color.b
	)
end

function module:HookPin()
	if not self.db or not self.db.middleClickToClear then
		return
	end

	if _G.WorldMapFrame:GetNumActivePinsByTemplate("WaypointLocationPinTemplate") ~= 0 then
		for pin in _G.WorldMapFrame:EnumeratePinsByTemplate("WaypointLocationPinTemplate") do
			if not self:IsHooked(pin, "OnMouseClickAction") then
				self:SecureHook(pin, "OnMouseClickAction", function(_, button)
					if button == "MiddleButton" then
						ClearUserWaypoint()
					end
				end)
			end
		end
	end
end

function module:HookDistanceText()
	_G.SuperTrackedFrame.DistanceText.__MERSetText = _G.SuperTrackedFrame.DistanceText.SetText

	self:SecureHook(_G.SuperTrackedFrame.DistanceText, "SetText", function(frame, text)
		if not self or not self.db or not text then
			return
		end

		-- Fix the distance text if distance > 1000
		if self.db.noLimit and strmatch(text, "%d%d%d%d.%d+") then
			text = gsub(text, "(%d+)%.%d+", "%1")
		end

		if self.db.noUnit then
			local after, isChanged = gsub(text, "(.*)%s.*$", "%1")
			if isChanged == 0 then
				after = gsub(text, "[^0-9%.].*$", "")
			end
			text = after
		end

		frame:__MERSetText(text)
	end)
end

function module:NoLimit()
	if not _G.SuperTrackedFrame then
		return
	end

	if not self.db or not self.db.noLimit then
		return
	end

	self:RawHook(_G.SuperTrackedFrame, "GetTargetAlphaBaseValue", function(frame)
		if GetDistance() > 999 then
			return 1
		else
			return self.hooks[_G.SuperTrackedFrame]["GetTargetAlphaBaseValue"](frame)
		end
	end, true)
end

function module.commandHandler(msg, isPreview)
	-- Global Command Handler
	if isPreview and type(isPreview) == "table" then
		isPreview = false
	end

	if not msg or msg == "" then
		if isPreview then
			return false, L["No Arg"]
		else
			F.Print(L["The argument is needed."])
			return
		end
	end

	msg = F.String.Replace(msg, {
		["　"] = " ",
		["．"] = ".",
		[","] = " ",
		["，"] = " ",
		["/"] = " ",
		["|"] = " ",
		["＂"] = " ",
		["'"] = " ",
		['"'] = " ",
		["["] = " ",
		["]"] = " ",
		["("] = " ",
		[")"] = " ",
		["（"] = " ",
		["）"] = " ",
		["的"] = " ",
		["在"] = " ",
		["于"] = " ",
	})

	local mapID = strmatch(msg, "#(%d+)")
	msg = gsub(msg, "#%d+", "")

	mapID = mapID or _G.WorldMapFrame:IsShown() and _G.WorldMapFrame:GetMapID() or GetBestMapForUnit("player")

	local numbers = {}
	local words = { F.String.Split(msg .. " ", " ") }

	if #words < 3 then
		if isPreview then
			return false, L["invalid"]
		else
			F.Print(L["The argument is invalid."])
			return
		end
	end

	for _, n in ipairs(words) do
		local num = tonumber(n)

		if not strmatch(n, "%.$") and num then
			tinsert(numbers, num)
		end
	end

	if #numbers < 2 then
		if isPreview then
			return false, L["invalid"]
		else
			F.Print(L["The argument is invalid."])
			return
		end
	end

	if numbers[1] > 100 or numbers[2] > 100 then
		if isPreview then
			return false, L["illegal"]
		else
			F.Print(L["The coordinates contain illegal number."])
			return
		end
	end

	if isPreview then
		local waypointString = numbers[1] .. ", " .. numbers[2]
		if numbers[3] then
			waypointString = waypointString .. ", " .. numbers[3]
		end

		local mapData = GetMapInfo(mapID) or GetMapInfo(GetBestMapForUnit("player"))
		return true, mapData.name .. " (" .. waypointString .. ")"
	else
		module:SetWaypoint(mapID, unpack(numbers))
	end
end

function module:SetWaypoint(mapID, x, y, z)
	mapID = mapID or _G.WorldMapFrame:IsShown() and _G.WorldMapFrame:GetMapID() or GetBestMapForUnit("player")

	-- colored waypoint string
	local mapData = GetMapInfo(mapID)
	if not mapData then
		mapID = GetBestMapForUnit("player")
		mapData = GetMapInfo(mapID)
	end
	local mapName = mapData.name
	local location = format("%s, %s", x, y)
	if z then
		location = location .. ", " .. z
	end
	local waypointString = C.StringByTemplate(format("%s (%s)", mapName, location), "primary")

	-- if not scaled, just do it here
	if x > 1 and y > 1 then
		x = x / 100
		y = y / 100
		z = z and z / 100
	end

	if x > 1 or y > 1 or (z and z > 1) then
		F.Print(L["The coordinates contain illegal number."])
		return
	end

	if CanSetUserWaypointOnMap(mapID) then
		SetUserWaypoint(UiMapPoint_CreateFromCoordinates(mapID, x, y, z))
		F.Print(format(L["Waypoint %s has been set."], waypointString))
	else
		self:Log("warning", L["Can not set waypoint on this map."])
	end
end

function module:WaypointParse()
	if not self.db.waypointParse.enable then
		return
	end

	if self.db.waypointParse.command then
		local keys = {}
		for k, _ in pairs(self.db.waypointParse.commandKeys) do
			tinsert(keys, k)
		end
		if self.db.waypointParse.virtualTomTom then
			if not IsAddOnLoaded("TomTom") and not _G.SLASH_TOMTOM_WAY1 then
				tinsert(keys, "way")
			end
		end
		MER:AddCommand("SUPER_TRACKER", keys, self.commandHandler)
	end

	if not self.db.waypointParse.worldMapInput then
		return
	end

	-- Input Text Edit Box
	local editBox = F.Widgets.New("Input", _G.WorldMapFrame, 200, 20, function(eb)
		self.commandHandler(eb:GetText(), false)
		eb:ClearFocus()
	end)

	editBox:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 3, -8)
	editBox:SetAutoFocus(false)

	-- Placeholder
	local placeholder = editBox:CreateFontString(nil, "ARTWORK")
	placeholder:FontTemplate(nil, nil, "SHADOWOUTLINE")
	placeholder:SetText("|cff666666" .. L["Go to ..."] .. "|r")
	placeholder:SetPoint("CENTER", editBox, "CENTER", 0, 0)

	editBox:HookScript("OnEditFocusGained", function()
		placeholder:Hide()
	end)

	editBox:HookScript("OnEditFocusLost", function(eb)
		local inputText = eb:GetText()
		if not inputText or gsub(inputText, " ", "") == "" then
			placeholder:Show()
			return
		end
		placeholder:Hide()
	end)

	-- Status Text
	local statusText = editBox:CreateFontString(nil, "ARTWORK")
	statusText:FontTemplate(nil, nil, "SHADOWOUTLINE")
	statusText:SetPoint("LEFT", editBox, "RIGHT", 5, 0)

	-- worldquest-questmarker-questionmark
	editBox:SetScript("OnTextChanged", function(eb)
		local inputText = eb:GetText()
		if not inputText or gsub(inputText, " ", "") == "" then
			statusText:SetText("")
			return
		end

		local success, preview = self.commandHandler(inputText, true)
		statusText:SetText("|cff" .. (success and "00d1b2" or "999999") .. preview .. "|r")
	end)

	F.Widgets.AddTooltip(
		editBox,
		format(
			"%s\n%s",
			F.cOption(L["Smart Waypoint"], "gradient"),
			L["You can paste any text contains coordinates here, and press ENTER to set the waypoint in map."]
		),
		"ANCHOR_TOPLEFT",
		-13,
		12
	)
end

function module:USER_WAYPOINT_UPDATED()
	if HasUserWaypoint() then
		if self.db and self.db.autoTrackWaypoint then
			E:Delay(0.1, SetSuperTrackedUserWaypoint, true)
		end
		E:Delay(0.15, self.HookPin, self)
	end
end

function module:ADDON_LOADED(_, addon)
	if addon == "Blizzard_QuestNavigation" then
		self:UnregisterEvent("ADDON_LOADED")
		self:NoLimit()
		self:ReskinDistanceText()
	end
end

function module:Initialize()
	self.db = E.db.mui.maps.superTracker

	if not self.db or not self.db.enable then
		return
	end

	if self.db.middleClickToClear then
		self:SecureHook(_G.WorldMapFrame, "Show", "HookPin")
	end

	if self.db.autoTrackWaypoint or self.db.middleClickToClear then
		self:RegisterEvent("USER_WAYPOINT_UPDATED")
		self:USER_WAYPOINT_UPDATED()
	end

	if not IsAddOnLoaded("Blizzard_QuestNavigation") then
		self:RegisterEvent("ADDON_LOADED")
		return
	end

	self:NoLimit()
	self:ReskinDistanceText()
	self:WaypointParse()

	if self.db.noLimit or self.db.noUnit then
		self:HookDistanceText()
	end
end

MER:RegisterModule(module:GetName())
