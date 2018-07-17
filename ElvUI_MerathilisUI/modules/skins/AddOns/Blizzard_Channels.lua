local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleChannels()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Channels ~= true or E.private.muiSkins.blizzard.channels ~= true then return end

	--[[ AddOns\Blizzard_Channels.lua ]]
	--[[ ChannelButton.lua ]]
	MERS.ChannelButtonHeaderMixin = {}
	function MERS.ChannelButtonHeaderMixin:Update()
		local count = self:GetMemberCount()
		if count > 0 then
			self.Collapsed.minus:Show()
			if self:IsCollapsed() then
				self.Collapsed.plus:Show()
			else
				self.Collapsed.plus:Hide()
			end
		else
			self.Collapsed.minus:Hide()
			self.Collapsed.plus:Hide()
		end
	end

	--[[ ChannelRoster.lua ]]
	MERS.ChannelRosterMixin = {}
	function MERS.ChannelRosterMixin:UpdateRosterWidth()
		local rosterLeftEdge = self:GetChannelFrame().LeftInset:GetRight();
		local rosterRightEdge = self.ScrollFrame.scrollBar:GetLeft();

		if self:GetChannelFrame():GetList().ScrollBar:IsShown() then
			rosterLeftEdge = self:GetChannelFrame():GetList().ScrollBar:GetRight();
		end
	end

	--[[ AddOns\Blizzard_Channels.xml ]]
	--[[ ChannelButton.xml ]]
	function MERS:ChannelButtonBaseTemplate(Button)
		Button:SetSize(Button:GetSize())
		Button.Text:SetHeight(0)
		Button.Text:SetPoint("LEFT", 6, 0)
		Button.Text:SetPoint("RIGHT", -6, 0)
	end

	function MERS:ChannelButtonHeaderTemplate(Button)
		hooksecurefunc(Button, "Update", MERS.ChannelButtonHeaderMixin.Update)

		MERS:ChannelButtonBaseTemplate(Button)
		Button:SetNormalTexture("")
		Button:SetHighlightTexture("")

		Button.Collapsed:SetAlpha(0)
		local minus = Button:CreateTexture(nil, "OVERLAY")
		minus:SetPoint("TOPLEFT", Button.Collapsed, 0, -3)
		minus:SetPoint("BOTTOMRIGHT", Button.Collapsed, 0, 3)
		minus:SetColorTexture(1, 1, 1)
		Button.Collapsed.minus = minus

		local plus = Button:CreateTexture(nil, "OVERLAY")
		plus:SetPoint("TOPLEFT", Button.Collapsed, 3, 0)
		plus:SetPoint("BOTTOMRIGHT", Button.Collapsed, -3, 0)
		plus:SetColorTexture(1, 1, 1)
		Button.Collapsed.plus = plus

		--[[ Scale ]]--
		Button.Collapsed:SetSize(7, 7)
		Button.Collapsed:SetPoint("TOPRIGHT", -8, -6)
	end

	function MERS:ChannelButtonTemplate(Button)
		MERS:ChannelButtonBaseTemplate(Button)
	end

	function MERS:ChannelButtonTextTemplate(Button)
		MERS:ChannelButtonTemplate(Button)
	end

	function MERS:ChannelButtonVoiceTemplate(Button)
		MERS:ChannelButtonTemplate(Button)
	end

	function MERS:ChannelButtonCommunityTemplate(Button)
		MERS:ChannelButtonTemplate(Button)
	end

	--[[ RosterButton.xml ]]
	function MERS:ChannelRosterButtonTemplate(Button)
		Button:SetSize(Button:GetSize())
	end

	--[[ CreateChannelPopup.xml ]]
	function MERS:CreateChannelPopupEditBoxTemplate(EditBox)
		MERS:InputBoxTemplate(EditBox)
	end

	function MERS:CreateChannelPopupButtonTemplate(Button)
		MERS:UIPanelButtonTemplate(Button)
	end

	--[[ ChannelList.xml ]]
	function MERS:ChannelListTemplate(ScrollFrame)
		MERS:UIPanelStretchableArtScrollBarTemplate(ScrollFrame.ScrollBar)
	end

	--[[ ChannelRoster.xml ]]
	function MERS:ChannelRosterTemplate(Frame)
		hooksecurefunc(Frame, "UpdateRosterWidth", MERS.ChannelRosterMixin.UpdateRosterWidth)

		MERS:HybridScrollBarTemplate(Frame.ScrollFrame.scrollBar)
	end

	--       CreateChannelPopup       --
	----====####$$$$%%%%$$$$####====----
	local CreateChannelPopup = _G["CreateChannelPopup"]

	CreateChannelPopup.Titlebar:Hide()
	CreateChannelPopup.Corner:Hide()

	CreateChannelPopup.CloseButton:SetPoint("TOPRIGHT", -5, -5)
	CreateChannelPopup.OKButton:SetPoint("BOTTOMLEFT", 5, 5)
	CreateChannelPopup.CancelButton:ClearAllPoints()
	CreateChannelPopup.CancelButton:SetPoint("BOTTOMRIGHT", -5, 5)

	CreateChannelPopup:SetSize(212, 200)
	CreateChannelPopup.Name:SetPoint("TOPLEFT", 23, -60)
	CreateChannelPopup.Name.Label:SetPoint("BOTTOMLEFT", CreateChannelPopup.Name, "TOPLEFT", 0, 5)
	CreateChannelPopup.Password:SetPoint("TOPLEFT", CreateChannelPopup.Name, "BOTTOMLEFT", 0, -30)
	CreateChannelPopup.Password.Label:SetPoint("BOTTOMLEFT", CreateChannelPopup.Password, "TOPLEFT", 0, 5)
	CreateChannelPopup.UseVoiceChat:SetPoint("TOPLEFT", CreateChannelPopup.Password, "BOTTOMLEFT", -7, -14)

	--          ChannelFrame          --
	----====####$$$$%%%%$$$$####====----

	local ChannelFrame = _G["ChannelFrame"]
	ChannelFrame:Styling()
	MERS:ButtonFrameTemplate(ChannelFrame)
	ChannelFrame.Icon:Hide()

	ChannelFrame.NewButton:SetPoint("BOTTOMLEFT", 5, 5)
	MERS:ChannelListTemplate(ChannelFrame.ChannelList)

	ChannelFrame.ChannelList:SetPoint("TOPLEFT", 7, -(27 + 20))
	MERS:InsetFrameTemplate(ChannelFrame.LeftInset)
	MERS:ChannelRosterTemplate(ChannelFrame.ChannelRoster)
	ChannelFrame.ChannelRoster:SetPoint("TOPRIGHT", -20, -(27 + 20))
	ChannelFrame.ChannelRoster:SetPoint("BOTTOMRIGHT", -20, 28)
	MERS:InsetFrameTemplate(ChannelFrame.RightInset)

	ChannelFrame.ChannelList:SetWidth(178)
end

S:AddCallbackForAddon("Blizzard_Channels", "mUIChannels", styleChannels)