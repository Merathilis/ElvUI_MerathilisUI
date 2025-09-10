local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local C_Timer_After = C_Timer.After

function module:Blizzard_PlayerSpells()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local frame = _G.PlayerSpellsFrame
	self:CreateShadow(frame)

	self:CreateBackdropShadow(_G.ClassTalentLoadoutImportDialog)
	self:CreateBackdropShadow(_G.ClassTalentLoadoutEditDialog)

	for _, tab in next, { frame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
		tab:SetPushedTextOffset(0, 0)
	end

	local SpellBookFrame = _G.PlayerSpellsFrame.SpellBookFrame
	if SpellBookFrame then
		local function CenterTabText(tab)
			if tab.Text and not tab.__MERTextCentered then
				C_Timer_After(0.05, function()
					if tab.Text and not tab.__MERTextCentered then
						tab.Text:ClearAllPoints()
						tab.Text:SetPoint("CENTER", tab, "CENTER", 0, 0)
						tab.__MERTextCentered = true
					end
				end)
			end
		end

		for _, tab in next, { SpellBookFrame.CategoryTabSystem:GetChildren() } do
			tab:SetPushedTextOffset(0, 0)
			CenterTabText(tab)
		end
	end

	local TalentsSelect = _G.HeroTalentsSelectionDialog
	if TalentsSelect then
		hooksecurefunc(TalentsSelect, "ShowDialog", function(frame)
			if not frame.__MERSkin then
				self:HighAlphaTransparent(TalentsSelect)
				frame.__MERSkin = true
			end
		end)
	end
end

module:AddCallbackForAddon("Blizzard_PlayerSpells")
