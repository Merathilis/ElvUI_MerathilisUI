local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Auras")
local A = E:GetModule("Auras")

local next = next
local pi = math.pi
local pcall = pcall
local hooksecurefunc = hooksecurefunc

local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local CreateFrame = CreateFrame

-- Gap in pixels between the header and the collapse button.
local BUFF_COLLAPSE_GAP = 2

-- A single texture rotated per orientation instead of separate art per direction, same trick
-- Blizzard's own CollapseAndExpandButtonTemplate uses. Using ElvUI's own shipped media file
-- here (guaranteed to exist) rather than a Blizzard atlas name we can't verify against the
-- live client from outside the game.
local ARROW_WIDTH, ARROW_HEIGHT = 22, 22

-- E.Media.Textures.ArrowRight's neutral (0-rotation) orientation turned out to be the mirror of
-- what its name implies, so all four directions are offset by 180 degrees from the naive mapping.
local ROTATION = {
	RIGHT = pi,
	LEFT = 0,
	UP = (3 * pi) / 2,
	DOWN = pi / 2,
}

-- Per growthDirection: which side is the "start" of the row/column (where the button sits,
-- outside the header) and which way the arrow points when the buffs are expanded. Anchored to
-- the middle of that edge (not a corner) so it's centered on the row instead of stuck to
-- whichever corner - header/mover spans the whole configured grid (all rows), not just the
-- currently visible row, so a corner anchor drifts away from the actual icons once more than
-- one row is configured.
local GROWTH_INFO = {
	RIGHT_DOWN = { horizontal = true, expandDirection = "RIGHT", point = "RIGHT", relativePoint = "LEFT", x = -1, y = 0 },
	RIGHT_UP = { horizontal = true, expandDirection = "RIGHT", point = "RIGHT", relativePoint = "LEFT", x = -1, y = 0 },
	LEFT_DOWN = { horizontal = true, expandDirection = "LEFT", point = "LEFT", relativePoint = "RIGHT", x = 1, y = 0 },
	LEFT_UP = { horizontal = true, expandDirection = "LEFT", point = "LEFT", relativePoint = "RIGHT", x = 1, y = 0 },
	DOWN_RIGHT = { horizontal = false, expandDirection = "DOWN", point = "BOTTOM", relativePoint = "TOP", x = 0, y = 1 },
	DOWN_LEFT = { horizontal = false, expandDirection = "DOWN", point = "BOTTOM", relativePoint = "TOP", x = 0, y = 1 },
	UP_RIGHT = { horizontal = false, expandDirection = "UP", point = "TOP", relativePoint = "BOTTOM", x = 0, y = -1 },
	UP_LEFT = { horizontal = false, expandDirection = "UP", point = "TOP", relativePoint = "BOTTOM", x = 0, y = -1 },
}

local function GetDB()
	return E.db.mui.auras.buffsCollapse
end

local function UpdateButtonRotation(header)
	local btn = header.collapseButton
	local info = btn and btn.info
	if not info then
		return
	end

	local expanded = not header.collapsed
	local rotation
	if info.horizontal then
		if info.expandDirection == "LEFT" then
			rotation = expanded and ROTATION.LEFT or ROTATION.RIGHT
		else
			rotation = expanded and ROTATION.RIGHT or ROTATION.LEFT
		end
	else
		if info.expandDirection == "DOWN" then
			rotation = expanded and ROTATION.DOWN or ROTATION.UP
		else
			rotation = expanded and ROTATION.UP or ROTATION.DOWN
		end
	end

	btn.tex:SetRotation(rotation)
	btn.highlight:SetRotation(rotation)
end

-- header is a Blizzard AuraContainer (DisableUntrustedLayoutScriptsTemplate) - anchoring
-- anything to it directly gets rejected ("Anchoring disallowed ... forbidden aspects"), the same
-- way GameTooltip:SetOwner() did, and even reading its resolved screen position back out
-- (GetLeft/Right/Top/Bottom) turned out to be unreliable for it. ElvUI itself never anchors to
-- the AuraContainer either though - it anchors the AuraContainer to header.mover (a perfectly
-- normal frame it creates for the "drag to move" mover, always kept at the exact same position
-- AND size as header - see E:CreateMover/Movers.lua) and glues header on top of that with a 0,0
-- offset. So header.mover gives us a safe, ordinary, live-updating stand-in for header's own
-- geometry without ever touching header itself.
local function UpdateButtonLayout(header)
	local btn = header.collapseButton
	local mover = header.mover
	if not btn or not mover then
		return
	end

	local info = GROWTH_INFO[header.growthDirection] or GROWTH_INFO.RIGHT_DOWN
	btn.info = info

	btn:ClearAllPoints()
	btn:SetPoint(info.point, mover, info.relativePoint, info.x * BUFF_COLLAPSE_GAP, info.y * BUFF_COLLAPSE_GAP)

	-- Matches Blizzard's own CollapseAndExpandButton: a fixed-size clickable area,
	-- independent of the buff icon size, that just flips long/short axis per orientation.
	if info.horizontal then
		btn:Size(20, 40)
	else
		btn:Size(40, 20)
	end

	UpdateButtonRotation(header)
end

