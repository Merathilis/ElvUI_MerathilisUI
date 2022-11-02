local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("blizzardOptions", "blizzardOptions") then
		return
	end

	local SettingsPanel = _G.SettingsPanel
	SettingsPanel.backdrop:Styling()
	module:CreateBackdropShadow(SettingsPanel)
end

S:AddCallback("SettingsPanel", LoadSkin)
