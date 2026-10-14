local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

local ipairs = ipairs
local format = format
local wipe = wipe
local tsort = table.sort
local ceil, floor, max, min = math.ceil, math.floor, math.max, math.min

local CreateFrame = CreateFrame
local GetCursorInfo = GetCursorInfo
local ClearCursor = ClearCursor
local CursorHasItem = CursorHasItem

-------------------------------------------------------------------------------
--  Compact display
-------------------------------------------------------------------------------
-- Every section (and every expansion/equipment-set group inside one) is a
-- block: a rectangle of whole item cells with its name above it. Blocks sit
-- side by side in bands, in section order; a band is one label row plus the
-- rows of its tallest block. The planner below picks the bands and block
-- widths: the least height first, then the least awkward block shapes within
-- one item row of that, and blocks widen into whatever width a band has left.

-- Space between two blocks side by side
local BLOCK_GAP = 14
-- The fewest cells a block takes when another block follows it in its band
local MID_MIN_CELLS = 3
-- Label row height on top of the font size, and the space below it
local BAND_PAD, LABEL_BELOW = 4, 3
-- Space a label leaves before the next block
local LABEL_PAD = 6
-- Room kept for the Recent Items clear button, and the label width it needs
local CLEAR_RESERVE, CLEAR_MIN_ROOM = 20, 80
-- A label's divider: its gap after the text, and the shortest one drawn
local LINE_GAP, LINE_MIN = 6, 12
-- A plan may be this many item rows taller than the shortest one when its
-- blocks are less awkward
local LOOKS_ROWS = 1

-- Item geometry of the current pass (from the options)
local pitchX, pitchY, spacingX, spacingY, gapExtra = 40, 40, 4, 4, 10

-------------------------------------------------------------------------------
--  Planner (pure: no game API; allocates nothing once its tables have grown)
-------------------------------------------------------------------------------
local function NewPackOutput()
	return {
		cellX = {},
		cellY = {},
		groupX = {},
		groupY = {},
		groupW = {},
		groupH = {},
		groupBand = {},
		labelRoom = {},
		bandH = {},
		labelBand = 0,
		-- Inputs of the last plan
		_mN = 0,
		_mColumns = 0,
		_mBandH = 0,
		_mPitchX = 0,
		_mPitchY = 0,
		_mSize = {},
		_mLabel = {},
		-- The last plan: per group its icon columns and block width in cells,
		-- per band its first and last group and its rows
		_pCols = {},
		_pWidth = {},
		_pBands = 0,
		_pFirst = {},
		_pLast = {},
		_pRows = {},
	}
end

-- The plan being made: cells and label cells per group, the column count,
-- the width a band may take, the label band height
local pSize, pColumns, pCap, pBand
local pLabel = {}
-- FitBand: each block's columns, and the widening offers in the order they go
local fbCols = {}
local offG, offCols, offGain, offCost = {}, {}, {}, {}
-- Plans kept to build on, as records: height, awkwardness, wrapped rows, the
-- first band's last group and rows, and the record of the plan after it
local rH, rA, rW, rJ, rK, rRest = {}, {}, {}, {}, {}, {}
-- The kept records for groups i..n: kept[keptAt[i]] .. kept[keptAt[i] + keptN[i] - 1]
local kept, keptAt, keptN = {}, {}, {}
-- Candidate plans for the current first group (candQ: height in half px)
local candH, candQ, candA, candW, candJ, candK, candRest, candOrd = {}, {}, {}, {}, {}, {}, {}, {}
local candN, candTop = 0, 0

-- Block width in cells for cols icon columns: at least its label, and
-- MID_MIN_CELLS unless it is its band's last block, at most the column count
local function BlockW(g, cols, last)
	local w = pLabel[g]
	if cols > w then
		w = cols
	end
	if not last and w < MID_MIN_CELLS then
		w = MID_MIN_CELLS
	end
	if w > pColumns then
		w = pColumns
	end
	return w
end

-- Icon columns of a block held to k rows
local function BandCols(g, k)
	local s = pSize[g]
	if s <= k then
		return 1
	end
	return ceil(s / k)
end

local function Rows(g, cols)
	local s = pSize[g]
	if s == 0 then
		return 0
	end
	return ceil(s / cols)
end

