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

	-- Difficulty Flags
	local flags = {"MiniMapInstanceDifficulty", "GuildInstanceDifficulty", "MiniMapChallengeMode"}
	for _, v in pairs(flags) do
		local flag = _G[v]
		flag:SetScale(.75)
	end
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

	if E.db.mui.maps.minimap.flash then
		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
		self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckMail")
	end
end

MER:RegisterModule(module:GetName())
