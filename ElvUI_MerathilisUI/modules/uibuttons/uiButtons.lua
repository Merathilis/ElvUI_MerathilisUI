local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule("MerathilisUI")
local mod = E:NewModule("muiButtons", "AceHook-3.0")
local lib = LibStub("LibElv-UIButtons-1.0")
local S = E:GetModule("Skins")
mod.modName = L["UI Buttons"]

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local RandomRoll = RandomRoll
local SendChatMessage = SendChatMessage
local ReloadUI = ReloadUI

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local CUSTOM = CUSTOM

local function CustomRollCall()
	local min, max = tonumber(E.db.mui.uiButtons.customroll.min), tonumber(E.db.mui.uiButtons.customroll.max)
	if min <= max then
		RandomRoll(min, max)
	else
		MER:Print(L["Custom roll limits are set incorrectly! Minimum should be smaller then or equial to maximum."])
	end
end

function mod:ConfigSetup(menu)
	menu:CreateDropdownButton("Config", "mui", "|cffff7d0aMerathilisUI|r", L["Merathilis Config"], L["Click to toggle MerathilisUI config group"],  function() if InCombatLockdown() then return end; E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui") end, nil, true)
	menu:CreateSeparator("Config", "First", 4, 2)
	menu:CreateDropdownButton( "Config", "Reload", "/reloadui", L["Reload UI"], L["Click to reload your interface"],  function() ReloadUI() end, nil, true)
	menu:CreateDropdownButton("Config", "MoveUI", "/moveui", L["Move UI"], L["Click to unlock moving ElvUI elements"],  function() if InCombatLockdown() then return end; E:ToggleConfigMode() end, nil, true)
end

function mod:AddonSetup(menu)
	menu:CreateDropdownButton("Addon", "Manager", L["AddOns"], L["AddOns Manager"], L["Click to toggle the AddOn Manager frame."],  function() _G["GameMenuButtonAddons"]:Click() end, nil, true)

	menu:CreateDropdownButton("Addon", "DBM", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() DBM:LoadGUI() end, "DBM-Core")
	menu:CreateDropdownButton("Addon", "VEM", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() VEM:LoadGUI() end, "VEM-Core")
	menu:CreateDropdownButton("Addon", "BigWigs", L["Boss Mod"], L["Boss Mod"], L["Click to toggle the Configuration/Option Window from the Bossmod you have enabled."], function() LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs"):OnClick("RightButton") end, "BigWigs")
	menu:CreateSeparator("Addon", "First", 4, 2)
	menu:CreateDropdownButton("Addon", "Altoholic", "Altoholic", nil, nil, function() Altoholic:ToggleUI() end, "Altoholic")
	menu:CreateDropdownButton("Addon", "AtlasLoot", "AtlasLoot", nil, nil, function() AtlasLoot.GUI:Toggle() end, "AtlasLoot")
	menu:CreateDropdownButton("Addon", "WeakAuras", "WeakAuras", nil, nil, function() SlashCmdList.WEAKAURAS() end, "WeakAuras")
	menu:CreateDropdownButton("Addon", "xCT", "xCT+", nil, nil, function() xCT_Plus:ToggleConfigTool() end, "xCT+")
	menu:CreateDropdownButton("Addon", "Swatter", "Swatter", nil, nil, function() Swatter.ErrorShow() end, "!Swatter")

	-- Always keep at the bottom
	menu:CreateDropdownButton("Addon", "WowLua", "WowLua", nil, nil, function() SlashCmdList["WOWLUA"]("") end, "WowLua", false)
end

function mod:StatusSetup(menu)
	menu:CreateDropdownButton("Status", "AFK", L["AFK"], nil, nil, function() SendChatMessage("" ,"AFK" ) end)
	menu:CreateDropdownButton("Status", "DND", L["DND"], nil, nil, function() SendChatMessage("" ,"DND" ) end)
end

function mod:RollSetup(menu)
	menu:CreateDropdownButton("Roll", "Ten", "1-10", nil, nil,  function() RandomRoll(1, 10) end)
	menu:CreateDropdownButton("Roll", "Twenty", "1-20", nil, nil,  function() RandomRoll(1, 20) end)
	menu:CreateDropdownButton("Roll", "Thirty", "1-30", nil, nil,  function() RandomRoll(1, 30) end)
	menu:CreateDropdownButton("Roll", "Forty", "1-40", nil, nil,  function() RandomRoll(1, 40) end)
	menu:CreateDropdownButton("Roll", "Hundred", "1-100", nil, nil,  function() RandomRoll(1, 100) end)
	menu:CreateDropdownButton("Roll", "Custom", CUSTOM, nil, nil,  function() CustomRollCall() end)
end

function mod:SetupBar(menu)
	if E.db.mui.uiButtons.style == "classic" then
		menu:CreateCoreButton("Config", "|cffff7d0aC|r", function() E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "mui") end)
		menu:CreateCoreButton("Reload", "R", function() ReloadUI() end)
		menu:CreateCoreButton("MoveUI", "M", function(self) E:ToggleConfigMode() end)
		menu:CreateCoreButton("Boss", "B", function(self)
			if IsAddOnLoaded("DBM-Core") then
				DBM:LoadGUI()
			elseif IsAddOnLoaded("VEM-Core") then
				VEM:LoadGUI()
			elseif IsAddOnLoaded("BigWigs") then
				LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs"):OnClick("RightButton")
			end
		end)
		menu:CreateCoreButton("Addon", "A", function(self) _G["GameMenuButtonAddons"]:Click() end)
	else
		menu:CreateCoreButton("Config", "C")
		mod:ConfigSetup(menu)

		menu:CreateCoreButton("Addon", "A")
		mod:AddonSetup(menu)

		menu:CreateCoreButton("Status", "S")
		mod:StatusSetup(menu)

		menu:CreateCoreButton("Roll", "R")
		mod:RollSetup(menu)
	end
end

function mod:RightClicks(menu)
	if E.db.mui.uiButtons.style == "classic" then return end
	for i = 1, #menu.ToggleTable do
		menu.ToggleTable[i]:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	end
	menu.Config.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.mui.uiButtons.Config.enable then
			menu.Config[menu.db.Config.called]:Click()
		end
	end)
	menu.Addon.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.mui.uiButtons.Addon.enable then
			menu.Addon[menu.db.Addon.called]:Click()
		end
	end)
	menu.Status.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.mui.uiButtons.Status.enable then
			menu.Status[menu.db.Status.called]:Click()
		end
	end)
	menu.Roll.Toggle:HookScript("OnClick", function(self, button, down)
		if button == "RightButton" and E.db.mui.uiButtons.Roll.enable then
			menu.Roll[menu.db.Roll.called]:Click()
		end
	end)
end

function mod:Initialize()
	if E.db.mui.uiButtonstyle then
		E.db.mui.uiButtons.style = E.db.mui.uiButtonstyle
		E.db.mui.uiButtonstyle = nil
	end

	mod.Holder = lib:CreateFrame("MER_uiButtons", E.db.mui.uiButtons, P.mui.uiButtons, E.db.mui.uiButtons.style, "dropdown", E.db.mui.uiButtons.strata, E.db.mui.uiButtons.level, E.db.mui.uiButtons.transparent)
	local menu = mod.Holder
	menu:Point("LEFT", E.UIParent, "LEFT", -2, 0);
	menu:SetupMover(L["MER UI Buttons"], "ALL,MISC")

	function mod:ForUpdateAll()
		mod.Holder.db = E.db.mui.uiButtons
		mod.Holder:ToggleShow()
		mod.Holder:FrameSize()
	end

	mod:SetupBar(menu)

	menu:FrameSize()
	menu:ToggleShow()

	mod.FrameSize = menu.FrameSize

	mod:RightClicks(menu)
	mod.Holder.mover:SetFrameLevel(305)
end

local function InitializeCallback()
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)