-- 0..2: a block wider than 7 columns or needlessly narrow, and one whose
-- last row holds a single icon. A block with no icons is never awkward.
local function Awk(g, cols)
	local s = pSize[g]
	if s == 0 then
		return 0
	end
	local a = 0
	if cols > 7 or cols < min(3, s) then
		a = 1
	end
	if cols > 1 and s > cols and s % cols == 1 then
		a = a + 1
	end
	return a
end

-- Width of the band i..j with every block held to k rows
local function BandWidth(i, j, k)
	local w = (j - i) * gapExtra
	for m = i, j do
		w = w + BlockW(m, BandCols(m, k), m == j) * pitchX
	end
	return w
end

-- The most rows of a block in the band i..j held to k rows
local function BandRows(i, j, k)
	local r = 0
	for m = i, j do
		local rows = Rows(m, BandCols(m, k))
		if rows > r then
			r = rows
		end
	end
	return r
end

-- Holds the band i..j to k rows, then spends its spare width widening
-- blocks: first the awkward ones (best awkwardness gain per extra cell
-- first), then from its last block back, a block takes its narrowest wider
-- shape with fewer rows that is no more awkward, round after round while any
-- block takes one. Widening never adds rows. Leaves each block's columns in
-- fbCols; returns the band's height and awkwardness.
local function FitBand(i, j, k)
	local w, offers = (j - i) * gapExtra, 0
	for m = i, j do
		local c = BandCols(m, k)
		fbCols[m] = c
		local last = m == j
		w = w + BlockW(m, c, last) * pitchX
		local now = Awk(m, c)
		local bestC, bestA = 0, now
		for wider = c + 1, (now > 0) and min(pSize[m], pColumns) or 0 do
			if wider > 7 and bestA <= 1 then
				break
			end
			local a = Awk(m, wider)
			if a < bestA then
				bestC, bestA = wider, a
				if a == 0 then
					break
				end
			end
		end
		if bestC > 0 then
			local gain, cost = now - bestA, BlockW(m, bestC, last) - BlockW(m, c, last)
			offers = offers + 1
			local at = offers
			while at > 1 and cost * offGain[at - 1] < offCost[at - 1] * gain do
				offG[at], offCols[at], offGain[at], offCost[at] =
					offG[at - 1], offCols[at - 1], offGain[at - 1], offCost[at - 1]
				at = at - 1
			end
			offG[at], offCols[at], offGain[at], offCost[at] = m, bestC, gain, cost
		end
	end

	local spare = pCap - w
	for o = 1, offers do
		local cost = offCost[o] * pitchX
		if cost <= spare then
			spare = spare - cost
			fbCols[offG[o]] = offCols[o]
		end
	end

	local took = true
	while took do
		took = false
		for m = j, i, -1 do
			local c = fbCols[m]
			local rows, now = Rows(m, c), Awk(m, c)
			for wider = c + 1, min(pSize[m], pColumns) do
				if wider > 7 and now == 0 then
					break
				end
				if Rows(m, wider) < rows and Awk(m, wider) <= now then
					local cost = (BlockW(m, wider, m == j) - BlockW(m, c, m == j)) * pitchX
					if cost <= spare then
						spare = spare - cost
						fbCols[m] = wider
						took = true
					end
					break
				end
			end
		end
	end

	local r, awk = 0, 0
	for m = i, j do
		local c = fbCols[m]
		local rows = Rows(m, c)
		if rows > r then
			r = rows
		end
		awk = awk + Awk(m, c)
	end
	return pBand + r * pitchY, awk
end

-- Adds the candidate plans that open with the band i..j held to k rows: one
-- per kept plan for the groups after it
local function Consider(i, j, k)
	local h, awk = FitBand(i, j, k)
	local at = keptAt[j + 1]
	for x = at, at + keptN[j + 1] - 1 do
		local r = kept[x]
		local total = h + rH[r]
		candN = candN + 1
		candH[candN], candQ[candN] = total, floor(total * 2 + 0.5)
		candA[candN], candW[candN] = awk + rA[r], (k - 1) + rW[r]
		candJ[candN], candK[candN], candRest[candN] = j, k, r
		candOrd[candN] = candN
	end
end

-- Least height first, then least awkward, then fewest wrapped rows, then the
-- order the candidates were made in
local function CandBefore(a, b)
	if candQ[a] ~= candQ[b] then
		return candQ[a] < candQ[b]
	end
	if candA[a] ~= candA[b] then
		return candA[a] < candA[b]
	end
	if candW[a] ~= candW[b] then
		return candW[a] < candW[b]
	end
	return a < b
