local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_RaidMarkers")
local S = MER:GetModule("MER_Skins")

local _G = _G
local GameTooltip = _G.GameTooltip

local abs = abs
local format = format
local gsub = gsub
local strupper = strupper

local ClearRaidMarker = ClearRaidMarker
local CreateFrame = CreateFrame
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local SetRaidTarget = SetRaidTarget
local UnregisterStateDriver = UnregisterStateDriver

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local lastClear = 0

local TargetToWorld = {
	[1] = 5,
	[2] = 6,
	[3] = 3,
	[4] = 2,
	[5] = 7,
	[6] = 1,
	[7] = 4,
	[8] = 8,
}

function module:UpdateBar()
	if not self.bar then
		return
	end

	if not self.db.enable then
		self.bar:Hide()
		return
	end

	local previousButton
	local numButtons = 0

	for i = 1, 11 do
		local button = self.bar.buttons[i]
		button:ClearAllPoints()
		button:SetSize(self.db.buttonSize, self.db.buttonSize)
		button.tex:SetSize(self.db.buttonSize, self.db.buttonSize)
		button.animGroup:Stop()

		if (i == 10 and not self.db.readyCheck) or (i == 11 and not self.db.countDown) then
			button:Hide()
		else
			button:Show()
			if self.db.orientation == "VERTICAL" then
				if i == 1 then
					button:SetPoint("TOP", 0, -self.db.backdropSpacing)
				else
					button:SetPoint("TOP", previousButton, "BOTTOM", 0, -self.db.spacing)
				end
			else
				if i == 1 then
					button:SetPoint("LEFT", self.db.backdropSpacing, 0)
				else
					button:SetPoint("LEFT", previousButton, "RIGHT", self.db.spacing, 0)
				end
			end
			previousButton = button
			numButtons = numButtons + 1
		end
	end

	local height = self.db.buttonSize + self.db.backdropSpacing * 2
	local width = self.db.backdropSpacing * 2 + self.db.buttonSize * numButtons + self.db.spacing * (numButtons - 1)

	if self.db.orientation == "VERTICAL" then
		width, height = height, width
	end

	self.bar:Show()
	self.bar:SetSize(width, height)
	self.barAnchor:SetSize(width, height)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function module:UpdateButtons()
	if not self.bar or not self.bar.buttons then
		return
	end

	self.modifierString = gsub(self.db.modifier, "^%l", strupper)

	for i = 1, 11 do
		local button = self.bar.buttons[i]

		if self.db.buttonBackdrop then
			button.backdrop:Show()
		else
			button.backdrop:Hide()
		end

		if button and button.backdrop.shadow then
			if self.db.backdrop then
				button.backdrop.MERshadow:Hide()
			else
				button.backdrop.MERshadow:Show()
			end
		end

		if button.isMarkButton then
			button:SetAttribute("shift-type*", nil)
			button:SetAttribute("alt-type*", nil)
			button:SetAttribute("ctrl-type*", nil)

			button:SetAttribute(format("%s-type*", self.db.modifier), "macro")

			if not self.db.inverse then
				button:SetAttribute("macrotext1", format("/tm %d", i))
				button:SetAttribute("macrotext2", "/tm 0")
				button:SetAttribute(format("%s-macrotext1", self.db.modifier), format("/wm %d", TargetToWorld[i]))
				button:SetAttribute(format("%s-macrotext2", self.db.modifier), format("/cwm %d", TargetToWorld[i]))
			else
				button:SetAttribute("macrotext1", format("/wm %d", TargetToWorld[i]))
				button:SetAttribute("macrotext2", format("/cwm %d", TargetToWorld[i]))
				button:SetAttribute(format("%s-macrotext1", self.db.modifier), format("/tm %d", i))
				button:SetAttribute(format("%s-macrotext2", self.db.modifier), "/tm 0")
			end
		end
	end
end

function module:ToggleSettings()
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "ToggleSettings")
		return
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	if self.bar and not self.db.enable then
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
		return
	end

	self:UpdateButtons()
	self:UpdateBar()

	if self.bar and self.db and self.db.visibility then
		RegisterStateDriver(
			self.bar,
			"visibility",
			self.db.visibility == "DEFAULT" and "[noexists, nogroup] hide; show"
				or self.db.visibility == "ALWAYS" and "[petbattle] hide; show"
				or "[group] show; [petbattle] hide; hide"
		)
	end

	if self.db.mouseOver then
		self.bar:SetScript("OnEnter", function(self)
			bar:SetAlpha(1)
		end)

		self.bar:SetScript("OnLeave", function(self)
			bar:SetAlpha(0)
		end)

		self.bar:SetAlpha(0)
	else
		self.bar:SetScript("OnEnter", nil)
		self.bar:SetScript("OnLeave", nil)
		self.bar:SetAlpha(1)
	end
end

