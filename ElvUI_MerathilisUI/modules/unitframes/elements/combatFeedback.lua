local MER, E, L, V, P, G = unpack(select(2, ...))
local CF = MER:NewModule('mUICombatFeedback', 'AceHook-3.0', 'AceEvent-3.0')
local UF = E:GetModule("UnitFrames")

--Cache global variables
local _G = _G
local tinsert = table.insert
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

if IsAddOnLoaded("ElvUI_CombatFeedback") then return end

P.unitframe.units.player.cft = {
	["text"] = {
		['enable'] = true,
		['position'] = "CENTER",
		['font'] = "Expressway",
		['size'] = 11,
		['outline'] = "OUTLINE",
		['xoffset'] = 0,
		['yoffset'] = 0,
	},
}

P.unitframe.units.target.cft = {
	["text"] = {
		['enable'] = true,
		['position'] = "CENTER",
		['font'] = "Expressway",
		['size'] = 11,
		['outline'] = "OUTLINE",
		['xoffset'] = 0,
		['yoffset'] = 0,
	},
}

P.unitframe.units.pet.cft = {
	["text"] = {
		['enable'] = false,
		['position'] = "CENTER",
		['font'] = "Expressway",
		['size'] = 11,
		['outline'] = "OUTLINE",
		['xoffset'] = 0,
		['yoffset'] = 0,
	},
}

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
}

