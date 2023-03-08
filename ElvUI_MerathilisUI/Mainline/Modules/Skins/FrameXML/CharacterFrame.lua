local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local M = E:GetModule('Misc')

local _G = _G
local CreateColor = CreateColor

local ClassSymbolFrame
local CharacterText

local function ColorizeStatPane(frame)
	if frame.leftGrad then
		frame.leftGrad:StripTextures()
	end
	if frame.rightGrad then
		frame.rightGrad:StripTextures()
	end

	frame.leftGrad = frame:CreateTexture(nil, "BORDER")
	frame.leftGrad:SetWidth(80)
	frame.leftGrad:SetHeight(frame:GetHeight())
	frame.leftGrad:SetPoint("LEFT", frame, "CENTER")
	frame.leftGrad:SetTexture(E.media.blankTex)
	frame.leftGrad:SetGradient("Horizontal", CreateColor(F.r, F.g, F.b, 0.75), CreateColor(F.r, F.g, F.b, 0))

	frame.rightGrad = frame:CreateTexture(nil, "BORDER")
	frame.rightGrad:SetWidth(80)
	frame.rightGrad:SetHeight(frame:GetHeight())
	frame.rightGrad:SetPoint("RIGHT", frame, "CENTER")
	frame.rightGrad:SetTexture(E.media.blankTex)
	frame.rightGrad:SetGradient("Horizontal", CreateColor(F.r, F.g, F.b, 0), CreateColor(F.r, F.g, F.b, 0.75))
end

