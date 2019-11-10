local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local module = MER:NewModule("CooldownFlash", "AceHook-3.0")

--Cache global variables
--Lua functions
local GetTime = GetTime
local select, pairs, bit, unpack = select, pairs, bit, unpack
local string = string
local wipe = wipe
local tinsert, tremove = table.insert, table.remove
--WoW API / Variables
local CreateFrame = CreateFrame
local GetPetActionInfo = GetPetActionInfo
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local GetSpellCooldown = GetSpellCooldown
local GetItemInfo = GetItemInfo
local GetItemCooldown = GetItemCooldown
local GetPetActionCooldown = GetPetActionCooldown
local IsInInstance = IsInInstance
local GetActionInfo = GetActionInfo
local GetActionTexture = GetActionTexture
local GetInventoryItemID = GetInventoryItemID
local GetInventoryItemTexture = GetInventoryItemTexture
local GetContainerItemID = GetContainerItemID
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
-- GLOBALS:

module.cooldowns, module.animating, module.watching = { }, { }, { }
local fadeInTime, fadeOutTime, maxAlpha, animScale, iconSize, holdTime, showSpellName, ignoredSpells, invertIgnored
local testtable

local DCP = CreateFrame("Frame", nil, E.UIParent)
DCP:SetAlpha(0)
DCP:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
DCP.TextFrame = DCP:CreateFontString(nil, "ARTWORK", "GameFontNormal")
DCP.TextFrame:SetPoint("TOP", DCP, "BOTTOM", 0, -5)
DCP.TextFrame:SetWidth(185)
DCP.TextFrame:SetJustifyH("CENTER")
DCP.TextFrame:SetTextColor(1, 1, 1)
module.DCP = DCP

local DCPT = DCP:CreateTexture(nil, "BORDER")
DCPT:SetTexCoord(unpack(E.TexCoords))
DCPT:SetAllPoints(DCP)
MERS:CreateBDFrame(DCP)
MERS:CreateSD(DCP)

local defaultsettings = {
	["enable"] = false,
	["fadeInTime"] = 0.3,
	["fadeOutTime"] = 0.6,
	["maxAlpha"] = 0.8,
	["animScale"] = 1.5,
	["iconSize"] = 50,
	["holdTime"] = 0.3,
	["petOverlay"] = {1, 1, 1},
	["ignoredSpells"] = "",
	["invertIgnored"] = false,
	["enablePet"] = false,
	["showSpellName"] = false,
	["x"] = UIParent:GetWidth()*UIParent:GetEffectiveScale()/2,
	["y"] = UIParent:GetHeight()*UIParent:GetEffectiveScale()/2,
}

-----------------------
-- Utility Functions --
-----------------------
local function tcount(tab)
	local n = 0
	for _ in pairs(tab) do
		n = n + 1
	end
	return n
end

local function memoize(f)
	local cache = nil

	local memoized = {}

	local function get()
		if (cache == nil) then
			cache = f()
		end

		return cache
	end

	memoized.resetCache = function()
		cache = nil
	end

	setmetatable(memoized, {__call = get})

	return memoized
end

local function GetPetActionIndexByName(name)
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		if (GetPetActionInfo(i) == name) then
			return i
		end
	end
	return nil
end

