local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NameplateAuras')
local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
local MUF = MER:GetModule('MER_UnitFrames')

local select = select
local find = string.find

local UnitClass = UnitClass
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc

--[[
	ALL CREDITS BELONG TO Nihilistzsche (Code taken from ElvUI_NihilistUI)
	IF YOU COPY THIS, YOU WILL BURN IN HELL!!!!
--]]

function module:PostUpdateAura(unit, button)
	if button and button.spellID then
		if not find(unit, "nameplate") then
			return
		end

		local spell = E.global.unitframe.aurafilters.CCDebuffs.spells[button.spellID]

		-- Size
		local width = button:GetWidth() or 26
		local height = button:GetHeight() or 18

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

	hooksecurefunc(nameplate.Debuffs, 'PostUpdateIcon', module.PostUpdateAura)
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

function module:Initialize()
	if E.db.mui.nameplates.enhancedAuras.enable ~= true then return end

	hooksecurefunc(NP, "Construct_Auras", module.Construct_Auras)
	hooksecurefunc(NP, "Construct_AuraIcon", module.Construct_AuraIcon)
end

MER:RegisterModule(module:GetName())
