local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NameplateAuras')
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select, unpack = pairs, select, unpack
local find = string.find
local max = math.max
local tsort = table.sort
-- WoW API / Variables
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
-- GLOBALS:

--[[
	ALL CREDITS BELONG TO NihilisticPandemonium (Code taken from ElvUI_NihilistUI)
	IF YOU COPY THIS, YOU WILL BURN IN HELL!!!!
--]]

function module:PostUpdateAura(unit, button)
	if button and button.spellID then
		if not find(unit, "nameplate") then
			return
		end

		local spell = E.global.unitframe.aurafilters.CCDebuffs.spells[button.spellID]

		-- Size
		local width = E.db.mui.nameplates.enhancedAuras.width or 26
		local height = E.db.mui.nameplates.enhancedAuras.height or 18

		if spell and spell ~= "" then
			width = 32
		else
			width = width
		end

		if spell and spell ~= "" then
			height = 32
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

		-- CC Caster Names
		if spell and spell ~= "" and button.caster then
			local name = UnitName(button.caster)
			local class = select(2, UnitClass(button.caster))
			local color = {r = 1, g = 1, b = 1}
			if class then
				color = E:ClassColor(class, true)
			end
			button.cc_name:SetText(name)
			button.cc_name:SetTextColor(color.r, color.g, color.b)
		else
			button.cc_name:SetText("")
		end
	end

	UF:PostUpdateAura(unit, button)
end

function module:Construct_Auras(nameplate)
	nameplate.Buffs.PostUpdateIcon = module.PostUpdateAura
	nameplate.Debuffs.PostUpdateIcon = module.PostUpdateAura

	nameplate.Buffs.SetPosition = module.SetPosition
	nameplate.Debuffs.SetPosition = module.SetPosition
end

function module:Construct_AuraIcon(button)
	if not button then return end

	-- Creates an own font element for caster name
	if not button.cc_name then
		button.cc_name = button:CreateFontString(nil, "OVERLAY")
		button.cc_name:FontTemplate(nil, 10, "OUTLINE")
		button.cc_name:Point("BOTTOM", button, "TOP", 1, 1)
		button.cc_name:SetJustifyH("CENTER")
	end

	local auras = button:GetParent()
	button.db = auras and NP.db.units and NP.db.units[auras.__owner.frameType] and NP.db.units[auras.__owner.frameType][auras.type]
end

function module.SetPosition(element, _, to)
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
			a = a + spacingx + (element[i].size and element[i].size.width or E.db.mui.nameplates.enhancedAuras.width)
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

function module:Initialize()
	if E.db.mui.nameplates.enhancedAuras.enable ~= true then return end

	hooksecurefunc(NP, "Construct_Auras", module.Construct_Auras)
	hooksecurefunc(NP, "Construct_AuraIcon", module.Construct_AuraIcon)
end

MER:RegisterModule(module:GetName())