function module:AddCharacterIcon()
	local CharacterFrameTitleText = _G.CharacterFrameTitleText
	local CharacterLevelText = _G.CharacterLevelText

	-- Class Icon Holder
	local ClassIconHolder = CreateFrame("Frame", "MER_ClassIcon", _G.PaperDollFrame)
	ClassIconHolder:SetSize(20, 20)

	local ClassIconTexture = ClassIconHolder:CreateTexture()
	ClassIconTexture:SetAllPoints(ClassIconHolder)

	CharacterLevelText:SetWidth(300)

	ClassSymbolFrame = ("|T" .. (MER.ClassIcons[E.myclass] .. ".tga:0:0:0:0|t"))

	hooksecurefunc('PaperDollFrame_SetLevel', function()
		CharacterFrameTitleText:SetDrawLayer("OVERLAY")
		CharacterFrameTitleText:SetFont(E.LSM:Fetch('font', E.db.general.font), E.db.general.fontSize + 2, E.db.general.fontStyle)

		CharacterLevelText:SetDrawLayer("OVERLAY")
	end)

	local titleText, coloredTitleText

	local function colorTitleText()
		CharacterText = CharacterFrameTitleText:GetText()
		coloredTitleText = E:TextGradient(CharacterText, F.ClassGradient[E.myclass]["r1"],
		F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"],
		F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"])
		if not CharacterText:match("|T") then
			titleText = ClassSymbolFrame .. " " .. coloredTitleText
		end
		CharacterFrameTitleText:SetText(titleText)
	end

	hooksecurefunc("CharacterFrame_Collapse", function()
		if _G.PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("CharacterFrame_Expand", function()
		if _G.PaperDollFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("ReputationFrame_Update", function()
		if _G.ReputationFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc("TokenFrame_Update", function()
		if _G.TokenFrame:IsShown() then
			colorTitleText()
		end
	end)

	hooksecurefunc(_G.CharacterFrame, "SetTitle", function()
		colorTitleText()
	end)

	if E.db.general.itemLevel.displayCharacterInfo then
		M:UpdatePageInfo(_G.CharacterFrame, "Character")
	end
end

function module:CharacterFrame()
	if not module:CheckDB("character", "character") then
		return
	end

	local CharacterFrame = _G.CharacterFrame
	local r, g, b = F.r, F.g, F.b

	CharacterFrame:Styling()
	module:CreateShadow(CharacterFrame)
	module:CreateShadow(_G.EquipmentFlyoutFrameButtons)

	for i = 1, 4 do
		module:ReskinTab(_G["CharacterFrameTab" .. i])
	end

	-- Remove the background
	local modelScene = _G.CharacterModelScene
	modelScene:DisableDrawLayer("BACKGROUND")
	modelScene:DisableDrawLayer("BORDER")
	modelScene:DisableDrawLayer("OVERLAY")
	modelScene.backdrop:Kill()

	local function UpdateHighlight(self)
		local highlight = self:GetHighlightTexture()
		highlight:SetColorTexture(1, 1, 1, .25)
		highlight:SetInside(self.bg)
	end

	local function UpdateCosmetic(self)
		local itemLink = GetInventoryItemLink("player", self:GetID())
		self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]

		slot.ignoreTexture:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
		slot.IconOverlay:SetAtlas("CosmeticIconFrame")
		slot.IconOverlay:SetInside()

		local popout = slot.popoutButton
		popout:SetNormalTexture(0)
		popout:SetHighlightTexture(0)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		if button.popoutButton then
			button.icon:SetShown(GetInventoryItemTexture("player", button:GetID()) ~= nil)
		end
		UpdateCosmetic(button)
		UpdateHighlight(button)
	end)

	local pane = CharacterStatsPane
	pane.ClassBackground:Hide()
	pane.ItemLevelFrame.Corruption:SetPoint("RIGHT", 22, -8)

	local categories = { pane.ItemLevelCategory, pane.AttributesCategory, pane.EnhancementsCategory }
	if categories then
		for _, category in pairs(categories) do
			if category.backdrop then
				category.backdrop:SetAlpha(0)
			end

			category.Title:FontTemplate(nil, 13, 'OUTLINE')
			category.Title:SetText(E:TextGradient(category.Title:GetText(), F.ClassGradient[E.myclass]["r1"], F.ClassGradient[E.myclass]["g1"], F.ClassGradient[E.myclass]["b1"], F.ClassGradient[E.myclass]["r2"], F.ClassGradient[E.myclass]["g2"], F.ClassGradient[E.myclass]["b2"]))

			local bg = category.Background
			bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
			bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
			bg:ClearAllPoints()
			bg:SetPoint("CENTER", 0, -5)
			bg:SetSize(210, 30)
			bg:SetVertexColor(r, g, b)
		end
	end

	if _G.PaperDollSidebarTabs.DecorRight then
		_G.PaperDollSidebarTabs.DecorRight:Hide()
	end

	hooksecurefunc(_G.PaperDollFrame.EquipmentManagerPane.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if child.icon and not child.styled then
				child.HighlightBar:SetColorTexture(1, 1, 1, .25)
				child.HighlightBar:SetDrawLayer("BACKGROUND")
				child.SelectedBar:SetColorTexture(r, g, b, .25)
				child.SelectedBar:SetDrawLayer("BACKGROUND")

				child.styled = true
			end
		end
	end)

	if not IsAddOnLoaded("DejaCharacterStats") then
		ColorizeStatPane(_G.CharacterStatsPane.ItemLevelFrame)

		hooksecurefunc("PaperDollFrame_UpdateStats", function()
			for _, Table in ipairs({_G.CharacterStatsPane.statsFramePool:EnumerateActive()}) do
				if type(Table) == "table" then
					for statFrame in pairs(Table) do
						ColorizeStatPane(statFrame)
						if statFrame.Background:IsShown() then
							statFrame.leftGrad:Show()
							statFrame.rightGrad:Show()
						else
							statFrame.leftGrad:Hide()
							statFrame.rightGrad:Hide()
						end
					end
				end
			end
		end)
	end

	-- Token
	module:CreateShadow(_G.TokenFramePopup)

	-- Reputation
	module:CreateShadow(_G.ReputationDetailFrame)

	self:AddCharacterIcon()
end

module:AddCallback("CharacterFrame")