function module:CreateBar()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", "MER_RaidBar", E.UIParent, "SecureHandlerStateTemplate")
	frame:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -106, 16)
	frame:SetFrameStrata("DIALOG")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetResizable(false)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
	frame.buttons = {}
	self.bar = frame

	self:CreateButtons()
	self:ToggleSettings()

	S:CreateBackdropShadow(self.bar.backdrop)

	E:CreateMover(
		self.barAnchor,
		"MER_RaidMarkersBarAnchor",
		MER.Title .. L["Raid Markers Bar"],
		nil,
		nil,
		nil,
		"ALL,PARTY,RAID,MERATHILISUI",
		function()
			return E.db.mui.raidmarkers.enable
		end,
		"mui,modules,raidmarkers"
	)
end

function module:UpdateCountDownButton()
	if not (self.db and self.bar and self.bar.buttons and self.bar.buttons[11]) then
		return
	end

	local button = self.bar.buttons[11]
	if IsAddOnLoaded("BigWigs") then
		button:SetAttribute("macrotext1", "/pull " .. self.db.countDownTime)
		button:SetAttribute("macrotext2", "/pull 0")
	elseif IsAddOnLoaded("DBM-Core") then
		button:SetAttribute("macrotext1", "/dbm pull " .. self.db.countDownTime)
		button:SetAttribute("macrotext2", "/dbm pull 0")
	else
		button:SetAttribute("macrotext1", _G.SLASH_COUNTDOWN1 .. " " .. self.db.countDownTime)
		button:SetAttribute("macrotext2", _G.SLASH_COUNTDOWN1 .. " " .. -1)
	end
end

