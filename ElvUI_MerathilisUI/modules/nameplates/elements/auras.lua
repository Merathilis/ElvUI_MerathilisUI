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
local hooksecurefunc = hooksecurefunc
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function NA:SetAura(aura, index, name, icon, count, duration, expirationTime, spellID)
	if aura and icon and spellID then
		local spell = E.global['unitframe']['aurafilters']['CCDebuffs']['spells'][spellID]
		-- Icon
		aura.spellID = spellID
		aura.icon:SetTexture(icon)

		-- Size
		local overrideWidth = aura:GetParent().db.widthOverride and aura:GetParent().db.widthOverride > 0 and aura:GetParent().db.widthOverride
		local width = overrideWidth or 28
		local height = aura:GetParent().db.baseHeight or 14

		if spell and spell ~= "" then
			width = width*1.35
		elseif E.db['mui']['NameplateAuras']['width'] then
			width =  E.db['mui']['NameplateAuras']['width']
		end

		if spell and spell ~= "" then
			height = height*1.35
		elseif E.db['mui']['NameplateAuras']['height'] then
			height = E.db['mui']['NameplateAuras']['height']
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

	if numCurrentAuras > maxAuras then
		for i = auras.db.numAuras, #auras.icons do
			tinsert(auras.auraCache, auras.icons[i])
			auras.icons[i]:Hide()
			auras.icons[i] = nil
		end
	end

	local overrideWidth = auras.db.widthOverride and auras.db.widthOverride > 0 and auras.db.widthOverride
	local width = overrideWidth or 28
	local height = auras.db.baseHeight or 14

	if E.db['mui']['NameplateAuras']['width'] then
		width = width*1.35
	end

	if E.db['mui']['NameplateAuras']['height'] then
		height = height*1.35
	end

	if (maxAuras > numCurrentAuras) then
		for i = 1, maxAuras do
			auras.icons[i] = auras.icons[i] or tremove(auras.auraCache) or NP:CreateAuraIcon(auras)
			auras.icons[i]:SetParent(auras)
			auras.icons[i]:ClearAllPoints()
			auras.icons[i]:Hide()

			auras.icons[i]:SetHeight(height)
			auras.icons[i]:SetWidth(width)
		end
	end

	NA:RepositionAuras(auras)
end

function NA:ConstructElement_Auras(frame, side)
	local auras = CreateFrame("FRAME", nil, frame)

	auras:SetHeight(14) -- this really doesn't matter
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

function NA:Initialize()
	if E.db.mui.NameplateAuras.enable ~= true then return; end

	hooksecurefunc(NP, "SetAura", NA.SetAura)
	hooksecurefunc(NP, "UpdateElement_Auras", NA.UpdateElement_Auras)
	NP.UpdateAuraIcons = NA.UpdateAuraIcons
	NP.ConstructElement_Auras = NA.ConstructElement_Auras
end

local function InitializeCallback()
	NA:Initialize()
end

MER:RegisterModule(NA:GetName(), InitializeCallback)
