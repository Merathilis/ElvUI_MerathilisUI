local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = E:NewModule("mUIMinimap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
MM.modName = L["Minimap"]

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

function MM:ChangeLandingButton()
	if _G["GarrisonLandingPageMinimapButton"] then
		_G["GarrisonLandingPageMinimapButton"]:SetSize(30, 30) -- needs to be set.
		_G["GarrisonLandingPageMinimapButton"]:HookScript("OnEvent", function(self)
			self:GetNormalTexture():SetAtlas(nil)
			self:SetNormalTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Home")
			self:GetNormalTexture():SetBlendMode("ADD")
			self:GetNormalTexture():SetSize(20, 20)
			self:GetNormalTexture():ClearAllPoints()
			self:GetNormalTexture():SetPoint("CENTER", 0, 1)

			self:GetPushedTexture():SetAtlas(nil)
			self:SetPushedTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Home")
			self:GetPushedTexture():SetBlendMode("ADD")
			self:GetPushedTexture():SetSize(20, 20)
			self:GetPushedTexture():ClearAllPoints()
			self:GetPushedTexture():SetPoint("CENTER", 1, 0)
			self:GetPushedTexture():SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		end)
	end
end

function MM:Initialize()
	self:ChangeLandingButton()
end

local function InitializeCallback()
	MM:Initialize()
end

E:RegisterModule(MM:GetName(), InitializeCallback)