--------------------------
-- Cooldown / Animation --
--------------------------
local elapsed = 0
local runtimer = 0
local function OnUpdate(_,update)
	module.db = E.db.mui.cooldownFlash
	elapsed = elapsed + update
	if (elapsed > 0.05) then
		for i,v in pairs(module.watching) do
			if (GetTime() >= v[1] + 0.5) then
				local getCooldownDetails
				if (v[2] == "spell") then
					getCooldownDetails = memoize(function()
						local start, duration, enabled = GetSpellCooldown(v[3])
						return {
							name = GetSpellInfo(v[3]),
							texture = GetSpellTexture(v[3]),
							start = start,
							duration = duration,
							enabled = enabled
						}
					end)
				elseif (v[2] == "item") then
					getCooldownDetails = memoize(function()
						local start, duration, enabled = GetItemCooldown(i)
						return {
							name = GetItemInfo(i),
							texture = v[3],
							start = start,
							duration = duration,
							enabled = enabled
						}
					end)
				elseif (v[2] == "pet") then
					getCooldownDetails = memoize(function()
						local name, texture = GetPetActionInfo(v[3])
						local start, duration, enabled = GetPetActionCooldown(v[3])
						return {
							name = name,
							texture = texture,
							isPet = true,
							start = start,
							duration = duration,
							enabled = enabled
						}
					end)
				end

				local cooldown = getCooldownDetails()
				if ((module.db.ignoredSpells[cooldown.name] ~= nil) ~= module.db.invertIgnored) then
					module.watching[i] = nil
				else
					if (cooldown.enabled ~= 0) then
						if (cooldown.duration and cooldown.duration > 2.0 and cooldown.texture) then
							module.cooldowns[i] = getCooldownDetails
						end
					end
					if (not (cooldown.enabled == 0 and v[2] == "spell")) then
						module.watching[i] = nil
					end
				end
			end
		end

		for i, getCooldownDetails in pairs(module.cooldowns) do
			local cooldown = getCooldownDetails()
			local remaining = cooldown.duration-(GetTime()-cooldown.start)
			if (remaining <= 0) then
				tinsert(module.animating, {cooldown.texture, cooldown.isPet, cooldown.name})
				module.cooldowns[i] = nil
			end
		end

		elapsed = 0
		if (#module.animating == 0 and tcount(module.watching) == 0 and tcount(module.cooldowns) == 0) then
			DCP:SetScript("OnUpdate", nil)
			return
		end
	end

	if (#module.animating > 0) then
		runtimer = runtimer + update
		if (runtimer > (module.db.fadeInTime + module.db.holdTime + module.db.fadeOutTime)) then
			tremove(module.animating, 1)
			runtimer = 0
			DCP.TextFrame:SetText(nil)
			DCPT:SetTexture(nil)
			DCPT:SetVertexColor(1, 1, 1)
			DCP:SetAlpha(0)
			DCP:SetSize(module.db.iconSize, module.db.iconSize)
		elseif module.db.enable then
			if (not DCPT:GetTexture()) then
				if (module.animating[1][3] ~= nil and module.db.showSpellName) then
					DCP.TextFrame:SetText(module.animating[1][3])
				end
				DCPT:SetTexture(module.animating[1][1])
			end
			local alpha = module.db.maxAlpha
			if (runtimer < module.db.fadeInTime) then
				alpha = module.db.maxAlpha * (runtimer / module.db.fadeInTime)
			elseif (runtimer >= module.db.fadeInTime + module.db.holdTime) then
				alpha = module.db.maxAlpha - (module.db.maxAlpha * ((runtimer - module.db.holdTime - module.db.fadeInTime) / module.db.fadeOutTime))
			end
			DCP:SetAlpha(alpha)
			local scale = module.db.iconSize + (module.db.iconSize * ((module.db.animScale - 1) * (runtimer / (module.db.fadeInTime + module.db.holdTime + module.db.fadeOutTime))))
			DCP:SetWidth(scale)
			DCP:SetHeight(scale)
		end
	end
end

--------------------
-- Event Handlers --
--------------------
function DCP:ADDON_LOADED(addon)
	if (not MERData_DCP) then
		MERData_DCP = defaultsettings
	else
		for i, v in pairs(defaultsettings) do
			if (not MERData_DCP[i]) then
				MERData_DCP[i] = v
			end
		end
	end
	-- self:SetPoint("CENTER", E.UIParent,"BOTTOMLEFT", MERData_DCP.x, MERData_DCP.y)
	E:CreateMover(DCP, "CooldownFlashMover", L["CooldownFlashMover"], true, nil, nil, 'ALL,SOLO,MERATHILISUI', nil, 'mui,modules,cooldownFlash')
end

function DCP:SPELL_UPDATE_COOLDOWN()
	for i, getCooldownDetails in pairs(module.cooldowns) do
		getCooldownDetails.resetCache()
	end
end

function DCP:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
	if (unit == "player") then
		module.watching[spellID] = {GetTime(),"spell",spellID}
		if (not self:IsMouseEnabled()) then
			self:SetScript("OnUpdate", OnUpdate)
		end
	end
end

function DCP:COMBAT_LOG_EVENT_UNFILTERED()
	local _, event, _, _, _, sourceFlags, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
	if (event == "SPELL_CAST_SUCCESS") then
		if (bit.band(sourceFlags,COMBATLOG_OBJECT_TYPE_PET) == COMBATLOG_OBJECT_TYPE_PET and bit.band(sourceFlags,COMBATLOG_OBJECT_AFFILIATION_MINE) == COMBATLOG_OBJECT_AFFILIATION_MINE) then
			local name = GetSpellInfo(spellID)
			local index = GetPetActionIndexByName(name)
			if (index and not select(7, GetPetActionInfo(index))) then
				module.watching[spellID] = {GetTime(),"pet",index}
			elseif (not index and spellID) then
				module.watching[spellID] = {GetTime(),"spell",spellID}
			else
				return
			end
			if (not self:IsMouseEnabled()) then
				self:SetScript("OnUpdate", OnUpdate)
			end
		end
	end
end

function DCP:PLAYER_ENTERING_WORLD()
	local inInstance,instanceType = IsInInstance()
	if (inInstance and instanceType == "arena") then
		self:SetScript("OnUpdate", nil)
		wipe(module.cooldowns)
		wipe(module.watching)
	end
end

function module:UseAction(slot)
	local actionType,itemID = GetActionInfo(slot)
	if (actionType == "item") then
		local texture = GetActionTexture(slot)
		module.watching[itemID] = {GetTime(),"item",texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function module:UseInventoryItem(slot)
	local itemID = GetInventoryItemID("player", slot);
	if (itemID) then
		local texture = GetInventoryItemTexture("player", slot)
		module.watching[itemID] = {GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function module:UseContainerItem(bag, slot)
	local itemID = GetContainerItemID(bag, slot)
	if (itemID) then
		local texture = select(10, GetItemInfo(itemID))
		module.watching[itemID] = {GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function module:UseItemByName(itemName)
	local itemID
	if itemName then
		itemID = string.match(select(2, GetItemInfo(itemName)), "item:(%d+)")
	end
	if (itemID) then
		local texture = select(10, GetItemInfo(itemID))
		module.watching[itemID] = {GetTime(), "item", texture}
		DCP:SetScript("OnUpdate", OnUpdate)
	end
end

function module:EnableCooldownFlash()
	self:SecureHook("UseContainerItem")
	self:SecureHook("UseInventoryItem")
	self:SecureHook("UseAction")
	self:SecureHook("UseItemByName")
	DCP:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	DCP:RegisterEvent("PLAYER_ENTERING_WORLD")
	DCP:RegisterEvent("ADDON_LOADED")
	DCP:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	if self.db.enablePet then
		DCP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function module:DisableCooldownFlash()
	self:Unhook("UseContainerItem")
	self:Unhook("UseInventoryItem")
	self:Unhook("UseAction")
	self:Unhook("UseItemByName")
	DCP:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	DCP:UnregisterEvent("PLAYER_ENTERING_WORLD")
	DCP:UnregisterEvent("ADDON_LOADED")
	DCP:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	DCP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function module:TestMode()
	tinsert(module.animating, {"Interface\\Icons\\achievement_guildperk_ladyluck_rank2", nil, "Spell Name"})
	DCP:SetScript("OnUpdate", OnUpdate)
end

function module:Initialize()
	module.db = E.db.mui.cooldownFlash
	MER:RegisterDB(self, "cooldownFlash")

	if self.db.enable then
		self:EnableCooldownFlash()
	end

	DCP:SetSize(self.db.iconSize, self.db.iconSize)
	DCP:SetPoint("CENTER", E.UIParent, "CENTER")

	DCP.TextFrame:FontTemplate(E.db.general.font, 18, "OUTLINE")
	DCP.TextFrame:SetShadowOffset(2, -2)

	function module:ForUpdateAll()
		module.db = E.db.mui.cooldownFlash
	end

	self:ForUpdateAll()
end

MER:RegisterModule(module:GetName())
