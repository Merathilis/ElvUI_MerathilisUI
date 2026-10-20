local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Instance profiles: an addon profile per kind of place (open world, dungeon,
-- raid, ...). Entering such a place offers to load its profile when the addons
-- differ, loading needs a reload. "Not Now" is remembered until the next reload.

local _G = _G
local next, pairs = next, pairs

local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance

local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetNumAddOns = C_AddOns.GetNumAddOns

local ENABLE_STATE_NONE = Enum.AddOnEnableState.None
local EVENT_OWNER = "MER_AddonManager_Instances"
local CHECK_DELAY = 3

-- IsInInstance types, in the order of the options
module.instanceTypes = {
	{ key = "none", text = L["Open World"] },
	{ key = "party", text = _G.DUNGEONS or L["Dungeons"] },
	{ key = "raid", text = _G.RAIDS or L["Raids"] },
	{ key = "scenario", text = L["Scenarios and Delves"] },
	{ key = "arena", text = _G.ARENA or L["Arena"] },
	{ key = "pvp", text = _G.BATTLEGROUNDS or L["Battlegrounds"] },
}

local declined = {} -- [instance type] = true until the next reload
local registered = false

-- The user addons of this character already match the profile (locked ones aside)
local function IsProfileActive(profile)
	for i = 1, GetNumAddOns() do
		local name, _, _, _, _, security = GetAddOnInfo(i)
		if security ~= "SECURE" and not module:IsLocked(name) then
			local enabled = GetAddOnEnableState(i, E.myguid) > ENABLE_STATE_NONE
			if enabled ~= (profile[name] == true) then
				return false
			end
		end
	end

	return true
end

local function CheckInstance()
	local db = module.db
	if not db.enable or db.bisect or InCombatLockdown() then
		return
	end

	local _, instanceType = IsInInstance()
	instanceType = instanceType or "none"

	local name = db.instanceProfiles[instanceType]
	local profile = name and db.profiles[name]
	if not profile or declined[instanceType] or IsProfileActive(profile) then
		return
	end

	E:StaticPopup_Show("MER_ADDON_INSTANCE_PROFILE", name, nil, { name = name, instanceType = instanceType })
end

local function OnEnteringWorld()
	-- After the loading screen, and after the login popups of the module
	E:Delay(CHECK_DELAY, CheckInstance)
end

E.PopupDialogs.MER_ADDON_INSTANCE_PROFILE = {
	text = L["Your addon profile for this kind of place is %s. Load it now? The UI reloads."],
	button1 = L["Load"],
	button2 = L["Not Now"],
	OnAccept = function(_, data)
		module:LoadProfile(data.name)
	end,
	OnCancel = function(_, data, reason)
		if reason == "clicked" and data then
			declined[data.instanceType] = true
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

---Listens for zone changes only while the module is on and a profile is assigned
function module:UpdateInstanceProfiles()
	local active = self.db.enable and next(self.db.instanceProfiles) ~= nil

	if active and not registered then
		F.Event.RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", OnEnteringWorld, EVENT_OWNER)
		registered = true
	elseif not active and registered then
		F.Event.UnregisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", EVENT_OWNER)
		registered = false
	end
end

---Keeps the assignments in step with renamed or deleted profiles
---@param oldName string
---@param newName string? nil when the profile was deleted
function module:RenameInstanceProfile(oldName, newName)
	local assigned = self.db.instanceProfiles
	for instanceType, name in pairs(assigned) do
		if name == oldName then
			assigned[instanceType] = newName
		end
	end

	self:UpdateInstanceProfiles()
end