local function ufPlayerTable()
	E.Options.args.unitframe.args.player.args.cft = {
		type = "group",
		name = L["|cffff7d0aCombat Feedback|r"],
		order = 1500,
		args = {
			text = {
				type = "group",
				order = 1,
				name = L["Frame Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.player.cft.text[ info[#info] ] end,
				args = {
					enable = {
						type = 'toggle',
						order = 1,
						name = L['Enable'],
						set = function(info, value) E.db.unitframe.units.player.cft.text.enable = value; end,
					},
					position = {
						order = 2,
						type = 'select',
						name = L["Position"],
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('player') end,
						values = positionValues,
					},
					spacer = {
						order = 3,
						type = "description",
						name = "",
					},
					font = {
						order = 4,
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; CF:UpdateText('player', _G["ElvUF_Player"].CombatFeedbackText) end,
						values = _G["AceGUIWidgetLSMlists"].font,
					},
					size = {
						order = 5,
						name = L["Size"],
						type = "range",
						min = 6, max = 30, step = 1,
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; CF:UpdateText('player', _G["ElvUF_Player"].CombatFeedbackText) end,
					},
					outline = {
						order = 6,
						name = L["Font Outline"],
						type = "select",
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; CF:UpdateText('player', _G["ElvUF_Player"].CombatFeedbackText) end,
					},
					xoffset = {
						order = 7,
						name = L['Text xOffset'],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('player') end,
					},
					yoffset = {
						order = 8,
						name = L['Text yOffset'],
						type = "range",
						min = -100, max = 100, step = 1,
						disabled = function() return not E.db.unitframe.units.player.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.player.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('player') end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, ufPlayerTable)

local function ufTargetTable()
	E.Options.args.unitframe.args.target.args.cft = {
		type = "group",
		name = L["|cffff7d0aCombat Feedback|r"],
		order = 1500,
		args = {
			text = {
				type = "group",
				order = 1,
				name = L["Frame Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.target.cft.text[ info[#info] ] end,
				args = {
					enable = {
						type = 'toggle',
						order = 1,
						name = L['Enable'],
						set = function(info, value) E.db.unitframe.units.target.cft.text.enable = value; end,
					},
					position = {
						order = 2,
						type = 'select',
						name = L["Position"],
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('target') end,
						values = positionValues,
					},
					spacer = {
						order = 3,
						type = "description",
						name = "",
					},
					font = {
						order = 4,
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; CF:UpdateText('target', _G["ElvUF_Target"].CombatFeedbackText) end,--UF:Update_FontStrings() end,
						values = _G["AceGUIWidgetLSMlists"].font,
					},
					size = {
						order = 5,
						name = L["Size"],
						type = "range",
						min = 6, max = 30, step = 1,
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; CF:UpdateText('target', _G["ElvUF_Target"].CombatFeedbackText) end,
					},
					outline = {
						order = 6,
						name = L["Font Outline"],
						type = "select",
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; CF:UpdateText('target', _G["ElvUF_Target"].CombatFeedbackText) end,
					},
					xoffset = {
						order = 7,
						name = L['Text xOffset'],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('target') end,
					},
					yoffset = {
						order = 8,
						name = L['Text yOffset'],
						type = "range",
						min = -100, max = 100, step = 1,
						disabled = function() return not E.db.unitframe.units.target.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.target.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('target') end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, ufTargetTable)

local function ufPetTable()
	E.Options.args.unitframe.args.pet.args.cft = {
		type = "group",
		name = L["|cffff7d0aCombat Feedback|r"],
		order = 1500,
		args = {
			text = {
				type = "group",
				order = 1,
				name = L["Frame Text"],
				guiInline = true,
				get = function(info) return E.db.unitframe.units.pet.cft.text[ info[#info] ] end,
				args = {
					enable = {
						type = 'toggle',
						order = 1,
						name = L['Enable'],
						set = function(info, value) E.db.unitframe.units.pet.cft.text.enable = value; end,
					},
					position = {
						order = 2,
						type = 'select',
						name = L["Position"],
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('pet') end,
						values = positionValues,
					},
					spacer = {
						order = 3,
						type = "description",
						name = "",
					},
					font = {
						order = 4,
						type = 'select', dialogControl = 'LSM30_Font',
						name = L["Font"],
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; CF:UpdateText('pet', _G["ElvUF_Pet"].CombatFeedbackText) end,
						values = _G["AceGUIWidgetLSMlists"].font,
					},
					size = {
						order = 5,
						name = L["Size"],
						type = "range",
						min = 6, max = 30, step = 1,
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; CF:UpdateText('pet', _G["ElvUF_Pet"].CombatFeedbackText) end,
					},
					outline = {
						order = 6,
						name = L["Font Outline"],
						type = "select",
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; CF:UpdateText('pet', _G["ElvUF_Pet"].CombatFeedbackText) end,
					},
					xoffset = {
						order = 7,
						name = L['Text xOffset'],
						type = "range",
						min = -200, max = 200, step = 1,
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('pet') end,
					},
					yoffset = {
						order = 8,
						name = L['Text yOffset'],
						type = "range",
						min = -100, max = 100, step = 1,
						disabled = function() return not E.db.unitframe.units.pet.cft.text.enable end,
						set = function(info, value) E.db.unitframe.units.pet.cft.text[ info[#info] ] = value; UF:CreateAndUpdateUF('pet') end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, ufPetTable)

function UF:Construct_CFText(frame, unit)
	local cft = frame.RaisedElementParent:CreateFontString(nil, "ARTWORK")

	UF['fontstrings'][cft] = true
	CF:UpdateText(unit, cft)
	return cft
end

function CF:UpdateText(unit, line)
	local db = E.db.unitframe.units[unit].cft.text
	line:FontTemplate(E.LSM:Fetch("font", db.font), db.size, db.outline)
end

function UF:ConstructCFTexts(frame, unit)
	frame.CombatFeedbackText = self:Construct_CFText(frame, unit)
end

function CF:UpdatePlayer(frame, db)
	frame.db = db

	local cFT = frame.CombatFeedbackText

	local x, y = UF:GetPositionOffset(frame.db.cft.text.position)
	cFT:ClearAllPoints()
	cFT:Point(frame.db.cft.text.position, _G["ElvUF_Player"].Health, frame.db.cft.text.position, x + frame.db.cft.text.xoffset, y + frame.db.cft.text.yoffset)

	frame:UpdateAllElements("MER_UpdateAllElements")
end

function CF:UpdateTarget(frame, db)
	frame.db = db

	local cFT = frame.CombatFeedbackText

	local x, y = UF:GetPositionOffset(frame.db.cft.text.position)
	cFT:ClearAllPoints()
	cFT:Point(frame.db.cft.text.position, _G["ElvUF_Target"].Health, frame.db.cft.text.position, x + frame.db.cft.text.xoffset, y + frame.db.cft.text.yoffset)

	frame:UpdateAllElements("MER_UpdateAllElements")
end

function CF:UpdatePet(frame, db)
	frame.db = db

	local cFT = frame.CombatFeedbackText

	local x, y = UF:GetPositionOffset(frame.db.cft.text.position)
	cFT:ClearAllPoints()
	cFT:Point(frame.db.cft.text.position, _G["ElvUF_Pet"].Health, frame.db.cft.text.position, x + frame.db.cft.text.xoffset, y + frame.db.cft.text.yoffset)

	frame:UpdateAllElements("MER_UpdateAllElements")
end

function CF:Initialize()
	UF:ConstructCFTexts(_G["ElvUF_Player"], 'player')
	UF:ConstructCFTexts(_G["ElvUF_Target"], 'target')
	UF:ConstructCFTexts(_G["ElvUF_Pet"], 'pet')

	UF:RegCFT()

	hooksecurefunc(UF, "Update_PlayerFrame", CF.UpdatePlayer)
	hooksecurefunc(UF, "Update_TargetFrame", CF.UpdateTarget)
	hooksecurefunc(UF, "Update_PetFrame", CF.UpdatePet)
end

local function InitializeCallback()
	CF:Initialize()
end

MER:RegisterModule(CF:GetName(), InitializeCallback)
