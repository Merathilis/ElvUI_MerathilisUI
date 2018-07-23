local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function styleCommunities()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.Communities ~= true or E.private.muiSkins.blizzard.communities ~= true then return end

	_G["CommunitiesFrame"]:Styling()

	-- Left Communities Buttons
	hooksecurefunc(CommunitiesListEntryMixin, "SetClubInfo", function(self, clubInfo)
		if clubInfo then
			-- Hide the ElvUI backdrop
			if self.bg then
				self.bg:Hide()
			end

			self:Styling()
		end
	end)

	hooksecurefunc(CommunitiesListEntryMixin, "SetAddCommunity", function(self)
		-- Hide ElvUI backdrop
		if self.bg then
			self.bg:Hide()
		end

		self:Styling()
	end)

	for i = 1, 5 do
		local button = _G["CommunitiesFrameContainerButton"..i]
		if button.backdrop then
			button.backdrop:Hide()
		end
		local bg = MERS:CreateBDFrame(button, 0)
		MERS:CreateBD(bg, .25)
	end

	-- Guild Rewards
	hooksecurefunc("CommunitiesGuildRewards_Update", function(self)
		local scrollFrame = self.RewardsContainer
		local offset = HybridScrollFrame_GetOffset(scrollFrame)
		local buttons = scrollFrame.buttons
		local button, index
		local numButtons = #buttons

		for i = 1, numButtons do
			button = buttons[i]
			index = offset + i

			-- Hide the ElvUI backdrop
			if button.backdrop then
				button.backdrop:Hide()
			end

			MERS:CreateBD(button, .25)

			button.index = index
		end
	end)
end

S:AddCallbackForAddon("Blizzard_Communities", "mUICommunities", styleCommunities)