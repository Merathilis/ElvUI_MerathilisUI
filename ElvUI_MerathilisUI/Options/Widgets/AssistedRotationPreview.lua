local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local AB = MER:GetModule("MER_Actionbars")

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")

local Type = "MERAssistedRotationPreview"
local Version = 1

local next, unpack = next, unpack

local CreateFrame, UIParent = CreateFrame, UIParent

-- Two sample buttons for the Single-Button Assistant rotation frame, one out of
-- combat and one in combat, drawn by the module itself so they follow the
-- color and animation settings. Used as `dialogControl` on a description.

local BUTTON_SIZE = 36
local COLUMN_OFFSET = 70
-- room for the art, which reaches 0.3x the button size past every edge
local BUTTON_TOP = 16
local LABEL_GAP = 14
local FALLBACK_ICON = 134400 -- question mark

local function GetIcon()
	local spellID = C_AssistedCombat and C_AssistedCombat.GetActionSpell()
	return spellID and C_Spell.GetSpellTexture(spellID) or FALLBACK_ICON
end

local function Update(widget)
	local db = E.db.mui and E.db.mui.actionbars and E.db.mui.actionbars.assistedRotation
	if not db then
		return
	end

	local icon = GetIcon()
	for _, sample in next, widget.samples do
		sample.icon:SetTexture(icon)
		AB:AssistedRotation_UpdatePreview(sample.rotation, sample.inCombat)
	end

	widget.frame:SetAlpha(db.enable and 1 or 0.4)
end

local function CreateSample(parent, offsetX, text, inCombat)
	local button = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
	button:SetPoint("TOP", parent, "TOP", offsetX, -BUTTON_TOP)
	button:SetTemplate()

	local icon = button:CreateTexture(nil, "ARTWORK")
	icon:SetInside()
	icon:SetTexCoord(unpack(E.TexCoords))

	local label = parent:CreateFontString(nil, "OVERLAY")
	label:SetFont(F.GetFontPath(), 11, "OUTLINE")
	label:SetTextColor(1, 1, 1)
	label:SetText(text)
	label:SetPoint("TOP", button, "BOTTOM", 0, -LABEL_GAP)

	return {
		icon = icon,
		inCombat = inCombat,
		rotation = AB:AssistedRotation_CreatePreview(button),
	}
end

local function Constructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(BUTTON_TOP + BUTTON_SIZE + LABEL_GAP + 24)
	frame:Hide()

	local widget = {
		type = Type,
		frame = frame,
		samples = {
			CreateSample(frame, -COLUMN_OFFSET, L["Out of Combat"], false),
			CreateSample(frame, COLUMN_OFFSET, L["In Combat"], true),
		},
	}

	widget.OnAcquire = function(self)
		self.frame:Show()
	end

	widget.OnRelease = function(self)
		self.frame:Hide()
	end

	-- AceConfigDialog feeds the widget again after every change, so this keeps it current
	widget.SetText = function(self)
		Update(self)
	end

	widget.SetWidth = function(self, width)
		self.frame:SetWidth(width)
	end

	widget.SetLabel = function() end
	widget.SetDisabled = function() end
	widget.SetImage = function() end
	widget.SetImageSize = function() end
	widget.SetFontObject = function() end
	widget.SetJustifyH = function() end
	widget.SetJustifyV = function() end
	widget.SetColor = function() end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
