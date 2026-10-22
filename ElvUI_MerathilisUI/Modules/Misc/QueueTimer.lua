local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local WS = W:GetModule("Skins")

local _G = _G
local ceil = math.ceil

local CreateFrame = CreateFrame
local GetBattlefieldPortExpiration = GetBattlefieldPortExpiration
local GetTime = GetTime
local hooksecurefunc = hooksecurefunc
local wipe = wipe

local LFG_PROPOSAL_TIME = 40 -- the client has no API for it, a dungeon invite always runs 40 seconds
local BAR_HEIGHT = 14
local URGENT_TIME = 10

local function Bar_OnUpdate(self)
	local timeLeft = self.expiresAt - GetTime()
	if timeLeft <= 0 then
		self:SetValue(0)
		self.text:SetText("")
		return
	end

	self:SetValue(timeLeft)
	self.text:SetText(ceil(timeLeft))
	if timeLeft <= URGENT_TIME then
		self.text:SetTextColor(1, 0.25, 0.25)
	else
		self.text:SetTextColor(1, 1, 1)
	end
end

---Runs the bar from `duration` seconds down; `total` is the full length of the invite, the bar starts
---partly drained when the dialog shows up late (after a reload, or for a second PvP queue)
---@param bar StatusBar
---@param duration number
---@param total number
local function StartBar(bar, duration, total)
	bar.expiresAt = GetTime() + duration
	bar:SetMinMaxValues(0, total)
	Bar_OnUpdate(bar)
end

---A countdown bar hanging below `parent`; it only ticks while the dialog is open, OnUpdate stops with it
---@param parent Frame
---@return StatusBar
local function CreateBar(parent)
	local bar = CreateFrame("StatusBar", nil, parent)
	bar:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -5)
	bar:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -5)
	bar:Height(BAR_HEIGHT)
	bar:SetStatusBarTexture(E.media.normTex)
	F.Color.SetGradient(bar:GetStatusBarTexture(), "HORIZONTAL", F.GradientColors(E.myclass))
	bar:CreateBackdrop("Transparent")
	WS:CreateBackdropShadow(bar)

	bar.text = bar:CreateFontString(nil, "OVERLAY")
	bar.text:FontTemplate(nil, 12, "SHADOWOUTLINE")
	bar.text:SetPoint("CENTER")

	bar.expiresAt = 0
	bar:SetScript("OnUpdate", Bar_OnUpdate)

	return bar
end

---BigWigs hangs its own LFG timer below the same dialog; ours takes its place
local function HideBigWigsTimer()
	local loader = _G.BigWigsLoader
	if not (loader and loader.RegisterMessage) then
		return
	end

	loader.RegisterMessage(module, "BigWigs_FrameCreated", function(_, frame, name)
		if name == "QueueTimer" then
			frame:Hide()
		end
	end)
end

function module:QueueTimer()
	if not E.db.mui.misc.queueTimer then
		return
	end

	-- The popup holds the invite and, once accepted, the status of the others: the timer runs through both
	local lfgPopup = _G.LFGDungeonReadyPopup
	if lfgPopup then
		local lfgBar = CreateBar(lfgPopup)
		lfgBar:RegisterEvent("LFG_PROPOSAL_SHOW")
		lfgBar:SetScript("OnEvent", function(self)
			StartBar(self, LFG_PROPOSAL_TIME, LFG_PROPOSAL_TIME)
		end)

		HideBigWigsTimer()
	end

	local pvpDialog = _G.PVPReadyDialog
	if pvpDialog and GetBattlefieldPortExpiration then
		local pvpBar = CreateBar(pvpDialog)
		local totals = {}

		-- Called on every UPDATE_BATTLEFIELD_STATUS while an invite is up, so the length of each queue's
		-- invite is taken from the first call only
		hooksecurefunc("PVPReadyDialog_Display", function(_, index)
			local timeLeft = GetBattlefieldPortExpiration(index)
			if not timeLeft or timeLeft <= 0 then
				return
			end

			if not totals[index] or timeLeft > totals[index] then
				totals[index] = timeLeft
			end
			StartBar(pvpBar, timeLeft, totals[index])
		end)

		pvpDialog:HookScript("OnHide", function()
			wipe(totals)
		end)
	end
end

module:AddCallback("QueueTimer")
