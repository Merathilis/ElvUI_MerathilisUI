local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleTradeSkill()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true or E.private.muiSkins.blizzard.tradeskill ~= true then return; end

	-- MainFrame
	_G["TradeSkillFrame"]:Styling()
	if _G["TradeSkillFrame"].bg1 then
		_G["TradeSkillFrame"].bg1:Hide()
	end
	if _G["TradeSkillFrame"].bg2 then
		_G["TradeSkillFrame"].bg2:Hide()
	end
end

S:AddCallbackForAddon("Blizzard_TradeSkillUI", "mUITradeSkill", styleTradeSkill)