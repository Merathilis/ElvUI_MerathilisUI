local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local ES = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local format = string.format
local CreateFrame = CreateFrame
local PlaySound = PlaySound

local function UndressButton()
	local Button = CreateFrame("Button", nil, _G.DressUpFrame, "UIPanelButtonTemplate")
	Button:SetText(format("|cff70C0F5%s", L["Undress"]))
	Button:SetHeight(_G.DressUpFrameResetButton:GetHeight())
	Button:SetWidth(Button:GetTextWidth() + 40)
	Button:SetPoint("RIGHT", _G.DressUpFrameResetButton, "LEFT", -2, 0)
	Button:RegisterForClicks("AnyUp")
	S:HandleButton(Button)

	Button.model = _G.DressUpFrame.ModelScene

	Button:SetScript("OnClick", function(self, button)
		local actor = self.model:GetPlayerActor()
		if not actor then return end
		if button == "RightButton" then
			actor:UndressSlot(19)
		else
			actor:Undress()
		end
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	end)

	Button:RegisterEvent("AUCTION_HOUSE_SHOW")
	Button:RegisterEvent("AUCTION_HOUSE_CLOSED")

	Button:SetScript("OnEvent", function(self)
		if self.model ~= _G.DressUpFrame.ModelScene then
			self:SetParent(_G.DressUpFrame.ModelScene)
			self:ClearAllPoints()
			self:SetPoint("RIGHT", _G.DressUpFrameResetButton, "LEFT", -2, 0)
			self.model = _G.DressUpFrame.ModelScene
		end
	end)
end

local function LoadSkin()
	if not module:CheckDB("dressingroom", "dressingroom") then
		return
	end

	_G.DressUpFrame:Styling()
	ES:CreateShadow(_G.DressUpFrame)

	_G.DressUpFrame.OutfitDetailsPanel:Styling()
	ES:CreateShadow(_G.DressUpFrame.OutfitDetailsPanel)

	-- Wardrobe edit frame
	_G.WardrobeOutfitFrame:Styling()
	ES:CreateBackdropShadow(_G.WardrobeOutfitFrame)

	-- AuctionHouse
	_G.SideDressUpFrame:Styling()
	ES:CreateBackdropShadow(_G.SideDressUpFrame)

	-- Undress Button
	UndressButton()
end

S:AddCallback("DressUpFrame", LoadSkin)
