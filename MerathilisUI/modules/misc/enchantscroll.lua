local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local S = E:GetModule('Skins')

-- Cache global variables
-- GLOBALS: TradeSkillFrame_SetSelection, CURRENT_TRADESKILL, UseItemByName, DoTradeSkill
local _G = _G
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local IsTradeSkillLinked = IsTradeSkillLinked
local IsTradeSkillGuild = IsTradeSkillGuild
local GetItemCount = GetItemCount
local GetTradeSkillInfo = GetTradeSkillInfo
local GetSpellInfo = GetSpellInfo
local GetTradeSkillNumReagents = GetTradeSkillNumReagents
local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Blizzard_TradeSkillUI") and not IsAddOnLoaded("OneClickEnchantScroll") and E.db.muiMisc.enchantScroll then
		local oldfunc = _G["TradeSkillFrame_SetSelection"]
		local button = CreateFrame("Button", "TradeSkillCreateScrollButton", _G["TradeSkillFrame"], "MagicButtonTemplate")
		if E.private.skins.blizzard.tradeskill == true then
			S:HandleButton(button)
			button:StripTextures()
			button:SetTemplate('Default', true)
			button:ClearAllPoints()
			button:SetPoint("TOPRIGHT", _G["TradeSkillCreateButton"], "TOPLEFT", -1, 0)
		else
			button:SetPoint("TOPRIGHT", _G["TradeSkillCreateButton"], "TOPLEFT")
		end
		button:SetScript("OnClick", function()
			DoTradeSkill(_G["TradeSkillFrame"].selectedSkill)
			UseItemByName(38682)
		end)

		function TradeSkillFrame_SetSelection(id)
			oldfunc(id)
			local skillName, _, _, _, altVerb = GetTradeSkillInfo(id)
			if IsTradeSkillGuild() or IsTradeSkillLinked() then
				button:Hide()
			elseif altVerb and CURRENT_TRADESKILL == GetSpellInfo(7411) then
				button:Show()
				local creatable = 1
				if not skillName then
					creatable = nil
				end
				local scrollnum = GetItemCount(38682)
				_G["TradeSkillCreateScrollButton"]:SetText(L['MISC_SCROLL'].." ("..scrollnum..")")
				if scrollnum == 0 then
					creatable = nil
				end
				for i = 1, GetTradeSkillNumReagents(id) do
					local _, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
					if playerReagentCount < reagentCount then
						creatable = nil
					end
				end
				if creatable then
					_G["TradeSkillCreateScrollButton"]:Enable()
				else
					_G["TradeSkillCreateScrollButton"]:Disable()
				end
			else
				button:Hide()
			end
		end
	end
end)
