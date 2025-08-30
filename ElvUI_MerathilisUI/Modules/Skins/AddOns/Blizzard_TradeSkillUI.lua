local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_TradeSkillUI()
	if not module:CheckDB("tradeskill", "tradeskill") then
		return
	end

	-- MainFrame
	local frame = _G.TradeSkillFrame
	module:CreateShadow(frame)

	if frame.bg1 then
		frame.bg1:Hide()
	end

	if frame.bg2 then
		frame.bg2:Hide()
	end

	-- Reposition Optional Reagentlist due to TradeTabs
	local optionalReagents = frame.OptionalReagentList
	optionalReagents:ClearAllPoints()
	optionalReagents:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 40, 0)
	module:CreateShadow(optionalReagents)
end

module:AddCallbackForAddon("Blizzard_TradeSkillUI")
