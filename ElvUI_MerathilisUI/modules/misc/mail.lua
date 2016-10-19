local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local pairs = pairs
-- WoW API / Variables
local GetLatestThreeSenders = GetLatestThreeSenders
local HasNewMail = HasNewMail
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, HAVE_MAIL, HAVE_MAIL_FROM

local mail = MiniMapMailFrame

local indicator = CreateFrame('Button', 'MinimapIcon', MMHolder)
indicator:SetSize(45, 45)
indicator:RegisterForClicks('AnyUp')
indicator:SetPoint('BOTTOMLEFT', 3, 12)

indicator.t = indicator:CreateTexture(nil, 'ARTWORK')
indicator.t:SetAllPoints()
indicator.t:SetTexCoord(.52, .63, .0255, .129)

indicator.mail = indicator:CreateTexture(nil, 'OVERLAY')
indicator.mail:SetSize(16, 16)
indicator.mail:SetPoint('BOTTOMLEFT', indicator.t, -2, -2)
indicator.mail:SetTexture[[Interface\AddOns\ElvUI_MerathilisUI\media\textures\mail]]
indicator.mail:Hide()

local function AddAnim(frame, offset)
	local anim = frame:CreateAnimationGroup()
	anim:SetLooping('REPEAT')

	anim.translateUp = anim:CreateAnimation('Translation')
	anim.translateUp:SetOrder(1)
	anim.translateUp:SetOffset(0, offset)
	anim.translateUp:SetDuration(3)
	anim.translateUp:SetEndDelay(.1)
	anim.translateUp:SetSmoothing('IN_OUT')

	anim.translateDn = anim:CreateAnimation('Translation')
	anim.translateDn:SetOrder(2)
	anim.translateDn:SetOffset(0, -offset)
	anim.translateDn:SetDuration(3)
	anim.translateDn:SetEndDelay(.1)
	anim.translateDn:SetSmoothing('IN_OUT')

	anim:Play()
end

local function OrganiseMinimap()
	local i = 1
	if not indicator:GetAnimationGroups() then AddAnim(indicator, 9) end
	for _, v in pairs({mail}) do
		v:Hide()
	end
end

local function AddMail()
	if HasNewMail() then
		indicator.mail:Show()
	else
		indicator.mail:Hide()
	end
end

local function AddIndicatorTooltip(self)
	local sender1, sender2, sender3 = GetLatestThreeSenders()
	local t

	GameTooltip:SetOwner(self, 'ANCHOR_LEFT')

	if sender1 or sender2 or sender3 then
		t = HAVE_MAIL_FROM
	else
		t = HasNewMail() and HAVE_MAIL or nil
	end

	if sender1 then
		t = t..'\n'..sender1
	end
	if sender2 then
		t = t..'\n'..sender2
	end
	if sender3 then
		t = t..'\n'..sender3
	end

	if t then
		GameTooltip:AddLine(t)
	end

	GameTooltip:Show()
end

for _, v in pairs({mail}) do
	if v:HasScript('OnShow') then
		v:HookScript('OnShow', OrganiseMinimap)
		v:HookScript('OnHide', OrganiseMinimap)
	else
		v:SetScript('OnShow', OrganiseMinimap)
		v:SetScript('OnHide', OrganiseMinimap)
	end
end

indicator:SetScript('OnEnter', AddIndicatorTooltip)
indicator:SetScript('OnLeave', 	function()
	GameTooltip:Hide()
end)

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('UPDATE_PENDING_MAIL')
f:SetScript('OnEvent', function(_, event)
	if event == 'PLAYER_ENTERING_WORLD' then
		OrganiseMinimap()
	else
		AddMail()
	end
end)