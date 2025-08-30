local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G

local hooksecurefunc = hooksecurefunc

function module:SettingsPanel()
	if not module:CheckDB("blizzardOptions", "blizzardOptions") then
		return
	end

	local SettingsPanel = _G.SettingsPanel
	module:CreateBackdropShadow(SettingsPanel)

	hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, "Update", function(frame)
		for _, child in next, { frame.ScrollTarget:GetChildren() } do
			if not child.__MERSkin then
				if child.BaseTab then
					module:ReskinTab(child.BaseTab)
				end
				if child.RaidTab then
					module:ReskinTab(child.RaidTab)
				end

				child.__MERSkin = true
			end
		end
	end)
end

module:AddCallback("SettingsPanel")
