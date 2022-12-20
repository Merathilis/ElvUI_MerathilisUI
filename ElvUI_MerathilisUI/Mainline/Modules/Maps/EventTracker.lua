local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_EventTracker')
local S = MER:GetModule('MER_Skins')
local LSM = E.Libs.LSM

local _G = _G
local floor = floor
local format = format
local ipairs = ipairs
local unpack = unpack

local CreateFrame = CreateFrame
local GetCurrentRegion = GetCurrentRegion
local GetLocale = GetLocale
local GetServerTime = GetServerTime
local PlaySoundFile = PlaySoundFile

local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_Timer_NewTicker = C_Timer.NewTicker

--[[
	Credits: fang2hou -> ElvUI_Windtools <3
]]--

local function secondToTime(second)
	local hour = floor(second / 3600)
	local min = floor((second - hour * 3600) / 60)
	local sec = floor(second - hour * 3600 - min * 60)

	if hour == 0 then
		return format("%02d:%02d", min, sec)
	else
		return format("%02d:%02d:%02d", hour, min, sec)
	end
end

local eventList = {
	"CommunityFeast",
	"SiegeOnDragonbaneKeep"
}

local colorPlatte = {
	blue = {
		{ r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
		{ r = 0.25882, g = 0.84314, b = 0.86667, a = 1 }
	},
	red = {
		{ r = 0.92549, g = 0.00000, b = 0.54902, a = 1 },
		{ r = 0.98824, g = 0.40392, b = 0.40392, a = 1 }
	},
	orange = {
		{ r = 1, g = 0.23, b = 0.00, a = 1 },
		{ r = 1, g = 0.48, b = 0.03, a = 1 }
	},
	running = {
		{ r = 0.00000, g = 0.94902, b = 0.37647, a = 1 },
		{ r = 0.01961, g = 0.45882, b = 0.90196, a = 1 }
	}
}

local function reskinStatusBar(bar)
	bar:SetFrameLevel(bar:GetFrameLevel() + 1)
	bar:StripTextures()
	bar:CreateBackdrop("Transparent")
	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)
end

local function getGradientText(text, colorTable)
	if not text or not colorTable then
		return text
	end
	return E:TextGradient(text, colorTable[1].r, colorTable[1].g, colorTable[1].b, colorTable[2].r, colorTable[2].g, colorTable[2].b)
end

