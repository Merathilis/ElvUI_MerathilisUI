local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_PlayerSpells()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local frame = _G.PlayerSpellsFrame
	self:CreateShadow(frame)

	for _, tab in next, { frame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end

	self:CreateBackdropShadow(_G.ClassTalentLoadoutImportDialog)
	self:CreateBackdropShadow(_G.ClassTalentLoadoutEditDialog)

	local TalentsSelect = _G.HeroTalentsSelectionDialog
	if TalentsSelect then
		hooksecurefunc(TalentsSelect, "ShowDialog", function(frame)
			if not frame.__MERSkin then
				frame.__MERSkin = true
				self:HighAlphaTransparent(TalentsSelect)
			end
		end)
	end
end

module:AddCallbackForAddon("Blizzard_PlayerSpells")