end

-- Chooses the bands and block widths for groups 1..n by dynamic programming
-- from the last group back: a plan for groups i..n is a first band i..j held
-- to k rows, then a kept plan for groups j + 1..n. Each i keeps its shortest
-- plan and every strictly less awkward one within LOOKS_ROWS rows of it. The
-- least awkward plan kept for group 1 goes to out's plan fields.
local function Plan(n, out)
	rH[1], rA[1], rW[1], rJ[1] = 0, 0, 0, false
	local rN, kN = 1, 1
	kept[1], keptAt[n + 1], keptN[n + 1] = 1, 1, 1
	local allowQ = 2 * LOOKS_ROWS * pitchY
	for i = n, 1, -1 do
		candN = 0
		local kMin, kMax, before = 1, 1, -gapExtra
		for j = i, n do
			local s = pSize[j]
			local need = ceil(s / pColumns)
			if need > kMin then
				kMin = need
			end
			if s > kMax then
				kMax = s
			end
			-- Stop once even one-column blocks no longer fit
			if j > i and before + gapExtra + BlockW(j, 1, true) * pitchX > pCap then
				break
			end
			before = before + gapExtra + BlockW(j, 1) * pitchX

			-- The fewest rows that fit
			local k = kMin
			if j > i then
				local hi = kMax
				while k < hi do
					local mid = floor((k + hi) / 2)
					if BandWidth(i, j, mid) <= pCap then
						hi = mid
					else
						k = mid + 1
					end
				end
			end
			Consider(i, j, k)

			local rows = BandRows(i, j, k)
			for more = k + 1, kMax do
				if BandRows(i, j, more) > rows + LOOKS_ROWS then
					break
				end
				-- The same block shapes as at more - 1 only add longer copies
				local differs = false
				for m = i, j do
					if BandCols(m, more) ~= BandCols(m, more - 1) then
						differs = true
						break
					end
				end
				if differs then
					Consider(i, j, more)
				end
			end
		end

		for x = candN + 1, candTop do
			candOrd[x] = nil
		end
		candTop = candN
		tsort(candOrd, CandBefore)

		local limit = candQ[candOrd[1]] + allowQ
		local first, lastA = kN + 1, nil
		for x = 1, candN do
			local c = candOrd[x]
			if candQ[c] > limit then
				break
			end
			if not lastA or candA[c] < lastA then
				lastA = candA[c]
				rN = rN + 1
				rH[rN], rA[rN], rW[rN] = candH[c], lastA, candW[c]
				rJ[rN], rK[rN], rRest[rN] = candJ[c], candK[c], candRest[c]
				kN = kN + 1
				kept[kN] = rN
			end
		end
		keptAt[i], keptN[i] = first, kN - first + 1
	end

	-- Unroll the answer band by band
	local pCols, pWidth, pFirst, pLast, pRows = out._pCols, out._pWidth, out._pFirst, out._pLast, out._pRows
	local r, i, nb = kept[keptAt[1] + keptN[1] - 1], 1, 0
	while rJ[r] do
		local j = rJ[r]
		FitBand(i, j, rK[r])
		nb = nb + 1
		pFirst[nb], pLast[nb] = i, j
		local most = 0
		for m = i, j do
			local c = fbCols[m]
			pCols[m], pWidth[m] = c, BlockW(m, c, m == j)
			local rows = Rows(m, c)
			if rows > most then
				most = rows
			end
		end
		pRows[nb] = most
		i, r = j + 1, rRest[r]
	end
	out._pBands = nb
end

