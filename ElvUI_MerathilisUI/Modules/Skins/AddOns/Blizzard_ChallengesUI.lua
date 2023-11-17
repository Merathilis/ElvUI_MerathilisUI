local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local ipairs, select = ipairs, select

local hooksecurefunc = hooksecurefunc

local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Copied from ElvUI
local function HandleAffixIcons(self)
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.bg then
			frame.bg = module:ReskinIcon(frame.Portrait)
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
	if C_AddOns_IsAddOnLoaded("AngryKeystones") and not angryStyle then
		local scheduel, party = select(4, self:GetChildren())
		scheduel:GetRegions():SetAlpha(0)
		select(3, scheduel:GetRegions()):SetAlpha(0)
		scheduel:SetTemplate('Transparent')
		if scheduel.Entries then
			for i = 1, 3 do
				HandleAffixIcons(scheduel.Entries[i])
			end
		end

		--ToDO: Check this part
		-- party:GetRegions():SetAlpha(0)
		-- select(3, party:GetRegions()):SetAlpha(0)
		-- module:CreateBD(party, .3)
		angryStyle = true
	end
end

local function LoadSkin()
	if not module:CheckDB("lfg", "challenges") then
		return
	end

	local KeyStoneFrame = _G.ChallengesKeystoneFrame
	KeyStoneFrame:Styling()
	module:CreateBackdropShadow(KeyStoneFrame)

	hooksecurefunc(_G.ChallengesFrame, 'Update', UpdateIcons)
end

S:AddCallbackForAddon("Blizzard_ChallengesUI", LoadSkin)
