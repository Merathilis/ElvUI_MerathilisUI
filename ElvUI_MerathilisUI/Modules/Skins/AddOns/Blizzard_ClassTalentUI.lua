local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:Blizzard_ClassTalentUI()
	if not module:CheckDB("talent", "talent") then
		return
	end

	local frame = _G.ClassTalentFrame
	module:CreateShadow(frame)

	frame.TalentsTab.BlackBG:SetAlpha(.5)
	frame.TalentsTab.Background:SetAlpha(.5)
	frame.TalentsTab.BottomBar:SetAlpha(.5)

	for _, tab in next, { frame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end
end

module:AddCallbackForAddon('Blizzard_ClassTalentUI')
