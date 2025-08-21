local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local function reskinTooltip(tt)
	if not tt then
		return
	end

	tt:StripTextures()
	tt:SetTemplate("Transparent")
	tt.CreateBackdrop = E.noop
	tt.ClearBackdrop = E.noop
	tt.SetBackdropColor = E.noop
	if tt.backdrop and tt.backdrop.Hide then
		tt.backdrop:Hide()
	end
	tt.backdrop = nil
	module:CreateShadow(tt)
end

local function reskinDungeonButton(MDT)
	local db = MDT:GetDB()
	local dungeonList = db and db.selectedDungeonList
	local currentList = MDT.dungeonSelectionToIndex and dungeonList and MDT.dungeonSelectionToIndex[dungeonList]
	if not currentList then
		return
	end

	for idx = 1, #currentList do
		if _G["MDTDungeonButton" .. idx] and not _G["MDTDungeonButton" .. idx].template then
			local button = _G["MDTDungeonButton" .. idx]

			if button.texture then
				button.texture:SetTexCoord(unpack(E.TexCoords))
				button.texture:SetInside()
			end

			if button.highlightTexture then
				button.highlightTexture:SetTexture(E.media.blankTex)
				button.highlightTexture:SetVertexColor(1, 1, 1, 0.2)
				button.highlightTexture:SetInside()
			end

			if button.selectedTexture then
				button.selectedTexture:SetTexture(E.media.blankTex)
				button.selectedTexture:SetVertexColor(1, 0.85, 0, 0.4)
				button.selectedTexture:SetInside()
			end

			if not button.template then
				button:SetTemplate()
				module:CreateShadow(button)
			end

			F.MoveFrameWithOffset(button.shortText, 0, 2)

			local BUTTON_SIZE = 40

			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", MDT.main_frame, "TOPLEFT", (idx - 1) * (BUTTON_SIZE + 2) + 2, -2)
		end
	end
end

local function reskinProgressBar(_, progressBar)
	local bar = progressBar and progressBar.Bar
	bar:StripTextures()
	bar:CreateBackdrop(nil, nil, nil, nil, nil, nil, nil, nil, true)
	bar:SetStatusBarTexture(E.media.normTex)

	bar.Label:ClearAllPoints()
	bar.Label:Point("CENTER", bar, 0, 0)
	F.SetFontOutline(bar.Label)
end

local function reskinButtonTexture(texture, alphaTimes)
	if not texture then
		return
	end

	texture:SetTexCoord(0, 1, 0, 1)
	texture:SetInside()

	texture:SetTexture(E.media.blankTex)
	texture.SetVertexColor_ = texture.SetVertexColor
	hooksecurefunc(texture, "SetVertexColor", function(self, r, g, b, a)
		self:SetVertexColor_(r, g, b, a * alphaTimes)
	end)
	texture:SetVertexColor(texture:GetVertexColor())
end

local function reskinContainerIcon(_, icon)
	if icon and icon.image then
		icon.image:SetTexCoord(unpack(E.TexCoords))
	end
end

local function reskinMapPOI(frame)
	if not frame or frame.__MERSkin or not frame.Texture then
		return
	end

	frame:SetTemplate()
	module:CreateShadow(frame)

	frame.HighlightTexture:Kill()
	frame.MERHighlightTexture = frame:CreateTexture(nil, "OVERLAY")
	frame.MERHighlightTexture:SetAllPoints(frame)
	frame.MERHighlightTexture:SetTexture(E.media.blankTex)
	frame.MERHighlightTexture:SetVertexColor(1, 1, 1, 0.2)

	hooksecurefunc(frame.HighlightTexture, "Show", function()
		frame.MERHighlightTexture:Show()
	end)

	hooksecurefunc(frame.HighlightTexture, "Hide", function()
		frame.MERHighlightTexture:Hide()
	end)

	frame.Texture:SetTexCoord(unpack(E.TexCoords))
	frame.Texture:SetInside()

	frame.__MERSkin = true
end

