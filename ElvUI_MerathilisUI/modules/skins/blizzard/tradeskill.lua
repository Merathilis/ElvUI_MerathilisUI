local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack

local function styleTradeSkill()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or E.private.muiSkins.blizzard.tradeskill ~= true then return; end

	-- MainFrame
	MERS:CreateGradient(TradeSkillFrame)
	if not TradeSkillFrame.stripes then
		MERS:CreateStripes(TradeSkillFrame)
	end
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", "mUITradeSkill", styleTradeSkill)