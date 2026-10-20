local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

local C_Timer_After = C_Timer.After

-- ElvUI gives the quest log headers (zones, Meta Quests, minimal campaign
-- headers) an opaque default backdrop; switch them to the transparent template
-- so they match the rest of our style. SetTemplate registers the template, so
-- ElvUI's later backdrop sweeps keep it.
local function SetBackdropTransparent(backdrop)
	if backdrop and not backdrop.MERTransparent then
		backdrop:SetTemplate("Transparent")
		backdrop.MERTransparent = true
	end
end

local function UpdateHeaders()
	local scrollFrame = _G.QuestScrollFrame

	for header in scrollFrame.headerFramePool:EnumerateActive() do
		SetBackdropTransparent(header.backdrop)
	end

	for header in scrollFrame.campaignHeaderMinimalFramePool:EnumerateActive() do
		SetBackdropTransparent(header.Background and header.Background.backdrop)
	end
end

local queued
local function QueueHeaderUpdate()
	if queued then
		return
	end
	queued = true

	-- Deferred: ElvUI creates the header backdrops in its own QuestLogQuests_Update
	-- hook, which may be registered after ours
	C_Timer_After(0, function()
		queued = nil
		UpdateHeaders()
	end)
end

function module:WorldMapFrame()
	if not E.private.skins.blizzard.enable or not E.private.skins.blizzard.worldmap then
		return
	end

	if not _G.QuestScrollFrame then
		return
	end

	hooksecurefunc("QuestLogQuests_Update", QueueHeaderUpdate)
	QueueHeaderUpdate()
end

module:AddCallback("WorldMapFrame")
