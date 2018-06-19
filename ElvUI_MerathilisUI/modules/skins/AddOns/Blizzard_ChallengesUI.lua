local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleChallenges()
	if E.private.skins.blizzard.enable ~= true or E.private.muiSkins.blizzard.challenges ~= true then return end

	--[[ AddOns\Blizzard_ChallengesUI.lua ]]
	function MERS.ChallengesFrame_Update(self)
		for i, icon in ipairs(self.DungeonIcons) do
			if i > (self._skinnedIcons or 0) then
				MERS:ChallengesDungeonIconFrameTemplate(icon)
				self._skinnedIcons = i
			end
		end
	end

	function MERS.ChallengesKeystoneFrameMixin_Reset(self)
		self:GetRegions():Hide()
		self.InstructionBackground:Hide()
	end

	function Hook.ChallengesKeystoneFrameMixin_OnKeystoneSlotted(self, affixInfo)
		for i, affix in ipairs(self.Affixes) do
			if i > (self._skinnedAffixes or 0) then
				MERS:ChallengesKeystoneFrameAffixTemplate(affix)
				self._skinnedAffixes = i
			end

			affix.Portrait:SetTexture(nil)
			if affix.info then
				affix.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[affix.info.key].texture)
			elseif affix.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(affix.affixID)
				affix.Portrait:SetTexture(filedataid)
			end
		end
	end

	--[[ AddOns\Blizzard_ChallengesUI.xml ]]
	function MERS:ChallengesDungeonIconFrameTemplate(Frame)
		Frame:GetRegions():Hide()
		S:CropIcon(Frame.Icon, Frame)
	end

	function MERS:ChallengesKeystoneFrameAffixTemplate(Frame)
		Frame.Border:Hide()
		S:CropIcon(Frame.Portrait)
	end

	hooksecurefunc("ChallengesFrame_Update", MERS.ChallengesFrame_Update)

	-----------------------------
	-- ChallengesKeystoneFrame --
	-----------------------------
	-- /run ChallengesKeystoneFrame:Show()
	local ChallengesKeystoneFrame = _G["ChallengesKeystoneFrame"]
	hooksecurefunc(ChallengesKeystoneFrame, "Reset", MERS.ChallengesKeystoneFrameMixin_Reset)
	hooksecurefunc(ChallengesKeystoneFrame, "OnKeystoneSlotted", MERS.ChallengesKeystoneFrameMixin_OnKeystoneSlotted)

	ChallengesKeystoneFrame:GetRegions():Hide()

	---------------------
	-- ChallengesFrame --
	---------------------
	local ChallengesFrame = _G["ChallengesFrame"]
	MERS:InsetFrameTemplate(ChallengesFrameInset)

	ChallengesFrame.WeeklyInfo:SetPoint("TOPLEFT")
	ChallengesFrame.WeeklyInfo:SetPoint("BOTTOMRIGHT")
	MERS:ChallengesKeystoneFrameAffixTemplate(ChallengesFrame.WeeklyInfo.Child.Affixes[1])

	local bg, inset = ChallengesFrame:GetRegions()
	bg:Hide()
	inset:Hide()
end

S:AddCallbackForAddon("Blizzard_ChallengesUI", "mUIChallenges", styleChallenges)