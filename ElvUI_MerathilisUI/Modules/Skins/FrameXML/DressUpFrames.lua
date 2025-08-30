local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local format = string.format

local CreateFrame = CreateFrame
local PlaySound = PlaySound
local hooksecurefunc = hooksecurefunc

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
		if not actor then
			return
		end
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

function module:DressUpFrame()
	if not module:CheckDB("dressingroom", "dressingroom") then
		return
	end

	module:CreateShadow(_G.DressUpFrame)
	module:CreateShadow(_G.DressUpFrame.OutfitDetailsPanel)
	module:CreateShadow(_G.DressUpFrame.SetSelectionPanel)
	-- Wardrobe edit frame
	module:CreateBackdropShadow(_G.WardrobeOutfitFrame)

	-- AuctionHouse
	module:CreateBackdropShadow(_G.SideDressUpFrame)

	-- Undress Button
	UndressButton()

	hooksecurefunc(_G.DressUpFrame.SetSelectionPanel.ScrollBox, "Update", function(box)
		box:ForEachFrame(function(frame)
			if frame.__MERSkin then
				return
			end
			F.SetFontOutline(frame.ItemName)
			local width = frame.ItemSlot:GetWidth()
			F.SetFontOutline(frame.ItemSlot)
			frame.ItemSlot:SetWidth(width + 4)

			frame.__MERSkin = true
		end)
	end)
end

module:AddCallback("DressUpFrame")
