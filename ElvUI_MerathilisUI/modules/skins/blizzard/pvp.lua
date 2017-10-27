local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule('Skins')

--Cache global variables
local _G = _G
local pairs, select = pairs, select
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, Inset

local function stylePvP()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.pvp ~= true or E.private.muiSkins.blizzard.pvp ~= true then return end

	local function onEnter(self)
		self:SetBackdropColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .4)
	end

	local function onLeave(self)
		self:SetBackdropColor(0, 0, 0, .25)
	end

	-- Category buttons
	for i = 1, 4 do
		local bu = _G["PVPQueueFrameCategoryButton"..i]
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu:SetScript("OnEnter", onEnter)
		bu:SetScript("OnLeave", onLeave)

		bu.backdropTexture:Hide()
	end

	local BonusFrame = _G["HonorFrame"].BonusFrame

	for _, bonusButton in pairs({"RandomBGButton", "Arena1Button", "AshranButton", "BrawlButton"}) do
		local bu = BonusFrame[bonusButton]
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .25)
		bu.SelectedTexture:SetAllPoints()

		bu.backdropTexture:Hide()
	end

	-- Honor frame specific
	for _, bu in pairs(_G["HonorFrame"].SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		MERS:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = MERS:CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", bg, 1, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", bg, -1, 1)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		bu.SelectedTexture:SetAllPoints(bu.tex)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = MERS:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	-- Conquest Frame
	Inset = _G["ConquestFrame"].Inset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	_G["ConquestFrame"].ArenaTexture:Hide()
	_G["ConquestFrame"].RatedBGTexture:Hide()
	_G["ConquestFrame"].ArenaHeader:Hide()
	_G["ConquestFrame"].RatedBGHeader:Hide()
	_G["ConquestFrame"].ShadowOverlay:Hide()

	for _, bu in pairs({_G["ConquestFrame"].Arena2v2, _G["ConquestFrame"].Arena3v3, _G["ConquestFrame"].RatedBG}) do
		bu:StripTextures()

		MERS:CreateBD(bu, .25)
		MERS:Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .25)
		bu.SelectedTexture:SetAllPoints()

		bu.backdropTexture:Hide()
	end

	-- War games
	Inset = _G["WarGamesFrame"].RightInset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	_G["WarGamesFrame"].InfoBG:Hide()
	_G["WarGamesFrame"].HorizontalBar:Hide()
	_G["WarGamesFrameInfoScrollFrame"].scrollBarBackground:Hide()
	_G["WarGamesFrameInfoScrollFrame"].scrollBarArtTop:Hide()
	_G["WarGamesFrameInfoScrollFrame"].scrollBarArtBottom:Hide()

	_G["WarGamesFrameDescription"]:SetTextColor(.9, .9, .9)

	local function onSetNormalTexture(self, texture)
		if texture:find("Plus") then
			self.plus:Show()
		else
			self.plus:Hide()
		end
	end

	for _, button in pairs(_G["WarGamesFrame"].scrollFrame.buttons) do
		local bu = button.Entry
		local SelectedTexture = bu.SelectedTexture

		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		MERS:CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		local tex = MERS:CreateGradient(bu)
		tex:SetDrawLayer("BACKGROUND")
		tex:SetPoint("TOPLEFT", 3, -1)
		tex:SetPoint("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = MERS:CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:SetSize(13, 13)
		headerBg:SetPoint("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		MERS:CreateBD(headerBg, 0)
		headerBg:Styling()

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:SetSize(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(E["media"].blankTex)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:SetSize(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(E["media"].blankTex)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end
end

S:AddCallbackForAddon("Blizzard_PVPUI", "mUIPvPUI", stylePvP)