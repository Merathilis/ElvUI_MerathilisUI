local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local async = MER.Utilities.Async
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

local CreateFrame = CreateFrame
local AuraUtil_FindAura = AuraUtil.FindAura

local tooltipTitle = "Exit Phase Diving"
async.WithSpellID(1250255, function(spell)
	tooltipTitle = F.GetMERStyleText(spell:GetSpellName())
end)

local function hasBuff(id)
	return AuraUtil_FindAura(function(...)
		return id == select(13, ...)
	end, "player", "HELPFUL")
end

local function visuallyHide(button)
	button.backdrop:SetAlpha(0)
	button.Icon:SetAlpha(0)
	button.Highlight:SetAlpha(0)
end

local function visuallyShow(button)
	button.backdrop:SetAlpha(1)
	button.Icon:SetAlpha(1)
	button.Highlight:SetAlpha(1)
end

local function updateVisual(button)
	if hasBuff(1214374) then
		visuallyShow(button)
	else
		visuallyHide(button)
	end
end

local function updateButton(button, db)
	if E.db.mui.misc.exitPhaseDiving.enable then
		button:Show()
		button:SetSize(db.width, db.height)
		button.Icon:SetTexCoord(E:CropRatio(db.width, db.height))
		updateVisual(button)
	else
		button:Hide()
	end
end

local function createButton()
	local button = CreateFrame("Button", MER.Title .. "ExitPhaseDivingButton", E.UIParent, "SecureActionButtonTemplate")

	button:SetAttribute("type*", "macro")
	button:SetAttribute("macrotext1", "/cancelaura 1214374\n/run _G.GameTooltip:Hide()")
	button:RegisterForClicks(MER.UseKeyDown and "AnyDown" or "AnyUp")
	button:SetPoint("TOP", 0, -90)

	button:StripTextures()
	button:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(button)

	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetInside()
	button.Icon:EnableMouse(false)
	button.Icon:SetTexture(135752)

	button.Highlight = button:CreateTexture(nil, "HIGHLIGHT")
	button.Highlight:SetInside()
	button.Highlight:SetTexture(E.media.blankTex)
	button.Highlight:SetColorTexture(1, 1, 1, 0.15)
	button.Highlight:Hide()

	button:SetScript("OnEnter", function()
		if hasBuff(1214374) then
			button.Highlight:Show()
			_G.GameTooltip:SetOwner(button, "ANCHOR_BOTTOM", 0, -5)
			_G.GameTooltip:SetText(tooltipTitle, 1, 1, 1)
			_G.GameTooltip:Show()
		end
	end)

	button:SetScript("OnLeave", function()
		button.Highlight:Hide()
		_G.GameTooltip:Hide()
	end)

	E:CreateMover(
		button,
		"MER_ExitPhaseDivingButtonMover",
		MER.Title .. L["Exit Phase Diving Button"],
		nil,
		nil,
		nil,
		"ALL,MERATHILISUI",
		function()
			return E.db.mui.misc.exitPhaseDiving.enable
		end,
		"mui,misc,exitPhaseDiving"
	)

	button:RegisterEvent("UNIT_AURA")
	button:SetScript("OnEvent", function(self, event, ...)
		if event == "UNIT_AURA" then
			if select(1, ...) == "player" then
				updateVisual(self)
			end
		end
	end)

	return button
end

function module:ExitPhaseDiving()
	if E.db.mui.misc.exitPhaseDiving.enable then
		self.ExitPhaseDivingButton = createButton()
		updateButton(self.ExitPhaseDivingButton, E.db.mui.misc.exitPhaseDiving)
	end
end

function module:UpdateExitPhaseDivingButton()
	F.TaskManager:OutOfCombat(function()
		if E.db.mui.misc.exitPhaseDiving.enable and not self.ExitPhaseDivingButton then
			self.ExitPhaseDivingButton = createButton()
		end
		if self.ExitPhaseDivingButton then
			updateButton(self.ExitPhaseDivingButton, E.db.mui.misc.exitPhaseDiving)
		end
	end)
end

module:AddCallback("ExitPhaseDiving")
module:AddCallbackForUpdate("UpdateExitPhaseDivingButton")
