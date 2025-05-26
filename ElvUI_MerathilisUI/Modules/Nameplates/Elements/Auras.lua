local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameplateAuras")
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")

local select = select
local find = string.find

local UnitClass = UnitClass
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc

--[[
	ALL CREDITS BELONG TO Nihilistzsche (Code taken from ElvUI_NihilistUI)
	IF YOU COPY THIS, YOU WILL BURN IN HELL!!!!
--]]

local function CCDebuffTextNeedsUpdate(button, db)
	local bdb = button.cc_name.lastFontInfo
	return not bdb or bdb[1] ~= db.font or bdb[2] ~= db.fontSize or bdb[3] ~= db.fontOutline
end

local function SetAndSaveCCDebuffFontInfo(button, db)
	if db.fontOutline == "NONE" then
		db.fontOutline = ""
	end
	button.cc_name:FontTemplate(E.Libs.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
	button.cc_name.lastFontInfo = { db.font, db.fontSize, db.fontOutline }
end

function module:PostUpdateAura(unit, button)
	if button then
		if not find(unit, "nameplate") then
			return
		end

		local ccSpell
		if button.spellID then
			ccSpell = E.global.unitframe.aurafilters.CCDebuffs.spells[button.spellID]
		end

		-- Size
		local width = self.db.width or button:GetWidth() and 26
		local height = self.db.height or button:GetHeight() and 18

		if ccSpell and ccSpell ~= "" then
			width = 32
		else
			width = width
		end

		if ccSpell and ccSpell ~= "" then
			height = 32
		else
			height = height
		end

		if width > height then
			local aspect = height / width
			button.Icon:SetTexCoord(0.07, 0.93, (0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07)
		elseif height > width then
			local aspect = width / height
			button.Icon:SetTexCoord((0.5 - (aspect / 2)) + 0.07, (0.5 + (aspect / 2)) - 0.07, 0.07, 0.93)
		else
			button.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end

		button:SetWidth(width)
		button:SetHeight(height)

		button.size = { ["width"] = width, ["height"] = height }

		-- Stacks
		local stackSize = 8

		if ccSpell and ccSpell.stackSize then
			stackSize = ccSpell.stackSize
		elseif E.global.unitframe.aurafilters.CCDebuffs.spells.stackSize then
			stackSize = E.global.unitframe.aurafilters.CCDebuffs.spells.stackSize
		end

		button.Count:FontTemplate(nil, stackSize, "SHADOWOUTLINE")

		-- CC Caster Names
		if ccSpell and ccSpell ~= "" and button.caster then
			if CCDebuffTextNeedsUpdate(button, self.db) then
				SetAndSaveCCDebuffFontInfo(button, self.db)
			end
			local name = UnitName(button.caster)
			local class = select(2, UnitClass(button.caster))
			local color = { r = 1, g = 1, b = 1 }
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
	nameplate.Buffs.PostUpdateButton = module.PostUpdateAura
	nameplate.Debuffs.PostUpdateButton = module.PostUpdateAura

	hooksecurefunc(nameplate.Debuffs, "PostUpdateButton", module.PostUpdateAura)
end

function module:Construct_AuraIcon(button)
	if not button then
		return
	end

	-- Creates an own font element for caster name
	if not button.cc_name then
		button.cc_name = button:CreateFontString(nil, "OVERLAY")
		SetAndSaveCCDebuffFontInfo(button, self.db)
		button.cc_name:Point("BOTTOM", button, "TOP", 1, 1)
		button.cc_name:SetJustifyH("CENTER")
	end

	local auras = button:GetParent()
	button.db = auras
		and NP.db.units
		and NP.db.units[auras.__owner.frameType]
		and NP.db.units[auras.__owner.frameType][auras.type]
end

function module:Initialize()
	if self.Initialized then
		return
	end

	-- Set DB
	self.db = F.GetDBFromPath("mui.nameplates.enhancedAuras")
	if not self.db.enable then
		return
	end

	hooksecurefunc(NP, "Construct_Auras", module.Construct_Auras)
	hooksecurefunc(NP, "Construct_AuraIcon", module.Construct_AuraIcon)

	self.Initialized = true
end

module.ProfileUpdate = module.Initialize

MER:RegisterModule(module:GetName())
