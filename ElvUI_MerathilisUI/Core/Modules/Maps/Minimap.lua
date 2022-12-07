local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Minimap')
local S = MER:GetModule('MER_Skins')
local MM = E:GetModule('Minimap')
local LCG = E.Libs.CustomGlow

local _G = _G
local select, unpack = select, unpack
local format = string.format

local C_Calendar_GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local C_Garrison_HasGarrison = C_Garrison and C_Garrison.HasGarrison
local GetInstanceInfo = GetInstanceInfo
local Minimap = _G.Minimap
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:CheckStatus()
	if not E.db.mui.maps.minimap.flash then return end

	local inv = C_Calendar_GetNumPendingInvites()
	local mailFrame = _G.MinimapCluster.MailFrame or _G.MiniMapMailFrame
	local mail = mailFrame:IsShown() and true or false


	if inv > 0 and mail then -- New invites and mail
		LCG.PixelGlow_Start(MM.MapHolder, {1, 0, 0, 1}, 8, -0.25, nil, 1)
	elseif inv > 0 and not mail then -- New invites and no mail
		LCG.PixelGlow_Start(MM.MapHolder, { 1, 1, 0, 1 }, 8, -0.25, nil, 1)
	elseif inv == 0 and mail then -- No invites and new mail
		LCG.PixelGlow_Start(MM.MapHolder, { r, g, b, 1 }, 8, -0.25, nil, 1)
	else -- None of the above
		LCG.PixelGlow_Stop(MM.MapHolder)
	end
end

function module:StyleMinimap()
	S:CreateBackdropShadow(Minimap)
end

function module:StyleMinimapRightClickMenu()
	-- Style the ElvUI's MiddleClick-Menu on the Minimap
	local Menu = _G.MinimapRightClickMenu
	if Menu then
		Menu:Styling()
	end
end

local function UpdateDifficultyFlag()
	F.HideObject(_G.MinimapCluster.InstanceDifficulty)

	local frame = _G.Minimap.DiffFlag
	local text = _G.Minimap.DiffText

	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

	local norm = format('|cff74a1ff%s|r', 'N')
	local hero = format('|cffff66ff%s|r', 'H')
	local myth = format('|cffff9900%s|r', 'M')
	local lfr = format('|cffcccccc%s|r', 'LFR')

	local mp = format('|cffff9900%s|r', 'M+')
	local pvp = format('|cffff0000%s|r', 'PvP')
	local wf = format('|cff00ff00%s|r', 'WF')
	local tw = format('|cff00ff00%s|r', 'TW')
	local scen = format('|cffffff00%s|r', 'SCEN')

	if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
		if difficulty == 1 then -- Normal
			text:SetText('5' .. norm)
		elseif difficulty == 2 then -- Heroic
			text:SetText('5' .. hero)
		elseif difficulty == 3 then -- 10 Player
			text:SetText('10' .. norm)
		elseif difficulty == 4 then -- 25 Player
			text:SetText('25' .. norm)
		elseif difficulty == 5 then -- 10 Player (Heroic)
			text:SetText('10' .. hero)
		elseif difficulty == 6 then -- 25 Player (Heroic)
			text:SetText('25' .. hero)
		elseif difficulty == 7 then -- LFR (Legacy)
			text:SetText(lfr)
		elseif difficulty == 8 then -- Mythic Keystone
			text:SetText(mplusdiff .. mp)
		elseif difficulty == 9 then -- 40 Player
			text:SetText('40')
		elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
			text:SetText(scen)
		elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
			text:SetText(scen)
		elseif difficulty == 40 then -- Mythic Scenario
			text:SetText(scen)
		elseif difficulty == 14 then -- Normal Raid
			text:SetText(numplayers .. norm)
		elseif difficulty == 15 then -- Heroic Raid
			text:SetText(numplayers .. hero)
		elseif difficulty == 16 then -- Mythic Raid
			text:SetText(numplayers .. myth)
		elseif difficulty == 17 then -- LFR
			text:SetText(numplayers .. lfr)
		elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
			text:SetText(scen)
		elseif difficulty == 23 then -- Mythic Party
			text:SetText('5' .. myth)
		elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
			text:SetText(tw)
		elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
			text:SetText(pvp)
		elseif difficulty == 29 then -- PvEvP Scenario
			text:SetText('PvEvP')
		elseif difficulty == 147 then -- Normal Scenario (Warfronts)
			text:SetText(wf)
		elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
			text:SetText(wf)
		end
	elseif instanceType == 'pvp' or instanceType == 'arena' then
		text:SetText(pvp)
	else
		text:SetText('')
	end

	if not inInstance then
		frame:SetAlpha(0)
	else
		frame:SetAlpha(1)
	end
