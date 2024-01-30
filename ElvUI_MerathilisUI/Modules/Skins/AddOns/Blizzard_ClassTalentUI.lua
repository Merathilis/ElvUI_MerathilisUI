local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:Blizzard_ClassTalentUI()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local frame = _G.ClassTalentFrame
	self:CreateShadow(frame)

	for _, tab in next, { frame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end

	self:CreateBackdropShadow(_G.ClassTalentLoadoutImportDialog)
	self:CreateBackdropShadow(_G.ClassTalentLoadoutEditDialog)
end

module:AddCallbackForAddon('Blizzard_ClassTalentUI')
