local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_EventTracker')
local S = MER:GetModule('MER_Skins')
local LSM = E.Libs.LSM

local _G = _G
local date = date
local floor = floor
local format = format
local ipairs = ipairs
local pairs = pairs
local type = type
local unpack = unpack
local tsort = table.sort
local math_pow = math.pow

local CreateFrame = CreateFrame
local GetCurrentRegion = GetCurrentRegion
local GetServerTime = GetServerTime
local PlaySoundFile = PlaySoundFile

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetMapInfo = C_Map.GetMapInfo
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_Timer_NewTicker = C_Timer.NewTicker
local C_NamePlate_GetNamePlates = C_NamePlate.GetNamePlates

local eventList = {
	"CommunityFeast",
	"SiegeOnDragonbaneKeep",
	"IskaaranFishingNet"
}

local env = {
	fishingNetPosition = {
		-- Waking Shores
		[1] = { map = 2022, x = 0.63585, y = 0.75349 },
		[2] = { map = 2022, x = 0.64514, y = 0.74178 },
		-- Lava
		[3] = { map = 2022, x = 0.33722, y = 0.65047 },
		[4] = { map = 2022, x = 0.34376, y = 0.64763 },
		-- Thaldraszus
		[5] = { map = 2025, x = 0.56782, y = 0.65178 },
		[6] = { map = 2025, x = 0.57756, y = 0.65491 },
		-- Ohn'ahran Plains
		[7] = { map = 2023, x = 0.80522, y = 0.78433 },
		[8] = { map = 2023, x = 0.80467, y = 0.77742 }
	},
	fishingNetWidgetIDToIndex = {
		-- data mining: https://wow.tools/dbc/?dbc=uiwidget&build=10.0.5.47621#page=1&colFilter[3]=exact%3A2087
		-- Waking Shores
		[4203] = 1,
		[4317] = 2
	}
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
	purple = {
		{ r = 0.27843, g = 0.46275, b = 0.90196, a = 1 },
		{ r = 0.55686, g = 0.32941, b = 0.91373, a = 1 }
	},
	running = {
		{ r = 0.06667, g = 0.60000, b = 0.55686, a = 1 },
		{ r = 0.21961, g = 0.93725, b = 0.49020, a = 1 }
	}
}

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
				if not module.playerEnteredWorld then
					return
				end

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
					F.Print(format(L["%s will be started in %s!"], eventIconString .. " " .. gradientName, secondToTime(self.timeLeft)))

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
		}
	},
	triggerTimer = {
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
				if not C_QuestLog_IsQuestFlaggedCompleted(70871) then
					self.netTable = nil
					return
				end

				local db = module:GetPlayerDB("iskaaranFishingNet")
				if not db then
					return
				end

				self.netTable = {}
				local now = GetServerTime()
				for netIndex = 1, #env.fishingNetPosition do
					if type(db[netIndex]) ~= "table" then
						db[netIndex] = nil
					end

					if not db[netIndex] or db[netIndex].time == 0 then
						self.netTable[netIndex] = "NOT_STARTED"
					else
						self.netTable[netIndex] = {
							left = db[netIndex].time - now,
							duration = db[netIndex].duration
						}
					end
				end
			end,
			uiUpdater = function(self)
				local done = {}
				local notStarted = {}
				local waiting = {}

				if self.netTable then
					for netIndex, timeData in pairs(self.netTable) do
						if type(timeData) == "string" then
							if timeData == "NOT_STARTED" then
								tinsert(notStarted, netIndex)
							end
						elseif type(timeData) == "table" then
							if timeData.left <= 0 then
								tinsert(done, netIndex)
							else
								tinsert(waiting, netIndex)
							end
						end
					end
				end

				local tip = ""

				if #done == #env.fishingNetPosition then
					tip = F.StringByTemplate(L["All nets can be collected"], "success")
					self.timerText:SetText("")

					self.statusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", F.CreateColorFromTable(colorPlatte.running[1]), F.CreateColorFromTable(colorPlatte.running[2]))
					self.statusBar:SetMinMaxValues(0, 1)
					self.statusBar:SetValue(1)

					E:Flash(self.runningTip, 1, true)
				elseif #waiting > 0 then
					if #done > 0 then
						local netsText = ""
						for i = 1, #done do
							netsText = netsText .. "#" .. done[i]
							if i ~= #done then
								netsText = netsText .. ", "
							end
						end
						tip = F.StringByTemplate(format(L["Net %s can be collected"], netsText), "success")
					else
						tip = L["Waiting"]
					end

					local maxTimeIndex
					for _, index in pairs(waiting) do
						if not maxTimeIndex or self.netTable[index].left > self.netTable[maxTimeIndex].left then
							maxTimeIndex = index
						end
					end

					if type(self.args.barColor[1]) == "number" then
						self.statusBar:SetStatusBarColor(unpack(self.args.barColor))
					else
						self.statusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", F.CreateColorFromTable(self.args.barColor[1]), F.CreateColorFromTable(self.args.barColor[2]))
					end

					self.timerText:SetText(secondToTime(self.netTable[maxTimeIndex].left))
					self.statusBar:SetMinMaxValues(0, self.netTable[maxTimeIndex].duration)
					self.statusBar:SetValue(self.netTable[maxTimeIndex].left)

					E:StopFlash(self.runningTip)
				else
					self.timerText:SetText("")
					self.statusBar:GetStatusBarTexture():SetGradient("HORIZONTAL", F.CreateColorFromTable(colorPlatte.running[1]), F.CreateColorFromTable(colorPlatte.running[2]))
					self.statusBar:SetMinMaxValues(0, 1)

					if #done > 0 then
						local netsText = ""
						for i = 1, #done do
							netsText = netsText .. "#" .. done[i]
							if i ~= #done then
								netsText = netsText .. ", "
							end
						end
						tip = F.StringByTemplate(format(L["Net %s can be collected"], netsText), "success")
						self.statusBar:SetValue(1)
					else
						tip = F.StringByTemplate(L["No Nets Set"], "danger")
						self.statusBar:SetValue(0)
					end

					E:StopFlash(self.runningTip)
				end

				self.runningTip:SetText(tip)
			end,
			alert = function(self)
				if not module.playerEnteredWorld then
					return
				end

				if not self.netTable then
					return
				end

				local db = module:GetPlayerDB("iskaaranFishingNet")
				if not db then
					return
				end

				if not self.args["alertCache"] then
					self.args["alertCache"] = {}
				end

				local needAnnounce = false
				local readyNets = {}
				local bonusReady = false

				for netIndex, timeData in pairs(self.netTable) do
					if type(timeData) == "table" and timeData.left <= 0 then
						if not self.args["alertCache"][netIndex] then
							self.args["alertCache"][netIndex] = {}
						end

						if not self.args["alertCache"][netIndex][db[netIndex].time] then
							self.args["alertCache"][netIndex][db[netIndex].time] = true
							local hour = self.args.disableAlertAfterHours
							if not hour or hour == 0 or (hour * 60 * 60 + timeData.left) > 0 then
								readyNets[netIndex] = true
								if netIndex > 2 then
									bonusReady = true
								end
								needAnnounce = true
							end
						end
					end
				end

				if needAnnounce then
					local netsText = ""

					if readyNets[1] and readyNets[2] then
						netsText = netsText .. format(L["Net #%d"], 1) .. ", " .. format(L["Net #%d"], 2)
					elseif readyNets[1] then
						netsText = netsText .. format(L["Net #%d"], 1)
					elseif readyNets[2] then
						netsText = netsText .. format(L["Net #%d"], 2)
					end

					if bonusReady then
						if readyNets[1] or readyNets[2] then
							netsText = netsText .. ", "
						end
						netsText = netsText .. L["Bonus Net"]
					end

					local eventIconString = F.GetIconString(self.args.icon, 16, 16)
					local gradientName = getGradientText(self.args.eventName, self.args.barColor)

					F.Print(format(eventIconString .. " " .. gradientName .. " " .. L["%s can be collected"], netsText))

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

				if not self.netTable or #self.netTable == 0 then
					_G.GameTooltip:AddLine(F.StringByTemplate(L["No Nets Set"], "danger"))
					_G.GameTooltip:Show()
					return
				end
				_G.GameTooltip:AddLine(L["Fishing Nets"])

				local netIndex1Status -- Always
				local netIndex2Status -- Always
				local bonusNetStatus -- Bonus
				local bonusTimeLeft = 0

				for netIndex, timeData in pairs(self.netTable) do
					local text
					if type(timeData) == "table" then
						if timeData.left <= 0 then
							text = F.StringByTemplate(L["Can be collected"], "success")
						else
							text = F.StringByTemplate(secondToTime(timeData.left), "info")
						end

						-- only show latest bonus net
						if netIndex > 2 and timeData.left > bonusTimeLeft then
							bonusTimeLeft = timeData.left
							bonusNetStatus = text
						end
					else
						if timeData == "NOT_STARTED" then
							text = F.StringByTemplate(L["Can be set"], "warning")
						end
					end

					if netIndex == 1 then
						netIndex1Status = text
					elseif netIndex == 2 then
						netIndex2Status = text
					end
				end

				_G.GameTooltip:AddDoubleLine(format(L["Net #%d"], 1), netIndex1Status)
				_G.GameTooltip:AddDoubleLine(format(L["Net #%d"], 2), netIndex2Status)
				if bonusNetStatus then
					_G.GameTooltip:AddDoubleLine(L["Bonus Net"], bonusNetStatus)
				else -- no bonus net
					_G.GameTooltip:AddDoubleLine(L["Bonus Net"], F.StringByTemplate(L["Not Set"], "danger"))
				end

				_G.GameTooltip:Show()
			end,
			onLeave = function(self)
				_G.GameTooltip:Hide()
			end
		}
	}
}

