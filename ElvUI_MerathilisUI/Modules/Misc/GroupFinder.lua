local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_GroupFinder")

-- Additions for the Premade Groups list on top of ElvUI's skin. Works alongside
-- WindTools' LFG List (role icons, score text) and Group Info tooltip instead of
-- repeating what they already show.

-- Blizzard_GroupFinder is Mainline only, WindTools' LFG List is off there too
if E.Forever then
	function module:Initialize() end
	function module:DatabaseUpdate() end
	function module:ResetApplications() end
	MER:RegisterModule(module:GetName())
	return
end

local _G = _G
local format = format
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = math.max
local pairs = pairs
local tconcat = table.concat
local time = time
local tonumber = tonumber
local type = type
local wipe = wipe

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_LFGList = C_LFGList
local CreateAtlasMarkup = CreateAtlasMarkup
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceEncounterInfo = GetSavedInstanceEncounterInfo
local GetSavedInstanceInfo = GetSavedInstanceInfo
local canaccesstable = canaccesstable
local issecretvalue = issecretvalue

local ROLE_ORDER = { "TANK", "HEALER", "DAMAGER" }
local FIVE_SLOTS = { TANK = 1, HEALER = 1, DAMAGER = 3 } -- the roles of a 5 player group
local ROLE_ATLAS = {
	TANK = "groupfinder-icon-role-micro-tank",
	HEALER = "groupfinder-icon-role-micro-heal",
	DAMAGER = "groupfinder-icon-role-micro-dps",
}
local EMPTY_SLOT_ATLAS = "groupfinder-icon-emptyslot"
local LEAVER_ATLAS = "groupfinder-icon-leaver"

-- Application outcomes per counted M+ application, in bar order
local SEGMENTS = {
	{ key = "accepted", label = L["Accepted"], r = 0.35, g = 0.85, b = 0.4 },
	{ key = "declined", label = L["Declined"], r = 0.95, g = 0.3, b = 0.3 },
	{ key = "delisted", label = L["Delisted"], r = 1, g = 0.6, b = 0.2 },
	{ key = "cancelled", label = L["Cancelled"], r = 0.55, g = 0.55, b = 0.55 },
}
local STATUS_KEY = {
	applied = "applied",
	declined = "declined",
	declined_full = "declined",
	timedout = "declined",
	declined_delisted = "delisted",
	cancelled = "cancelled",
	invited = "accepted", -- every invite counts as accepted
	inviteaccepted = "accepted",
}
local SCOPES = { "session", "character", "account" }
local SCOPE_LABEL = { session = L["Session"], character = L["Character"], account = L["Account"] }
local SESSION_GAP = 300 -- relogging or reloading within 5 minutes keeps the session

local layers = setmetatable({}, { __mode = "k" }) -- Blizzard role icon -> our drawing above it
local missingScratch = {}
local seenResults, prevResults = {}, nil -- latest / previous search's result IDs
local prevCategory
local isMythicPlus = {} -- resultID -> applied group is a Mythic+ one

local function IsSecret(value)
	return issecretvalue and issecretvalue(value) or false
end

local function ResultInfo(resultID)
	local info = resultID and C_LFGList.GetSearchResultInfo(resultID)
	if type(info) ~= "table" or IsSecret(info) or (canaccesstable and not canaccesstable(info)) then
		return nil
	end
	return info
end

local function ActivityInfo(info)
	local activities = info and info.activityIDs
	local activityID = type(activities) == "table" and not IsSecret(activities) and activities[1]
	if type(activityID) ~= "number" or IsSecret(activityID) then
		return nil
	end
	local activity = C_LFGList.GetActivityInfoTable(activityID)
	if type(activity) ~= "table" or IsSecret(activity) or (canaccesstable and not canaccesstable(activity)) then
		return nil
	end
	return activity
end

-- WindTools' role icon settings while it reskins the list, else nil
local function WTIcons()
	local db = E.private.WT and E.private.WT.misc and E.private.WT.misc.lfgList
	if not (db and db.enable and db.icon and db.icon.enable) then
		return nil
	end
	local LL = W and W.GetModule and W:GetModule("LFGList", true)
	if LL and LL.StopRunning then
		return nil
	end
	return db.icon
