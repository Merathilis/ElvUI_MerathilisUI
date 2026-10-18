local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

local C_Timer_After = C_Timer.After

-- ElvUI gives some journal rows (Traveler's Log, Item Sets) an opaque default
-- backdrop; switch them to the transparent template so they match the rest of
-- our style. SetTemplate registers the template, so ElvUI's later backdrop
-- sweeps keep it.
local function SetRowTransparent(row)
	local backdrop = row.backdrop
	if backdrop and not backdrop.MERTransparent then
		backdrop:SetTemplate("Transparent")
		backdrop.MERTransparent = true
	end
end

local queued = {}
local function QueueRowUpdate(scrollBox)
	if queued[scrollBox] then
		return
	end
	queued[scrollBox] = true

	-- Deferred: ElvUI creates the row backdrops in its own ScrollBox.Update hook,
	-- which may be registered after ours
	C_Timer_After(0, function()
		queued[scrollBox] = nil
		scrollBox:ForEachFrame(SetRowTransparent)
	end)
end

local function HookScrollBox(scrollBox)
	if not scrollBox then
		return
	end

	hooksecurefunc(scrollBox, "Update", QueueRowUpdate)
	QueueRowUpdate(scrollBox)
end

function module:Blizzard_EncounterJournal()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.encounterjournal then
		return
	end

	-- ElvUI only replaces the row art with backdrops when the parchment remover is on
	if not E.private.skins.parchmentRemoverEnable then
		return
	end

	local journal = _G.EncounterJournal

	-- Traveler's Log
	local monthlyActivities = _G.EncounterJournalMonthlyActivitiesFrame
	HookScrollBox(monthlyActivities and monthlyActivities.ScrollBox)

	-- Item Sets
	local itemSets = journal and journal.LootJournalItems and journal.LootJournalItems.ItemSetsFrame
	HookScrollBox(itemSets and itemSets.ScrollBox)
end

module:AddCallbackForAddon("Blizzard_EncounterJournal")