local functionFactory = {
	loopTimer = {
		init = function(self)
			self.icon = self:CreateTexture(nil, "ARTWORK")
			self.icon:CreateBackdrop("Transparent")
			self.icon.backdrop:SetOutside(self.icon, 1, 1)
			self.statusBar = CreateFrame("StatusBar", nil, self)
			self.name = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.timerText = self.statusBar:CreateFontString(nil, "OVERLAY")
			self.runningTip = self.statusBar:CreateFontString(nil, "OVERLAY")

			reskinStatusBar(self.statusBar)

			self.statusBar.spark = self.statusBar:CreateTexture(nil, "ARTWORK", nil, 1)
			self.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
			self.statusBar.spark:SetBlendMode("ADD")
			self.statusBar.spark:SetPoint("CENTER", self.statusBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			self.statusBar.spark:SetSize(4, 26)
		end,
		setup = function(self)
			self.icon:SetTexture(self.args.icon)
			self.icon:SetTexCoord(unpack(E.TexCoords))
			self.icon:SetSize(22, 22)
			self.icon:ClearAllPoints()
			self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)

			self.statusBar:ClearAllPoints()
			self.statusBar:SetPoint("TOPLEFT", self, "LEFT", 26, 2)
			self.statusBar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 6)

			module:SetFont(self.timerText, 13)
			self.timerText:ClearAllPoints()
			self.timerText:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -6)

			module:SetFont(self.name, 13)
			self.name:ClearAllPoints()
			self.name:SetPoint("TOPLEFT", self, "TOPLEFT", 30, -6)
			self.name:SetText(self.args.label)

			module:SetFont(self.runningTip, 10)
			self.runningTip:SetText(self.args.runningText)
			self.runningTip:SetPoint("CENTER", self.statusBar, "BOTTOM", 0, 0)
		end,
		ticker = {
			interval = 0.3,
			dateUpdater = function(self)
				self.isCompleted = C_QuestLog_IsQuestFlaggedCompleted(self.args.questID)

				local timeSinceStart = GetServerTime() - self.args.startTimestamp
				self.timeOver = timeSinceStart % self.args.interval
				self.nextEventIndex = floor(timeSinceStart / self.args.interval) + 1
				self.nextEventTimestamp = self.args.startTimestamp + self.args.interval * self.nextEventIndex

				if self.timeOver < self.args.duration then
					self.timeLeft = self.args.duration - self.timeOver
					self.isRunning = true
				else
					self.timeLeft = self.args.interval - self.timeOver
					self.isRunning = false
				end
			end,
			uiUpdater = function(self)
				self.icon:SetDesaturated(self.args.desaturate and self.isCompleted)

				if self.isRunning then
					-- event ending tracking timer
					self.timerText:SetText(F.StringByTemplate(secondToTime(self.timeLeft), "success"))
					self.statusBar:SetMinMaxValues(0, self.args.duration)
					self.statusBar:SetValue(self.timeOver)
					local tex = self.statusBar:GetStatusBarTexture()
					tex:SetGradient("HORIZONTAL", F.CreateColorFromTable(colorPlatte.running[1]), F.CreateColorFromTable(colorPlatte.running[2]))
					self.runningTip:Show()
					E:Flash(self.runningTip, 1, true)
				else
					-- normal tracking timer
					self.timerText:SetText(secondToTime(self.timeLeft))
					self.statusBar:SetMinMaxValues(0, self.args.interval)
					self.statusBar:SetValue(self.timeLeft)

					if type(self.args.barColor[1]) == "number" then
						self.statusBar:SetStatusBarColor(unpack(self.args.barColor))
					else
						local tex = self.statusBar:GetStatusBarTexture()
						tex:SetGradient("HORIZONTAL", F.CreateColorFromTable(self.args.barColor[1]), F.CreateColorFromTable(self.args.barColor[2]))
					end

					E:StopFlash(self.runningTip)
					self.runningTip:Hide()
				end
			end,
			alert = function(self)
				if not self.args["alertCache"] then
					self.args["alertCache"] = {}
				end

				if self.args["alertCache"][self.nextEventIndex] then
					return
				end

				if not self.args.alertSecond or self.isRunning then
					return
				end

				if self.args.stopAlertIfCompleted and self.isCompleted then
					return
				end

				if self.args.filter and not self.args:filter() then
					return
				end

				if self.timeLeft <= self.args.alertSecond then
					self.args["alertCache"][self.nextEventIndex] = true
					local eventIconString = F.GetIconString(self.args.icon, 16, 16)
					local gradientName = getGradientText(self.args.eventName, self.args.barColor)
					F.Print(format( L["%s will be started in %s!"], eventIconString .. " " .. gradientName, secondToTime(self.timeLeft)))
					if self.args.soundFile then
						PlaySoundFile(LSM:Fetch("sound", self.args.soundFile), "Master")
					end
				end
			end
		},
		tooltip = {
			onEnter = function(self)
				_G.GameTooltip:ClearLines()
				_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 8)
				_G.GameTooltip:SetText(F.GetIconString(self.args.icon, 16, 16) .. " " .. self.args.eventName, 1, 1, 1)

				_G.GameTooltip:AddLine(" ")
				_G.GameTooltip:AddDoubleLine(L["Location"], self.args.location, 1, 1, 1)

				_G.GameTooltip:AddLine(" ")
				_G.GameTooltip:AddDoubleLine(L["Interval"], secondToTime(self.args.interval), 1, 1, 1)
				_G.GameTooltip:AddDoubleLine(L["Duration"], secondToTime(self.args.duration), 1, 1, 1)
				if self.nextEventTimestamp then
					_G.GameTooltip:AddDoubleLine(L["Next Event"], date("%m/%d %H:%M:%S", self.nextEventTimestamp), 1, 1, 1)
				end

				_G.GameTooltip:AddLine(" ")
				if self.isRunning then
					_G.GameTooltip:AddDoubleLine(L["Status"], F.StringByTemplate(self.args.runningText, "success"), 1, 1, 1)
				else
					_G.GameTooltip:AddDoubleLine(L["Status"], F.StringByTemplate(L["Waiting"], "greyLight"), 1, 1, 1)
				end

				if self.isCompleted then
					_G.GameTooltip:AddDoubleLine(L["Weekly Reward"], F.StringByTemplate(L["Completed"], "success"), 1, 1, 1)
				else
					_G.GameTooltip:AddDoubleLine(L["Weekly Reward"], F.StringByTemplate(L["Not Completed"], "danger"), 1, 1, 1)
				end

				_G.GameTooltip:Show()
			end,
			onLeave = function(self)
				_G.GameTooltip:Hide()
			end
		},
	},
}

