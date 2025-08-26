local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

-- Credits: Ndui_Plus

local pairs = pairs

local function HandleItemButton(item)
	if not item then
		return
	end

	S:HandleIcon(item.Icon)
end

local function ReskinCatalystFrame(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if not child.__MERSkin then
			local objType = child:GetObjectType()
			if objType == "Frame" and child.Bg then
				child:StripTextures()
				child:CreateBackdrop("Transparent")
				child.backdrop:SetInside()
				child.__MERSkin = true
			elseif objType == "Button" and child.Icon and child.FavoriteStar then
				HandleItemButton(child)
				child.__MERSkin = true
			end
		end
	end
end

local function ReskinTooltipFrame(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		local objType = child:GetObjectType()
		if objType == "Button" and child.Ticksquare and child.Checkmark then
			local Ticksquare = child.Ticksquare
			local Checkmark = child.Checkmark
			local Background = child.Background

			if not child.backdrop then
				child:CreateBackdrop("Transparent")
				child.backdrop:SetAllPoints(Ticksquare)
				Ticksquare:SetTexture("")

				Checkmark:SetAtlas("checkmark-minimal")
				Checkmark:SetVertexColor(F.r, F.g, F.b)
				Checkmark:Size(20)
				Checkmark:SetDesaturated(true)
				Checkmark:ClearAllPoints()
				Checkmark:Point("CENTER", Ticksquare)

				Background:SetTexture(E.Media.normTex)
				Background:SetVertexColor(F.r, F.g, F.b, 0.25)
				Background:ClearAllPoints()
				Background:Point("TOPLEFT", -15 + 2 * E.mult, 0)
				Background:Point("BOTTOMRIGHT", 15 - 2 * E.mult, 0)
			end

			child.backdrop:SetShown(Ticksquare:IsShown() and Ticksquare:GetAlpha() == 1)
		end
	end
end

local function HandleDungeon(self)
	self.NineSlice:SetTemplate("Transparent")
	self.Bg:SetAlpha(1)

	for _, button in ipairs(self.itemFrames) do
		HandleItemButton(button)
	end

	local button = self.TeleportButton
	if button then
		local icon = button.Icon:GetTexture()
		local noTex = button.NoTeleportTexture:GetTexture()
		button:StripTextures()
		button.Icon:SetTexture(icon)
		button.NoTeleportTexture:SetTexture(noTex)
		S:HandleIcon(button.Icon, true)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
		button:GetHighlightTexture():SetInside(button.backdrop)
	end
end

local function ReskinDungeonsFrame(frame)
	if not frame.__MERSkin then
		frame:StripTextures()

		for _, child in pairs({ frame:GetChildren() }) do
			local objType = child:GetObjectType()
			if objType == "Button" and child.Icon and child.Text then
				S:HandleButton(child, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
				if child.Icon then
					child.Icon:Hide()
				end
				if child.__texture then
					child.__texture:Hide()
				end
			elseif objType == "Frame" and child.Title and child.itemFrames then
				HandleDungeon(child)
			end
		end

		frame.__MERSkin = true
	end
end

local function updateBackdropColor(self, isDisabled)
	if isDisabled then
		self.backdrop:SetBackdropColor(0, 0, 0, 0.25)
	else
		self.backdrop:SetBackdropColor(F.r, F.g, F.b, 0.25)
	end
end

local function HandleRaid(self)
	self.BgTexture:SetAlpha(0)
	S:HandleIcon(self.BossIcon, true)
	self:CreateBackdrop("Transparent")
	self.backdrop:ClearAllPoints()
	self.backdrop:Point("TOPLEFT", self.BossIcon.backdrop, "TOPRIGHT", 2, 0)
	self.backdrop:Point("BOTTOMLEFT", self.BossIcon.backdrop, "BOTTOMRIGHT", 2, 0)
	self.backdrop:Point("RIGHT")

	for _, button in ipairs(self.itemFrames) do
		HandleItemButton(button)
	end

	updateBackdropColor(self, self.BgTexture:IsDesaturated())
	hooksecurefunc(self, "SetDisabled", updateBackdropColor)
end

local function ReskinRaidTab(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		local objType = child:GetObjectType()
		if objType == "Frame" and child.Title and child.BossIcon and child.itemFrames then
			HandleRaid(child)
		end
	end
end

local function ReskinRaidsFrame(frame)
	if not frame.__MERSkin then
		frame:StripTextures()

		for _, child in pairs({ frame:GetChildren() }) do
			local objType = child:GetObjectType()
			if objType == "Button" and child.Icon and child.Text then
				S:HandleButton(child, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
				if child.Icon then
					child.Icon:Hide()
				end
				if child.__texture then
					child.__texture:Hide()
				end
			end
		end

		for i, tab in ipairs(frame.Tabs) do
			module:ReskinTab(tab)

			if i ~= 1 then
				tab:ClearAllPoints()
				tab:Point("TOPLEFT", frame.Tabs[i - 1], "TOPRIGHT", -15, 0)
			end

			ReskinRaidTab(tab.Children)
		end

		frame.__MERSkin = true
	end
end

local function ReskinSpecFrame(frame)
	if not frame.__MERSkin then
		for _, child in pairs({ frame:GetChildren() }) do
			local objType = child:GetObjectType()
			if objType == "Button" then
				local texture = child.GetNormalTexture and child:GetNormalTexture()
				local atlas = texture and texture:GetAtlas()
				if atlas and atlas == "RedButton-Exit" then
					S:HandleCloseButton(child)
				end
			elseif objType == "Frame" and child.itemFrames and child.Bg then
				child:HideBackdrop()
				child.Bg:CreateBackdrop("Transparent")
				S:HandleButton(child.Button)

				for _, button in ipairs(child.itemFrames) do
					HandleItemButton(button)
				end
			end
		end

		frame.__MERSkin = true
	end
end

function module:KeystoneLoot()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.klf then
		return
	end

	local frame = _G.KeystoneLootFrame
	if not frame then
		return
	end

	S:HandlePortraitFrame(frame)

	for _, child in pairs({ frame:GetChildren() }) do
		local texture = child.GetNormalTexture and child:GetNormalTexture()
		local atlas = texture and texture:GetAtlas()
		if atlas and atlas == "RedButton-Exit" then
			S:HandleCloseButton(child)
			break
		end
	end

	local OptionsButton = frame.OptionsButton
	if OptionsButton then
		OptionsButton:ClearAllPoints()
		OptionsButton:SetPoint("TOPRIGHT", -28, -6)
	end

	local CatalystFrame = frame.CatalystFrame
	if CatalystFrame then
		CatalystFrame:ClearAllPoints()
		CatalystFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -40)
		CatalystFrame:HookScript("OnShow", ReskinCatalystFrame)
	end

	local TooltipFrame = frame.TooltipFrame
	if TooltipFrame then
		TooltipFrame:StripTextures()
		TooltipFrame:CreateBackdrop("Transparent")
		TooltipFrame:HookScript("OnShow", ReskinTooltipFrame)
	end

	for i, tab in ipairs(frame.Tabs) do
		module:ReskinTab(tab)

		if i ~= 1 then
			tab:ClearAllPoints()
			tab:SetPoint("TOPLEFT", frame.Tabs[i - 1], "TOPRIGHT", 3, -1)
		end

		if tab.id == "dungeons" then
			tab.Children:HookScript("OnShow", ReskinDungeonsFrame)
		elseif tab.id == "raids" then
			tab.Children:HookScript("OnShow", ReskinRaidsFrame)
		end
	end

	for _, child in pairs({ _G.UIParent:GetChildren() }) do
		if child.layoutType == "SimplePanelTemplate" and E:Round(child:GetHeight()) == 217 then
			child:StripTextures()
			child:CreateBackdrop("Transparent")
			child:HookScript("OnShow", ReskinSpecFrame)
			break
		end
	end
end

module:AddCallbackForAddon("KeystoneLoot")
