local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = E:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["Minimap"]

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
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

function MM:Initialize()
	self:ChangeLandingButton()

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