end

function module:CreateDifficultyFlag()
	if not E.db.mui.maps.minimap.difficulty then
		return
	end

	local Minimap = _G.Minimap

	local diff = 256 - 190
	local halfDiff = ceil(diff / 2)

	local frame = CreateFrame('Frame', nil, Minimap)
	frame:SetSize(64, 32)
	frame:SetPoint('TOP', Minimap, 4, -halfDiff - 4)
	frame:SetFrameLevel(Minimap:GetFrameLevel() + 2)

	local texture = frame:CreateTexture(nil, 'BACKGROUND')
	texture:SetAllPoints()
	texture:SetTexture(MER.Media.Textures.MinimapDifficulty)
	texture:SetVertexColor(0, .75, .98, .45)

	local text = frame:CreateFontString(nil, 'OVERLAY')
	text:FontTemplate(nil, 11, 'OUTLINE')
	text:SetPoint('CENTER', frame)
	text:SetJustifyH('CENTER')

	Minimap.DiffFlag = frame
	Minimap.DiffText = text

	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:RegisterEvent('INSTANCE_GROUP_SIZE_CHANGED')
	frame:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
	frame:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
	frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	frame:RegisterEvent('GROUP_ROSTER_UPDATE')
	frame:RegisterEvent('CHALLENGE_MODE_START')
	frame:RegisterEvent('CHALLENGE_MODE_COMPLETED')
	frame:RegisterEvent('CHALLENGE_MODE_RESET')

	frame:SetScript('OnEvent', UpdateDifficultyFlag)
end

local function toggleExpansionLandingPageButton(_, ...)
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(MER.RedColor .. _G.ERR_NOT_IN_COMBAT)
		return
	end

	if not C_Garrison_HasGarrison(...) then
		_G.UIErrorsFrame:AddMessage(MER.RedColor .. _G.CONTRIBUTION_TOOLTIP_UNLOCKED_WHEN_ACTIVE)
		return
	end

	ShowGarrisonLandingPage(...)
end

module.ExpansionMenuList = {
	{ text = _G.GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_9_0, notCheckable = true },
	{ text = _G.WAR_CAMPAIGN, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_8_0, notCheckable = true },
	{ text = _G.ORDER_HALL_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_7_0, notCheckable = true },
	{ text = _G.GARRISON_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_6_0, notCheckable = true },
}

function module:CreateExpansionLandingButton()
	local button = _G.ExpansionLandingPageMinimapButton

	if not button then
		return
	end

	button:HookScript('OnMouseDown', function(self, btn)
		if btn == 'RightButton' then
			if _G.GarrisonLandingPage and _G.GarrisonLandingPage:IsShown() then
				HideUIPanel(_G.GarrisonLandingPage)
			end

			if _G.ExpansionLandingPage and _G.ExpansionLandingPage:IsShown() then
				HideUIPanel(_G.ExpansionLandingPage)
			end

			EasyMenu(module.ExpansionMenuList, F.EasyMenu, self, -80, 0, 'MENU', 1)
		end
	end)

	button:SetScript('OnEnter', function(self)
		_G.GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		_G.GameTooltip:SetText(self.title, 1, 1, 1)
		_G.GameTooltip:AddLine(self.description, nil, nil, nil, true)
		_G.GameTooltip:AddLine(L["Right click to switch expansion"], nil, nil, nil, true)
		_G.GameTooltip:Show()
	end)
end

function module:Initialize()
	if not E.private.general.minimap.enable then return end

	local db = E.db.mui.maps

	-- Add a check if the backdrop is there
	if not Minimap.backdrop then
		Minimap:CreateBackdrop("Default", true)
	end

	self:StyleMinimap()
	self:StyleMinimapRightClickMenu()

	if E.Retail then
		self:CreateExpansionLandingButton()
		self:CreateDifficultyFlag()
	end

	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckStatus")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckStatus")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckStatus")

	self:MinimapPing()
end

MER:RegisterModule(module:GetName())
