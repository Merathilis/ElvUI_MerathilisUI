local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0")
local MERS = E:GetModule("muiSkins")
local B = E:GetModule("Bags")

--Cache global variables
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function EventHandler(self, event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self:RegisterEvent("AUCTION_HOUSE_SHOW")
		self:RegisterEvent("AUCTION_HOUSE_CLOSED")
	elseif ( event == "AUCTION_HOUSE_SHOW" ) then
		B:OpenBags()
	elseif ( event == "AUCTION_HOUSE_CLOSED" ) then
		B:CloseBags()
	end
end

function MERB:StyleBags()
	if _G["ElvUI_ContainerFrame"] then
		MERS:CreateGradient(_G["ElvUI_ContainerFrame"])
		MERS:CreateStripes(_G["ElvUI_ContainerFrame"])
		MERS:CreateGradient(_G["ElvUI_ContainerFrameContainerHolder"])
		MERS:CreateStripes(_G["ElvUI_ContainerFrameContainerHolder"])
	end

	if _G["ElvUIBags"] then
		MERS:CreateGradient(_G["ElvUIBags"])
		MERS:CreateStripes(_G["ElvUIBags"])
	end
end

function MERB:StyleBank()
	if _G["ElvUI_BankContainerFrame"] then
		if _G["ElvUI_BankContainerFrame"].isSkinned then return end
		MERS:CreateGradient(_G["ElvUI_BankContainerFrame"])
		MERS:CreateStripes(_G["ElvUI_BankContainerFrame"])
		MERS:CreateGradient(_G["ElvUI_BankContainerFrameContainerHolder"])
		MERS:CreateStripes(_G["ElvUI_BankContainerFrameContainerHolder"])

		_G["ElvUI_BankContainerFrame"].isSkinned = true
	end
end

function MERB:init()
	self:StyleBags()
	self:RegisterEvent("BANKFRAME_OPENED", "StyleBank")
end

function MERB:Initialize()
	if E.private.bags.enable ~= true then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", EventHandler)

	self:StyleBank()
	self:init()
end

local function InitializeCallback()
	MERB:Initialize()
end

E:RegisterModule(MERB:GetName(), InitializeCallback)