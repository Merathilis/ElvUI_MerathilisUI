local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local B = E:GetModule("Bags")

local _G = _G
local pairs = pairs

function module:ElvUI_ContainerFrames()
	if not E.private.bags.enable then
		return
	end

	self:CreateShadow(B.BagFrame)
	self:CreateShadow(B.BagFrame.ContainerHolder)
	self:CreateShadow(B.BankFrame)
	self:CreateShadow(B.BankFrame.ContainerHolder)
end

function module:ContainerFrame()
	if E.private.bags.enable then
		return
	end

	for i = 1, _G.NUM_CONTAINER_FRAMES do
		local container = _G["ContainerFrame" .. i]
		if container and container.template then
			self:CreateShadow(container)
		end
	end

	self:CreateShadow(_G.ContainerFrameCombinedBags)

	-- Bank
	self:CreateShadow(_G.BankFrame)

	for _, frame in pairs({ _G.BankSlotsFrame, _G.ReagentBankFrame, _G.AccountBankPanel }) do
		if frame and frame.EdgeShadows then
			frame.EdgeShadows:SetAlpha(0)
		end
	end

	if _G.BankFrame.TabSystem then
		local tabSet = _G.BankFrame:GetTabSet()
		if tabSet then
			for _, tabID in ipairs(tabSet) do
				local tabButton = _G.BankFrame:GetTabButton(tabID)
				if tabButton then
					self:ReskinTab(tabButton)
				end
			end
		end
	end
end

module:AddCallback("ContainerFrame")
module:AddCallback("ElvUI_ContainerFrames")
