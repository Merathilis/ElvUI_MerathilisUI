local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, select, unpack = ipairs, select, unpack
-- WoW API
local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

-- Copied from ElvUI
local function HandleAffixIcons(self)
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.bg then
			frame.bg = MERS:ReskinIcon(frame.Portrait)
		end

		if frame.info then
			frame.Portrait:SetTexture(_G.CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode_GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end

-- Angy Keystone Skinning
local angryStyle
local function UpdateIcons(self)
	if IsAddOnLoaded("AngryKeystones") and not angryStyle then
		local scheduel, party = select(4, self:GetChildren())
		scheduel:GetRegions():SetAlpha(0)
		select(3, scheduel:GetRegions()):SetAlpha(0)
		MERS:CreateBD(scheduel, .3)
		if scheduel.Entries then
			for i = 1, 3 do
				HandleAffixIcons(scheduel.Entries[i])
			end
		end

		party:GetRegions():SetAlpha(0)
		select(3, party:GetRegions()):SetAlpha(0)
		MERS:CreateBD(party, .3)
		angryStyle = true
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.challenges ~= true then return end

	local KeyStoneFrame = _G.ChallengesKeystoneFrame
	KeyStoneFrame:Styling()

	hooksecurefunc("ChallengesFrame_Update", UpdateIcons)
end

S:AddCallbackForAddon("Blizzard_ChallengesUI", "mUIChallenges", LoadSkin)
