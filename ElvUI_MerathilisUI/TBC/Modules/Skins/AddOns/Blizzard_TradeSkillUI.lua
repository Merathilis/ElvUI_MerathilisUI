local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or E.private.mui.skins.blizzard.tradeskill ~= true then return; end

	-- MainFrame
	local frame = _G.TradeSkillFrame
	frame.backdrop:Styling()
	MER:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", "mUITradeSkill", LoadSkin)
