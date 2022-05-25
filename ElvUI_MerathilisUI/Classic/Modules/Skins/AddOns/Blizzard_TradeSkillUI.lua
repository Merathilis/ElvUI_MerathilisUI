local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_TradeSkillUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or not E.private.mui.skins.blizzard.tradeskill then return; end

	-- MainFrame
	local frame = _G.TradeSkillFrame
	frame.backdrop:Styling()
	MER:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon("Blizzard_TradeSkillUI")