-- Lays n groups out as blocks in bands. size[g] = cells of group g (0 = just
-- a label), labelW[g] = its label's width in px. x values are px from the
-- content's left edge, y values negative down from 0. The plan is memoised in
-- out and only made again when an input changed. Returns the bottom y.
local function Pack(size, labelW, n, columns, bandH, out)
	if columns < 1 then
		columns = 1
	end

	local mSize, mLabel = out._mSize, out._mLabel
	local same = out._mN == n
		and out._mColumns == columns
		and out._mBandH == bandH
		and out._mPitchX == pitchX
		and out._mPitchY == pitchY
	for g = 1, n do
		local s, lw = size[g], ceil(labelW[g])
		if mSize[g] ~= s or mLabel[g] ~= lw then
			mSize[g], mLabel[g] = s, lw
			same = false
		end
	end

	-- The labels keep their row at the band's top; the icons start below
	local band = bandH + LABEL_BELOW
	if not same then
		out._mN, out._mColumns, out._mBandH, out._mPitchX, out._mPitchY = n, columns, bandH, pitchX, pitchY
		pSize, pColumns, pCap, pBand = mSize, columns, columns * pitchX, band
		for g = 1, n do
			pLabel[g] = max(1, ceil((mLabel[g] + 2 * spacingX - BLOCK_GAP) / pitchX))
		end
		Plan(n, out)
	end

	out.labelBand = band
	local cellX, cellY = out.cellX, out.cellY
	local groupX, groupY, groupW, groupH = out.groupX, out.groupY, out.groupW, out.groupH
	local groupBand, labelRoom, bandHeight = out.groupBand, out.labelRoom, out.bandH
	local pCols, pWidth, pFirst, pLast, pRows = out._pCols, out._pWidth, out._pFirst, out._pLast, out._pRows
	local rightX = columns * pitchX - spacingX
	local y, ci, nb, widest = 0, 0, out._pBands, 0

	for b = 1, nb do
		local h = band + pRows[b] * pitchY
		bandHeight[b] = h
		local last, x = pLast[b], 0
		for g = pFirst[b], last do
			local cols, s = pCols[g], size[g]
			local rows = (s > 0) and ceil(s / cols) or 0
			local w = pWidth[g] * pitchX - spacingX
			groupX[g], groupY[g] = x, y
			groupW[g], groupH[g] = w, band + rows * pitchY - spacingY
			groupBand[g] = b
			if g < last then
				labelRoom[g] = w + BLOCK_GAP - LABEL_PAD
			elseif x + w > widest then
				widest = x + w
			end

			local top = y - band
			for t = 0, s - 1 do
				local row = floor(t / cols)
				ci = ci + 1
				cellX[ci] = x + (t - row * cols) * pitchX
				cellY[ci] = top - row * pitchY
			end
			x = x + w + BLOCK_GAP
		end
		y = y - h
	end

	-- A band's last label may run to the right edge
	local edge = rightX
	if nb > 0 and rightX - widest > 0 and rightX - widest < pitchX then
		edge = widest
	end
	for b = 1, nb do
		local g = pLast[b]
		labelRoom[g] = max(edge - groupX[g], groupW[g] + BLOCK_GAP - LABEL_PAD)
	end

	return y
end

-------------------------------------------------------------------------------
--  Labels
-------------------------------------------------------------------------------
-- Click a label to fold or unfold its section, like a Grid header.
local function Label_OnClick(self)
	if not self.sectionKey or self.searching then
		return
	end

	local collapsed = module.db.collapsedSections
	collapsed[self.sectionKey] = (not collapsed[self.sectionKey]) or nil
	if self.refresh then
		self.refresh()
	end
end

local function Label_OnEnter(self)
	local cc = E.myClassColor
	self.text:SetTextColor(cc.r, cc.g, cc.b)

	if (self.isCut or self.hint) and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(self.fullText, 1, 1, 1)
		if self.hint then
			GameTooltip:AddLine(self.hint, 0.6, 0.6, 0.6, true)
		end
		GameTooltip:Show()
	end
end

local function Label_OnLeave(self)
	self.text:SetTextColor(self.textR, self.textG, self.textB)
	GameTooltip_Hide()
end

local function GetLabel(frame, index)
	local pool = frame.compactLabels
	if not pool then
		pool = {}
		frame.compactLabels = pool
	end

	local label = pool[index]
	if label then
		return label
	end

	label = CreateFrame("Button", nil, frame.contentChild)
	label:RegisterForClicks("LeftButtonUp")
	label:SetScript("OnClick", Label_OnClick)
	label:SetScript("OnEnter", Label_OnEnter)
	label:SetScript("OnLeave", Label_OnLeave)

	label.icon = label:CreateTexture(nil, "ARTWORK")
	label.icon:Point("LEFT")

	label.text = label:CreateFontString(nil, "OVERLAY")
	label.text:SetJustifyH("LEFT")
	label.text:SetWordWrap(false)

	local cc = E.myClassColor
	label.line = label:CreateTexture(nil, "ARTWORK")
	label.line:SetColorTexture(cc.r, cc.g, cc.b, 0.35)
	label.line:Height(1)

	label.clearButton = CreateFrame("Button", nil, label)
	label.clearButton:Size(12)
	pcall(label.clearButton.SetTemplate, label.clearButton)
	label.clearButton.tex = label.clearButton:CreateTexture(nil, "OVERLAY")
	label.clearButton.tex:SetAllPoints()
	label.clearButton.tex:SetTexture(E.Media.Textures.Close)
	label.clearButton:SetScript("OnEnter", function(self)
		self.tex:SetVertexColor(cc.r, cc.g, cc.b)
	end)
	label.clearButton:SetScript("OnLeave", function(self)
		self.tex:SetVertexColor(1, 1, 1)
	end)
	label.clearButton:Hide()

	pool[index] = label
	return label
