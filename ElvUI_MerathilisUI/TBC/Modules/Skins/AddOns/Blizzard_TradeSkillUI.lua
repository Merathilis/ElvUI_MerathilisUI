local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("tradeskill", "tradeskill") then
		return
	end

	-- MainFrame
	local frame = _G.TradeSkillFrame
	if frame.backdrop then
		frame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(frame)
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", LoadSkin)
