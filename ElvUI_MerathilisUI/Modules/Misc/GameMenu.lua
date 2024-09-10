local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

local _G = _G
local random = random

local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local UIFrameFadeIn = UIFrameFadeIn

local GameMenuFrame = _G.GameMenuFrame

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

MER.NPCS = {
	86470, -- Pepe
	-- Shadowlands
	172854, -- Dredger Butler
	175783, -- Digallo
	171716, -- Indigo
	173586, -- Leafadore
	173992, -- Torghast Lurker
	-- Dragonflight
	183638, -- Ichabod
	188844, -- Humduck Livingsworth the Third
	188861, -- Secretive Frogduck
	189152, -- Lubbins
	191627, -- Lord Basilton
	184285, -- Gnomelia Gearheart
	-- The War Within
	222078, -- Wriggle
	222877, -- Ghostcap Menace
	222532, -- Bouncer
	223399, -- Tickler
}

local Sequences = { 26, 52, 69, 111, 225 }

function module:GameMenu_OnShow()
	local iconsDb = E.db.mui.armory.icons
	local guildName = GetGuildInfo("player")

	local specIcon = ""

	local _, classId = UnitClassBase("player")
	local specIndex = GetSpecialization()
	local id = GetSpecializationInfoForClassID(classId, specIndex)

	if id and id ~= 0 and iconsDb then
		specIcon = iconsDb[id]
	else
		specIcon = ""
	end

	local mainFrame = CreateFrame("Frame", nil, E.UIParent)
	mainFrame:SetAllPoints(E.UIParent)
	mainFrame:SetFrameStrata("TOOLTIP")
	mainFrame:SetFrameLevel(GameMenuFrame:GetFrameLevel())

	local bottomPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	bottomPanel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
	bottomPanel:Width(E.screenWidth + (E.Border * 2))
	bottomPanel:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(bottomPanel)

	bottomPanel.ignoreFrameTemplates = true
	bottomPanel.ignoreBackdropColors = true
	E["frames"][bottomPanel] = true

	bottomPanel.anim = CreateAnimationGroup(bottomPanel)
	bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
	bottomPanel.anim.height:SetChange(E.screenHeight * (1 / 4))
	bottomPanel.anim.height:SetDuration(0.6)
	bottomPanel:Height(0)
	bottomPanel.anim.height:Play()

	bottomPanel.Logo = bottomPanel:CreateTexture(nil, "OVERLAY")
	bottomPanel.Logo:Size(100)
	bottomPanel.Logo:SetPoint("CENTER", bottomPanel, "TOP", 0, -80)
	bottomPanel.Logo:SetTexture(I.General.MediaPath .. "Textures\\mUI1_Shadow.tga")

	bottomPanel.nameText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.nameText:FontTemplate(nil, 26)
	bottomPanel.nameText:SetTextColor(1, 1, 1, 1)
	bottomPanel.nameText:SetPoint("TOP", bottomPanel.Logo, "BOTTOM", 0, -5)
	bottomPanel.nameText:SetText(F.String.GradientClass(E.myname))

	bottomPanel.guildText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.guildText:FontTemplate(nil, 16)
	bottomPanel.guildText:SetPoint("TOP", bottomPanel.nameText, "BOTTOM", 0, 0)
	bottomPanel.guildText:SetTextColor(1, 1, 1, 1)
	bottomPanel.guildText:SetText(
		guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or ""
	)

	bottomPanel.specIcon = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.specIcon:SetFont("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Fonts\\ToxiUIIcons.ttf", 20, "OUTLINE")
	bottomPanel.specIcon:SetPoint("TOP", bottomPanel.guildText, "BOTTOM", 0, -15)
	bottomPanel.specIcon:SetTextColor(1, 1, 1, 1)
	bottomPanel.specIcon:SetText(F.String.Class(specIcon))

	bottomPanel.levelText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.levelText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.levelText:SetPoint("RIGHT", bottomPanel.specIcon, "LEFT", -4, 0)
	bottomPanel.levelText:SetTextColor(1, 1, 1, 1)
	bottomPanel.levelText:SetText("Lvl " .. E.mylevel)

	bottomPanel.classText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.classText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.classText:SetPoint("LEFT", bottomPanel.specIcon, "RIGHT", 4, 0)
	bottomPanel.classText:SetTextColor(1, 1, 1, 1)
	bottomPanel.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))

	local topPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	topPanel:Point("TOP", E.UIParent, "TOP", 0, 0)
	topPanel:Width(E.screenWidth + (E.Border * 2))
	topPanel:CreateBackdrop("Transparent")
	S:CreateBackdropShadow(topPanel)

	topPanel.ignoreFrameTemplates = true
	topPanel.ignoreBackdropColors = true
	E["frames"][topPanel] = true

	topPanel.anim = CreateAnimationGroup(topPanel)
	topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
	topPanel.anim.height:SetChange(E.screenHeight * (1 / 4))
	topPanel.anim.height:SetDuration(0.6)
	topPanel:Height(0)
	topPanel.anim.height:Play()

	topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
	topPanel.factionLogo:Point("CENTER", topPanel, "CENTER", 0, 0)
	topPanel.factionLogo:Size(186, 186)
	topPanel.factionLogo:SetTexture(I.General.MediaPath .. "Textures\\ClassBanner\\CLASS-" .. E.myclass)

	-- Use this frame to control the position of the model - taken from ElvUI
	local modelHolder = CreateFrame("Frame", nil, mainFrame)
	modelHolder:Size(150)
	modelHolder:Point("RIGHT", GameMenuFrame, "LEFT", -300, 0)

	local playerKey = random(1, 5)
	local playerEmote = Sequences[playerKey]

	local playerModel = CreateFrame("PlayerModel", nil, modelHolder)
	playerModel:Point("CENTER", modelHolder, "CENTER")
	playerModel:Size(E.screenWidth * 2, E.screenHeight * 2) --YES, double screen size. This prevents clipping of models.
	playerModel:SetScale(0.8)
	playerModel:SetAlpha(1)
	playerModel:ClearModel()
	playerModel:SetUnit("player")
	playerModel:SetFacing(6.5)
	playerModel:SetPortraitZoom(0.05)
	playerModel:SetCamDistanceScale(4.8)
	playerModel:SetAnimation(playerEmote)
	UIFrameFadeIn(playerModel, 1, playerModel:GetAlpha(), 1)
	playerModel.isIdle = nil

	local npcHolder = CreateFrame("Frame", nil, mainFrame)
	npcHolder:Size(150)
	npcHolder:Point("LEFT", GameMenuFrame, "RIGHT", 300, 0)

	local npc = MER.NPCS
	local mod = random(1, #npc)
	local npcID = npc[mod]
	local npcKey = random(1, 5)
	local npcEmote = Sequences[npcKey]

	local npcModel = CreateFrame("PlayerModel", nil, npcHolder)
	npcModel:Point("CENTER", npcHolder, "CENTER")
	npcModel:Size(256)
	npcModel:SetScale(0.8)
	npcModel:SetAlpha(1)

	npcModel:ClearModel()
	npcModel:SetCreature(npcID)
	npcModel:SetCamDistanceScale(1)
	npcModel:SetFacing(6)
	npcModel:SetAnimation(npcEmote)
	UIFrameFadeIn(self, 1, npcModel:GetAlpha(), 1)
	npcModel.isIdle = nil

	self.mainFrame = mainFrame
	self.mainFrame:Show()

	self.modelHolder = modelHolder
	self.npcHolder = npcHolder
end

function module:GameMenu_OnHide()
	if self.mainFrame then
		self.mainFrame:Hide()
	end
end

function module:GameMenu()
	if not E.db.mui.general.GameMenu then
		return
	end

	self:SecureHookScript(GameMenuFrame, "OnShow", module.GameMenu_OnShow)
	self:SecureHookScript(GameMenuFrame, "OnHide", module.GameMenu_OnHide)
end

module:AddCallback("GameMenu")
