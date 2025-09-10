local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

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
		for _, tab in next, { SpellBookFrame.CategoryTabSystem:GetChildren() } do
			tab.Text:ClearAllPoints()
			tab.Text:Point("CENTER")
			F.InternalizeMethod(tab.Text, "SetPoint", true)
			tab:SetPushedTextOffset(0, 0)
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
