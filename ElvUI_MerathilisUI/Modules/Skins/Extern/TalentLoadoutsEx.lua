local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local function ReskinChildButton(self)
	if not self then
		F.Developer.ThrowError("Object is nil")
		return
	end

	for _, child in pairs({ self:GetChildren() }) do
		if child:GetObjectType() == "Button" and child.Left and child.Middle and child.Right and child.Text then
			S:HandleButton(child)
		end
	end
end

local function SkinListButton(self)
	if not self.isSkinned then
		self:DisableDrawLayer("BACKGROUND")
		self.Check:SetAtlas("checkmark-minimal")
		S:HandleIcon(self.Icon)
		S:HandleCollapseTexture(self.ToggleButton)
		self.ToggleButton:GetPushedTexture():SetAlpha(0)

		self.bg = module:CreateBDFrame(self, 0.25)
		self.bg:SetAllPoints()
		self.SelectedBar:SetColorTexture(F.r, F.g, F.b, 0.25)
		self.SelectedBar:SetInside(self.bg)
		local hl = self:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, 0.25)
		hl:SetInside(self.bg)

		self.isSkinned = true
	end

	self.bg:SetShown(not not (self.data and not self.data.text))
end

local function ReskinPopupFrame(self)
	if not self then
		F.Developer.ThrowError("Object is nil")
		return
	end

	self.Border:StripTextures()
	self.Header:StripTextures()
	self.Main:StripTextures()
	module:SetBD(self)
end

function module:TalentLoadoutsEx()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.tle then
		return
	end

	F.WaitFor(function()
		return not not _G.TalentLoadoutExMainFrame
	end, function()
		local frame = _G.TalentLoadoutExMainFrame
		frame:StripTextures()
		module:SetBD(frame, nil, 0, 0, 0, 0)
		frame:ClearAllPoints()
		frame:Point("TOPLEFT", _G.PlayerSpellsFrame, "TOPRIGHT", 1, 0)
		frame:Point("BOTTOMLEFT", _G.PlayerSpellsFrame, "BOTTOMRIGHT", 1, 0)
		S:HandleTrimScrollBar(frame.ScrollBar)
		ReskinChildButton(frame)

		for _, button in frame.ScrollBox:EnumerateFrames() do
			SkinListButton(button)
		end

		hooksecurefunc(frame.ScrollBox, "Update", function(self)
			self:ForEachFrame(SkinListButton)
		end)

		local popupFrame = frame.EditPopupFrame
		if popupFrame then
			-- B.ReskinIconSelector(popupFrame)

			local listFrame = popupFrame.IconListFrame
			if listFrame then
				listFrame:StripTextures()
				module:SetBD(listFrame):SetInside()
				listFrame:ClearAllPoints()
				listFrame:Point("TOPLEFT", popupFrame, "BOTTOMLEFT")
				listFrame:Point("TOPRIGHT", popupFrame, "BOTTOMRIGHT")

				for _, child in pairs({ listFrame:GetChildren() }) do
					if child.icon and child.name then
						local hl = child:GetHighlightTexture()
						hl:SetColorTexture(1, 1, 1, 0.25)
						hl:SetAllPoints(child.texture)
						S:HandleIcon(child.texture)
					end
				end
			end

			local textFrame = popupFrame.TalentTextFrame
			if textFrame then
				textFrame:StripTextures()
				module:SetBD(textFrame):SetInside()
				textFrame:ClearAllPoints()
				textFrame:Point("BOTTOMLEFT", popupFrame, "TOPLEFT")
				textFrame:Point("BOTTOMRIGHT", popupFrame, "TOPRIGHT")
				textFrame.Main:StripTextures()

				local editBox = textFrame.Main and textFrame.Main.EditBox
				if editBox then
					S:HandleEditBox(editBox)
					editBox:ClearAllPoints()
					editBox:Point("TOPLEFT", 2, -2)
					editBox:Point("BOTTOMRIGHT", -2, 2)
				end
			end
		end

		local textPopup = frame.TextPopupFrame and frame.TextPopupFrame.Main
		if textPopup then
			ReskinPopupFrame(frame.TextPopupFrame)
			textPopup.ScrollFrame:StripTextures()
			module:CreateBDFrame(textPopup.ScrollFrame, 0.25)
			S:HandleScrollBar(textPopup.ScrollFrame and textPopup.ScrollFrame.ScrollBar)
			ReskinChildButton(textPopup)
		end

		local presetPopup = frame.PresetPopupFrame and frame.PresetPopupFrame.Main
		if presetPopup then
			ReskinPopupFrame(frame.PresetPopupFrame)
			S:HandleDropDownBox(presetPopup.AddonDropDownMenu)

			local configFrame = presetPopup.AddonConfigFrame1
			if configFrame then
				S:HandleDropDownBox(configFrame.ModeOptionFrame and configFrame.ModeOptionFrame.DropDownMenu)
				S:HandleCheckBox(configFrame.CombineOptionFrame and configFrame.CombineOptionFrame.CheckButton)
			end
		end

		local pvpFrame = frame.PvpFrame
		if pvpFrame then
			pvpFrame:StripTextures()
			S:HandleCheckBox(pvpFrame.CheckButton)
		end
	end)
end

module:AddCallbackForAddon("Blizzard_PlayerSpells", module.TalentLoadoutsEx)
