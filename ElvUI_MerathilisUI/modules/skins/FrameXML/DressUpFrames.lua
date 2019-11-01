local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
local format = string.format
local CreateFrame = CreateFrame
local PlaySound = PlaySound
-- GLOBALS:

local function UndressButton()
	local Button = CreateFrame("Button", nil, _G.DressUpFrame, "UIPanelButtonTemplate")
	Button:SetText(format("|cff70C0F5%s", L["Undress"]))
	Button:SetHeight(_G.DressUpFrameResetButton:GetHeight())
	Button:SetWidth(Button:GetTextWidth() + 40)
	Button:SetPoint("RIGHT", _G.DressUpFrameResetButton, "LEFT", -2, 0)
	Button:RegisterForClicks("AnyUp")
	S:HandleButton(Button)

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
	Button.model = _G.DressUpFrame.ModelScene

	Button:RegisterEvent("AUCTION_HOUSE_SHOW")
	Button:RegisterEvent("AUCTION_HOUSE_CLOSED")
	Button:SetScript("OnEvent", function(self)
		if _G.AuctionFrame:IsVisible() and self.model ~= _G.SideDressUpFrame.ModelScene then
			self:SetParent(_G.SideDressUpFrame.ModelScene)
			self:ClearAllPoints()
			self:SetPoint("BOTTOM", _G.SideDressUpFrame.ResetButton, "TOP", 0, 3)
			self.model = _G.SideDressUpFrame.ModelScene
		elseif self.model ~= _G.DressUpFrame.ModelScene then
			self:SetParent(_G.DressUpFrame.ModelScene)
			self:ClearAllPoints()
			self:SetPoint("RIGHT", _G.DressUpFrameResetButton, "LEFT", -2, 0)
			self.model = _G.DressUpFrame.ModelScene
		end
	end)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.muiSkins.blizzard.dressingroom ~= true then return end

	_G.DressUpFrame:Styling()

	-- Wardrobe edit frame
	_G.WardrobeOutfitFrame:Styling()

	-- AuctionHouse
	_G.SideDressUpFrame:Styling()

	-- Undress Button
	UndressButton()
end

S:AddCallback("mUIDressingRoom", LoadSkin)