local eventData = {
	CommunityFeast = {
		dbKey = "communityFeast",
		args = {
			icon = 4687629,
			type = "loopTimer",
			questID = 70893,
			duration = 16 * 60,
			interval = 1.5 * 60 * 60,
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
					[1] = 1675765800, -- NA
					[2] = 1675767600, -- KR
					[3] = 1676017800, -- EU
					[4] = 1675767600, -- TW
					[5] = 1675767600, -- CN
					[72] = 1675767600 -- TR -- Adjust me
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and MER.Locale ~= "koKR" then
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
					[5] = 1670770800, -- CN
					[72] = 1670770800 -- TR -- Adjust me
				}
				local region = GetCurrentRegion()
				-- TW is not a real region, so we need to check the client language if player in KR
				if region == 2 and MER.Locale ~= "koKR" then
					region = 4
				end

				return timestampTable[region]
			end)()
		}
	},
	IskaaranFishingNet = {
		dbKey = "iskaaranFishingNet",
		args = {
			icon = 2159815,
			type = "triggerTimer",
			filter = function()
				return C_QuestLog_IsQuestFlaggedCompleted(70871)
			end,
			barColor = colorPlatte.purple,
			eventName = L["Iskaaran Fishing Net"],
			label = L["Fishing Net"],
			events = {
				{
					"UNIT_SPELLCAST_SUCCEEDED",
					function(unit, _, spellID)
						if not unit or unit ~= "player" then
							return
						end

						local map = C_Map_GetBestMapForUnit("player")
						if not map then
							return
						end

						local position = C_Map_GetPlayerMapPosition(map, "player")

						if not position then
							return
						end

						local lengthMap = {}

						for i, netPos in ipairs(env.fishingNetPosition) do
							if map == netPos.map then
								local length = math_pow(position.x - netPos.x, 2) + math_pow(position.y - netPos.y, 2)
								lengthMap[i] = length
							end
						end

						local min
						local netIndex = 0
						for i, length in pairs(lengthMap) do
							if not min or length < min then
								min = length
								netIndex = i
							end
						end

						if not min or netIndex <= 0 then
							return
						end

						local db = module:GetPlayerDB("iskaaranFishingNet")
						if spellID == 377887 then -- Get Fish
							if db[netIndex] then
								db[netIndex] = nil
							end
						elseif spellID == 377883 then -- Set Net
							E:Delay(0.5, function()
								local namePlates = C_NamePlate_GetNamePlates(true)
								if #namePlates > 0 then
									for _, namePlate in ipairs(namePlates) do
										if namePlate and namePlate.UnitFrame and namePlate.UnitFrame.WidgetContainer then
											local container = namePlate.UnitFrame.WidgetContainer
											if container.timerWidgets then
												for id, widget in pairs(container.timerWidgets) do
													if env.fishingNetWidgetIDToIndex[id] and env.fishingNetWidgetIDToIndex[id] == netIndex then
														if widget.Bar and widget.Bar.value and widget.Bar.range then
															db[netIndex] = { time = GetServerTime() + widget.Bar.value, duration = widget.Bar.range }
														end
													end
												end
											end
										end
									end
								end
							end)
						end
					end
				}
			}
		}
	},
	--[[ 10.1 stuff
	ResearchersUnderFire = {
		dbKey = "ResearchersUnderFire",
		args = {
			icon = 2159815,
			type = "triggerTimer",
			barColor = colorPlatte.purple,
			eventName = L["Researchers Under Fire"],
			label = L["Researchers Under Fire"],
			runningText = L["Fire"],
			filter = function(args)
			end,
			startTimestamp = (function()
			end)()
		}
	}]]
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

	frame.dbKey = data.dbKey
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

	if data.args.events then
		for _, event in ipairs(data.args.events) do
			module:AddEventHandler(event[1], event[2])
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

