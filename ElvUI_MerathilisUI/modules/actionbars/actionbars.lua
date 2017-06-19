local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:NewModule("mUIActionbars", "AceEvent-3.0")
MAB.modName = L["ActionBars"]

if E.private.actionbar.enable ~= true then return; end

local _G = _G
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After

-- GLOBALS: NUM_PET_ACTION_SLOTS, DisableAddOn
-- GLOBALS: ElvUI_BarPet, ElvUI_StanceBar

local availableActionbars = availableActionbars or 6

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar}

local function CheckExtraAB()
	if IsAddOnLoaded("ElvUI_ExtraActionBars") then
		availableActionbars = 10
	else
		availableActionbars = 6
	end
end

-- from ElvUI_TrasparentBackdrops plugin
function MAB:TransparentBackdrops()
	-- Actionbar backdrops
	local db = E.db.mui.actionbars
	for i = 1, availableActionbars do
		local transBars = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(transBars) do
			if frame.backdrop then
				if db.transparent then
					frame.backdrop:SetTemplate("Transparent")
				else
					frame.backdrop:SetTemplate("Default")
				end
			end
		end

		-- Buttons
		for k = 1, 12 do
			local buttonBars = {_G["ElvUI_Bar"..i.."Button"..k]}
			for _, button in pairs(buttonBars) do
				if button.backdrop then
					if db.transparent then
						button.backdrop:SetTemplate("Transparent")
					else
						button.backdrop:SetTemplate("Default", true)
					end
				end
			end
		end
	end

	-- Other bar backdrops
	local transOtherBars = {ElvUI_BarPet, ElvUI_StanceBar}
	for _, frame in pairs(transOtherBars) do
		if frame.backdrop then
			if db.transparent then
				frame.backdrop:SetTemplate("Transparent")
			else
				frame.backdrop:SetTemplate("Default")
			end
		end
	end

	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G["PetActionButton"..i]}
		for _, button in pairs(petButtons) do
			if button.backdrop then
				if db.transparent then
					button.backdrop:SetTemplate("Transparent")
				else
					button.backdrop:SetTemplate("Default", true)
				end
			end
		end
	end
end

function MAB:Initialize()
	CheckExtraAB()
	C_TimerAfter(1, MAB.TransparentBackdrops)
	if IsAddOnLoaded("ElvUI_TB") then DisableAddOn("ElvUI_TB") end
end

local function InitializeCallback()
	MAB:Initialize()
end

E:RegisterModule(MAB:GetName(), InitializeCallback)