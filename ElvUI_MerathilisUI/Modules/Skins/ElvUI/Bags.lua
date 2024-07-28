local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local B = E:GetModule("Bags")

local _G = _G
local pairs = pairs

local NUM_CONTAINER_FRAMES = NUM_CONTAINER_FRAMES

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
	print("hitsss")
	if E.private.bags.enable then
		return
	end

	for bagID = 1, NUM_CONTAINER_FRAMES do
		local container = _G["ContainerFrame" .. bagID]
		if container and container.template then
			self:CreateShadow(container)
		end
		print(container)
	end

	self:CreateShadow(_G.ContainerFrameCombinedBags)

	-- Bank
	self:CreateShadow(_G.BankFrame)

	for _, frame in pairs({ _G.BankSlotsFrame, _G.ReagentBankFrame, _G.AccountBankPanel }) do
		if frame and frame.EdgeShadows then
			frame.EdgeShadows:SetAlpha(0)
		end
	end

	for _, tab in pairs(_G.BankFrame.Tabs) do
		self:ReskinTab(tab)
	end
end

module:AddCallback("ContainerFrame")
module:AddCallback("ElvUI_ContainerFrames")