-- Applies (or restores) the collapsed state on the live ElvUI aura container.
-- ElvUI's Retail buff header is built on Blizzard's AuraContainer widget, which does its own
-- native sorting/flow layout - we can't just Hide() individual buff buttons without the
-- container fighting us on the next layout pass. Instead we shrink the group to a single row
-- and switch its sort to soonest-expiring-first, so long/permanent buffs are the ones that get
-- cut (mirroring Blizzard's own "hide unless about to expire" rule) while the container itself
-- keeps doing the actual (gap-free) layout.
--
-- Reapplying just SetAuraGroupMaxFrameCount/SetAuraGroupSortMethod on their own doesn't stick
-- (the container only re-evaluates candidates on a full group update), so we go through
-- E:Auras_UpdateGroup exactly like ElvUI itself does when the Wrap After/Sort Method options
-- change, reusing the same filter/candidate data ElvUI built for this group.
local function ApplyCollapsedState(header, collapsed)
	if not header or E:IsRestrictedAuras() or header.forceShowAuras then
		return
	end

	header.collapsed = collapsed

	local maxCount, sortMethod, sortDirection
	if collapsed then
		maxCount = header.numAuras or header.maxFrameCount
		sortMethod = (E.AuraContainerSortMethod and E.AuraContainerSortMethod.TIME_REMAINING) or header.sortMethod
		sortDirection = (E.AuraContainerSortDirection and E.AuraContainerSortDirection.ASCENDING) or header.sortDirection
	else
		maxCount = header.maxFrameCount
		sortMethod = header.sortMethod
		sortDirection = header.sortDirection
	end

	for key in next, header.active do
		local data = header.filters and header.filters[key]
		if data then
			pcall(E.Auras_UpdateGroup, E, header, key, data, nil, maxCount, sortMethod, sortDirection)
		end
	end

	UpdateButtonRotation(header)
end

function module:ToggleCollapsed(header)
	local collapsed = not header.collapsed
	ApplyCollapsedState(header, collapsed)

	GetDB().expanded = not collapsed
end

-- Only expanded buffs give us an accurate count (collapsed mode caps the container itself),
-- so we only re-evaluate whether the button is needed while expanded - same as Blizzard only
-- showing the button when it actually has something to hide.
function module:CheckOverflow()
	local header = A.BuffFrame
	local btn = header and header.collapseButton
	if not btn then
		return
	end

	-- Runs on its own repeating timer, independent of Refresh() - without this check, disabling
	-- the feature (Refresh Hides the button once) gets undone by the next tick re-showing it,
	-- since this had no idea the feature was just turned off.
	if not GetDB().enable then
		btn:Hide()
		return
	end

	UpdateButtonLayout(header)

	if header.forceShowAuras then
		btn:Hide()
		return
	end

	if header.collapsed then
		btn:Show()
		return
	end

	local count = 0
	for _ in next, header.buttons do
		count = count + 1
	end

	btn:SetShown(count > (header.numAuras or 0))
end

local function CreateCollapseButton(header)
	-- Must NOT be parented to header: ElvUIPlayerBuffs is built on Blizzard's AuraContainer
	-- widget (DisableUntrustedLayoutScriptsTemplate), and any frame parented inside it inherits
	-- that protection ("forbidden aspects" / UntrustedLayoutScriptExecution) - even simple,
	-- everyday calls like GameTooltip:SetOwner() get blocked/tainted on such a child. Parenting
	-- to E.UIParent instead and only using SetPoint to follow header sidesteps that entirely.
	local btn = CreateFrame("Button", "ElvUIPlayerBuffsCollapseAndExpandButton", E.UIParent)

	-- header:GetFrameStrata()/GetFrameLevel() can come back as a secret value (Blizzard's
	-- opaque-value protection) depending on context, which SetFrameStrata/SetFrameLevel then
	-- reject outright - fall back to sane defaults instead of erroring when that happens.
	local strata = header:GetFrameStrata()
	btn:SetFrameStrata(E:NotSecretValue(strata) and strata or "MEDIUM")

	local level = header:GetFrameLevel()
	btn:SetFrameLevel((E:NotSecretValue(level) and level or 1) + 5)

	local tex = btn:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(E.Media.Textures.ArrowRight)
	tex:SetSize(ARROW_WIDTH, ARROW_HEIGHT)
	tex:SetPoint("CENTER")
	btn.tex = tex

	local highlight = btn:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetTexture(E.Media.Textures.ArrowRight)
	highlight:SetSize(ARROW_WIDTH, ARROW_HEIGHT)
	highlight:SetPoint("CENTER")
	highlight:SetAlpha(0.4)
	highlight:SetBlendMode("ADD")
	btn.highlight = highlight

	btn.header = header
	header.collapseButton = btn

	btn:SetScript("OnClick", function(self)
		module:ToggleCollapsed(self.header)
	end)

	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(self.header.collapsed and L["Expand Buffs"] or L["Collapse Buffs"])
		GameTooltip:Show()
	end)

	btn:SetScript("OnLeave", GameTooltip_Hide)

	return btn
end

function module:SetupHeader(header)
	if not header or header.collapseButton then
		return
	end

	CreateCollapseButton(header)
	UpdateButtonLayout(header)
	ApplyCollapsedState(header, not GetDB().expanded)

	self:ScheduleRepeatingTimer("CheckOverflow", 0.5)
end

function module:Refresh()
	local db = GetDB()
	local header = A.BuffFrame

	if not header or not db.enable then
		if header and header.collapseButton then
			ApplyCollapsedState(header, false)
			header.collapseButton:Hide()
		end
		return
	end

	if not header.collapseButton then
		self:SetupHeader(header)
	else
		UpdateButtonLayout(header)
		ApplyCollapsedState(header, header.collapsed)
	end
end

function module:Initialize()
	if not E.Retail then
		return
	end

	hooksecurefunc(A, "UpdateHeader", function(_, header)
		if header == A.BuffFrame then
			module:Refresh()
		end
	end)

	if A.BuffFrame then
		self:Refresh()
	end
end

MER:RegisterModule(module:GetName())
