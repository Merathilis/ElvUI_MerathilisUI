local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Misc')

local _G = _G
local random = random

local GameMenuFrame = _G["GameMenuFrame"]
local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local UIFrameFadeIn = UIFrameFadeIn

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

local logo = "Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\mUI1.tga"

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
}

local Sequences = { 26, 52, 69, 111, 225 }

local function Player_Model(self)
	local key = random(1, 5)
	local emote = Sequences[key]

	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(6.5)
	self:SetPortraitZoom(0.05)
	self:SetCamDistanceScale(4.8)
	self:SetAlpha(1)
	self:SetAnimation(emote)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

local function NPC_Model(self)
	local npc = MER.NPCS
	local mod = random(1, #npc)
	local id = npc[mod]
	local key = random(1, 5)
	local emote = Sequences[key]

	self:ClearModel()
	self:SetCreature(id)
	self:SetCamDistanceScale(1)
	self:SetFacing(6)
	self:SetAlpha(1)
	self:SetAnimation(emote)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

function module:GameMenu()
	if not E.db.mui.general.GameMenu then
		return
	end

	-- GameMenu Frame
	if not GameMenuFrame.MUIbottomPanel then
		GameMenuFrame.MUIbottomPanel = CreateFrame("Frame", nil, GameMenuFrame, 'BackdropTemplate')
		local bottomPanel = GameMenuFrame.MUIbottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:Width(GetScreenWidth() + (E.Border * 2))
		bottomPanel:CreateBackdrop('Transparent')
		MER:CreateInnerNoise(bottomPanel)

		bottomPanel.ignoreFrameTemplates = true
		bottomPanel.ignoreBackdropColors = true
		E["frames"][bottomPanel] = true

		bottomPanel.anim = CreateAnimationGroup(bottomPanel)
		bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
		bottomPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		bottomPanel.anim.height:SetDuration(0.6)

		bottomPanel:SetScript("OnShow", function(self)
			self:Height(0)
			self.anim.height:Play()
		end)

		bottomPanel.Logo = bottomPanel:CreateTexture(nil, "ARTWORK")
		bottomPanel.Logo:Size(150)
		bottomPanel.Logo:SetPoint("CENTER", bottomPanel, "CENTER", 0, 0)
		bottomPanel.Logo:SetTexture(logo)
	end

	if not GameMenuFrame.MUItopPanel then
		GameMenuFrame.MUItopPanel = CreateFrame("Frame", nil, GameMenuFrame, 'BackdropTemplate')
		local topPanel = GameMenuFrame.MUItopPanel
		topPanel:SetFrameLevel(0)
		topPanel:Point("TOP", E.UIParent, "TOP", 0, 0)
		topPanel:Width(GetScreenWidth() + (E.Border * 2))
		topPanel:CreateBackdrop('Transparent')
		MER:CreateInnerNoise(topPanel)

		topPanel.ignoreFrameTemplates = true
		topPanel.ignoreBackdropColors = true
		E["frames"][topPanel] = true

		topPanel.anim = CreateAnimationGroup(topPanel)
		topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
		topPanel.anim.height:SetChange(GetScreenHeight() * (1 / 4))
		topPanel.anim.height:SetDuration(0.6)

		topPanel:SetScript("OnShow", function(self)
			self:Height(0)
			self.anim.height:Play()
		end)

		topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
		topPanel.factionLogo:Point("CENTER", topPanel, "CENTER", 0, 0)
		topPanel.factionLogo:Size(186, 186)
		topPanel.factionLogo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\ClassBanner\\CLASS-" ..
			E.myclass)
	end

	-- Use this frame to control the position of the model - taken from ElvUI
	if not GameMenuFrame.modelHolder then
		GameMenuFrame.modelHolder = CreateFrame("Frame", nil, GameMenuFrame)
		GameMenuFrame.modelHolder:Size(150)
		GameMenuFrame.modelHolder:SetPoint("RIGHT", GameMenuFrame, "LEFT", -300, 0)

		local playerModel = CreateFrame("PlayerModel", nil, GameMenuFrame.modelHolder)
		playerModel:Point("CENTER", GameMenuFrame.modelHolder, "CENTER")
		playerModel:SetScript("OnShow", Player_Model)
		playerModel:Size(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
		playerModel:SetScale(0.8)
		playerModel.isIdle = nil
		playerModel:Show()
	end

	if not GameMenuFrame.npcHolder then
		GameMenuFrame.npcHolder = CreateFrame("Frame", nil, GameMenuFrame)
		GameMenuFrame.npcHolder:SetSize(150, 150)
		GameMenuFrame.npcHolder:SetPoint("LEFT", GameMenuFrame, "RIGHT", 300, 0)

		local npcModel = CreateFrame("PlayerModel", nil, GameMenuFrame.npcHolder)
		npcModel:Point("CENTER", GameMenuFrame.npcHolder, "CENTER")
		npcModel:SetScript("OnShow", NPC_Model)
		npcModel.isIdle = nil
		npcModel:Size(256)
		npcModel:SetScale(0.8)
		npcModel:Show()

	end
end

module:AddCallback("GameMenu")
