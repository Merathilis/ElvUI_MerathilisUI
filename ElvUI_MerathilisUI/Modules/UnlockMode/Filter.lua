local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Finding movers: a name filter in the toolbar that hides the movers whose
-- name lacks one of the typed words, Ctrl+mouse wheel that cycles through
-- movers lying on top of each other, and opening the mover mode on a single
-- mover from its options page.

local gmatch, gsub, strfind, strlower = string.gmatch, string.gsub, string.find, string.lower
local ipairs, next, pairs, sort, tinsert, tremove, wipe = ipairs, next, pairs, sort, tinsert, tremove, wipe
local max = math.max

local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown

-------------------------------------------------------------------------------
--  Name filter
--  Only hides movers the layout filter showed, and shows exactly those again.
-------------------------------------------------------------------------------
local filterWords = {}
local filteredOut = {}

local function MoverText(mover)
	-- Titles like MER.Title carry color codes
	local text = gsub(gsub(mover.textString or mover.name or "", "|c%x%x%x%x%x%x%x%x", ""), "|r", "")
	return strlower(text .. " " .. (mover.name or ""))
end

local function MatchesFilter(mover)
	local text = MoverText(mover)
	for _, word in ipairs(filterWords) do
		if not strfind(text, word, 1, true) then
			return false
		end
	end
	return true
end

function module:SetFilter(text)
	wipe(filterWords)
	for word in gmatch(strlower(text or ""), "%S+") do
		tinsert(filterWords, word)
	end
	self:ApplyFilter()
end

function module:ApplyFilter()
	if InCombatLockdown() then
		return
	end

	for mover in pairs(filteredOut) do
		mover:Show()
	end
	wipe(filteredOut)

	if not E.ConfigurationMode or not next(filterWords) then
		return
	end

	for _, holder in pairs(E.CreatedMovers) do
		local mover = holder.mover
		if mover and mover:IsShown() and not MatchesFilter(mover) then
			filteredOut[mover] = true
			mover:Hide()
		end
	end
end

-- ElvUI shows the movers of a layout again on its own, the filter follows
function module:ReapplyFilter()
	wipe(filteredOut)
	self:ApplyFilter()
end

-- The mover mode closed, ElvUI already hid every mover
function module:ClearFilter()
	wipe(filterWords)
	wipe(filteredOut)
	if self.toolbar then
		self.toolbar.filter:SetText("")
		self.toolbar.filter:ClearFocus()
	end
end

-------------------------------------------------------------------------------
--  Overlapping movers
--  Ctrl+mouse wheel over a stack of movers brings the next one to the top and
--  selects it. Only the frame levels of the movers change, nothing moves.
-------------------------------------------------------------------------------
local stack = {}

local function ByLevel(a, b)
	return a:GetFrameLevel() > b:GetFrameLevel()
end

function module:CycleOverlap(delta)
	if self.dragging or InCombatLockdown() then
		return
	end

	wipe(stack)
	for _, holder in pairs(E.CreatedMovers) do
		local mover = holder.mover
		if mover and mover:IsShown() and mover:IsMouseOver() then
			tinsert(stack, mover)
		end
	end
	if #stack < 2 then
		wipe(stack)
		return
	end
	sort(stack, ByLevel)

	-- Wheel down sends the top one to the bottom, wheel up brings the bottom one up
	local top = max(stack[1]:GetFrameLevel(), #stack)
	if delta < 0 then
		tinsert(stack, tremove(stack, 1))
	else
		tinsert(stack, 1, tremove(stack))
	end

	for index, mover in ipairs(stack) do
		-- Never below the level ElvUI gave it, that one keeps it above its own frame
		mover.MER_BaseLevel = mover.MER_BaseLevel or mover:GetFrameLevel()
		mover:SetFrameLevel(max(mover.MER_BaseLevel, top - index + 1))
	end

	self:Select(stack[1])
	wipe(stack)
end

local function OnMouseWheel(mover, delta)
	if module:IsActive() and module.db.overlapCycle and IsControlKeyDown() then
		module:CycleOverlap(delta)
	elseif mover.MER_OnMouseWheel then
		-- ElvUI's own wheel nudge
		mover.MER_OnMouseWheel(mover, delta)
	end
end

-- Wraps ElvUI's wheel script, Ctrl+wheel would nudge the mover too otherwise
function module:HookMoverWheel(mover)
	if mover.MER_OnMouseWheel ~= nil then
		return
	end
	mover.MER_OnMouseWheel = mover:GetScript("OnMouseWheel") or false
	mover:SetScript("OnMouseWheel", OnMouseWheel)
end

-------------------------------------------------------------------------------
--  Show a single mover
--  Used by the buttons the options add to the pages of modules with a mover.
-------------------------------------------------------------------------------
function module:ShowMover(name)
	local holder = E.CreatedMovers[name]
	if not holder or InCombatLockdown() then
		return
	end

	-- ElvUI's layout filter also takes a mover name
	E:ToggleMoveMode(name)
	E.ConfigurationToggled = true

	if self:IsActive() and holder.mover:IsShown() then
		self:Select(holder.mover)
	end
end
