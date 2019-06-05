local MER, E, L, V, P, G = unpack(select(2, ...))
local NA = MER:NewModule("NameplateAuras", "AceEvent-3.0")
local NP = E:GetModule("NamePlates")
NA.modName = L["NameplateAuras"]

-- Cache global variables
-- Lua functions
local _G = _G
local strsub = strsub
local pairs = pairs
local max = math.max
local tsort = table.sort
-- WoW API / Variables
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

--[[
	ALL CREDITS BELONG TO NihilisticPandemonium (Code taken from ElvUI_ChaoticUI)
	IF YOU COPY THIS, YOU WILL BURN IN HELL!!!!
--]]

function NA:PostUpdateAura(unit, button)
	if button and button.spellID then
		local spell = E.global.unitframe.aurafilters.CCDebuffs.spells[button.spellID]
		local name = strsub(UnitName(button.caster), 1, 6)
		local _, class = UnitClass(button.caster)
		local classColor = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class]) or _G.RAID_CLASS_COLORS[class]

		-- Size
		local width = E.db.mui.nameplates.enhancedAuras.width or 26
		local height = E.db.mui.nameplates.enhancedAuras.height or 18

		if spell and spell ~= "" then
			width = 30
		else
			width = width
		end

		if spell and spell ~= "" then
			height = 30
		else
			height = height
		end

		if width > height then
			local aspect = height / width
			button.icon:SetTexCoord(0.07, 0.93, (0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07)
		elseif height > width then
			local aspect = width / height
			button.icon:SetTexCoord((0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07, 0.07, 0.93)
		else
			button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end

		button:SetWidth(width)
		button:SetHeight(height)

		button.size = {["width"] = width, ["height"] = height}

		-- Stacks
		local stackSize = 7

		if spell and spell["stackSize"] then
			stackSize = spell["stackSize"]
		end

		button.count:FontTemplate(nil, stackSize, "OUTLINE")

		-- CC Caster Names
		for spellId, _ in pairs(E.global.unitframe.aurafilters.CCDebuffs) do
			if spell and spell ~= "" then
				local spellName = GetSpellInfo(button.spellID)
				if spellName then
					button.cc_name:SetText(name)
					button.cc_name:SetTextColor(classColor.r, classColor.g, classColor.b)
				end
			else
				button.cc_name:SetText("")
			end
		end
	end
end

function NA:Construct_Auras(nameplate)
	nameplate.Buffs_.SetPosition = NA.SetPosition
	nameplate.Debuffs_.SetPosition = NA.SetPosition
end

function NA:Construct_AuraIcon(button)
	-- Creates an own font element for caster name
	if not button.cc_name then
		button.cc_name = button:CreateFontString("OVERLAY")
		button.cc_name:FontTemplate()
		button.cc_name:Point("BOTTOM", button, "TOP")
	end
end

function NA.SetPosition(element, _, to)
	local from = 1
	if not element[from] then
		return
	end

	local anchor = element.initialAnchor or "BOTTOMLEFT"
	local growthx = (element["growth-x"] == "LEFT" and -1) or 1
	local spacingx = (element["spacing-x"] or element.spacing or 0)
	local eheight = element[from].db.height

	local function GetAnchorPoint(index)
		local a = 0
		for i = index - 1, from, -1 do
			a = a + spacingx + element[i].size.width
		end
		return a * growthx
	end

	for i = from, to do
		local button = element[i]
		if (not button) then
			break
		end
		eheight = max(eheight, element[i].size and (element[i].size.height) or 0)
		button:ClearAllPoints()
		button:SetPoint(anchor, element, anchor, GetAnchorPoint(i), 0)
	end

	element:SetHeight(eheight)
end

function NA:Initialize()
	if E.db.mui.nameplates.enhancedAuras.enable ~= true then return end

	hooksecurefunc(NP, "Construct_Auras", NA.Construct_Auras)
	hooksecurefunc(NP, "Construct_AuraIcon", NA.Construct_AuraIcon)
	hooksecurefunc(NP, "PostUpdateAura", NA.PostUpdateAura)
end

local function InitializeCallback()
	NA:Initialize()
end

MER:RegisterModule(NA:GetName(), InitializeCallback)
