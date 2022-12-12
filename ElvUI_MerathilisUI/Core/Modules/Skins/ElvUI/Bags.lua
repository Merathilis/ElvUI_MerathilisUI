local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Bags')
local S = MER:GetModule('MER_Skins')
local B = E:GetModule('Bags')

local _G = _G
local pairs = pairs

local hooksecurefunc = hooksecurefunc

function S:ElvUI_Bags()
	if not E.private.bags.enable then
		return
	end

	self:CreateShadow(B.BagFrame)
	self:CreateShadow(B.BagFrame.ContainerHolder)
	self:CreateShadow(B.BankFrame)
	self:CreateShadow(B.BankFrame.ContainerHolder)
end

function S:ElvUI_BagBar()
	if E.private.bags.bagBar and B.BagBar and B.BagBar.buttons then
		for _, buttons in pairs(B.BagBar.buttons) do
			self:CreateShadow(buttons)
		end
	end
end

function S:ElvUI_BagSell()
	if B and B.SellFrame then
		self:CreateBackdropShadow(B.SellFrame)
	end
end

function S:Initialize()
	if E.private.bags.enable ~= true then return end

	module.db = E.db.mui.bags.equipoverlay

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

		if E.Retail then
			if not module.InitialUpdates.ReagentBankButton then --For reagent bank, hook to toggle button and update layout when first clicked
				_G["ElvUI_BankContainerFrame"].reagentToggle:HookScript("OnClick", function()
					if not module.InitialUpdates.ReagentBank then
						B:Layout(true)
						module.InitialUpdates.ReagentBank = true
					end
				end)
				module.InitialUpdates.ReagentBankButton = true
			end
		end
	end)
end

MER:RegisterModule(S:GetName())
S:AddCallback("ElvUI_Bags")
S:AddCallback("ElvUI_BagBar")
S:AddCallback("ElvUI_BagSell")
