local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")

local function HandleFilterButton(self)
	if not self then
		F.Developer.ThrowError("filter button not found")
		return
	end

	module:ReskinFilterButton(self)
	if self.__texture then
		self.__texture:Hide()
	end
end

local function HandleSummaryButton(self)
	if not self then
		F.Developer.ThrowError("summary button not found")
		return
	end

	self.Background:SetAlpha(0)
	if not self.backdrop then
		self:CreateBackdrop("Transparent")
		self.backdrop:SetInside()
	end
	local hl = self.FrameHighlight
	hl:SetColorTexture(1, 1, 1, 0.25)
	hl:SetInside(self.bg)
	S:HandleIcon(self.Icon)
end

local function UpdateSelectedTexture(self, atlas)
	if self.SelectedTexture then
		self.SelectedTexture:SetShown(not not atlas)
	end
end

local function HandleBindingButton(self)
	if not self.IsSkinned then
		self.Background:SetAlpha(0)
		if not self.backdrop then
			self:CreateBackdrop("Transparent")
			self.backdrop:SetInside()
		end
		local hl = self.FrameHighlight
		hl:SetColorTexture(1, 1, 1, 0.25)
		hl:SetInside(self.bg)

		self.SelectedTexture = self:CreateTexture(nil, "BACKGROUND")
		self.SelectedTexture:SetColorTexture(F.r, F.g, F.b, 0.25)
		self.SelectedTexture:SetInside(self.bg)
		self.SetNormalAtlas = UpdateSelectedTexture
		self.ClearNormalTexture = UpdateSelectedTexture
		self:SetPushedTexture(0)

		S:HandleIcon(self.Icon)
		S:HandleButton(self.DeleteButton)

		self.IsSkinned = true
	end
end

local function HandleMacroButton(self)
	if not self.IsSkinned then
		self:SetNormalTexture(0)
		S:HandleIcon(self:GetNormalTexture(), true)
		self.SelectedTexture:SetColorTexture(1, 0.8, 0, 0.5)
		self.SelectedTexture:SetInside(self.backdrop)
		local hl = self:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, 0.25)
		hl:SetInside(self.backdrop)

		self.IsSkinned = true
	end
end

local function HandlePageButton(self, direction)
	if not self then
		F.Developer.ThrowError("page button not found")
		return
	end

	module:ReskinArrow(self, direction)
	self:SetSize(20, 20)
end

local function HandleCatalogButton(self)
	S:HandleIcon(self.background, true)
	local hl = self:GetHighlightTexture()
	hl:SetColorTexture(1, 1, 1, 0.25)
	hl:SetInside(self.backdrop)
end

local function ReskinSpellBookButton(self)
	local tab = self.spellbookTab
	if tab and not tab.IsSkinned then
		tab.bg:SetAlpha(0)
		tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		tab:SetHighlightTexture(E.media.normTex)
		tab:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
		tab:CreateBackdrop("Transparent")

		tab.IsSkinned = true
	end
end

local function ReskinBindingFrame(self)
	local frame = self.ui
	if not frame or frame.IsSkinned then
		return
	end

	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	TT:SetStyle(frame.tooltip)

	local BrowsePage = self.BrowsePage and self.BrowsePage.frame
	if BrowsePage then
		S:HandleButton(BrowsePage.AddButton)
		S:HandleButton(BrowsePage.EditButton)
		S:HandleButton(BrowsePage.QuickbindMode)
		BrowsePage.background:StripTextures()
		BrowsePage.background:CreateBackdrop("Transparent")
		S:HandleTrimScrollBar(BrowsePage.scrollbar)
		HandleFilterButton(BrowsePage.OptionsButton)
		S:HandleEditBox(BrowsePage.SearchBox)

		MER:SecureHook(BrowsePage.scrollFrame, "Update", function(self)
			self:ForEachFrame(HandleBindingButton)
		end)
	end

	local EditPage = self.EditPage and self.EditPage.frame
	if EditPage then
		S:HandleButton(EditPage.SaveButton)
		S:HandleButton(EditPage.CancelButton)
		S:HandleButton(EditPage.RemoveRankButton)
		HandleSummaryButton(EditPage.bindSummary)
		S:HandleButton(EditPage.changeBinding)
		S:HandleButton(EditPage.editMacro)

		if self.EditPage.bindSetFrames then
			for _, checkbox in pairs(self.EditPage.bindSetFrames) do
				S:HandleCheckBox(checkbox)
			end
		end
	end

	local EditMacroPage = self.EditMacroPage and self.EditMacroPage.frame
	if EditMacroPage then
		S:HandleButton(EditMacroPage.SaveButton)
		S:HandleButton(EditMacroPage.CancelButton)
		HandleSummaryButton(EditMacroPage.bindSummary)
		EditMacroPage.background:StripTextures()
		EditMacroPage:CreateBackdrop("Transparent")
		EditMacroPage.backdrop:SetAllPoints(EditMacroPage.background)
		EditMacroPage.EditBox:StripTextures()
		EditMacroPage.EditBox:CreateBackdrop("Transparent")
		S:HandleTrimScrollBar(EditMacroPage.EditBox.ScrollBar)
		S:HandleTrimScrollBar(EditMacroPage.iconScrollFrame.scrollbar)

		MER:SecureHook(EditMacroPage.iconScrollFrame, "Update", function(self)
			self:ForEachFrame(HandleMacroButton)
		end)
	end

	local CatalogWindow = self.CatalogWindow and self.CatalogWindow.frame
	if CatalogWindow then
		CatalogWindow:StripTextures()
		CatalogWindow:CreateBackdrop("Transparent")
		WS:CreateShadow(CatalogWindow)
		CatalogWindow:ClearAllPoints()
		CatalogWindow:SetPoint("LEFT", frame, "RIGHT", 2, 0)
		HandlePageButton(CatalogWindow.next, "right")
		HandlePageButton(CatalogWindow.prev, "left")
		S:HandleEditBox(CatalogWindow.searchBox)
		HandleFilterButton(CatalogWindow.filterButton)

		for _, button in ipairs(CatalogWindow.buttons) do
			HandleCatalogButton(button)
		end
	end

	frame.IsSkinned = true
end

function module:Clique()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.cl then
		return
	end

	local Clique = _G.Clique
	if not Clique then
		return
	end

	module:DisableAddOnSkins("Clique", false)

	MER:SecureHook(Clique, "ShowSpellBookButton", ReskinSpellBookButton)

	local config = Clique.GetBindingConfig and Clique:GetBindingConfig()
	MER:SecureHook(config, "InitializeLayout", ReskinBindingFrame)
end

module:AddCallbackForAddon("Clique")
