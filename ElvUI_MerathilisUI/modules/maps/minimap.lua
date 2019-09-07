local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local LCG = LibStub('LibCustomGlow-1.0')

--Cache global variables
--Lua functions
local _G = _G
local pairs, select, unpack = pairs, select, unpack
local format = string.format
--WoW API / Variables
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local GetUnitName = GetUnitName
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UnitClass = UnitClass
local UnitName = UnitName
local Minimap = _G.Minimap
local hooksecurefunc = hooksecurefunc
local IsInInstance = IsInInstance
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
-- GLOBALS:

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:CheckMail()
	local inv = C_Calendar_GetNumPendingInvites()
	local mail = _G["MiniMapMailFrame"]:IsShown() and true or false

	if inv > 0 and mail then -- New invites and mail
		LCG.PixelGlow_Start(Minimap.backdrop, {242, 5/255, 5/255, 1}, 8, -0.25, nil, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		LCG.PixelGlow_Start(Minimap.backdrop, {1, 30/255, 60/255, 1}, 8, -0.25, nil, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		LCG.PixelGlow_Start(Minimap.backdrop, {r, g, b, 1}, 8, -0.25, nil, 1)
	else -- None of the above
		LCG.PixelGlow_Stop(Minimap.backdrop)
	end
end

function module:MiniMapCoords()
	if E.db.mui.maps.minimap.coords.enable ~= true then return end

	local pos = E.db.mui.maps.minimap.coords.position or "BOTTOM"
	local Coords = MER:CreateText(Minimap, "OVERLAY", 12, "OUTLINE", "CENTER")
	Coords:SetTextColor(unpack(E["media"].rgbvaluecolor))
	if pos == "BOTTOM" then
		Coords:SetPoint(pos, 0, 2)
	elseif pos == "TOP" and (E.db.general.minimap.locationText == 'SHOW' or E.db.general.minimap.locationText == 'MOUSEOVER') then
		Coords:SetPoint(pos, 0, -12)
	elseif pos == "TOP" and E.db.general.minimap.locationText == 'HIDE' then
		Coords:SetPoint(pos, 0, -2)
	else
		Coords:SetPoint(pos, 0, 0)
	end
	Coords:Hide()

	Minimap:HookScript("OnUpdate",function()
		if select(2, GetInstanceInfo()) == "none" then
			local x, y = E.MapInfo.x or 0, E.MapInfo.y or 0
			if x and y and x > 0 and y > 0 then
				Coords:SetText(format("%d,%d", x*100, y*100))
			else
				Coords:SetText("")
			end
		end
	end)

	Minimap:HookScript("OnEnter", function() Coords:Show() end)
	Minimap:HookScript("OnLeave", function() Coords:Hide() end)
end

function module:MiniMapPing()
	if E.db.mui.maps.minimap.ping.enable ~= true then return end

	local pos = E.db.mui.maps.minimap.ping.position or "TOP"
	local xOffset = E.db.mui.maps.minimap.ping.xOffset or 0
	local yOffset = E.db.mui.maps.minimap.ping.yOffset or 0
	local f = CreateFrame("Frame", nil, Minimap)
	f:SetAllPoints()
	f.text = MER:CreateText(f, "OVERLAY", 10, "OUTLINE", "", nil, pos, xOffset, yOffset)

	local anim = f:CreateAnimationGroup()
	anim:SetScript("OnPlay", function() f:SetAlpha(1) end)
	anim:SetScript("OnFinished", function() f:SetAlpha(0) end)

	anim.fader = anim:CreateAnimation("Alpha")
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing("OUT")
	anim.fader:SetStartDelay(3)

	MER:RegisterEvent("MINIMAP_PING", function(_, unit)
		local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
		local name = UnitName(unit)

		anim:Stop()
		f.text:SetText(name)
		f.text:SetTextColor(color.r, color.g, color.b)
		anim:Play()
	end)
end

function module:RaidDifficulty()
	if E.db.mui.maps.minimap.difficulty ~= true then return end

	local RaidDifficulty = CreateFrame('Frame', nil, Minimap)
	RaidDifficulty:SetSize(24, 8)
	RaidDifficulty:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 5, -5)
	RaidDifficulty:RegisterEvent('PLAYER_ENTERING_WORLD')
	RaidDifficulty:RegisterEvent('CHALLENGE_MODE_START')
	RaidDifficulty:RegisterEvent('CHALLENGE_MODE_COMPLETED')
	RaidDifficulty:RegisterEvent('CHALLENGE_MODE_RESET')
	RaidDifficulty:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
	RaidDifficulty:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
	RaidDifficulty:RegisterEvent('ZONE_CHANGED_NEW_AREA')

	local RaidDifficultyText = RaidDifficulty:CreateFontString(nil, 'OVERLAY')
	RaidDifficultyText:FontTemplate()
	RaidDifficultyText:SetPoint('TOPLEFT', 0, 0)

	RaidDifficulty:SetScript('OnEvent', function()
		local _, instanceType = IsInInstance()
		local difficulty = select(3, GetInstanceInfo())
		local numplayers = select(9, GetInstanceInfo())
		local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ''

		local norm = format("|cff09ff00%s |r", "N")
		local hero = format("|cffff7d0a%s |r", "H")
		local myth = format("|cffff0000%s |r", "M")

		if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
			if (difficulty == 1) then -- Normal
				RaidDifficultyText:SetText('5'..norm)
			elseif difficulty == 2 then -- Heroic
				RaidDifficultyText:SetText('5'..hero)
			elseif difficulty == 3 then -- 10 Player
				RaidDifficultyText:SetText('10'..norm)
			elseif difficulty == 4 then -- 25 Player
				RaidDifficultyText:SetText('25'..norm)
			elseif difficulty == 5 then -- 10 Player (Heroic)
				RaidDifficultyText:SetText('10'..hero)
			elseif difficulty == 6 then -- 25 Player (Heroic)
				RaidDifficultyText:SetText('25'..hero)
			elseif difficulty == 7 then -- LFR (Legacy)
				RaidDifficultyText:SetText(format("|cff09ff00%s |r", "LFR"))
			elseif difficulty == 8 then -- Mythic Keystone
				RaidDifficultyText:SetText(format("|cffff0000%s |r", "M+"..mplusdiff))
			elseif difficulty == 9 then -- 40 Player
				RaidDifficultyText:SetText('40R')
			elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
				RaidDifficultyText:SetText('HScen')
			elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
				RaidDifficultyText:SetText('Scen')
			elseif difficulty == 40 then -- Mythic Scenario
				RaidDifficultyText:SetText('MScen')
			elseif difficulty == 14 then -- Normal Raid
				RaidDifficultyText:SetText(format("|cff09ff00%s |r", "N:"..numplayers))
			elseif difficulty == 15 then -- Heroic Raid
				RaidDifficultyText:SetText(format("|cffff7d0a%s |r", "H:"..numplayers))
			elseif difficulty == 16 then -- Mythic Raid
				RaidDifficultyText:SetText(format("|cffff0000%s |r", "M"))
			elseif difficulty == 17 then -- LFR
				RaidDifficultyText:SetText(format("|cff09ff00%s |r", "LFR:"..numplayers))
			elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
				RaidDifficultyText:SetText('EScen')
			elseif difficulty == 23 then -- Mythic Party
				RaidDifficultyText:SetText('5'..myth)
			elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
				RaidDifficultyText:SetText('TW')
			elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
				RaidDifficultyText:SetText(format("|cffFFFF00%s |r", 'PVP'))
			elseif difficulty == 29 then -- PvEvP Scenario
				RaidDifficultyText:SetText('PvEvP')
			elseif difficulty == 147 then -- Normal Scenario (Warfronts)
				RaidDifficultyText:SetText('WF')
			elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
				RaidDifficultyText:SetText('HWF')
			end
		elseif instanceType == 'pvp' or instanceType == 'arena' then
			RaidDifficultyText:SetText(format("|cffFFFF00%s |r", 'PVP'))
		else
			RaidDifficultyText:SetText('')
		end

		if not IsInInstance() then
			RaidDifficultyText:Hide()
		else
			RaidDifficultyText:Show()
		end
	end)

	-- Hide Blizz
	local frames = {
		'MiniMapInstanceDifficulty',
		'GuildInstanceDifficulty',
		'MiniMapChallengeMode',
	}

	for _, v in pairs(frames) do
		_G[v]:Kill()
	end
end

function module:StyleMinimap()
	Minimap:Styling(true, true, false, 180, 180, .75)

	-- QueueStatus Button
	_G.QueueStatusMinimapButtonBorder:Hide()
	_G.QueueStatusMinimapButtonIconTexture:SetTexture(nil)

	local queueIcon = Minimap:CreateTexture(nil, "ARTWORK")
	queueIcon:SetPoint("CENTER", _G.QueueStatusMinimapButton)
	queueIcon:SetSize(50, 50)
	queueIcon:SetTexture("Interface\\Minimap\\Raid_Icon")

	local anim = queueIcon:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	anim.rota = anim:CreateAnimation("Rotation")
	anim.rota:SetDuration(2)
	anim.rota:SetDegrees(360)

	hooksecurefunc("QueueStatusFrame_Update", function()
		queueIcon:SetShown(_G.QueueStatusMinimapButton:IsShown())
	end)
	hooksecurefunc("EyeTemplate_StartAnimating", function() anim:Play() end)
	hooksecurefunc("EyeTemplate_StopAnimating", function() anim:Stop() end)
end

function module:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	local db = E.db.mui.maps
	MER:RegisterDB(self, "minimap")

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
		Minimap.backdrop:SetBackdrop({
			edgeFile = E.LSM:Fetch("statusbar", "MerathilisGradient"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
	end

	self:MiniMapCoords()
	self:MiniMapPing()
	self:StyleMinimap()
	self:RaidDifficulty()

	if E.db.mui.maps.minimap.flash then
		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
		self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckMail")
	end
end

MER:RegisterModule(module:GetName())
