local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local AB = E:GetModule("ActionBars")

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local CreateFrame = CreateFrame

local function HotKeyTweak(button)
	if button.MERHotKeyFrame or not button.cooldown then
		return
	end
	button.MERHotKeyFrame = CreateFrame("Frame", nil, button)
	button.MERHotKeyFrame:SetAllPoints(button)
	button.MERHotKeyFrame:SetFrameStrata("LOW")
	button.MERHotKeyFrame:SetFrameLevel(button.cooldown:GetFrameLevel() + 2)
	button.HotKey:SetParent(button.MERHotKeyFrame)
end

function module:HotKey()
	if not E.private.actionbar.enable or not E.db.cooldown.enable or not E.db.mui.misc.hotKey then
		return
	end

	hooksecurefunc(E, "CreateCooldownTimer", function(_, button)
		if button and button.cooldown and AB.handledbuttons[button] then
			HotKeyTweak(button)
		end
	end)

	for button in pairs(AB.handledbuttons) do
		HotKeyTweak(button)
	end
end

module:AddCallback("HotKey")