end

-- Sets font, icon and text; returns the label's full width in px
local function MeasureLabel(label, group)
	local font = module.db.headerFont
	label.text:FontTemplate(font.name, font.size, font.style)
	label.text:SetText(group.label)
	label.fullText = group.label

	local iconWidth = 0
	if group.section and group.isFirst then
		local size = font.size + 2
		label.icon:Size(size)
		module.SetCategoryIcon(label.icon, group.section)
		label.icon:Show()
		iconWidth = size + 4
	else
		label.icon:Hide()
	end
	label.iconWidth = iconWidth

	return iconWidth + (label.text:GetUnboundedStringWidth() or 0)
end

local function ShowLabel(ctx, label, group, x, y, room, bandH, blockW, searching)
	local reserve = group.showClear and room >= CLEAR_MIN_ROOM and CLEAR_RESERVE or 0
	local textRoom = max(1, room - reserve - label.iconWidth)
	local textW = label.text:GetUnboundedStringWidth() or 0

	label:ClearAllPoints()
	label:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", x, y)
	label:Size(max(1, room), bandH)

	label.text:ClearAllPoints()
	label.text:Point("LEFT", label, "LEFT", label.iconWidth, 0)
	label.text:Width(textRoom)
	label.isCut = textW > textRoom

	if group.collapsed then
		label.textR, label.textG, label.textB = 0.5, 0.5, 0.5
	else
		label.textR, label.textG, label.textB = 1, 1, 1
	end
	label.text:SetTextColor(label.textR, label.textG, label.textB)

	label.sectionKey = group.section and group.section.key
	label.refresh = ctx.refresh
	label.searching = searching
	label.hint = group.collapsed and L["Click to unfold."] or nil

	-- Divider from the text end to the block's right edge
	local lineX = label.iconWidth + min(textW, textRoom) + LINE_GAP
	local lineEnd = min(blockW, room - reserve)
	if lineEnd - lineX >= LINE_MIN then
		label.line:ClearAllPoints()
		label.line:Point("LEFT", label, "LEFT", lineX, 0)
		label.line:Width(lineEnd - lineX)
		label.line:Show()
	else
		label.line:Hide()
	end

	if reserve > 0 then
		local section = group.section
		label.clearButton:ClearAllPoints()
		label.clearButton:Point("RIGHT", label, "LEFT", room - 4, 0)
		label.clearButton:SetScript("OnClick", function()
			module.ClearRecentSection(section)
			ctx.refresh()
		end)
		label.clearButton:Show()
	else
		label.clearButton:Hide()
	end

	label:Show()
end

-------------------------------------------------------------------------------
--  Drop zones
-------------------------------------------------------------------------------
-- While an item is on the cursor, every block it can be assigned to (or the
-- Pinned block, to pin it) is covered by a drop zone - the "+" slots of the
-- Grid display, which would not fit between packed blocks. A block that
-- already holds the item keeps no zone, so dropping onto its own items still
-- swaps or stacks them. Hidden (and not clickable) the rest of the time.
local function Zone_OnDrop(self)
	if not (CursorHasItem() and self.onAssign) then
		return
	end

	local kind, itemID = GetCursorInfo()
	if kind == "item" and itemID then
		ClearCursor()
		self.onAssign(itemID)
	end
end

local function Zone_OnEnter(self)
	local cc = E.myClassColor
	self.fill:SetColorTexture(cc.r, cc.g, cc.b, 0.35)
	if self.tooltipText and not GameTooltip:IsForbidden() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(self.tooltipText, 1, 1, 1, true)
		GameTooltip:Show()
	end
end

local function Zone_OnLeave(self)
	local cc = E.myClassColor
	self.fill:SetColorTexture(cc.r, cc.g, cc.b, 0.2)
	GameTooltip_Hide()
end