module.eventHandlers = {
	["PLAYER_ENTERING_WORLD"] = {
		function() E:Delay(10, function()
				module.playerEnteredWorld = true
			end)
		end
	}
}

function module:HandlerEvent(event, ...)
	if self.eventHandlers[event] then
		for _, handler in ipairs(self.eventHandlers[event]) do
			handler(...)
		end
	end
end

function module:AddEventHandler(event, handler)
	if not self.eventHandlers[event] then
		self.eventHandlers[event] = {}
	end

	tinsert(self.eventHandlers[event], handler)
end

function module:SetFont(target, size)
	if not target or not size then
		return
	end

	if not self.db or not self.db.font then
		return
	end

	F.SetFontDB(target, {
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

	local frame = CreateFrame("Frame", "MER_EventTracker", _G.WorldMapFrame)

	frame:SetHeight(30)
	frame:SetFrameStrata("MEDIUM")

	self.frame = frame
end

function module:GetPlayerDB(key)
	local globalDB = E.global.mui.maps.eventTracker

	if not globalDB then
		return
	end

	if not globalDB[E.myrealm] then
		globalDB[E.myrealm] = {}
	end

	if not globalDB[E.myrealm][E.myname] then
		globalDB[E.myrealm][E.myname] = {}
	end

	if not globalDB[E.myrealm][E.myname][key] then
		globalDB[E.myrealm][E.myname][key] = {}
	end

	return globalDB[E.myrealm][E.myname][key]
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
				self.frame:Styling()
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
			tracker.args.soundFile = self.db[data.dbKey].sound and self.db[data.dbKey].soundFile

			if self.db[data.dbKey].alert then
				tracker.args.alert = true
				tracker.args.alertSecond = self.db[data.dbKey].second
				tracker.args.stopAlertIfCompleted = self.db[data.dbKey].stopAlertIfCompleted
				tracker.args.stopAlertIfPlayerNotEnteredDragonlands =
				self.db[data.dbKey].stopAlertIfPlayerNotEnteredDragonlands
				tracker.args.disableAlertAfterHours = self.db[data.dbKey].disableAlertAfterHours
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

	for event in pairs(self.eventHandlers) do
		self:RegisterEvent(event, "HandlerEvent")
	end
end

function module:ProfileUpdate()
	self:Initialize()

	if self.frame then
		self.frame:SetShown(self.db.enable)
	end
end

MER:RegisterModule(module:GetName())

MER:AddCommand("EVENT_TRACKER", { "/wtet" }, function(msg)
	if msg == "forceUpdate" then
		local map = C_Map_GetBestMapForUnit("player")
		if not map then
			return
		end

		local position = C_Map_GetPlayerMapPosition(map, "player")

		if not position then
			return
		end

		local lengthMap = {}

		for i, netPos in ipairs(env.fishingNetPosition) do
			if map == netPos.map then
				local length = math_pow(position.x - netPos.x, 2) + math_pow(position.y - netPos.y, 2)
				lengthMap[i] = length
			end
		end

		local min
		local netIndex = 0
		for i, length in pairs(lengthMap) do
			if not min or length < min then
				min = length
				netIndex = i
			end
		end

		if not min or netIndex <= 0 then
			return
		end

		local db = module:GetPlayerDB("iskaaranFishingNet")

		local namePlates = C_NamePlate_GetNamePlates(true)
		if #namePlates > 0 then
			for _, namePlate in ipairs(namePlates) do
				if namePlate and namePlate.UnitFrame and namePlate.UnitFrame.WidgetContainer then
					local container = namePlate.UnitFrame.WidgetContainer
					if container.timerWidgets then
						for id, widget in pairs(container.timerWidgets) do
							if env.fishingNetWidgetIDToIndex[id] and env.fishingNetWidgetIDToIndex[id] == netIndex then
								if widget.Bar and widget.Bar.value then
									db[netIndex] = {time = GetServerTime() + widget.Bar.value, duration = widget.Bar.range}
								end
							end
						end
					end
				end
			end
		end
	end

	if msg == "findNet" then
		local map = C_Map_GetBestMapForUnit("player")
		if not map then
			return
		end

		local position = C_Map_GetPlayerMapPosition(map, "player")

		if not position then
			return
		end

		local namePlates = C_NamePlate_GetNamePlates(true)
		if #namePlates > 0 then
			for _, namePlate in ipairs(namePlates) do
				if namePlate and namePlate.UnitFrame and namePlate.UnitFrame.WidgetContainer then
					local container = namePlate.UnitFrame.WidgetContainer
					if container.timerWidgets then
						for id, widget in pairs(container.timerWidgets) do
							if widget.Bar and widget.Bar.value then
								F.Print("------------")
								F.Print("mapID", map)
								F.Print("mapName", C_Map_GetMapInfo(map).name)
								F.Print("position", position.x, position.y)
								F.Print("widgetID", id)
								F.Print("timeLeft", widget.Bar.value, secondToTime(widget.Bar.value))
								F.Print("------------")
							end
						end
					end
				end
			end
		end
	end
end)
