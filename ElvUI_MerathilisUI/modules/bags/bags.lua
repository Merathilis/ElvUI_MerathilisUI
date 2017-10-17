local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0")
local MERS = E:GetModule("muiSkins")
local B = E:GetModule("Bags")

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
	if ElvUI_ContainerFrame then
		MERS:CreateGradient(ElvUI_ContainerFrame)
		MERS:CreateStripes(ElvUI_ContainerFrame)
		MERS:CreateGradient(ElvUI_ContainerFrameContainerHolder)
		MERS:CreateStripes(ElvUI_ContainerFrameContainerHolder)
	end

	if ElvUIBags then
		MERS:CreateGradient(ElvUIBags)
		MERS:CreateStripes(ElvUIBags)
	end
end

function MERB:StyleBank()
	if ElvUI_BankContainerFrame then
		if ElvUI_BankContainerFrame.isSkinned then return end
		MERS:CreateGradient(ElvUI_BankContainerFrame)
		MERS:CreateStripes(ElvUI_BankContainerFrame)
		MERS:CreateGradient(ElvUI_BankContainerFrameContainerHolder)
		MERS:CreateStripes(ElvUI_BankContainerFrameContainerHolder)

		ElvUI_BankContainerFrame.isSkinned = true
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