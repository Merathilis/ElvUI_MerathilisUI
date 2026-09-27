local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
F.Event = {}

local next, pairs, pcall, select, type, unpack = next, pairs, pcall, select, type, unpack
local rawset = rawset
local securecallfunction = securecallfunction
local secureexecuterange = secureexecuterange

local CreateFrame = CreateFrame
local C_Timer_After = C_Timer.After
local InCombatLockdown = InCombatLockdown
local EventUtil = EventUtil

do
	local closureGeneration = {
		function(f)
			return function(...)
				return f(...)
			end
		end,
		function(f, a)
			return function(...)
				return f(a, ...)
			end
		end,
		function(f, a, b)
			return function(...)
				return f(a, b, ...)
			end
		end,
		function(f, a, b, c)
			return function(...)
				return f(a, b, c, ...)
			end
		end,
		function(f, a, b, c, d)
			return function(...)
				return f(a, b, c, d, ...)
			end
		end,
		function(f, a, b, c, d, e)
			return function(...)
				return f(a, b, c, d, e, ...)
			end
		end,
		function(f, a, b, c, d, e, g)
			return function(...)
				return f(a, b, c, d, e, g, ...)
			end
		end,
	}

	function F.Event.GenerateClosure(f, ...)
		local count = select("#", ...)
		local generator = closureGeneration[count + 1]
		if generator then
			return generator(f, ...)
		end
		F.Developer.ThrowError(
			"Closure generation does not support more than " .. (#closureGeneration - 1) .. " parameters"
		)
	end
end

function F.Event.RunNextFrame(callback, delay)
	C_Timer_After(delay or 0, callback)
end

do
	local count = 0
	local function counter()
		count = count + 1
		return count
	end

	-- Numeric owner ids are reserved for callbacks registered without an owner
	function F.Event.GenerateOwnerId()
		return securecallfunction(counter)
	end
end

do
	local InsertEventAttribute = "insert-secure-event"
	local callbackType = F.Enum({ "CLOSURE", "FUNCTION" })
	local callbackTables = {}
	for _, value in pairs(callbackType) do
		callbackTables[value] = {}
	end

	local eventFrame = CreateFrame("Frame")
	local attributeDelegate = CreateFrame("FRAME")
	attributeDelegate:SetScript("OnAttributeChanged", function(_, attribute, value)
		if attribute == InsertEventAttribute then
			local event = securecallfunction(unpack, value)
			if type(event) ~= "string" then
				return F.Developer.ThrowError("'event' requires string type", event)
			end
			for _, callbackTable in pairs(callbackTables) do
				if not callbackTable[event] then
					rawset(callbackTable, event, {})
				end
			end
		end
	end)

	local function GetCallbacksByEvent(callType, event)
		return callbackTables[callType][event]
	end

	local function HasRegistrantsForEvent(event)
		for _, callbackTable in pairs(callbackTables) do
			local callbacks = callbackTable[event]
			if callbacks and securecallfunction(next, callbacks) then
				return true
			end
		end
		return false
	end

	local function HasCallback(event, owner)
		for _, callbackTable in pairs(callbackTables) do
			local callbacks = callbackTable[event]
			if callbacks and callbacks[owner] then
				return true
			end
		end
		return false
	end

	local function SecureInsertEvent(event)
		if not HasRegistrantsForEvent(event) then
			attributeDelegate:SetAttribute(InsertEventAttribute, { event })
		end
	end

	function F.Event.RegisterCallback(event, func, owner, ...)
		if type(event) ~= "string" then
			return F.Developer.ThrowError("RegisterCallback 'event' requires string type.", event)
		elseif type(func) ~= "function" then
			return F.Developer.ThrowError("RegisterCallback 'func' requires function type.", event)
		else
			if owner == nil then
				owner = F.Event.GenerateOwnerId()
			elseif type(owner) == "number" then
				return F.Developer.ThrowError("RegisterCallback 'owner' as number is reserved internally.")
			end
		end

		SecureInsertEvent(event)

		for _, callbackTable in pairs(callbackTables) do
			local callbacks = callbackTable[event]
			callbacks[owner] = nil
		end

		local count = select("#", ...)
		if count > 0 then
			local callbacks = GetCallbacksByEvent(callbackType.CLOSURE, event)
			callbacks[owner] = F.Event.GenerateClosure(func, owner, ...)
		else
			local callbacks = GetCallbacksByEvent(callbackType.FUNCTION, event)
			callbacks[owner] = func
		end

		return owner
	end

	local function CallbackRegistryExecuteClosurePair(_, closure, ...)
		securecallfunction(closure, ...)
	end

	local function CallbackRegistryExecuteOwnerPair(owner, func, ...)
		securecallfunction(func, owner, ...)
	end

	-- Snapshot so callbacks can (un)register during dispatch; keys are owners and must be kept as-is
	local function copyCallbacks(callbacks)
		local copy = {}
		for owner, callback in pairs(callbacks) do
			copy[owner] = callback
		end
		return copy
	end

	function F.Event.TriggerEvent(event, ...)
		if type(event) ~= "string" then
			return F.Developer.ThrowError("TriggerEvent 'event' requires string type.", event)
		end

		local closures = GetCallbacksByEvent(callbackType.CLOSURE, event)
		if closures and next(closures) then
			secureexecuterange(copyCallbacks(closures), CallbackRegistryExecuteClosurePair, ...)
		end

		local funcs = GetCallbacksByEvent(callbackType.FUNCTION, event)
		if funcs and next(funcs) then
			secureexecuterange(copyCallbacks(funcs), CallbackRegistryExecuteOwnerPair, ...)
		end
	end

	eventFrame:SetScript("OnAttributeChanged", function(_, frameEvent, value)
		if value == 0 then
			eventFrame:UnregisterEvent(frameEvent)
		elseif value == 1 then
			-- Unknown events (e.g. retail-only ones on Forever) would throw here
			if not pcall(eventFrame.RegisterEvent, eventFrame, frameEvent) then
				F.Developer.LogDebug("RegisterFrameEvent: unknown event", frameEvent)
			end
		end
	end)

	function F.Event.RegisterFrameEvent(frameEvent)
		eventFrame:SetAttribute(frameEvent, (eventFrame:GetAttribute(frameEvent) or 0) + 1)
	end

	function F.Event.UnregisterFrameEvent(frameEvent)
		local eventCount = eventFrame:GetAttribute(frameEvent) or 0
		if eventCount > 0 then
			eventFrame:SetAttribute(frameEvent, eventCount - 1)
		end
	end

	-- The frame event is counted once per owner, so re-registering an owner does not leak a count
	function F.Event.RegisterFrameEventAndCallback(frameEvent, func, owner, ...)
		if owner == nil or not HasCallback(frameEvent, owner) then
			F.Event.RegisterFrameEvent(frameEvent)
		end
		return F.Event.RegisterCallback(frameEvent, func, owner, ...)
	end

	local function createCallbackHandle(event, owner)
		local handle = {
			Unregister = function()
				F.Event.UnregisterCallback(event, owner)
			end,
		}
		return handle
	end

	local function createCallbackHandleFrameEvent(cbrHandle, frameEvent)
		local handle = {
			Unregister = function()
				F.Event.UnregisterFrameEvent(frameEvent)
				cbrHandle:Unregister()
			end,
		}
		return handle
	end

	function F.Event.RegisterCallbackWithHandle(event, func, owner, ...)
		owner = F.Event.RegisterCallback(event, func, owner, ...)
		return createCallbackHandle(event, owner)
	end

	function F.Event.RegisterFrameEventAndCallbackWithHandle(frameEvent, ...)
		F.Event.RegisterFrameEvent(frameEvent)
		local cbrHandle = F.Event.RegisterCallbackWithHandle(frameEvent, ...)
		return createCallbackHandleFrameEvent(cbrHandle, frameEvent)
	end

	function F.Event.UnregisterCallback(event, owner)
		if type(event) ~= "string" then
			return F.Developer.ThrowError("UnregisterCallback 'event' requires string type", event)
		elseif owner == nil then
			return F.Developer.ThrowError("UnregisterCallback 'owner' is required")
		end

		for _, callbackTable in pairs(callbackTables) do
			local callbacks = callbackTable[event]
			if callbacks then
				callbacks[owner] = nil
			end
		end
	end

	-- Only releases the frame event if this owner actually registered it
	function F.Event.UnregisterFrameEventAndCallback(frameEvent, owner)
		if owner ~= nil and HasCallback(frameEvent, owner) then
			F.Event.UnregisterFrameEvent(frameEvent)
		end
		F.Event.UnregisterCallback(frameEvent, owner)
	end

	function F.Event.RegisterOnceCallback(frameEvent, callback)
		local handle = nil

		local CallbackWrapper = function(_, ...)
			handle:Unregister()
			callback(...)
		end

		handle = F.Event.RegisterCallbackWithHandle(frameEvent, CallbackWrapper)
	end

	function F.Event.RegisterOnceFrameEventAndCallback(frameEvent, callback, ...)
		local handle = nil
		local requiredEventArgs = F.Table.SafePack(...)
		local CallbackWrapper = function(_, ...)
			-- Only compare the args the caller filters on; payloads may carry secret values
			for i = 1, requiredEventArgs.n do
				local arg = select(i, ...)
				if E:IsSecretValue(arg) or arg ~= requiredEventArgs[i] then
					return
				end
			end

			handle:Unregister()
			callback(...)
		end

		handle = F.Event.RegisterFrameEventAndCallbackWithHandle(frameEvent, CallbackWrapper)
	end

	function F.Event.ContinueOnAddOnLoaded(addOnName, callback)
		EventUtil.ContinueOnAddOnLoaded(addOnName, callback)
	end

	function F.Event.ContinueOutOfCombat(callback)
		if not InCombatLockdown() then
			callback()
			return
		end

		F.Event.RegisterOnceFrameEventAndCallback("PLAYER_REGEN_ENABLED", callback)
	end

	function F.Event.ContinueAfter(cmp, callback)
		if cmp() == true then
			callback()
			return
		end

		local checkWrapper
		checkWrapper = function()
			if cmp() == true then
				callback()
				return
			end

			C_Timer_After(0.2, checkWrapper)
		end

		C_Timer_After(0.2, checkWrapper)
	end

	do
		local elvUpdating = false
		local elvUFUpdating = false

		MER:RawHook(E, "UpdateStart", function(...)
			elvUpdating = true
			MER.hooks[E]["UpdateStart"](...)
		end)

		MER:RawHook(E, "UpdateEnd", function(...)
			MER.hooks[E]["UpdateEnd"](...)
			elvUpdating = false
		end)

		local eUF = E:GetModule("UnitFrames")
		MER:RawHook(eUF, "Update_AllFrames", function(...)
			elvUFUpdating = true
			MER.hooks[eUF]["Update_AllFrames"](...)
			elvUFUpdating = false
		end)

		-- ElvUIs mass updates are coroutines now, they outlive the calls that queued them
		local function elvCoroutinesRunning()
			return E.CoroutineFrame and E.CoroutineFrame:IsShown()
		end

		function F.Event.ContinueAfterElvUIUpdate(callback)
			F.Event.ContinueAfter(function()
				return not (elvUpdating or elvUFUpdating or elvCoroutinesRunning())
			end, callback)
		end
	end

	function F.Event.ContinueAfterAllEvents(callback, ...)
		local events = {}
		local owner = { id = F.Event.GenerateOwnerId() }

		local function haveReceivedAllEvents()
			for _, received in pairs(events) do
				if not received then
					return false
				end
			end

			return true
		end

		local count = select("#", ...)
		for index = 1, count do
			local event = select(index, ...)
			events[event] = false

			local function onEventReceived()
				events[event] = true

				F.Event.UnregisterFrameEventAndCallback(event, owner)

				if haveReceivedAllEvents() then
					callback()
				end
			end

			F.Event.RegisterFrameEventAndCallback(event, onEventReceived, owner)
		end
	end

	eventFrame:SetScript("OnEvent", function(_, event, ...)
		F.Event.TriggerEvent(event, ...)
	end)
end
