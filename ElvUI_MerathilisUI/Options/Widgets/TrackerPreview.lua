local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local max = math.max
local CreateFont = CreateFont
local GetTime = GetTime
local C_Spell_GetSpellTexture = C_Spell and C_Spell.GetSpellTexture

-- The trackers in their states, built by the module itself (BuildBattleResFrame,
-- BuildBloodlustFrame and their layout functions). Used as `dialogControl` on a
-- description named "battleRes" or "bloodlust".
-- Battle Res: charges left while the next one recharges, and no charges left.
-- Bloodlust: the Sated lockout (Show Sated), the active lust and the ready state
-- (Show Ready).

local PADDING = 10
local GAP = 16
local MIN_HEIGHT = 50

local BREZ_RECHARGE, BREZ_ELAPSED = 90, 25
local LOCKOUT_DURATION, LOCKOUT_ELAPSED = 600, 140
local BUFF_DURATION, BUFF_ELAPSED = 40, 12
local SATED_SPELL = 57724 -- Sated

-- Own font objects, the countdown numbers of the real trackers keep theirs. Created with the
-- first preview, not at login.
local battleResFont, bloodlustFont

local function GetTracker()
	return MER:GetModule("MER_Tracker")
end

local function Build(widget)
	local tracker = GetTracker()
	local frame = widget.frame

	if not battleResFont then
		battleResFont = CreateFont("MER_TrackerPreviewBattleResFont")
		battleResFont:SetFont(E.media.normFont, 14, "OUTLINE")
		bloodlustFont = CreateFont("MER_TrackerPreviewBloodlustFont")
		bloodlustFont:SetFont(E.media.normFont, 14, "OUTLINE")
	end

	widget.battleRes = {
		tracker:BuildBattleResFrame(nil, frame, "MER_TrackerPreviewBattleResFont"),
		tracker:BuildBattleResFrame(nil, frame, "MER_TrackerPreviewBattleResFont"),
	}

	widget.bloodlust = {
		sated = tracker:BuildBloodlustFrame(nil, frame, "MER_TrackerPreviewBloodlustFont"),
		active = tracker:BuildBloodlustFrame(nil, frame, "MER_TrackerPreviewBloodlustFont"),
		ready = tracker:BuildBloodlustFrame(nil, frame, "MER_TrackerPreviewBloodlustFont"),
	}
end

-- Places the shown frames in one centered row
local function LayoutRow(widget, frames)
	local total, height = 0, 0
	for _, frame in ipairs(frames) do
		total = total + frame:GetWidth()
		height = max(height, frame:GetHeight())
	end
	total = total + GAP * (#frames - 1)

	local x = -total / 2
	for _, frame in ipairs(frames) do
		frame:ClearAllPoints()
		frame:SetPoint("LEFT", widget.frame, "CENTER", x, 0)
		x = x + frame:GetWidth() + GAP
	end

	widget.frame:SetHeight(max(MIN_HEIGHT, height + PADDING * 2))
end

-- Charges like SetBattleResCount: red without charges, the icon desaturated if wanted
local function SetCharges(frame, db, charges, isText)
	frame.count:SetText(charges)
	if charges == 0 then
		frame.count:SetTextColor(1, 0.2, 0.2)
	else
		frame.count:SetTextColor(db.countColor.r, db.countColor.g, db.countColor.b)
	end
	frame.icon:SetDesaturated(charges == 0 and db.desaturate)
	frame.separator:SetShown(isText)
	frame.cooldown:SetCooldown(GetTime() - BREZ_ELAPSED, BREZ_RECHARGE)
end

local function UpdateBattleRes(widget)
	local tracker = GetTracker()
	local db = E.db.mui.tracker.battleRes

	for _, frame in pairs(widget.bloodlust) do
		frame:Hide()
	end

	local samples = { 2, 0 }
	for index, frame in ipairs(widget.battleRes) do
		local isText = tracker:LayoutBattleResFrame(frame, battleResFont, db)
		SetCharges(frame, db, samples[index], isText)
		frame:Show()
	end

	LayoutRow(widget, widget.battleRes)
	Preview.SetEnabled(widget, db.enable)
end

local function UpdateBloodlust(widget)
	local tracker = GetTracker()
	local db = E.db.mui.tracker.bloodlust
	local frames = widget.bloodlust
	local lustIcon = tracker:GetLustIcon()

	for _, frame in ipairs(widget.battleRes) do
		frame:Hide()
	end

	for _, frame in pairs(frames) do
		tracker:LayoutBloodlustFrame(frame, bloodlustFont, db)
		frame.readyText:SetText(L["Ready"])
		frame.readyText:Hide()
		frame.buff:Hide()
		frame.cooldown:Clear()
		frame.icon:SetTexture(lustIcon)
		frame.icon:SetDesaturated(db.desaturate)
	end

	-- Lockout after a lust, like RenderBloodlust's SATED state
	local sated = frames.sated
	sated.icon:SetTexture(C_Spell_GetSpellTexture and C_Spell_GetSpellTexture(SATED_SPELL) or lustIcon)
	sated.cooldown:SetCooldown(GetTime() - LOCKOUT_ELAPSED, LOCKOUT_DURATION)

	-- The lust buff lies on top of the lockout while it runs
	local active = frames.active
	active.cooldown:SetCooldown(GetTime() - BUFF_ELAPSED, LOCKOUT_DURATION)
	active.buff.iconFrame.icon:SetTexture(lustIcon)
	active.buff.cooldown:SetCooldown(GetTime() - BUFF_ELAPSED, BUFF_DURATION)
	active.buff:Show()

	local ready = frames.ready
	ready.icon:SetDesaturated(false)
	ready.readyText:Show()

	local shown = {}
	sated:SetShown(db.showSated)
	if db.showSated then
		shown[#shown + 1] = sated
	end
	active:Show()
	shown[#shown + 1] = active
	ready:SetShown(db.showReady)
	if db.showReady then
		shown[#shown + 1] = ready
	end

	LayoutRow(widget, shown)
	Preview.SetEnabled(widget, db.enable)
end

local function Update(widget, key)
	if key == "bloodlust" then
		UpdateBloodlust(widget)
	else
		UpdateBattleRes(widget)
	end
end

Preview.Register("MERTrackerPreview", 1, MIN_HEIGHT, Build, Update)
