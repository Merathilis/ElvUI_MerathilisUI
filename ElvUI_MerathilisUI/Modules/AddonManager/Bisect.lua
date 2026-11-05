local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_AddonManager") ---@class AddonManager

-- Finds the addon behind a problem by halving: half of the suspects stays on,
-- the UI reloads and the user answers whether the problem is still there, until
-- one addon is left. The addons of the character are saved at the start and
-- come back at the end. The state lives in E.global between the reloads.

local _G = _G
local ceil, format, ipairs, log = ceil, format, ipairs, math.log
local tinsert = tinsert

local InCombatLockdown = InCombatLockdown

local DisableAddOn = C_AddOns.DisableAddOn
local EnableAddOn = C_AddOns.EnableAddOn
local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local GetNumAddOns = C_AddOns.GetNumAddOns
local SaveAddOns = C_AddOns.SaveAddOns
local C_UI_Reload = C_UI.Reload

local ENABLE_STATE_NONE = Enum.AddOnEnableState.None

-- Always on during the search, no matter the locks: without them there is no question after the reload
local ALWAYS_ON = {
	ElvUI = true,
	ElvUI_Libraries = true,
	ElvUI_Options = true,
	ElvUI_MerathilisUI = true,
}

local function IsKept(name)
	return ALWAYS_ON[name] or module:IsLocked(name)
end

local function GetState()
	return module.db.bisect
end

---Switches the user addons of this character: on when in `enabled` (or kept), off otherwise
---@param enabled table<string, boolean>
local function ApplyAndReload(enabled)
	for i = 1, GetNumAddOns() do
		local name, _, _, _, _, security = GetAddOnInfo(i)
		if security ~= "SECURE" then
			if IsKept(name) or enabled[name] then
				EnableAddOn(i, E.myguid)
			else
				DisableAddOn(i, E.myguid)
			end
		end
	end

	SaveAddOns()
	C_UI_Reload()
end

local function StepsLeft(count)
	return count > 1 and ceil(log(count) / log(2)) or 0
end

-- Half of the suspects on, plus whatever they need to load
local function NextStep()
	local state = GetState()
	local suspects = state.suspects

	local testing = {}
	for i = 1, ceil(#suspects / 2) do
		tinsert(testing, suspects[i])
	end

	local enabled = {}
	for _, name in ipairs(testing) do
		enabled[name] = true
		for _, dep in ipairs(module.CollectDependencies(name)) do
			enabled[dep] = true
		end
	end

	state.testing = testing
	state.step = state.step + 1

	ApplyAndReload(enabled)
end

---@param result string|false? the addon found, false when none was found
local function Finish(result)
	local state = GetState()
	state.finished = true
	state.result = result or false

	ApplyAndReload(state.backup)
end

---@param stillThere boolean the problem happens with the tested half on
function module:AnswerBisect(stillThere)
	local state = GetState()
	if not state or state.finished then
		return
	end

	local suspects = {}
	if stillThere then
		suspects = state.testing
	else
		local tested = {}
		for _, name in ipairs(state.testing) do
			tested[name] = true
		end
		for _, name in ipairs(state.suspects) do
			if not tested[name] then
				tinsert(suspects, name)
			end
		end
	end

	state.suspects = suspects

	if #suspects == 1 then
		Finish(suspects[1])
	elseif #suspects == 0 then
		Finish(false)
	else
		NextStep()
	end
end

function module:StopBisect()
	if GetState() then
		Finish(nil)
	end
end

function module:StartBisect()
	if InCombatLockdown() then
		F.Print(_G.ERR_NOT_IN_COMBAT)
		return
	end

	local backup, suspects = {}, {}
	for i = 1, GetNumAddOns() do
		local name, _, _, _, _, security = GetAddOnInfo(i)
		if security ~= "SECURE" and GetAddOnEnableState(i, E.myguid) > ENABLE_STATE_NONE then
			backup[name] = true
			if not IsKept(name) then
				tinsert(suspects, name)
			end
		end
	end

	if #suspects == 0 then
		F.Print(L["There are no addons to search through, every enabled addon is locked."])
		return
	end

	self.db.bisect = { backup = backup, suspects = suspects, step = 0 }
	NextStep()
end

--[[----------------------------------
--	Popups
--]]
----------------------------------
E.PopupDialogs.MER_ADDON_BISECT_START = {
	text = L["Find the addon that causes a problem: half of your addons are turned off, the UI reloads and you tell whether the problem is still there, until one addon is left. Locked addons stay on. Your addons come back at the end.\n\nStart now?"],
	button1 = _G.ACCEPT,
	button2 = _G.CANCEL,
	OnAccept = function()
		module:StartBisect()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

E.PopupDialogs.MER_ADDON_BISECT_STEP = {
	text = L["Find Faulty Addon (step %s)\n\n%s"],
	button1 = L["Problem Is Still There"],
	button2 = L["Problem Is Gone"],
	button3 = L["Stop"],
	OnAccept = function()
		module:AnswerBisect(true)
	end,
	OnCancel = function(_, _, reason)
		if reason == "clicked" then
			module:AnswerBisect(false)
		end
	end,
	OnAlt = function()
		module:StopBisect()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
	noCancelOnEscape = true,
	preferredIndex = 3,
}

E.PopupDialogs.MER_ADDON_BISECT_RESULT = {
	text = "%s",
	button1 = _G.OKAY,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

function module:ShowBisectStartPopup()
	E:StaticPopup_Show("MER_ADDON_BISECT_START")
end

-- After each reload of a running search: ask, or report the result
function module:ResumeBisect()
	local state = GetState()
	if not state then
		return
	end

	if state.finished then
		self.db.bisect = nil

		local text
		if state.result then
			text =
				format(L["Found it: %s causes the problem. Your addons are back."], F.String.MERATHILISUI(state.result))
		elseif state.result == false then
			text =
				L["No single addon causes the problem, it also happens with all suspects off (or only with several of them together). Your addons are back."]
		else
			text = L["The search was stopped. Your addons are back."]
		end

		E:StaticPopup_Show("MER_ADDON_BISECT_RESULT", text)
		return
	end

	local remaining = #state.suspects
	E:StaticPopup_Show(
		"MER_ADDON_BISECT_STEP",
		state.step,
		format(
			L["%d of %d suspects on, about %d more |4step:steps; after this one.\n\nDoes the problem still happen?"],
			#state.testing,
			remaining,
			StepsLeft(remaining) - 1
		)
	)
end
