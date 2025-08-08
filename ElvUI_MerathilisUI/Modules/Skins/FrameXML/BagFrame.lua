local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local select = select

local function SkinTabButton(self, btn)
	if not btn or btn.__MERSkin or btn.GetObjectType and btn:GetObjectType() ~= "Button" then
		return
	end
	self:ReskinTab(btn)
	self:CreateShadow(btn)
	btn.__MERSkin = true
end

local function HookBankTabPool(self, panel)
	local pool = panel and panel.bankTabPool
	if not pool or pool.__MERHook then
		return
	end
	pool.__MERHook = true

	hooksecurefunc(pool, "Acquire", function(p)
		for tab in p:EnumerateActive() do
			SkinTabButton(self, tab)
		end
	end)
end

local function HookItemButtonPool(self, panel)
	local pool = panel and panel.itemButtonPool
	if not pool or pool.__MERHook then
		return
	end
	pool.__MERHook = true

	hooksecurefunc(pool, "Acquire", function(p)
		for button in p:EnumerateActive() do
			if not button.__MERSkin then
				self:CreateShadow(button)
				button.__MERSkin = true
			end
		end
	end)
end

local function SkinBottomTabSystem(self, frame)
	if not frame then
		return
	end

	local function SkinAllTabs()
		if frame.TabSystem then
			for i = 1, frame.TabSystem:GetNumChildren() do
				local child = select(i, frame.TabSystem:GetChildren())
				SkinTabButton(self, child)
			end
		end
	end

	SkinAllTabs()
end

local function SkinBankPanelControls(self, panel)
	if not panel then
		return
	end

	HookBankTabPool(self, panel)
	HookItemButtonPool(self, panel)

	if panel.AutoDepositFrame and panel.AutoDepositFrame.DepositButton then
		local depositBtn = panel.AutoDepositFrame.DepositButton
		if not depositBtn.__MERSkin then
			self:CreateShadow(depositBtn)
			depositBtn.__MERSkin = true
		end
	end

	if panel.AutoSortButton then
		if not panel.AutoSortButton.__MERSkin then
			self:CreateShadow(panel.AutoSortButton)
			panel.AutoSortButton.__MERSkin = true
		end
	end

	if panel.EdgeShadows then
		panel.EdgeShadows:SetAlpha(0)
	end
end

local function SkinSearchBox(self)
	if _G.BankItemSearchBox and _G.BankItemSearchBox.backdrop then
		local searchBox = _G.BankItemSearchBox.backdrop
		if not searchBox.__MERSkin then
			self:CreateShadow(searchBox)
			searchBox.__MERSkin = true
		end
	end
end

function module:ContainerFrame()
	if E.private.bags.enable or not self:CheckDB("bags") then
		return
	end

	local bankFrame = _G.BankFrame
	local bankPanel = _G.BankPanel

	if bankFrame and not bankFrame.__MERSkin then
		self:CreateShadow(bankFrame)
		bankFrame.__MERSkin = true
	end

	if bankPanel and not bankPanel.__MERSkin then
		self:CreateShadow(bankPanel)
		bankPanel.__MERSkin = true
	end

	SkinBankPanelControls(self, bankPanel)
	SkinBottomTabSystem(self, bankFrame)
	SkinSearchBox(self)
end

module:AddCallback("ContainerFrame")
