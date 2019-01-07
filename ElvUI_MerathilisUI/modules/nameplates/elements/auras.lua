local MER, E, L, V, P, G = unpack(select(2, ...))
local NA = MER:NewModule("NameplateAuras", "AceEvent-3.0")
local NP = E:GetModule("NamePlates")
NA.modName = L["NameplateAuras"]

-- Cache global variables
-- Lua functions
local ipairs, pairs, tonumber, select = ipairs, pairs, tonumber, select
local tinsert, tremove, tsort = table.insert, table.remove, table.sort
local max = math.max

-- WoW API / Variables
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetAddOnEnableState = GetAddOnEnableState
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, side

function NA:SetAura(aura, index, name, icon, count, duration, expirationTime, spellID)
	if aura and icon and spellID then
		local spell = E.global['nameplate']['spellList'][spellID]
		-- Icon
		aura.icon:SetTexture(icon)

		-- Size
		local width = aura:GetParent().db.widthOverride > 0 and aura:GetParent().db.widthOverride or 18
		local height = aura:GetParent().db.baseHeight or 18

		if spell and spell['width'] then
			--width = spell['width']
			width = width*1.5
		elseif E.global['nameplate']['spellListDefault']['width'] then
			width = E.global['nameplate']['spellListDefault']['width']
		end

		if spell and spell['height'] then
			--height = spell['height']
			height = height*1.5
		elseif E.global['nameplate']['spellListDefault']['height'] then
			height = E.global['nameplate']['spellListDefault']['height']
		end

		if width > height then
			local aspect = height / width
			aura.icon:SetTexCoord(0.07, 0.93, (0.5 - (aspect/2))+0.07, (0.5 + (aspect/2))-0.07)
		elseif height > width then
			local aspect = width / height
			aura.icon:SetTexCoord((0.5 - (aspect/2))+0.07, (0.5 + (aspect/2))-0.07, 0.07, 0.93)
		else
			aura.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end

		aura.spellID = spellID
		aura:SetWidth(width)
		aura:SetHeight(height)

		NA:SortAuras(aura:GetParent())
	end
end

function NA:SortAuras(auras)
	local function sortAuras(iconA, iconB)
		local aWidth = iconA:GetWidth()
		local aHeight = iconA:GetHeight()

		local bWidth = iconB:GetWidth()
		local bHeight = iconB:GetHeight()

		local aCalc = (aWidth + aHeight) * (aWidth / aHeight)
		local bCalc = (bWidth + bHeight) * (bWidth / bHeight)

		if (iconA:IsShown() ~= iconB:IsShown()) then
			return iconA:IsShown()
		end

		return aCalc > bCalc
	end
	tsort(auras.icons, sortAuras)
	NA:RepositionAuras(auras)
end

function NA:UpdateAuraIcons(auras)
	local maxAuras = auras.db.numAuras
	local numCurrentAuras = #auras.icons

	if (not auras.auraCache) then
		auras.auraCache = {}
	end

	local width = auras.db.widthOverride > 0 and auras.db.widthOverride or 18
	local height = auras.db.baseHeight or 18

	if E.global['nameplate']['spellListDefault']['width'] then
		--width = E.global['nameplate']['spellListDefault']['width']
		width = width*1.5
	end

	if E.global['nameplate']['spellListDefault']['height'] then
		--height = E.global['nameplate']['spellListDefault']['height']
		height = height*1.5
	end

	if numCurrentAuras > maxAuras then
		for i = auras.db.numAuras, #auras.icons do
			tinsert(auras.auraCache, auras.icons[i])
			auras.icons[i]:Hide()
			auras.icons[i] = nil
		end
	end

	if (maxAuras > numCurrentAuras) then
		for i=1, maxAuras do
			auras.icons[i] = tremove(auras.auraCache)
			if (not auras.icons[i]) then
				auras.icons[i] =  NP:CreateAuraIcon(auras)
				auras.icons[i]:SetParent(auras)
				auras.icons[i]:Hide()
			end
			local spell = E.global['nameplate']['spellList'][auras.icons[i].spellID]
			auras.icons[i]:ClearAllPoints()
			auras.icons[i]:SetHeight(height*1.5)
			auras.icons[i]:SetWidth(width*1.5)
		end
	end

	NA:RepositionAuras(auras)
end

function NA:ConstructElement_Auras(frame, side)
	local auras = CreateFrame("FRAME", nil, frame)

	auras:SetHeight(18) -- this really doesn't matter
	auras.side = side
	auras.icons = {}

	return auras
end

function NA:RepositionAuras(auras)
	for i, icon in ipairs(auras.icons) do
		icon:ClearAllPoints() -- this probably fix a :SetPoint error if the PLAYER Plate is enabled

		if(auras.side == "LEFT") then
			if(i == 1) then
				icon:SetPoint("BOTTOMLEFT", auras, "BOTTOMLEFT")
			else
				icon:SetPoint("BOTTOMLEFT", auras.icons[i-1], "BOTTOMRIGHT", E.Border + E.Spacing*3, 0)
			end
		else
			if(i == 1) then
				icon:SetPoint("BOTTOMRIGHT", auras, "BOTTOMRIGHT")
			else
				icon:SetPoint("BOTTOMRIGHT", auras.icons[i-1], "BOTTOMLEFT", -(E.Border + E.Spacing*3), 0)
			end
		end
	end
end

function NA:UpdateAuraSet(auras)
	self:SortAuras(auras)
end

function NA:UpdateElement_Auras(frame)
	NA:UpdateAuraSet(frame.Debuffs)
	NA:UpdateAuraSet(frame.Buffs)
end

function NA:UpdateSpellList()
	local filters = E.global['nameplate']['spellList']

	for key, value in pairs(filters) do
		if (not tonumber(key)) then
			local spellID = select(7, GetSpellInfo(key))
			if (spellID) then
				filters[spellID] = value
			end
			filters[key] = nil
		end
	end
end

function NA:PLAYER_ENTERING_WORLD()
	self:UpdateSpellList()
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

function NA:Initialize()
	if E.db.mui.NameplateAuras.enable ~= true then return; end

	hooksecurefunc(NP, "SetAura", NA.SetAura)
	hooksecurefunc(NP, "UpdateElement_Auras", NA.UpdateElement_Auras)
	NP.UpdateAuraIcons = NA.UpdateAuraIcons
	NP.ConstructElement_Auras = NA.ConstructElement_Auras
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

local function InitializeCallback()
	NA:Initialize()
end

MER:RegisterModule(NA:GetName(), InitializeCallback)