local function GetZone(frame, index)
	local pool = frame.compactZones
	local zone = pool[index]
	if zone then
		return zone
	end

	zone = CreateFrame("Button", nil, frame.contentChild)
	zone:RegisterForClicks("AnyUp")

	local cc = E.myClassColor
	zone.fill = zone:CreateTexture(nil, "BACKGROUND")
	zone.fill:SetAllPoints()
	zone.fill:SetColorTexture(cc.r, cc.g, cc.b, 0.2)

	zone.plusIcon = zone:CreateTexture(nil, "OVERLAY")
	zone.plusIcon:SetSize(16, 16)
	zone.plusIcon:Point("CENTER")
	zone.plusIcon:SetTexture(E.Media.Textures.Plus)
	zone.plusIcon:SetVertexColor(cc.r, cc.g, cc.b)

	zone:SetScript("OnReceiveDrag", Zone_OnDrop)
	zone:SetScript("OnMouseUp", Zone_OnDrop)
	zone:SetScript("OnEnter", Zone_OnEnter)
	zone:SetScript("OnLeave", Zone_OnLeave)
	zone:Hide()

	pool[index] = zone
	return zone
end

local function SyncZones(frame)
	local pool = frame.compactZones
	if not pool or not frame.compactZoneCount then
		return
	end

	local kind, itemID = GetCursorInfo()
	if kind ~= "item" then
		itemID = nil
	end

	for i = 1, frame.compactZoneCount do
		local zone = pool[i]
		local show = false
		if itemID then
			if zone.isPin then
				show = not module:IsItemPinned(itemID)
			else
				show = not zone.heldItems[itemID]
			end
		end
		zone:SetShown(show)
	end
end