end

-- WindTools' Group Info tooltip lists the classes per role already
local function WTGroupInfo()
	local db = E.db.WT and E.db.WT.tooltips and E.db.WT.tooltips.groupInfo
	return db and db.enable and not C_AddOns_IsAddOnLoaded("PremadeGroupsFilter")
end

-------------------------------------------------------------------------------
-- Role icons: leaver mark and missing roles
-------------------------------------------------------------------------------
local function IconLayer(icon)
	local layer = layers[icon]
	if layer then
		return layer
	end

	-- Above WindTools' reskinned icon and its backdrop, which would cover
	-- Blizzard's leaver texture on the icon itself
	local frame = CreateFrame("Frame", nil, icon)
	frame:SetAllPoints(icon)
	frame:SetFrameLevel(icon:GetFrameLevel() + 5)
	frame:EnableMouse(false)

	layer = { frame = frame }
	layer.role = frame:CreateTexture(nil, "ARTWORK")
	layer.role:SetPoint("CENTER")
	layer.role:Hide()

	-- Same atlas, size and spot as Blizzard's own leaver mark
	layer.leaver = frame:CreateTexture(nil, "OVERLAY")
	layer.leaver:SetAtlas(LEAVER_ATLAS, false)
	layer.leaver:SetSize(12, 12)
	layer.leaver:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 4, 2)
	layer.leaver:Hide()

	layers[icon] = layer
	return layer
end

-- A missing role in the look of WindTools' role icons, or Blizzard's
local function SetMissingRole(texture, role, disabled)
	local wt = WTIcons()
	local pack = wt and wt.reskin and wt.pack
	if pack == "SPEC" then
		pack = "SQUARE" -- an empty slot has no spec
	end

	local packTextures = pack and W.Media.RoleIcons and W.Media.RoleIcons[pack]
	if pack == "SQUARE" and W.Media.Textures.ROLES then
		texture:SetTexture(W.Media.Textures.ROLES)
		texture:SetTexCoord(WF.GetRoleTexCoord(role))
	elseif packTextures and packTextures[role] then
		texture:SetTexture(packTextures[role])
		texture:SetTexCoord(0, 1, 0, 1)
	else
		texture:SetAtlas(ROLE_ATLAS[role], false)
		wt = nil
	end

	local size = wt and wt.size or 12
	texture:SetSize(size, size)
	texture:SetDesaturated(true)
	texture:SetAlpha(disabled and 0.3 or 0.6)
	texture:Show()
end