function module:CreateButtons()
	self.modifierString = self.db.modifier:gsub("^%l", strupper)

	for i = 1, 11 do
		local button = self.bar.buttons[i]
		if not button then
			button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
			button:CreateBackdrop("Transparent")
		end
		button:SetSize(self.db.buttonSize, self.db.buttonSize)

		if E.private.mui.skins.enable and E.private.mui.skins.shadow.enable then
			S:CreateBackdropShadow(button)
		end

		local tex = button:CreateTexture(nil, "ARTWORK")
		tex:SetSize(self.db.buttonSize, self.db.buttonSize)
		tex:SetPoint("CENTER")
		button.tex = tex

		if i < 9 then
			tex:SetTexture(format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", i))

			button:SetAttribute("type*", "macro")
			button:SetAttribute(format("%s-type*", self.db.modifier), "macro")

			button.isMarkButton = true
		elseif i == 9 then
			tex:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")

			button:SetAttribute("type", "click")
			if not self.db.inverse then
				button:SetScript("OnClick", function(btn)
					if _G[format("Is%sKeyDown", module.modifierString)]() then
						ClearRaidMarker()
					else
						local now = GetTime()
						if now - lastClear > 1 then -- limiting
							lastClear = now
							for j = 8, 0, -1 do
								E:Delay((8 - j) * 0.34, SetRaidTarget, "player", j)
							end
						end
					end
				end)
			else
				button:SetScript("OnClick", function(btn)
					if _G[format("Is%sKeyDown", module.modifierString)]() then
						local now = GetTime()
						if now - lastClear > 1 then -- limiting
							lastClear = now
							for j = 8, 0, -1 do
								E:Delay((8 - j) * 0.34, SetRaidTarget, "player", j)
							end
						end
					else
						ClearRaidMarker()
					end
				end)
			end
		elseif i == 10 then
			tex:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			button:SetAttribute("type*", "macro")
			button:SetAttribute("macrotext1", "/readycheck")
			button:SetAttribute("macrotext2", "/combatlog")
		elseif i == 11 then
			tex:SetTexture("Interface\\Icons\\Spell_unused2")
			tex:SetTexCoord(0.25, 0.8, 0.2, 0.75)
			button:SetAttribute("type*", "macro")
			if IsAddOnLoaded("BigWigs") then
				button:SetAttribute("macrotext1", "/pull " .. self.db.countDownTime)
				button:SetAttribute("macrotext2", "/pull 0")
			elseif IsAddOnLoaded("DBM-Core") then
				button:SetAttribute("macrotext1", "/dbm pull " .. self.db.countDownTime)
				button:SetAttribute("macrotext2", "/dbm pull 0")
			else
				button:SetAttribute("macrotext1", _G.SLASH_COUNTDOWN1 .. " " .. self.db.countDownTime)
				button:SetAttribute("macrotext2", _G.SLASH_COUNTDOWN1 .. " " .. -1)
			end
		end

		button:RegisterForClicks(MER.UseKeyDown and "AnyDown" or "AnyUp")

		local tooltipText = ""

		if i < 9 then
			if not self.db.inverse then
				tooltipText = format(
					"%s\n%s\n%s\n%s",
					L["Left Click to mark the target with this mark."],
					L["Right Click to clear the mark on the target."],
					format(L["%s + Left Click to place this worldmarker."], module.modifierString),
					format(L["%s + Right Click to clear this worldmarker."], module.modifierString)
				)
			else
				tooltipText = format(
					"%s\n%s\n%s\n%s",
					L["Left Click to place this worldmarker."],
					L["Right Click to clear this worldmarker."],
					format(L["%s + Left Click to mark the target with this mark."], module.modifierString),
					format(L["%s + Right Click to clear the mark on the target."], module.modifierString)
				)
			end
		elseif i == 9 then
			if not self.db.inverse then
				tooltipText = format(
					"%s\n%s",
					L["Click to clear all marks."] .. " (|cff2ecc71" .. L["takes 3s"] .. "|r)",
					format(L["%s + Click to remove all worldmarkers."], module.modifierString)
				)
			else
				tooltipText = format(
					"%s\n%s",
					L["Click to remove all worldmarkers."],
					format(L["%s + Click to clear all marks."], module.modifierString)
				)
			end
		elseif i == 10 then
			tooltipText =
				format("%s\n%s", L["Left Click to ready check."], L["Right click to toggle advanced combat logging."])
		elseif i == 11 then
			tooltipText = format("%s\n%s", L["Left Click to start count down."], L["Right click to stop count down."])
		end

		local tooltipTitle = i <= 9 and L["Raid Markers"] or L["Raid Utility"]

		local animGroup = tex:CreateAnimationGroup()
		local scaleAnim = animGroup:CreateAnimation("Scale")
		scaleAnim:SetTarget(tex)
		scaleAnim:SetOrigin("CENTER", 0, 0)

		button.animGroup = animGroup

		animGroup:SetScript("OnPlay", function()
			tex:SetScale(1)
		end)

		animGroup:SetScript("OnFinished", function()
			tex:SetScale(tex.__toScale)
		end)

		button:SetScript("OnEnter", function(btn)
			if module.db.buttonAnimation then
				local progress = F.Or(animGroup:GetProgress(), 0)
				local currentScale = F.Or(tex:GetScale(), 1)
				if abs(progress) > 0.002 and tex.__fromScale and tex.__toScale then
					currentScale = tex.__fromScale + (tex.__toScale - tex.__fromScale) * progress
				end
				animGroup:Stop()
				tex.__fromScale = currentScale
				tex.__toScale = 1.3
				scaleAnim:SetScaleFrom(currentScale, currentScale)
				scaleAnim:SetScaleTo(1.3, 1.3)
				scaleAnim:SetDuration(
					(module.db.buttonAnimationScale - currentScale)
						/ (module.db.buttonAnimationScale - 1)
						* module.db.buttonAnimationDuration
				)
				animGroup:Play()
			end

			local icon = F.GetIconString(I.Media.Textures.pepeSmall, 14)
			btn:SetBackdropBorderColor(0.7, 0.7, 0)
			if module.db.tooltip then
				GameTooltip:SetOwner(btn, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(tooltipTitle .. " " .. icon)
				GameTooltip:AddLine(tooltipText, 1, 1, 1)
				GameTooltip:Show()
			end
		end)

		button:SetScript("OnLeave", function(btn)
			if module.db.buttonAnimation then
				local progress = F.Or(animGroup:GetProgress(), 0)
				local currentScale = F.Or(tex:GetScale(), 1)
				if abs(progress) > 0.002 and tex.__fromScale and tex.__toScale then
					currentScale = tex.__fromScale + (tex.__toScale - tex.__fromScale) * progress
				end
				animGroup:Stop()
				tex.__fromScale = currentScale
				tex.__toScale = 1
				scaleAnim:SetScaleFrom(currentScale, currentScale)
				scaleAnim:SetScaleTo(1, 1)
				scaleAnim:SetDuration(
					module.db.buttonAnimationDuration * (currentScale - 1) / (module.db.buttonAnimationScale - 1)
				)
				animGroup:Play()
			end

			btn:SetBackdropBorderColor(0, 0, 0)
			if module.db.tooltip then
				GameTooltip:Hide()
			end
		end)

		button:HookScript("OnEnter", function()
			if not self.db.mouseOver then
				return
			end
			self.bar:SetAlpha(1)
			button:SetBackdropBorderColor(0.7, 0.7, 0)
		end)

		button:HookScript("OnLeave", function()
			if not self.db.mouseOver then
				return
			end
			self.bar:SetAlpha(0)
			button:SetBackdropBorderColor(0, 0, 0)
		end)

		self.bar.buttons[i] = button
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.raidmarkers

	if self.db.enable and not self.bar then
		self:CreateBar()
		return
	end

	self.modifierString = self.db.modifier:gsub("^%l", strupper)

	self:ToggleSettings()
end

function module:Initialize()
	if not E.db.mui.raidmarkers.enable then
		return
	end

	self.db = E.db.mui.raidmarkers
	self:CreateBar()
end

MER:RegisterModule(module:GetName())