function module:MythicDungeonTools()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mdt then
		return
	end

	if not _G.MDT then
		return
	end

	local skinned = false

	self:SecureHook(_G.MDT, "Async", function(_, _, name)
		if name == "showInterface" and not skinned then
			F.WaitFor(function()
				return _G.MDTFrame and _G.MDTFrame.MaxMinButtonFrame and _G.MDTFrame.closeButton and true or false
			end, function()
				S:HandleMaxMinFrame(_G.MDTFrame.MaxMinButtonFrame)
				S:HandleCloseButton(_G.MDTFrame.closeButton)
			end, 0.05, 10)

			F.WaitFor(function()
				return _G.MDT.tooltip and _G.MDT.pullTooltip and true or false
			end, function()
				reskinTooltip(_G.MDT.tooltip)
				reskinTooltip(_G.MDT.pullTooltip)
			end, 0.05, 10)

			skinned = true
		end
	end)

	self:SecureHook(_G.MDT, "initToolbar", function()
		if _G.MDTFrame then
			local virtualBackground = CreateFrame("Frame", "MER_MDTSkinBackground", _G.MDTFrame)
			virtualBackground:Point("TOPLEFT", _G.MDTTopPanel, "TOPLEFT")
			virtualBackground:Point("BOTTOMRIGHT", _G.MDTSidePanel, "BOTTOMRIGHT")
			self:CreateShadow(virtualBackground)
			self:CreateShadow(_G.MDTToolbarFrame)
		end
	end)

	self:SecureHook(_G.MDT, "UpdateEnemyInfoFrame", function(MDT)
		local container = MDT.enemyInfoFrame.characteristicsContainer
		if container and not container.__MERSkin then
			hooksecurefunc(container, "AddChild", reskinContainerIcon)
			for _, child in pairs(container.children) do
				reskinContainerIcon(nil, child)
			end

			container.__MERSkin = true
		end
	end)

	self:SecureHook(_G.MDT, "POI_CreateFramePools", function(MDT)
		for _, template in pairs({ "MapLinkPinTemplate", "DeathReleasePinTemplate", "VignettePinTemplate" }) do
			local pool = MDT.GetFramePool(template)
			if pool then
				self:SecureHook(pool, "Acquire", function(p)
					if p.active then
						for _, frame in pairs(p.active) do
							reskinMapPOI(frame)
						end
					end
				end)
			end
		end
	end)

	self:SecureHook(_G.MDT, "UpdateDungeonDropDown", reskinDungeonButton)
	self:SecureHook(_G.MDT, "SkinProgressBar", reskinProgressBar)
end

function module:MDTPullButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mdt then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()

		reskinButtonTexture(widget.frame.pickedGlow, 0.5)
		reskinButtonTexture(widget.frame.highlight, 0.2)
		reskinButtonTexture(widget.background, 0.3)

		widget.pullNumber:ClearAllPoints()
		widget.pullNumber:SetPoint("CENTER", widget.frame, "LEFT", 12, 1)

		hooksecurefunc(widget.frame.pickedGlow, "Show", function()
			widget.pullNumber:FontTemplate(nil, 18, "OUTLINE")
			widget.pullNumber:SetTextColor(1, 1, 1, 1)
		end)

		hooksecurefunc(widget.frame.pickedGlow, "Hide", function()
			widget.pullNumber:FontTemplate(nil, 14, "OUTLINE")
			widget.pullNumber:SetTextColor(1, 0.93, 0.76, 0.8)
		end)

		return widget
	end

	return SkinnedConstructor
end

function module:MDTNewPullButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mdt then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		widget.frame:StripTextures()
		reskinButtonTexture(widget.background, 0.2)
		widget.background:SetVertexColor(1, 1, 1, 0.4)
		reskinButtonTexture(widget.frame.highlight, 0.2)

		return widget
	end

	return SkinnedConstructor
end

function module:MDTSpellButton(Constructor)
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.mdt then
		return Constructor
	end

	local function SkinnedConstructor()
		local widget = Constructor()
		S:HandleIcon(widget.icon)
		local iconWidth, iconHeight = widget.icon:GetSize()
		widget.icon:SetSize(iconWidth - 2, iconHeight - 2)
		F.MoveFrameWithOffset(widget.icon, -3, 0)

		widget.frame.background:SetAlpha(0)
		reskinButtonTexture(widget.frame.highlight, 0.2)
		widget.frame:SetTemplate()

		return widget
	end

	return SkinnedConstructor
end

module:AddCallbackForAddon("MythicDungeonTools")
module:AddCallbackForAceGUIWidget("MDTPullButton")
module:AddCallbackForAceGUIWidget("MDTNewPullButton")
module:AddCallbackForAceGUIWidget("MDTSpellButton")