function module:UpdateEnumerate(enumerate, numPlayers, displayData, disabled)
	local icons = enumerate and enumerate.Icons
	if not icons then
		return
	end

	local db = self.db
	local missing
	if db.missingRoles and numPlayers == 5 and type(displayData) == "table" and not IsSecret(displayData) then
		missing = wipe(missingScratch)
		for _, role in ipairs(ROLE_ORDER) do
			local have = displayData[role]
			if IsSecret(have) then
				missing = nil
				break
			end
			for _ = 1, max(0, FIVE_SLOTS[role] - (tonumber(have) or 0)) do
				missing[#missing + 1] = role
			end
		end
	end

	-- Blizzard numbers the icons right to left and fills members from the
	-- left, so this walk meets the members first and then the empty slots
	local missingIndex = 0
	for i = #icons, 1, -1 do
		local icon = icons[i]
		local layer = (db.leaver or missing) and IconLayer(icon) or layers[icon]
		if layer then
			layer.role:Hide()
			layer.leaver:Hide()
		end

		if layer and i <= numPlayers and icon:IsShown() then
			local background = icon.RoleIconWithBackground
			local backgroundAtlas = background and background:IsShown() and background:GetAtlas()

			if backgroundAtlas == EMPTY_SLOT_ATLAS and not IsSecret(backgroundAtlas) then
				missingIndex = missingIndex + 1
				local role = missing and missing[missingIndex]
				if role then
					-- Blizzard sets the alpha again on its next update
					background:SetAlpha(0)
					SetMissingRole(layer.role, role, disabled)
				end
			elseif db.leaver then
				local leaver = icon.LeaverIcon
				local shown = leaver and leaver:IsShown()
				if shown and not IsSecret(shown) then
					layer.leaver:SetDesaturated(disabled)
					layer.leaver:SetAlpha(disabled and 0.5 or 1)
					layer.leaver:Show()
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Group names: new groups green, declined or locked out ones red
-------------------------------------------------------------------------------
-- Saved to this activity's instance and difficulty with no boss left to kill
local function LockedOut(activity, resultID)
	if not (activity and activity.mapID) then
		return false
	end

	for i = 1, GetNumSavedInstances() do
		local _, _, _, difficultyID, locked, _, _, _, _, _, numBosses, _, _, instanceID = GetSavedInstanceInfo(i)
		if locked and instanceID == activity.mapID and difficultyID == activity.difficultyID then
			-- Raids other than Mythic save per boss, so compare the group's kills
			local perBoss = (activity.maxNumPlayers or 5) > 5 and difficultyID ~= 16
			if not perBoss then
				return true
			end

			local done = C_LFGList.GetSearchResultEncounterInfo(resultID)
			if done and (IsSecret(done) or (canaccesstable and not canaccesstable(done))) then
				return false
			end

			local killedByGroup = {}
			for _, name in ipairs(done or {}) do
				if IsSecret(name) then
					return false
				end
				killedByGroup[name] = true
			end

			local anyAlive = false
			for j = 1, (tonumber(numBosses) or 0) do
				local boss, _, killed = GetSavedInstanceEncounterInfo(i, j)
				if boss and not killedByGroup[boss] then
					anyAlive = true
					if not killed then
						return false
					end
				end
			end
			return anyAlive
		end
	end

	return false
end

function module:UpdateSearchEntry(entry)
	local resultID = entry and entry.resultID
	if not resultID or not self.db.nameColors or not entry.Name then
		return
	end

	local info = ResultInfo(resultID)
	if not info then
		return
	end

	local delisted, censored = info.isDelisted, info.censored
	if IsSecret(delisted) or IsSecret(censored) or delisted or censored then
		return
	end

	local _, appStatus = C_LFGList.GetApplicationInfo(resultID)
	local declined = appStatus == "declined" or appStatus == "declined_full" or appStatus == "declined_delisted"
	if declined or LockedOut(ActivityInfo(info), resultID) then
		entry.Name:SetTextColor(1, 0.25, 0.25)
	elseif prevResults and not prevResults[resultID] and (appStatus == "none" or appStatus == nil) then
		entry.Name:SetTextColor(0.3, 1, 0.3)
	end
end

-- Remember this search's results, adding the ones that arrive while the panel shows
function module:UpdateResultList(panel)
	local results = panel and panel.results
	if panel.searching or type(results) ~= "table" or not panel:IsVisible() then
		return
	end

	for i = 1, #results do
		local id = results[i]
		if not IsSecret(id) then
			seenResults[id] = true
		end
	end
end

-- Groups count as new against the previous search of the same category only
function module:DoSearch(panel)
	prevResults = (prevCategory == panel.categoryID) and seenResults or nil
	prevCategory = panel.categoryID
	seenResults = {}
end

-------------------------------------------------------------------------------
-- Tooltip: members by role
-------------------------------------------------------------------------------
local function MemberName(player)
	local name = player.name and not IsSecret(player.name) and player.name
	if not name then
		return nil
	end

	local color = E:ClassColor(player.classFilename, false)
	local text = color and format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name) or name
	if player.isLeader and not IsSecret(player.isLeader) then
		text = text .. " " .. CreateAtlasMarkup("groupfinder-icon-leader", 12, 8)
	end
	if player.isLeaver and not IsSecret(player.isLeaver) then
		text = text .. " " .. CreateAtlasMarkup(LEAVER_ATLAS, 12, 12)
	end

	return text
end

