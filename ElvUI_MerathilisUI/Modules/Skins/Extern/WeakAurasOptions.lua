local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local type = type
local unpack = unpack

local buttons = {}
local expandButtons = {}

local function RemoveBorder(frame)
	for _, region in pairs({ frame:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			local tex = region:GetTexture()
			if tex and tex == 130841 then
				region:Kill()
			end
		end
	end
end

local function HandleAllChildButtons(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("Button") then
			S:HandleButton(child)
		end
	end
end

function module:WeakAuras_RegisterRegionOptions(name, createFunction, icon, displayName, createThumbnail, ...)
	if type(icon) == "function" then
		local OldIcon = icon
		icon = function()
			local f = OldIcon()
			RemoveBorder(f)
			return f
		end
	end

	if type(createThumbnail) == "function" then
		local OldCreateThumbnail = createThumbnail
		createThumbnail = function()
			local f = OldCreateThumbnail()
			RemoveBorder(f)
			return f
		end
	end

	self.hooks[_G.WeakAuras.Private]["RegisterRegionOptions"](
		name,
		createFunction,
		icon,
		displayName,
		createThumbnail,
		...
	)
end

local function ReskinNormalButton(button, next)
	if button.Left and button.Middle and button.Right and button.Text then
		S:HandleButton(button)
	end
	if next then
		for _, child in pairs({ button:GetChildren() }) do
			if child:GetObjectType() == "Button" then
				ReskinNormalButton(child)
			end
		end
	end
end

local function ReskinChildButton(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:GetObjectType() == "Button" then
			ReskinNormalButton(child, true)
		end
	end
end

local function ApplyTextureCoords(tex, force)
	if not tex or not tex.SetTexCoord then
		return
	end

	if tex.MERTexCoords and not force then
		return
	end

	tex:SetTexCoord(unpack(E.TexCoords))
	tex.MERTexCoords = true
end

function module:WeakAurasMultiLineEditBox(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.waOptions then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()
		S:HandleButton(widget.button)

		widget.scrollBG:SetAlpha(0)
		widget.scrollFrame:StripTextures()
		S:HandleScrollBar(widget.scrollBar)

		widget.editBox:DisableDrawLayer("BACKGROUND")
		widget.frame:CreateBackdrop()
		widget.frame.backdrop:ClearAllPoints()
		widget.frame.backdrop:OffsetFrameLevel(nil, widget.frame)
		widget.frame.backdrop:SetPoint("TOPLEFT", widget.scrollFrame, "TOPLEFT", -5, 2)
		widget.frame.backdrop:SetPoint("BOTTOMRIGHT", widget.scrollFrame, "BOTTOMRIGHT", 0, 0)

		local onShow = widget.frame:GetScript("OnShow")
		widget.frame:SetScript("OnShow", function(frame)
			onShow(frame)
			if not frame.obj or not frame.obj.extraButtons then
				return
			end

			for _, button in pairs(frame.obj.extraButtons) do
				if not button.MERStyle then
					S:HandleButton(button)
					button.MERStyle = true
				end
			end
		end)
		return widget
	end

	return SkinedConstructor
end

function module:WeakAurasDisplayButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.waOptions then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()
		if widget.background then
			S:HandleButton(widget.frame, nil, nil, nil, true, "Transparent")
			widget.frame.background:SetAlpha(0)
			widget.frame.backdrop:OffsetFrameLevel(nil, widget.frame)
			widget.frame.backdrop.color = { widget.frame.backdrop.Center:GetVertexColor() }

			hooksecurefunc(widget.frame.background, "Hide", function()
				widget.frame.backdrop.Center:SetVertexColor(1, 0, 0, 0.3)
			end)

			hooksecurefunc(widget.frame.background, "Show", function()
				widget.frame.backdrop.Center:SetVertexColor(unpack(widget.frame.backdrop.color))
			end)
		end

		ApplyTextureCoords(widget.icon)

		if widget.renamebox then
			S:HandleEditBox(widget.renamebox)
		end

		if widget.frame.highlight then
			widget.frame.highlight:SetTexture(E.media.blankTex)
			widget.frame.highlight:SetVertexColor(1, 1, 1, 0.15)
			widget.frame.highlight:SetInside()
		end

		-- Set Icon (Generally, Weakauras call this function to update the icon)
		if widget.SetIcon then
			local SetIcon = widget.SetIcon
			widget.SetIcon = function(frame, icon)
				SetIcon(frame, icon)
				if frame.iconRegion then
					ApplyTextureCoords(frame.iconRegion.icon, true)
				end
			end
		end

		-- Update Thumbnail (After picking up the new icon for this aura, Weakauras will call this function)
		if widget.UpdateThumbnail then
			local UpdateThumbnail = widget.UpdateThumbnail
			widget.UpdateThumbnail = function(frame)
				UpdateThumbnail(frame)
				if frame.thumbnail then
					ApplyTextureCoords(frame.thumbnail.icon, true)
				end
			end
		end

		if widget.expand then
			-- Expand Button
			local expandButton = widget.expand
			expandButton:StripTextures()
			expandButton.SetNormalTexture = E.noop
			expandButton.SetHighlightTexture = E.noop
			expandButton.SetPushedTexture = E.noop

			expandButton:CreateBackdrop()
			expandButton.backdrop:SetInside(nil, 2, 2)
			expandButton.backdrop.Center:Kill()
			expandButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
			expandButton.Texture = expandButton.backdrop:CreateTexture(nil, "OVERLAY")
			expandButton.Texture:SetSize(12, 12)
			expandButton.Texture:SetTexture(I.Media.Icons.Plus)
			expandButton.Texture:SetVertexColor(0.5, 0.5, 0.5, 1)
			expandButton.Texture:SetPoint("CENTER")
			expandButton:HookScript("OnEnter", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(1, 1, 1)
				end
			end)

			expandButton:HookScript("OnLeave", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
				end
			end)

			local DisableExpand = widget.DisableExpand
			widget.DisableExpand = function(frame)
				DisableExpand(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Plus)
				expandButton.Texture:SetVertexColor(0.3, 0.3, 0.3, 1)
			end

			local Expand = widget.Expand
			widget.Expand = function(frame)
				Expand(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Minus)
				expandButton.Texture:SetVertexColor(1, 1, 1, 1)
			end

			local Collapse = widget.Collapse
			widget.Collapse = function(frame)
				Collapse(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Plus)
				expandButton.Texture:SetVertexColor(1, 1, 1, 1)
			end
		end

		-- Group (verb) Button
		if widget.group then
			-- Expand Button
			local groupButton = widget.group
			groupButton:StripTextures()
			groupButton.SetNormalTexture = E.noop
			groupButton.SetHighlightTexture = E.noop
			groupButton.SetPushedTexture = E.noop

			groupButton:CreateBackdrop()
			groupButton.backdrop:SetInside(nil, 2, 2)
			groupButton.backdrop.Center:Kill()
			groupButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
			groupButton.Texture = groupButton.backdrop:CreateTexture(nil, "OVERLAY")
			groupButton.Texture:SetSize(9, 9)
			groupButton.Texture:SetTexture(I.Media.Icons.Forward)
			groupButton.Texture:SetPoint("CENTER")
			groupButton:HookScript("OnEnter", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(1, 1, 1)
				end
			end)

			groupButton:HookScript("OnLeave", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
				end
			end)
		end

		return widget
	end

	return SkinedConstructor
end

module.WeakAurasNewButton = module.WeakAurasDisplayButton

function module:WeakAurasLoadedHeaderButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.waOptions then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()

		if widget.expand then
			-- Expand Button
			local expandButton = widget.expand
			expandButton:StripTextures()
			expandButton.SetNormalTexture = E.noop
			expandButton.SetHighlightTexture = E.noop
			expandButton.SetPushedTexture = E.noop

			expandButton:CreateBackdrop()
			expandButton.backdrop:SetInside(nil, 2, 2)
			expandButton.backdrop.Center:Kill()
			expandButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
			expandButton.Texture = expandButton.backdrop:CreateTexture(nil, "OVERLAY")
			expandButton.Texture:SetSize(12, 12)
			expandButton.Texture:SetTexture(I.Media.Icons.Plus)
			expandButton.Texture:SetVertexColor(0.5, 0.5, 0.5, 1)
			expandButton.Texture:SetPoint("CENTER")
			expandButton:HookScript("OnEnter", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(1, 1, 1)
				end
			end)

			expandButton:HookScript("OnLeave", function(self)
				if not self.disabled and self.backdrop then
					self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
				end
			end)

			local DisableExpand = widget.DisableExpand
			widget.DisableExpand = function(frame)
				DisableExpand(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Plus)
				expandButton.Texture:SetVertexColor(0.3, 0.3, 0.3, 1)
			end

			local Expand = widget.Expand
			widget.Expand = function(frame)
				Expand(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Minus)
				expandButton.Texture:SetVertexColor(1, 1, 1, 1)
			end

			local Collapse = widget.Collapse
			widget.Collapse = function(frame)
				Collapse(frame)
				expandButton.Texture:SetTexture(I.Media.Icons.Plus)
				expandButton.Texture:SetVertexColor(1, 1, 1, 1)
			end
		end

		return widget
	end

	return SkinedConstructor
end

do
	local AnchorDict = {
		["TOP"] = "up",
		["BOTTOM"] = "down",
		["LEFT"] = "left",
		["RIGHT"] = "right",
	}
	function module:WeakAurasOptionMoverSizer()
		if not _G.WeakAurasOptions or not _G.WeakAurasOptions.moversizer then
			return
		end

		local frame = _G.WeakAurasOptions.moversizer

		-- Mover Edge
		module:StripEdgeTextures(frame)
		frame:CreateBackdrop()
		frame.backdrop:SetInside(frame, 2, 2)
		frame.backdrop.Center:Kill()
		frame.backdrop:SetBackdropBorderColor(1, 1, 1)
		module:CreateShadow(frame.backdrop, 4, 1, 1, 1, true)

		-- Mover Buttons
		for _, child in pairs({ frame:GetChildren() }) do
			local numChildren = child:GetNumChildren()
			local numRegions = child:GetNumRegions()
			if numChildren == 2 and numRegions == 0 then
				for _, button in pairs({ child:GetChildren() }) do
					local anchor = button:GetPoint()
					if anchor then
						button:StripTextures()
						button:SetSize(16, 16)
						button:CreateBackdrop()
						module:CreateShadow(button.backdrop)
						button.Texture = button.backdrop:CreateTexture(nil, "OVERLAY")
						button.Texture:SetTexture(E.Media.Textures.ArrowUp)
						button.Texture:SetPoint("CENTER")
						button.Texture:SetSize(16, 16)
						button.Texture:SetRotation(S.ArrowRotation[AnchorDict[anchor]])

						button:HookScript("OnEnter", function(self)
							if self.Texture then
								self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
							end
						end)

						button:HookScript("OnLeave", function(self)
							if self.Texture then
								self.Texture:SetVertexColor(1, 1, 1, 1)
							end
						end)
					end
				end
			end
		end
	end
end

function module:WeakAurasIconButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.waOptions then
		return Constructor
	end

	local function SkinedConstructor()
		local widget = Constructor()
		widget.frame:CreateBackdrop()
		widget.frame.backdrop.Center:StripTextures()
		ApplyTextureCoords(widget.texture)
		widget.texture:SetInside(widget.frame, 3, 3)
		widget.frame.backdrop:SetInside(widget.frame, 2, 2)

		local highlightTexture = widget.frame:GetHighlightTexture()
		if highlightTexture then
			highlightTexture:StripTextures()
		end

		widget.frame:HookScript("OnEnter", function(self)
			if self.backdrop then
				self.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
			end
		end)

		widget.frame:HookScript("OnLeave", function(self)
			if self.backdrop then
				self.backdrop:SetBackdropBorderColor(0, 0, 0)
			end
		end)

		return widget
	end

	return SkinedConstructor
end

function module:WeakAuras_ShowOptions()
	local frame = _G.WeakAurasOptions
	if not frame or frame.MERStyle then
		return
	end

	-- Remove background
	frame:StripTextures()
	S:HandleFrame(frame, true, nil, 0, 0, 0, 0)
	module:CreateShadow(frame)

	S:HandleCloseButton(frame.CloseButton)

	if frame.MaxMinButtonFrame.MinimizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MinimizeButton, "up", nil, true)
		frame.MaxMinButtonFrame.MinimizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MinimizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	if frame.MaxMinButtonFrame.MaximizeButton then
		S:HandleNextPrevButton(frame.MaxMinButtonFrame.MaximizeButton, "down", nil, true)
		frame.MaxMinButtonFrame.MaximizeButton:ClearAllPoints()
		frame.MaxMinButtonFrame.MaximizeButton:Point("RIGHT", frame.CloseButton, "LEFT")
	end

	for _, region in pairs({ frame:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
			region.SetTexture = E.noop
		end
	end

	-- Mover Sizer
	self:WeakAurasOptionMoverSizer()

	-- Buttons
	for _, child in pairs({ frame:GetChildren() }) do
		if child:GetObjectType() == "Button" then
			ReskinNormalButton(child, true)
		elseif child:GetObjectType() == "Frame" then
			ReskinChildButton(child)
			ReskinNormalButton(child, true)
		end
	end

	-- Filter editbox
	if frame.filterInput then
		local inputBox = frame.filterInput
		local rightPart
		S:HandleEditBox(inputBox)
		for i = 1, inputBox:GetNumPoints() do
			local point, relativeFrame = inputBox:GetPoint(i)
			if point == "RIGHT" then
				rightPart = relativeFrame
				break
			end
		end
		if rightPart then
			inputBox:SetHeight(inputBox:GetHeight() + 5)
			inputBox:ClearAllPoints()
			inputBox:SetPoint("TOP", frame, "TOP", 0, -62)
			inputBox:SetPoint("LEFT", frame, "LEFT", 19, 0)
			inputBox:SetPoint("RIGHT", rightPart, "LEFT", -1, 0)
		end
	end

	for _, child in pairs({ frame:GetChildren() }) do
		local numRegions = child:GetNumRegions()
		local numChildren = child:GetNumChildren()
		local frameStrata = child:GetFrameStrata()

		if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then -- Top right buttons(close & collapse)
			for _, region in pairs({ child:GetRegions() }) do
				region:StripTextures()
			end
			local button = child:GetChildren()

			if not button.MERStyle and button.GetNormalTexture then
				local normalTexturePath = button:GetNormalTexture():GetTexture()
				if normalTexturePath == 252125 then
					button:StripTextures()

					button.Texture = button:CreateTexture(nil, "OVERLAY")
					button.Texture:SetPoint("CENTER")
					button.Texture:SetTexture(E.Media.Textures.ArrowUp)
					button.Texture:SetSize(14, 14)

					button:HookScript("OnEnter", function(self)
						if self.Texture then
							self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
						end
					end)

					button:HookScript("OnLeave", function(self)
						if self.Texture then
							self.Texture:SetVertexColor(1, 1, 1, 1)
						end
					end)

					button:HookScript("OnClick", function(self)
						self:SetNormalTexture("")
						self:SetPushedTexture("")
						if self:GetParent():GetParent().minimized then
							button.Texture:SetRotation(S.ArrowRotation["down"])
						else
							button.Texture:SetRotation(S.ArrowRotation["up"])
						end
					end)

					button:SetHitRectInsets(6, 6, 7, 7)
					button:SetPoint("TOPRIGHT", frame.backdrop, "TOPRIGHT", -25, -5)
				else
					S:HandleCloseButton(button)
					button:ClearAllPoints()
					button:SetPoint("TOPRIGHT", frame.backdrop, "TOPRIGHT", -3, -3)
				end

				button.MERStyle = true
			end
		end

		-- tipPopup
		if frameStrata == "FULLSCREEN" then
			child:StripTextures()
			child:CreateBackdrop("Transparent")
			module:CreateShadow(child.backdrop)
			for _, subChild in pairs({ child:GetChildren() }) do
				if subChild.GetObjectType and subChild:GetObjectType() == "EditBox" then
					S:HandleEditBox(subChild)
					subChild.backdrop:SetInside(nil, 0, 7)
				end
			end
		end
	end

	-- Snippets Frame
	local snippetsFrame = _G.WeakAurasSnippets
	if snippetsFrame then
		snippetsFrame:ClearAllPoints()
		snippetsFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 5, 0)
		snippetsFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
		snippetsFrame:StripTextures()
		snippetsFrame:CreateBackdrop("Transparent")
		module:CreateBackdropShadow(snippetsFrame)
		ReskinChildButton(snippetsFrame)
	end

	-- Top Panel Position Fix
	if frame.toolbarContainer then
		local importButton, newButton
		for _, child in pairs({ frame.toolbarContainer:GetChildren() }) do
			if child.obj and child.obj.type == "WeakAurasToolbarButton" then
				if child:GetNumPoints() == 2 then
					local point, relativeFrame, relativePoint = child:GetPoint(1)
					if point == "RIGHT" and relativeFrame == frame.filterInput and relativePoint == "RIGHT" then
						local point, relativeFrame, relativePoint = child:GetPoint(2)
						if point == "BOTTOM" and relativeFrame == frame and relativePoint == "TOP" then
							importButton = child
						end
					end
				end
			end
		end

		if importButton then
			for _, child in pairs({ frame.toolbarContainer:GetChildren() }) do
				if child.obj and child.obj.type == "WeakAurasToolbarButton" then
					if child:GetNumPoints() == 1 then
						local point, relativeFrame, relativePoint = child:GetPoint(1)
						if point == "RIGHT" and relativeFrame == importButton and relativePoint == "LEFT" then
							newButton = child
						end
					end
				end
			end
		end

		if importButton and newButton then
			newButton:ClearAllPoints()
			newButton:SetPoint("BOTTOMLEFT", frame.filterInput, "TOPLEFT", 0, 6)
			importButton:ClearAllPoints()
			importButton:SetPoint("LEFT", newButton, "RIGHT", 4, 0)
		end
	end

	frame.MERStyle = true
end

function postHookPrivate(method, postHook)
	if not _G.WeakAuras or not _G.WeakAuras.OptionsPrivate then
		return
	end

	local oldConstructor = _G.WeakAuras.OptionsPrivate[method]
	_G.WeakAuras.OptionsPrivate[method] = function(...)
		local widget = oldConstructor(...)
		if widget and not widget.__MERSkin then
			postHook(widget)
			widget.__MERSkin = true
		end
		return widget
	end
end

function module:WeakAuras_TextEditor()
	S:HandleButton(_G.WASettingsButton)

	local frame = _G.WASnippetsButton:GetParent()
	if not frame then
		return
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if child.Text then
			S:HandleButton(child)
		end
	end

	frame = _G.WeakAurasSnippets
	if not frame then
		return
	end

	frame:SetBackdrop(nil)
	frame:CreateBackdrop("Transparent")
	module:CreateShadow(frame)

	for _, child in pairs({ frame:GetChildren() }) do
		if child.Text then
			S:HandleButton(child)
		end
	end
end

function module:WeakAurasOptions()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.waOptions then
		return
	end

	if not _G.WeakAuras or not _G.WeakAuras.Private then
		return
	end

	module:SecureHook(_G.WeakAuras, "ShowOptions", "WeakAuras_ShowOptions")

	local generalEditBoxSkinner = function(skip, element)
		if skip then
			return
		end
		if element and element.GetObjectType and element:GetObjectType() == "EditBox" then
			element.Left:Kill()
			element.Middle:Kill()
			element.Right:Kill()
			element:CreateBackdrop()
			return true
		end
	end

	local generalButtonSkinner = function(skip, element)
		if skip then
			return
		end
		if element and element.GetObjectType and element:GetObjectType() == "Button" then
			S:HandleButton(element)
			return true
		end
	end

	local skinChildren = function(widget)
		local frame = widget.frame or widget
		for _, child in pairs({ frame:GetChildren() }) do
			if child.GetObjectType then
				local skip = false
				skip = generalEditBoxSkinner(skip, child)
				generalButtonSkinner(skip, child)
			end
		end
	end

	for _, mod in pairs({ "UpdateFrame", "IconPicker", "ImportExport" }) do
		postHookPrivate(mod, skinChildren)
	end

	postHookPrivate("TextEditor", function(widget)
		skinChildren(widget)

		if _G.WASettingsButton then
			S:HandleButton(_G.WASettingsButton)
		end

		if _G.WeakAurasAPISearchFrame then
			S:HandleFrame(_G.WeakAurasAPISearchFrame, true, "Transparent")
			self:CreateShadow(_G.WeakAurasAPISearchFrame)

			if _G.WeakAurasAPISearchFilterInput then
				S:HandleEditBox(_G.WeakAurasAPISearchFilterInput)
			end
		end

		if _G.WeakAurasSnippets then
			S:HandleFrame(_G.WeakAurasSnippets, true, "Transparent")
			self:CreateShadow(_G.WeakAurasSnippets)
			skinChildren(_G.WeakAurasSnippets)
		end
	end)
end

function module:WeakAuras_CreateTemplateView(Private, frame)
	local frame = self.hooks[_G.WeakAuras].CreateTemplateView(Private, frame)
	HandleAllChildButtons(frame)
	return frame
end

function module:WeakAurasTemplatesLoadTimerBody()
	if _G.WeakAuras and _G.WeakAuras.CreateTemplateView then
		self:CancelTimer(self.weakAurasTemplatesLoadTimer)
		self.weakAurasTemplatesLoadTimer = nil
		self:RawHook(_G.WeakAuras, "CreateTemplateView", "WeakAuras_CreateTemplateView")

		if _G.WeakAurasOptions then
			if _G.WeakAurasOptions.newView and _G.WeakAurasOptions.newView.frame then
				HandleAllChildButtons(_G.WeakAurasOptions.newView.frame)
			end
		end
	end
end

function module:WeakAurasTemplates()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.weakAuras then
		return
	end

	self.weakAurasTemplatesLoadTimer = self:ScheduleRepeatingTimer("WeakAurasTemplatesLoadTimerBody", 0.1)
end

module:AddCallbackForAddon("WeakAurasOptions")
module:AddCallbackForAddon("WeakAurasTemplates")
module:AddCallbackForAceGUIWidget("WeakAurasMultiLineEditBox")
module:AddCallbackForAceGUIWidget("WeakAurasDisplayButton")
module:AddCallbackForAceGUIWidget("WeakAurasIconButton")
module:AddCallbackForAceGUIWidget("WeakAurasNewButton")
module:AddCallbackForAceGUIWidget("WeakAurasLoadedHeaderButton")