local eventData = {
	CommunityFeast = {
		dbKey = "communityFeast",
		args = {
			icon = 4687629,
			type = "loopTimer",
			questID = 70893,
			duration = 16 * 60,
			interval = 3.5 * 60 * 60,
			barColor = colorPlatte.blue,
			eventName = L["Community Feast"],
			location = C_Map_GetMapInfo(2024).name,
			label = L["Feast"],
			runningText = L["Cooking"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1670776200, -- NA
					[2] = 1670770800, -- KR
					[3] = 1670774400, -- EU
					[4] = 1670779800, -- TW
					[5] = 1670779800 -- CN
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and GetLocale() ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)()
		}
	},
	SiegeOnDragonbaneKeep = {
		dbKey = "siegeOnDragonbaneKeep",
		args = {
			icon = 236469,
			type = "loopTimer",
			questID = 70866,
			duration = 10 * 60,
			interval = 2 * 60 * 60,
			eventName = L["Siege On Dragonbane Keep"],
			label = L["Dragonbane Keep"],
			location = C_Map_GetMapInfo(2022).name,
			barColor = colorPlatte.red,
			runningText = L["In Progress"],
			filter = function(args)
				if args.stopAlertIfPlayerNotEnteredDragonlands and not C_QuestLog_IsQuestFlaggedCompleted(67700) then
					return false
				end
				return true
			end,
			startTimestamp = (function()
				local timestampTable = {
					[1] = 1670770800, -- NA
					[2] = 1670770800, -- KR
					[3] = 1670774400, -- EU
					[4] = 1670770800, -- TW
					[5] = 1670770800 -- CN
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and GetLocale() ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)()
		}
	}
}

local trackers = {
	pool = {}
}

function trackers:get(event)
	if self.pool[event] then
		self.pool[event]:Show()
		return self.pool[event]
	end

	local data = eventData[event]

	local frame = CreateFrame("Frame", "MER_EventTracker" .. event, module.frame)
	frame:SetSize(220, 30)

	frame.args = data.args

	if functionFactory[data.args.type] then
		local functions = functionFactory[data.args.type]
		if functions.init then
			functions.init(frame)
		end

		if functions.setup then
			functions.setup(frame)
			frame.profileUpdate = function()
				functions.setup(frame)
			end
		end

		if functions.ticker then
			frame.tickerInstance = C_Timer_NewTicker(functions.ticker.interval, function()
				if not (module and module.db and module.db.enable) then
					return
				end
				functions.ticker.dateUpdater(frame)
				functions.ticker.alert(frame)
				if _G.WorldMapFrame:IsShown() and frame:IsShown() then
					functions.ticker.uiUpdater(frame)
				end
			end)
		end

		if functions.tooltip then
			frame:SetScript("OnEnter", function()
				functions.tooltip.onEnter(frame, data.args)
			end)

			frame:SetScript("OnLeave", function()
				functions.tooltip.onLeave(frame, data.args)
			end)
		end
	end

	self.pool[event] = frame

	return frame
end

function trackers:disable(event)
	if self.pool[event] then
		self.pool[event]:Hide()
	end
end

function module:SetFont(target, size)
	if not target or not size then
		return
	end

	if not self.db or not self.db.font then
		return
	end

	F.SetFontDB(target,
		{
			name = self.db.font.name,
			size = floor(size * self.db.font.scale),
			style = self.db.font.outline
		}
	)
end

function module:ConstructFrame()
	if not _G.WorldMapFrame or self.frame then
		return
	end

	local frame = CreateFrame("Frame", "WTEventTracker", _G.WorldMapFrame)

	frame:SetHeight(30)
	frame:SetFrameStrata("MEDIUM")

	self.frame = frame
end

function module:UpdateTrackers()
	self:ConstructFrame()

	self.frame:SetHeight(self.db.height)

	self.frame:ClearAllPoints()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.worldmap) then
		self.frame:SetPoint("TOPLEFT", _G.WorldMapFrame, "BOTTOMLEFT", -2, self.db.yOffset)
		self.frame:SetPoint("TOPRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", 2, self.db.yOffset)

		if self.db.backdrop then
			if not self.frame.backdrop then
				self.frame.backdrop = CreateFrame("Frame", nil, self.frame, "TooltipBackdropTemplate")
				self.frame.backdrop:SetAllPoints(self.frame)
			end
			self.frame.backdrop:Show()
		else
			if self.frame.backdrop then
				self.frame.backdrop:Hide()
			end
		end
	else
		self.frame:SetPoint("TOPLEFT", _G.WorldMapFrame.backdrop, "BOTTOMLEFT", 1, self.db.yOffset)
		self.frame:SetPoint("TOPRIGHT", _G.WorldMapFrame.backdrop, "BOTTOMRIGHT", -1, self.db.yOffset)

		if self.db.backdrop then
			if not self.frame.backdrop then
				self.frame:CreateBackdrop("Transparent")
				S:CreateShadowModule(self.frame.backdrop)
			end
			self.frame.backdrop:Show()
		else
			if self.frame.backdrop then
				self.frame.backdrop:Hide()
			end
		end
	end

	local lastTracker = nil
	for _, event in ipairs(eventList) do
		local data = eventData[event]
		local tracker = self.db[data.dbKey].enable and trackers:get(event) or trackers:disable(event)
		if tracker then
			if tracker.profileUpdate then
				tracker.profileUpdate()
			end

			tracker.args.desaturate = self.db[data.dbKey].desaturate
			tracker.args.soundFile = self.db.sound and self.db[data.dbKey].soundFile

			if self.db[data.dbKey].alert then
				tracker.args.alert = true
				tracker.args.alertSecond = self.db[data.dbKey].second
				tracker.args.stopAlertIfCompleted = self.db[data.dbKey].stopAlertIfCompleted
				tracker.args.stopAlertIfPlayerNotEnteredDragonlands = self.db[data.dbKey].stopAlertIfPlayerNotEnteredDragonlands
			else
				tracker.args.alertSecond = nil
				tracker.args.stopAlertIfCompleted = nil
			end

			tracker:ClearAllPoints()
			if lastTracker then
				tracker:SetPoint("LEFT", lastTracker, "RIGHT", self.db.spacing, 0)
			else
				tracker:SetPoint("LEFT", self.frame, "LEFT", self.db.spacing * 0.68, 0)
			end
			lastTracker = tracker
		end
	end
end

function module:Initialize()
	self.db = E.db.mui.maps.eventTracker

	if not self.db or not self.db.enable then
		return
	end

	self:UpdateTrackers()
end

function module:ProfileUpdate()
	self:Initialize()

	if self.frame then
		self.frame:SetShown(self.db.enable)
	end
end

MER:RegisterModule(module:GetName())
