local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = MER:GetModule("muiSkins")
local B = E:GetModule("Bags")
MERB.modName = L["Bags"]

--Cache global variables
--Lua Variables
local ipairs, pairs = ipairs, pairs
local floor = math.floor
--WoW API / Variables
local GetContainerNumSlots = GetContainerNumSlots
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERB:SkinBags()
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:Styling()
		ElvUI_ContainerFrameContainerHolder:Styling()
	end

	if ElvUIBags then
		ElvUIBags.backdrop:Styling()
	end
end

function MERB:SkinBank()
	if ElvUI_BankContainerFrame then
		ElvUI_BankContainerFrame:Styling()
		ElvUI_BankContainerFrameContainerHolder:Styling()
	end
end

function MERB:ReskinSellFrame()
	if B.SellFrame then
		B.SellFrame:Styling()
		B.SellFrame.statusbar:SetStatusBarColor(unpack(E["media"].rgbvaluecolor))
	end
end
hooksecurefunc(B, "CreateSellFrame", MERB.ReskinSellFrame)

function MERB:AllInOneBags()
	self:SkinBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'SkinBank')
end

function MERB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Styling()
		end
	end

	if BankFrame then
		BankFrame:Styling()
	end
end

-- Transparent Slots
function MERB:HookBags(isBank)
	local slot
	for _, bagFrame in pairs(B.BagFrames) do
		--Applying transparent template for all current slots
		for _, bagID in pairs(bagFrame.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				if bagFrame.Bags[bagID] then
					slot = bagFrame.Bags[bagID][slotID];
					if E.db.mui.bags.transparentSlots and slot.template ~= "Transparent" then
						slot:SetTemplate('Transparent')
					end
				end
			end
		end
	end

	--Applying transparent template for reagent bank
	if E.db.mui.bags.transparentSlots and _G["ElvUIReagentBankFrameItem1"] and _G["ElvUIReagentBankFrameItem1"].template ~= "Transparent" then
		for slotID = 1, 98 do
			local slot = _G["ElvUIReagentBankFrameItem"..slotID];
			if slot.template ~= "Transparent" then slot:SetTemplate('Transparent') end
		end
	end
end


function MERB:Initialize()
	if E.private.bags.enable ~= true then return end

	self:AllInOneBags()
	self:SkinBlizzBags()
	self:SkinBank()
	self:HookBags();
	hooksecurefunc(B, "Layout", function(self, isBank)
		MERB:HookBags(isBank)
	end)

	--This table is for initial update of a frame, cause applying transparent template breaks color borders
	MERB.InitialUpdates = {
		Bank = false,
		ReagentBank = false,
		ReagentBankButton = false,
	}

	--Fix borders for bag frames
	hooksecurefunc(B, "OpenBank", function()
		if not MERB.InitialUpdates.Bank then --For bank, just update on first show
			B:Layout(true)
			MERB.InitialUpdates.Bank = true
		end

		if not MERB.InitialUpdates.ReagentBankButton then --For reagent bank, hook to toggle button and update layout when first clicked
			_G["ElvUI_BankContainerFrame"].reagentToggle:HookScript("OnClick", function()
				if not MERB.InitialUpdates.ReagentBank then
					B:Layout(true)
					MERB.InitialUpdates.ReagentBank = true
				end
			end)
			MERB.InitialUpdates.ReagentBankButton = true
		end
	end)
end

local function InitializeCallback()
	MERB:Initialize()
end

MER:RegisterModule(MERB:GetName(), InitializeCallback)
