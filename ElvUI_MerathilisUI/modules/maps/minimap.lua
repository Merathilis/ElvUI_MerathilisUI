local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = E:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["MiniMap"]

--Cache global variables
--Lua functions
local _G = _G
local select = select
local format = string.format
--WoW API / Variables
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local GetPlayerMapPosition = GetPlayerMapPosition
local SetMapToCurrentZone = SetMapToCurrentZone
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local function blipIcons()
	_G["Minimap"]:SetBlipTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\blipIcons.tga")
end

function MM:ChangeLandingButton()
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

			self:GetPushedTexture():SetAtlas(nil)
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
	local Coords = Minimap:CreateFontString(nil, "OVERLAY")
	Coords:FontTemplate(nil, 12, "OUTLINE")
	Coords:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	Coords:SetPoint(pos, 0, 0)
	Coords:Hide()

	Minimap:HookScript("OnUpdate",function()
		if select(2, GetInstanceInfo()) == "none" then
			local x,y = GetPlayerMapPosition("player")
			if x>0 or y>0 then
				Coords:SetText(format("%d,%d",x*100,y*100))
			else
				Coords:SetText("")
			end
		end
	end)

	Minimap:HookScript("OnEvent",function(self,event,...)
		if event == "ZONE_CHANGED_NEW_AREA" and not WorldMapFrame:IsShown() then
			SetMapToCurrentZone()
		end
	end)

	WorldMapFrame:HookScript("OnHide", SetMapToCurrentZone)
	Minimap:HookScript("OnEnter", function() Coords:Show() end)
	Minimap:HookScript("OnLeave", function() Coords:Hide() end)
end

function MM:Initialize()
	self:ChangeLandingButton()
	self:MiniMapCoords()

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			blipIcons()
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

local function InitializeCallback()
	MM:Initialize()
end

E:RegisterModule(MM:GetName(), InitializeCallback)