local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local LSM = LibStub('LibSharedMedia-3.0')
local MM = E:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["MiniMap"]

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
local format = string.format
--WoW API / Variables
local CalendarGetNumPendingInvites = CalendarGetNumPendingInvites
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
--local GetPlayerMapPosition = GetPlayerMapPosition
local Minimap = _G["Minimap"]
local SetMapToCurrentZone = SetMapToCurrentZone
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

function MM:ReskinMinimap()
	if not Minimap.IsSkinned then
		Minimap:CreateBackdrop("Default", true)
		Minimap.backdrop:SetBackdrop({
			edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(2),
			insets = {left = E:Scale(2), right = E:Scale(2), top = E:Scale(2), bottom = E:Scale(2)},
		})
		_G["Minimap"]:Styling(true, true, false, 180, 180, .75)

		Minimap.IsSkinned = true
	end
end

function MM:CheckMail()
	local inv = CalendarGetNumPendingInvites()
	local mail = _G["MiniMapMailFrame"]:IsShown() and true or false
	if inv > 0 and mail then -- New invites and mail
		Minimap.backdrop:SetBackdropBorderColor(242, 5/255, 5/255)
		MER:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		Minimap.backdrop:SetBackdropBorderColor(1, 30/255, 60/255)
		MER:CreatePulse(Minimap.backdrop, 1, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		Minimap.backdrop:SetBackdropBorderColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
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

function MM:ChangeMiniMapButtons()
	--Garrison Icon
	if _G["GarrisonLandingPageMinimapButton"] then
		local scale = E.db.general.minimap.icons.classHall.scale or 1

		_G["GarrisonLandingPageMinimapButton"]:SetScale(scale) -- needs to be set.
		_G["GarrisonLandingPageMinimapButton"].LoopingGlow:Size(_G["GarrisonLandingPageMinimapButton"]:GetSize()*0.75)
		_G["GarrisonLandingPageMinimapButton"]:HookScript("OnEvent", function(self)
			self:GetNormalTexture():SetAtlas(nil)
			self:SetNormalTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Home")
			self:GetNormalTexture():SetBlendMode("ADD")
			self:GetNormalTexture():ClearAllPoints()
			self:GetNormalTexture():SetPoint("CENTER", 0, 1)

			self:SetPushedTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Home")
			self:GetPushedTexture():SetBlendMode("ADD")
			self:GetPushedTexture():ClearAllPoints()
			self:GetPushedTexture():SetPoint("CENTER", 1, 0)
			self:GetPushedTexture():SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		end)
	end
end

function MM:MiniMapCoords()
	if E.db.mui.maps.minimap.coords.enable ~= true then return end

	local pos = E.db.mui.maps.minimap.coords.position or "BOTTOM"
	local Coords = MER:CreateText(Minimap, "OVERLAY", 12, "OUTLINE", "CENTER")
	Coords:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	Coords:SetPoint(pos, 0, 0)
	Coords:Hide()

	--Minimap:HookScript("OnUpdate",function()
		--if select(2, GetInstanceInfo()) == "none" then
			--local x,y = GetPlayerMapPosition("player")
			--if x>0 or y>0 then
				--Coords:SetText(format("%d,%d",x*100,y*100))
			--else
				--Coords:SetText("")
			--end
		--end
	--end)
--
	Minimap:HookScript("OnEvent",function(self,event,...)
		if event == "ZONE_CHANGED_NEW_AREA" and not _G["WorldMapFrame"]:IsShown() then
			SetMapToCurrentZone()
		end
	end)

	_G["WorldMapFrame"]:HookScript("OnHide", SetMapToCurrentZone)
	Minimap:HookScript("OnEnter", function() Coords:Show() end)
	Minimap:HookScript("OnLeave", function() Coords:Hide() end)
end

function MM:Initialize()
	if E.private.general.minimap.enable ~= true then return end

	self:ReskinMinimap()
	self:ChangeMiniMapButtons()
	self:MiniMapCoords()
	self:ButtonCollectorInit()

	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckMail")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckMail")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckMail")
	self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckMail")
	self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckMail")
end

local function InitializeCallback()
	MM:Initialize()
end

E:RegisterModule(MM:GetName(), InitializeCallback)