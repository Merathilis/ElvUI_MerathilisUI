local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Minimap')
local S = MER:GetModule('MER_Skins')
local MM = E:GetModule('Minimap')
local LCG = E.Libs.CustomGlow

local _G = _G
local unpack = unpack

local C_Calendar_GetNumPendingInvites = C_Calendar and C_Calendar.GetNumPendingInvites
local C_Garrison_HasGarrison = C_Garrison and C_Garrison.HasGarrison
local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local MiniMapMailFrame = _G.MiniMapMailFrame

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:CheckStatus()
	if not E.db.mui.maps.minimap.flash then return end

	local inv = C_Calendar_GetNumPendingInvites()
	local indicator = MinimapCluster.IndicatorFrame
	local mailFrame = (indicator and indicator.MailFrame) or MiniMapMailFrame
	local craftingFrame = (indicator and indicator.CraftingOrderFrame)
	local mail = mailFrame:IsShown() and true or false
	local crafting = E.Retail and craftingFrame:IsShown() and true or false

	if inv > 0 and mail and crafting then -- New invites and mail and crafting orders
		LCG.PixelGlow_Start(MM.MapHolder, { 1, 0, 0, 1 }, 8, -0.25, nil, 1)
	elseif inv > 0 and not mail and not crafting then -- New invites and no mail and no crafting orders
		LCG.PixelGlow_Start(MM.MapHolder, { 1, 1, 0, 1 }, 8, -0.25, nil, 1)
	elseif inv == 0 and mail and not crafting then -- No invites and new mail and no crafting orders
		LCG.PixelGlow_Start(MM.MapHolder, { r, g, b, 1 }, 8, -0.25, nil, 1)
	elseif inv == 0 and not mail and crafting then -- No invites and no mail and new crafting orders
		LCG.PixelGlow_Start(MM.MapHolder, { 0, 0.75, 0.98, 1 }, 8, -0.25, nil, 1)
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
	end

	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckStatus")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckStatus")
	if E.Retail then
		self:RegisterEvent("CRAFTINGORDERS_UPDATE_PERSONAL_ORDER_COUNTS", "CheckStatus")
	end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckStatus")

	self:MinimapPing()
end

MER:RegisterModule(module:GetName())
