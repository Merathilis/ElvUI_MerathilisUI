local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = MER:GetModule("muiSkins")
local B = E:GetModule("Bags")

--Cache global variables
--Lua Variables
local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local floor = math.floor
--WoW API / Variables
local GetContainerNumSlots = GetContainerNumSlots
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function module:SkinBags()
	if _G.ElvUI_ContainerFrame then
		_G.ElvUI_ContainerFrame:Styling()
		_G.ElvUI_ContainerFrameContainerHolder:Styling()
	end

	if _G.ElvUIBags then
		_G.ElvUIBags.backdrop:Styling()
	end
end

function module:SkinBank()
	if _G.ElvUI_BankContainerFrame then
		_G.ElvUI_BankContainerFrame:Styling()
		_G.ElvUI_BankContainerFrameContainerHolder:Styling()
	end
end

function module:ReskinSellFrame()
	if B.SellFrame then
		B.SellFrame:Styling()
		B.SellFrame.statusbar:SetStatusBarColor(unpack(E["media"].rgbvaluecolor))
	end
end
hooksecurefunc(B, "CreateSellFrame", module.ReskinSellFrame)

function module:AllInOneBags()
	self:SkinBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'SkinBank')
end

function module:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, _G.NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Styling()
		end
	end

	if _G.BankFrame then
		_G.BankFrame:Styling()
	end
end

-- Transparent Slots
function module:HookBags(isBank)
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


function module:Initialize()
	if E.private.bags.enable ~= true then return end

	module.db = E.db.mui.bags.equipoverlay
	MER:RegisterDB(self, "bags")

	self:AllInOneBags()
	self:SkinBlizzBags()
	self:SkinBank()
	self:HookBags();
	hooksecurefunc(B, "Layout", function(self, isBank)
		module:HookBags(isBank)
	end)

	--This table is for initial update of a frame, cause applying transparent template breaks color borders
	module.InitialUpdates = {
		Bank = false,
		ReagentBank = false,
		ReagentBankButton = false,
	}

	--Fix borders for bag frames
	hooksecurefunc(B, "OpenBank", function()
		if not module.InitialUpdates.Bank then --For bank, just update on first show
			B:Layout(true)
			module.InitialUpdates.Bank = true
		end

		if not module.InitialUpdates.ReagentBankButton then --For reagent bank, hook to toggle button and update layout when first clicked
			_G["ElvUI_BankContainerFrame"].reagentToggle:HookScript("OnClick", function()
				if not module.InitialUpdates.ReagentBank then
					B:Layout(true)
					module.InitialUpdates.ReagentBank = true
				end
			end)
			module.InitialUpdates.ReagentBankButton = true
		end
	end)
end

MER:RegisterModule(module:GetName())