-- Hooked into the cursor watch (module.OnCursorChanged) once per window
local function RegisterZoneSync(frame)
	if frame.compactZones then
		return
	end

	frame.compactZones = {}
	module.placeholderPools[#module.placeholderPools + 1] = function()
		if frame:IsShown() and frame.compactZoneCount then
			SyncZones(frame)
		end
	end
end

-------------------------------------------------------------------------------
--  Render
-------------------------------------------------------------------------------
-- One pass's groups, reused (entries past groupCount are stale)
local groups = {}
local groupSize, groupLabelW = {}, {}
local cells = {}

local function AddGroup(n, section, label, isFirst, collapsed, showClear)
	local group = groups[n]
	if not group then
		group = {}
		groups[n] = group
	end
	group.section = section
	group.label = label
	group.isFirst = isFirst
	group.collapsed = collapsed
	group.showClear = showClear
	group.firstCell = nil
	groupSize[n] = 0
	return group
end

-- Splits the sections into blocks: one per section, or one per expansion/
-- equipment-set group inside it (the first named "<section>: <group>").
local function CollectGroups(sections, searching)
	local n, cellCount = 0, 0
	local collapsedSections = module.db.collapsedSections

	for _, section in ipairs(sections) do
		local collapsed = not searching and collapsedSections[section.key] and true or false
		local count = section.itemCount or #section.items
		local items = section.items
		local subHeaders = section.subHeaders

		if collapsed or #items == 0 then
			n = n + 1
			AddGroup(n, section, format("%s (%d)", section.name, count), true, collapsed, false)
		else
			local firstSub = subHeaders and subHeaders[1]
			local leadEnd = firstSub and (firstSub.index - 1) or #items

			-- Items in front of the first sub-header (or all of them)
			if leadEnd > 0 then
				n = n + 1
				AddGroup(n, section, format("%s (%d)", section.name, count), true, false, section.showClear)
				for i = 1, leadEnd do
					cellCount = cellCount + 1
					cells[cellCount] = items[i]
					groupSize[n] = groupSize[n] + 1
				end
			end

			if subHeaders then
				for s, sub in ipairs(subHeaders) do
					local runEnd = (subHeaders[s + 1] and subHeaders[s + 1].index or (#items + 1)) - 1
					local isFirst = leadEnd == 0 and s == 1
					local label = isFirst and format("%s: %s (%d)", section.name, sub.name, sub.count)
						or format("%s (%d)", sub.name, sub.count)
					n = n + 1
					AddGroup(n, section, label, isFirst, false, isFirst and section.showClear)
					for i = sub.index, runEnd do
						cellCount = cellCount + 1
						cells[cellCount] = items[i]
						groupSize[n] = groupSize[n] + 1
					end
				end
			end
		end
	end

	return n
end

function module.HideCompactContent(ctx)
	local frame = ctx.frame
	if not frame or not frame.compactActive then
		return
	end

	frame.compactActive = nil
	frame.compactZoneCount = nil
	for _, label in ipairs(frame.compactLabels or {}) do
		label:Hide()
	end
	for _, zone in ipairs(frame.compactZones or {}) do
		zone:Hide()
	end
end

function module.RenderCompactContent(ctx, sections, contentWidth)
	local db = module.db
	local frame = ctx.frame
	local pools = ctx.pools
	local searching = module.searchText and module.searchText ~= ""

	frame.compactActive = true
	RegisterZoneSync(frame)

	pitchX = db.itemSize + db.itemSpacingH
	pitchY = db.itemSize + db.itemSpacingV
	spacingX = db.itemSpacingH
	spacingY = db.itemSpacingV
	gapExtra = BLOCK_GAP - spacingX

	local columns = max(1, floor((contentWidth + spacingX) / pitchX))
	local bandH = db.headerFont.size + BAND_PAD

	local n = CollectGroups(sections, searching)

	for g = 1, n do
		local group = groups[g]
		local width = MeasureLabel(GetLabel(frame, g), group)
		groupLabelW[g] = group.showClear and (width + CLEAR_RESERVE) or width
	end
	for i = n + 1, #(frame.compactLabels or {}) do
		frame.compactLabels[i]:Hide()
	end

	if n == 0 then
		frame.compactZoneCount = 0
		for _, zone in ipairs(frame.compactZones) do
			zone:Hide()
		end
		pools.ReleaseSlotsFrom(1)
		return 0
	end

	frame.compactPack = frame.compactPack or NewPackOutput()
	local out = frame.compactPack
	local bottomY = Pack(groupSize, groupLabelW, n, columns, bandH, out)

	-- Labels, and where each section starts for the sidebar
	for g = 1, n do
		local group = groups[g]
		if group.isFirst then
			ctx.offsets[group.section.key] = -out.groupY[g]
		end
		ShowLabel(
			ctx,
			GetLabel(frame, g),
			group,
			out.groupX[g],
			out.groupY[g],
			out.labelRoom[g],
			bandH,
			out.groupW[g],
			searching
		)
	end

	-- Item slots
	local cellIndex = 0
	for g = 1, n do
		local orderKey = groups[g].section.orderKey
		for _ = 1, groupSize[g] do
			cellIndex = cellIndex + 1
			local btn = pools.AcquireSlot(cellIndex)
			module.UpdateSlotVisual(btn, cells[cellIndex])
			btn.orderKey = orderKey
			btn:ClearAllPoints()
			btn:Size(db.itemSize)
			btn:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", out.cellX[cellIndex], out.cellY[cellIndex])
		end
	end
	pools.ReleaseSlotsFrom(cellIndex + 1)

	-- Drop zones over every block that can take an item
	local zoneCount, zoneLevel = 0, ctx.contentChild:GetFrameLevel() + 20
	local heldBySection = {}
	for g = 1, n do
		local group = groups[g]
		local section = group.section
		local onAssign, tooltipText = module.GetSectionAssignHandler(ctx, section)

		local held = heldBySection[section]
		if onAssign and not held then
			held = {}
			for _, entry in ipairs(section.items) do
				if entry.itemID then
					held[entry.itemID] = true
				end
			end
			heldBySection[section] = held
		end

		if onAssign then
			zoneCount = zoneCount + 1
			local zone = GetZone(frame, zoneCount)
			local height = out.groupH[g]
			-- A block without items also takes the empty space under its label
			if groupSize[g] == 0 then
				height = max(out.bandH[out.groupBand[g]] - spacingY, out.labelBand)
			end
			zone:SetFrameLevel(zoneLevel)
			zone:ClearAllPoints()
			zone:Point("TOPLEFT", ctx.contentChild, "TOPLEFT", out.groupX[g], out.groupY[g])
			zone:Size(max(out.groupW[g], db.itemSize), max(height, db.itemSize))
			zone.isPin = section.key == module.PinnedCategory.key
			zone.heldItems = held
			zone.onAssign = onAssign
			zone.tooltipText = tooltipText
		end
	end
	for i = zoneCount + 1, #frame.compactZones do
		frame.compactZones[i]:Hide()
	end
	frame.compactZoneCount = zoneCount
	SyncZones(frame)

	wipe(cells)

	return -bottomY + 6
end
