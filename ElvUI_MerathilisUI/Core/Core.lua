local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local C = W.Utilities.Color

local _G = _G
local format = string.format
local ipairs, pcall, select, tonumber, tostring = ipairs, pcall, select, tonumber, tostring
local strsplit = strsplit
local tinsert = table.insert

local InCombatLockdown = InCombatLockdown

MER.GearTex = "Interface\\WorldMap\\Gear_64"

MER.RegisteredModules = {}
MER.Changelog = {}

-- Config Helper
MER.Values = {
	FontFlags = E.Libs.ACH.FontValues,
}

if not E.Retail then
	E.PopupDialogs.WRONGWOWVERSION = {
		text = MER.Title
			.. L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"],
		--button1 = OKAY,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
	}
	E:StaticPopup_Show("WRONGWOWVERSION")
end

-- this needs to be available early (don't put it in Staticpopups.lua)
E.PopupDialogs.MERATHILIS_OPEN_CHANGELOG = {
	text = format(L["Welcome to %s %s!"], MER.Title, MER.DisplayVersion),
	button1 = L["Open Changelog"],
	button2 = _G.CANCEL,
	OnAccept = function()
		E:ToggleOptions("mui,changelog")
	end,
	hideOnEscape = 1,
}

-- Clickable chat links, built with MER.CreateLink("feature", "text", args...).
-- Blizzard's "addon" link type is handled by LinkUtil and forwarded as the
-- "SetItemRef" EventRegistry event, so it never falls through to ItemRefTooltip.
MER.LinkOperations = {
	["changelog"] = E.PopupDialogs.MERATHILIS_OPEN_CHANGELOG.OnAccept,
}

local LINK_PREFIX = "addon:MerathilisUI:"

---@param feature string key of MER.LinkOperations
---@param text string visible link text
---@param ... string|number arguments passed to the operation
function MER.CreateLink(feature, text, ...)
	local data = LINK_PREFIX .. feature
	for i = 1, select("#", ...) do
		data = data .. ":" .. tostring((select(i, ...)))
	end

	return format("|H%s|h[%s]|h", data, text)
end

_G.EventRegistry:RegisterCallback("SetItemRef", function(_, link)
	local linkType, addon, feature, arg1, arg2, arg3 = strsplit(":", link)
	if linkType == "addon" and addon == "MerathilisUI" and MER.LinkOperations[feature] then
		MER.LinkOperations[feature](arg1, arg2, arg3)
	end
end, MER)

-- Register own Modules
function MER:RegisterModule(name)
	if not name then
		F.Developer.ThrowError("The name of module is required!")
		return
	end

	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end

function MER:InitializeModules()
	for _, moduleName in ipairs(MER.RegisteredModules) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			-- Report through the error handler, a failed Initialize leaves the module half set up
			local ok, err = pcall(module.Initialize, module)
			if not ok then
				F.Developer.ThrowError(moduleName, "failed to initialize:", err)
			end
		end
	end

	self:LoadCommands()

	local function onAllEvents()
		F.Event.ContinueAfterElvUIUpdate(function()
			-- Set initialized
			self.initialized = true
			F.Event.TriggerEvent("MER.Initialized")

			F.Event.RunNextFrame(function()
				self.DelayedWorldEntered = true

				F.Developer.PrintDelayedMessages()
			end, 5)

			F.Event.ContinueOutOfCombat(function()
				self.initializedSafe = true
				F.Event.TriggerEvent("MER.InitializedSafe")
			end)
		end)
	end

	F.Event.ContinueAfterAllEvents(onAllEvents, "PLAYER_ENTERING_WORLD", "FIRST_FRAME_RENDERED")
end

function MER:PLAYER_LOGIN()
	self:InitializeModules()
end

function MER:UpdateModules()
	self:UpdateScripts()

	for _, moduleName in ipairs(self.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.ProfileUpdate then
			local ok, err = pcall(module.ProfileUpdate, module)
			if not ok then
				F.Developer.ThrowError(moduleName, "failed to update the profile:", err)
			end
		end
	end
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #E.ConfigModeLayouts + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:CheckElvUIVersion()
	-- ElvUI versions check
	if E.version < 99999 then
		if MER.ElvUIVersion < 1 or (MER.ElvUIVersion < MER.RequiredVersion) then
			E:StaticPopup_Show("VERSION_OUTDATED")
			return false -- If ElvUI Version is outdated stop right here. So things don't get broken.
		elseif MER.ElvUIVersion > MER.RequiredVersion + 0.03 then
			E:StaticPopup_Show("VERSION_MISMATCH")
			return false
		end
	end

	return true
end

function MER:ChangelogReadAlert()
	local readVer = E.global.mui and E.global.mui.changelogRead and tonumber(E.global.mui.changelogRead) or 0
	local currentVer = MER.Version and tonumber(MER.Version) or 0

	if readVer < currentVer then
		if E.global.mui.core.changlogPopup and not InCombatLockdown() then
			E:StaticPopup_Show("MERATHILIS_OPEN_CHANGELOG")
		else
			F.Print(
				format(L["Welcome to version %s!"], C.StringByTemplate(MER.Version, "teal-400")),
				C.StringByTemplate(MER.CreateLink("changelog", L["Open Changelog"]), "sky-400")
			)
		end
	end
end

function MER:UpdateProfiles(_)
	self:UpdateScripts()

	F.Event.TriggerEvent("MER.DatabaseUpdate")
end

-- Deliberate Blizzard global override (see the taint audit): Blizzard's
-- ShouldShowMawBuffs tests C_UnitAuras data, which is secret while auras are
-- restricted and then errors when reached from tainted code (ElvUI's objective
-- tracker updates). The Maw buffs can't matter while auras are secret.
local ShouldShowMawBuffs = _G.ShouldShowMawBuffs
if ShouldShowMawBuffs and C_Secrets and C_Secrets.ShouldAurasBeSecret then
	_G.ShouldShowMawBuffs = function()
		if C_Secrets.ShouldAurasBeSecret() then
			return false
		end

		return ShouldShowMawBuffs()
	end
end
