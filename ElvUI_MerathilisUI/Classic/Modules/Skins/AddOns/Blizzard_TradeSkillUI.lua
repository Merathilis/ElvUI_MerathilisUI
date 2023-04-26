local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or not E.private.mui.skins.blizzard.tradeskill then return; end

	-- MainFrame
	local frame = _G.TradeSkillFrame
	if frame.backdrop then
		frame.backdrop:Styling()
	end
	module:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", LoadSkin)
