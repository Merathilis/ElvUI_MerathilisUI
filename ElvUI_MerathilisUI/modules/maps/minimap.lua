local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local MM = MER:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["MiniMap"]

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
local format = string.format
--WoW API / Variables
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local Minimap = _G["Minimap"]
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

function MM:CheckMail()
	local inv = C_Calendar_GetNumPendingInvites()
	local mail = _G["MiniMapMailFrame"]:IsShown() and true or false

	if inv > 0 and mail then -- New invites and mail
		Minimap.backdrop:SetBackdropBorderColor(242, 5/255, 5/255)
		MER:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		Minimap.backdrop:SetBackdropBorderColor(1, 30/255, 60/255)
		MER:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		Minimap.backdrop:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
		MER:CreatePulse(Minimap.backdrop, 1, 1)
	else -- None of the above
		Minimap.backdrop:SetScript("OnUpdate", nil)
		if not E.PixelMode then
			Minimap.backdrop:SetAlpha(1)
		else
			Minimap.backdrop:SetAlpha(0)
		end
		Minimap.backdrop:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end
end

function MM:MiniMapCoords()
	if E.db.mui.maps.minimap.coords.enable ~= true then return end

	local pos = E.db.mui.maps.minimap.coords.position or "BOTTOM"
	local Coords = MER:CreateText(Minimap, "OVERLAY", 12, "OUTLINE", "CENTER")
	Coords:SetTextColor(unpack(E["media"].rgbvaluecolor))
	Coords:SetPoint(pos, 0, 0)
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

function MM:MiniMapPing()
	if E.db.mui.maps.minimap.ping.enable ~= true then return end

	local pos = E.db.mui.maps.minimap.ping.position or "TOP"
	local xOffset = E.db.mui.maps.minimap.ping.xOffset or 0
	local yOffset = E.db.mui.maps.minimap.ping.yOffset or 0
	local f = CreateFrame("Frame", nil, Minimap)
	f:SetAllPoints()
	f.text = MERS:CreateFS(f, 8, "", false, pos, xOffset, yOffset)

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
		local _, unitClass = UnitClass(unit)
		local class = ElvUF.colors.class[unitClass]
		local name = GetUnitName(unit)

		anim:Stop()
		f.text:SetText(name)
		f.text:SetTextColor(class[1], class[2], class[3])
		anim:Play()
	end)
end

function MM:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
		Minimap.backdrop:SetBackdrop({
			edgeFile = E.LSM:Fetch("statusbar", "MerathilisGradient"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
	end

	self:MiniMapCoords()
	self:ButtonCollectorInit()
	self:MiniMapPing()

	if E.db.mui.maps.minimap.flash then
		self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
		self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckMail")
		self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckMail")
	end
end

local function InitializeCallback()
	MM:Initialize()
end

MER:RegisterModule(MM:GetName(), InitializeCallback)