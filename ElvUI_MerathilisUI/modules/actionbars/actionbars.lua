local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local module = MER:NewModule("mUIActionbars", "AceEvent-3.0")

if E.private.actionbar.enable ~= true then return; end

--Cache global variables
local _G = _G
local pairs = pairs
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: NUM_PET_ACTION_SLOTS, DisableAddOn
-- GLOBALS: ElvUI_BarPet, ElvUI_StanceBar, hooksecurefunc

local availableActionbars = availableActionbars or 6
local styleOtherBacks = {_G.ElvUI_BarPet, _G.ElvUI_StanceBar}

local function CheckExtraAB()
	if IsAddOnLoaded("ElvUI_ExtraActionBars") then
		availableActionbars = 10
	else
		availableActionbars = 6
	end
end

function module:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, availableActionbars do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Styling()
			end
		end
	end

	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Styling()
		end
	end

	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in pairs(petButtons) do
			if button.backdrop then
				button.backdrop:Styling()
			end
		end
	end
end

function module:Initialize()
	if E.private.actionbar.enable ~= true then return; end

	local db = E.db.mui.actionbars
	MER:RegisterDB(self, "actionbars")

	CheckExtraAB()
	C_TimerAfter(1, module.StyleBackdrops)

	self:SpecBarInit()
	self:EquipBarInit()
end

MER:RegisterModule(module:GetName())