function module:AddMemberTooltip(tooltip, resultID)
	if not self.db.memberTooltip or not (tooltip and tooltip:IsShown()) then
		return
	end

	local info = ResultInfo(resultID)
	if not info or IsSecret(info.isDelisted) or info.isDelisted then
		return
	end

	local activity = ActivityInfo(info)
	local numMembers = info.numMembers
	if not activity or type(numMembers) ~= "number" or IsSecret(numMembers) or numMembers < 1 then
		return
	end

	local byRole = { TANK = {}, HEALER = {}, DAMAGER = {} }
	for i = 1, numMembers do
		local player = C_LFGList.GetSearchResultPlayerInfo(resultID, i)
		local role, class = player and player.assignedRole, player and player.classFilename
		if role and class and not IsSecret(role) and not IsSecret(class) and byRole[role] then
			local list = byRole[role]
			list[#list + 1] = player
		end
	end

	-- Dungeons and arenas show roles and classes in the row already, as does
	-- WindTools' Group Info, so names are what is left to add
	local displayTypes = Enum.LFGListDisplayType
	local namesOnly = WTGroupInfo()
		or (
			displayTypes
			and (
				activity.displayType == displayTypes.RoleEnumerate
				or activity.displayType == displayTypes.ClassEnumerate
			)
		)

	if namesOnly then
		local names = {}
		for _, role in ipairs(ROLE_ORDER) do
			for _, player in ipairs(byRole[role]) do
				names[#names + 1] = MemberName(player)
			end
		end
		if #names == 0 then
			return
		end

		tooltip:AddLine(" ")
		tooltip:AddLine(L["Members:"] .. " " .. tconcat(names, "|cff808080,|r "), 1, 0.82, 0, true)
		tooltip:Show()
		return
	end

	local added = false
	for _, role in ipairs(ROLE_ORDER) do
		for _, player in ipairs(byRole[role]) do
			if not added then
				tooltip:AddLine(" ")
				added = true
			end

			local color = E:ClassColor(player.classFilename, false) or _G.NORMAL_FONT_COLOR
			local className = (not IsSecret(player.className) and player.className) or player.classFilename
			local spec = player.specName and not IsSecret(player.specName) and player.specName
			local left = CreateAtlasMarkup(ROLE_ATLAS[role], 12, 12)
				.. " "
				.. (spec and (spec .. " ") or "")
				.. className
			tooltip:AddDoubleLine(left, MemberName(player) or "", color.r, color.g, color.b, 1, 1, 1)
		end
	end

	if added then
		tooltip:Show()
	end
end

-------------------------------------------------------------------------------
-- Mythic+ applications bar
-------------------------------------------------------------------------------
local function Fill(counts)
	for _, segment in ipairs(SEGMENTS) do
		counts[segment.key] = tonumber(counts[segment.key]) or 0
	end
	counts.applied = tonumber(counts.applied) or 0
	return counts
end

local function Store(scope)
	if scope == "account" then
		return Fill(E.global.mui.groupFinder.applications)
	end
	local private = E.private.mui.groupFinder
	return Fill(scope == "session" and private.session or private.applications)
end

function module:ResetApplications(scope)
	local counts = Store(scope)
	for key in pairs(counts) do
		counts[key] = 0
	end
	self:UpdateApplicationsBar()
end

function module:ApplicationsTooltip(owner)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:AddLine(L["Mythic+ Applications"], 1, 1, 1)
	for _, scope in ipairs(SCOPES) do
		local counts = Store(scope)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(SCOPE_LABEL[scope], format(L["%d applied"], counts.applied), 1, 0.82, 0, 1, 1, 1)
		for _, segment in ipairs(SEGMENTS) do
			GameTooltip:AddDoubleLine(
				"   " .. segment.label,
				counts[segment.key],
				segment.r,
				segment.g,
				segment.b,
				1,
				1,
				1
			)
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["|cffFFFFFFClick:|r Switch between session, character and account"])
	GameTooltip:Show()
end

function module:CreateApplicationsBar()
	if self.appsBar then
		return self.appsBar
	end

	local host = _G.GroupFinderFrame
	local anchor = host and host.groupButton1
	if not anchor then
		return nil
	end

	local bar = CreateFrame("Button", "MER_GroupFinderApplications", host, "BackdropTemplate")
	bar:SetHeight(18)
	bar:SetPoint("BOTTOMLEFT", host, "BOTTOMLEFT", 10, 12)
	bar:SetWidth(anchor:GetWidth())
	bar:SetFrameLevel(host:GetFrameLevel() + 5)
	bar:SetTemplate("Transparent")
	bar:RegisterForClicks("LeftButtonUp")

	bar.title = bar:CreateFontString(nil, "OVERLAY")
	bar.title:FontTemplate(nil, 12)
	bar.title:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 4)
	bar.title:SetTextColor(1, 0.82, 0)

	bar.segments, bar.numbers = {}, {}
	for i in ipairs(SEGMENTS) do
		bar.segments[i] = bar:CreateTexture(nil, "ARTWORK")
		bar.numbers[i] = bar:CreateFontString(nil, "OVERLAY")
		bar.numbers[i]:FontTemplate(nil, 11, "OUTLINE")
	end

	bar.empty = bar:CreateFontString(nil, "OVERLAY")
	bar.empty:FontTemplate(nil, 11, "OUTLINE")
	bar.empty:SetPoint("CENTER")
	bar.empty:SetTextColor(1, 1, 1, 0.6)
	bar.empty:SetText(L["No applications yet"])

	bar:SetScript("OnClick", function()
		local db = self.db.applications
		for i, scope in ipairs(SCOPES) do
			if scope == db.scope then
				db.scope = SCOPES[i % #SCOPES + 1]
				break
			end
		end
		self:UpdateApplicationsBar()
		self:ApplicationsTooltip(bar)
	end)
	bar:SetScript("OnEnter", function()
		self:ApplicationsTooltip(bar)
	end)
	bar:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	bar:HookScript("OnSizeChanged", function()
		self:UpdateApplicationsBar()
	end)

	self.appsBar = bar
	return bar
end

function module:UpdateApplicationsBar()
	local bar = self.appsBar
	if not (bar and bar:IsVisible()) then
		return
	end

	local scope = self.db.applications.scope
	if not SCOPE_LABEL[scope] then
		scope = "character"
	end
	bar.title:SetFormattedText("%s |cffffffff(%s)|r", L["Mythic+ Applications"], SCOPE_LABEL[scope])

	local counts = Store(scope)
	local total = 0
	for _, segment in ipairs(SEGMENTS) do
		total = total + counts[segment.key]
	end

	-- Inside the 1px border, each segment shows its slice of the statusbar texture
	local pixel = E.mult or 1
	local width = (bar:GetWidth() or 0) - 2 * pixel
	local texture = E.media.normTex
	local x = 0
	for i, segment in ipairs(SEGMENTS) do
		local tex, number = bar.segments[i], bar.numbers[i]
		local segmentWidth = total > 0 and width > 0 and (width * counts[segment.key] / total) or 0

		tex:ClearAllPoints()
		tex:SetPoint("TOPLEFT", bar, "TOPLEFT", pixel + x, -pixel)
		tex:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", pixel + x, pixel)
		tex:SetWidth(max(segmentWidth, 0.01))
		tex:SetTexture(texture)
		tex:SetVertexColor(segment.r, segment.g, segment.b)
		if width > 0 then
			tex:SetTexCoord(x / width, (x + segmentWidth) / width, 0, 1)
		end
		tex:SetShown(segmentWidth >= 0.5)

		number:SetFormattedText("%d", counts[segment.key])
		number:ClearAllPoints()
		number:SetPoint("CENTER", tex, "CENTER")
		number:SetShown(segmentWidth >= 0.5 and number:GetStringWidth() + 4 <= segmentWidth)

		x = x + segmentWidth
	end

	bar.empty:SetShown(total == 0)
end

-- Shown on the Premade Groups page, where the applications are made
function module:UpdateApplicationsVisibility()
	local list = _G.LFGListFrame
	local want = self.db.enable and self.db.applications.enable and list and list:IsVisible()
	if want then
		self:CreateApplicationsBar()
	end
	if self.appsBar then
		self.appsBar:SetShown(want and true or false)
		self:UpdateApplicationsBar()
	end
end

local function LookUpMythicPlus(resultID)
	local activity = ActivityInfo(ResultInfo(resultID))
	local mythicPlus = activity and activity.isMythicPlusActivity
	if IsSecret(mythicPlus) or activity == nil then
		return nil
	end
	return mythicPlus == true
end

function module:LFG_LIST_APPLICATION_STATUS_UPDATED(_, resultID, status, oldStatus)
	if type(resultID) ~= "number" or IsSecret(resultID) or IsSecret(status) or IsSecret(oldStatus) then
		return
	end

	-- The group may be gone from the results by the time it answers, so
	-- remember at application time whether it is a Mythic+ one
	if status == "applied" then
		if oldStatus == "applied" then
			return
		end
		isMythicPlus[resultID] = LookUpMythicPlus(resultID)
	elseif isMythicPlus[resultID] == nil then
		isMythicPlus[resultID] = LookUpMythicPlus(resultID)
	end

	local counted = isMythicPlus[resultID]
	if status ~= "applied" and status ~= "invited" then
		isMythicPlus[resultID] = nil
	end

	local key = STATUS_KEY[status]
	if not key or status == oldStatus or counted ~= true then
		return
	end

	for _, scope in ipairs(SCOPES) do
		local counts = Store(scope)
		counts[key] = counts[key] + 1
	end

	self:UpdateApplicationsBar()
end

function module:PLAYER_LOGOUT()
	-- ElvUI's logout cleanup runs first and drops the whole table while it
	-- still only holds defaults, so recreate it for the timestamp to be saved
	local mui = E.private.mui
	if not mui then
		return
	end
	mui.groupFinder = mui.groupFinder or {}
	mui.groupFinder.sessionTime = time()
end

-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------
function module:HookGroupFinder()
	if self.hooked or not _G.LFGListFrame then
		return
	end
	self.hooked = true

	-- Plain hooks that check the settings themselves, so turning parts on or
	-- off needs no reload
	hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", function(...)
		if self.db and self.db.enable then
			self:UpdateEnumerate(...)
		end
	end)
	hooksecurefunc("LFGListSearchEntry_Update", function(entry)
		if self.db and self.db.enable then
			self:UpdateSearchEntry(entry)
		end
	end)
	hooksecurefunc("LFGListSearchPanel_UpdateResultList", function(panel)
		self:UpdateResultList(panel)
	end)
	hooksecurefunc("LFGListSearchPanel_DoSearch", function(panel)
		self:DoSearch(panel)
	end)
	hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", function(tooltip, resultID)
		if self.db and self.db.enable then
			self:AddMemberTooltip(tooltip, resultID)
		end
	end)

	_G.LFGListFrame:HookScript("OnShow", function()
		self:UpdateApplicationsVisibility()
	end)
	_G.LFGListFrame:HookScript("OnHide", function()
		self:UpdateApplicationsVisibility()
	end)
	self:UpdateApplicationsVisibility()
