local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0")
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
	-- doesnt work
	if _G["ElvUI_ContainerFrame"] then
		_G["ElvUI_ContainerFrame"]:Styling(true, true)
		_G["ElvUI_ContainerFrameContainerHolder"]:Styling(true, true)
	end

	if _G["ElvUIBags"] then
		-- doesnt work
		_G["ElvUIBags"]:Styling(true, true)
		_G["ElvUIBags"]:Styling(true, true)
	end
end

function MERB:StyleBank()
	-- doesnt work
	if _G["ElvUI_BankContainerFrame"] then
		if _G["ElvUI_BankContainerFrame"].isSkinned then return end
		_G["ElvUI_BankContainerFrame"]:Styling(true, true)
		_G["ElvUI_BankContainerFrameContainerHolder"]:Styling(true, true)

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