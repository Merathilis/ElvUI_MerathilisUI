local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_GameMenu')
local MERS = MER:GetModule('MER_Skins')

local _G = _G
local random = random

local GameMenuFrame = _G["GameMenuFrame"]
local CreateFrame = CreateFrame
local CreateAnimationGroup = CreateAnimationGroup
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local UIFrameFadeIn = UIFrameFadeIn

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

local logo = "Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\mUI1.tga"

MER.NPCS = {
	285, -- Murloc
	86470, -- Pepe
	16445, -- Terky
	15552, -- Doctor Weavil
	32398, -- King Ping
	82464, -- Elekk Plushie
	71163, -- Unborn Val"kir
	91226, -- Graves
	54128, -- Creepy Crate
	28883, -- Frosty
	61324, -- Baby Ape
	23754, -- Murloc Costume
	34694, -- Gurgli
	54438, -- Murkablo
	85009, -- Murkidan
	68267, -- Cinder Kitten
	51601, -- Moonkin Hatchling
	85283, -- Brightpaw
	103159, -- Baby Winston
	123650, -- Shadow
	126579, -- Ghost Shark
	85463, -- Gorefu
	119408, -- "Captain" Klutz
	127956, -- Amalgam of Destruction
	85682, -- Blingtron 4999b
	72285, -- Chi-Chi, Hatchling of Chi-Ji
	67332, -- Darkmoon Eye
	71693, -- Rascal-Bot
	66499, -- Bishibosh
	-- BfA
	139073, -- Poda
	139770, -- Taptaf
	140125, -- Miimii
	141941, -- Baa'l
	143160, -- Brutus
	143507, -- Voidwiggler
	143563, -- Cholerian
	143794, -- Scuttle
	143796, -- Barnaby
	-- Shadowlands
	172854, -- Dredger Butler
	175783, -- Digallo
	171716, -- Indigo
	173586, -- Leafadore
	173992, -- Torghast Lurker
	-- Dragonflight
	183638, -- Ichabod
	188861, -- Secretive Frogduck
	189152, -- Lubbins
	191627, -- Lord Basilton
}

--[[
	0 = idle
	1 = death
	3 = stop
	4 = fast walk
	5 = run
	8 = take a light hit
	9 = take a medium hit
	10 = take a heavy hit
	11-12 = turning
	13 = backing up
	14 = stunned
	26 = attack stance
	43 = swimming
	55 - roar (non-loop)
	56 - idle
	57 - special attack 1H
	58 - special attack 2H
	60 = chat
	61 = eat
	62 = mine ore
	63 = combine tradeskill
	64 - talk_exclamation
	65 - shrug
	66 = bow
	67 = wave
	68 = cheer
	69 = dance
	70 = laugh
	71 - sleep, lie
	72 - idle
	73 = rude
	74 = roar
	75 = kneel
	76 = kiss
	77 = cry
	78 = chicken
	79 - beg, grovel
	80 = applaud
	81 = shout
	82 = flex
	83 = flirt
	84 = point
	87 - shield bash
	89 - sheathe/unsheathe from back
	90 - sheath/unsheathe from waist
	91 - sitting on a mount
	92 - idle
	93 - idle
	94 - idle
	95 - kick (non-loop)
	96 - sit
	97 = sit
	98 - stop
	99 - sleep, lie
	100 - sleep, lie
	101 = get up
	103 - sitting on mount
	104 - sitting on chair
	105 - nocking bow with arrow
	107 - fishing cast
	109 - attack idle with bow
	110 - attack idle with gun or crossbow
	113 = salute
	114 - kneel
	115 - kneel
	116 - stand from kneeling
	117 - shield bash
	118 - special attack 1H
	119 = crouching run
	120 = crouch
	121 - knockdown
	122 - idle
	123 - crafting (loop)
	124 = channel spell
	125 = channel spell
	126 = spin
	127 - idle
	128 - crafting (non-loop)
	129 - stop
	130 - idle
	131 - drown
	132 - drowned
	133 - fishing
	134 - fishing loop
	135 - swimming loop
	136 - mining, blacksmith crafting
	137 = stunned
]]--

local Sequences = {26, 52, 69, 111, 225}

local function Player_Model(self)
	local key = random(1,5)
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
	local key = random(1,5)
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
	-- GameMenu Frame
	if not GameMenuFrame.MUIbottomPanel then
		GameMenuFrame.MUIbottomPanel = CreateFrame("Frame", nil, GameMenuFrame, 'BackdropTemplate')
		local bottomPanel = GameMenuFrame.MUIbottomPanel
		bottomPanel:SetFrameLevel(0)
		bottomPanel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
		bottomPanel:Width(GetScreenWidth() + (E.Border*2))
		bottomPanel:CreateBackdrop('Transparent')
		bottomPanel.backdrop:Styling()

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
		topPanel:Width(GetScreenWidth() + (E.Border*2))
		topPanel:CreateBackdrop('Transparent')
		topPanel.backdrop:Styling()

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
		topPanel.factionLogo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\ClassBanner\\CLASS-"..E.myclass)
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
		npcModel:Point("CENTER",  GameMenuFrame.npcHolder, "CENTER")
		npcModel:SetScript("OnShow", NPC_Model)
		npcModel.isIdle = nil
		npcModel:Size(256)
		npcModel:SetScale(0.8)
		npcModel:Show()
	end
end

function module:Initialize()
	if E.db.mui.general.GameMenu then
		self:GameMenu()
	end
end

MER:RegisterModule(module:GetName())