end

-- Hide our drawing on every row, Blizzard's next update brings its own art back
function module:ClearIcons()
	for _, layer in pairs(layers) do
		layer.role:Hide()
		layer.leaver:Hide()
	end
end

function module:RefreshList()
	local panel = _G.LFGListFrame and _G.LFGListFrame.SearchPanel
	if panel and panel:IsVisible() and _G.LFGListSearchPanel_UpdateResults then
		_G.LFGListSearchPanel_UpdateResults(panel)
	end
end

function module:DatabaseUpdate()
	self.db = F.GetDBFromPath("mui.misc.groupFinder")
	if not self.db then
		return
	end

	local counting = self.db.enable and self.db.applications.enable
	if counting then
		self:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
	else
		self:UnregisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
	end

	if not self.db.enable or not (self.db.leaver or self.db.missingRoles) then
		self:ClearIcons()
	end

	if self.hooked then
		self:UpdateApplicationsVisibility()
		self:RefreshList()
	elseif self.db.enable then
		F.Event.ContinueOnAddOnLoaded("Blizzard_GroupFinder", function()
			self:HookGroupFinder()
		end)
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	local private = E.private.mui.groupFinder
	if time() - (tonumber(private.sessionTime) or 0) > SESSION_GAP then
		wipe(private.session)
	end
	self:RegisterEvent("PLAYER_LOGOUT")

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
