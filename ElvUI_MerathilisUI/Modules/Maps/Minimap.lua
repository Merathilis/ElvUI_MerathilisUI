local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Minimap")
local S = MER:GetModule("MER_Skins")
local MM = E:GetModule("Minimap")
local LCG = E.Libs.CustomGlow

local _G = _G
local unpack = unpack

local GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local MiniMapMailFrame = _G.MiniMapMailFrame

local r, g, b = unpack(E.media.rgbvaluecolor)

function module:CheckStatus()
	if not E.db.mui.maps.minimap.flash then
		return
	end

	local inv = GetNumPendingInvites()
	local indicator = MinimapCluster.IndicatorFrame
	local mailFrame = (indicator and indicator.MailFrame) or MiniMapMailFrame
	local craftingFrame = (indicator and indicator.CraftingOrderFrame)
	local mail = mailFrame:IsShown() and true or false
	local crafting = craftingFrame:IsShown() and true or false

	if inv > 0 and mail and crafting then -- New invites and mail and crafting orders
		LCG.PixelGlow_Start(Minimap.backdrop, { 1, 0, 0, 1 }, 8, -0.25, nil, 1)
	elseif inv > 0 and not mail and not crafting then -- New invites and no mail and no crafting orders
		LCG.PixelGlow_Start(Minimap.backdrop, { 1, 1, 0, 1 }, 8, -0.25, nil, 1)
	elseif inv == 0 and mail and not crafting then -- No invites and new mail and no crafting orders
		LCG.PixelGlow_Start(Minimap.backdrop, { r, g, b, 1 }, 8, -0.25, nil, 1)
	elseif inv == 0 and not mail and crafting then -- No invites and no mail and new crafting orders
		LCG.PixelGlow_Start(Minimap.backdrop, { 0, 0.75, 0.98, 1 }, 8, -0.25, nil, 1)
	else -- None of the above
		LCG.PixelGlow_Stop(Minimap.backdrop)
	end
end

function module:StyleMinimap()
	S:CreateBackdropShadow(Minimap)
end

function module:Initialize()
	if not E.private.general.minimap.enable then
		return
	end

	self:StyleMinimap()

	self:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES", "CheckStatus")
	self:RegisterEvent("UPDATE_PENDING_MAIL", "CheckStatus")
	self:RegisterEvent("CRAFTINGORDERS_UPDATE_PERSONAL_ORDER_COUNTS", "CheckStatus")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnHide", "CheckStatus")
	self:HookScript(_G["MiniMapMailFrame"], "OnShow", "CheckStatus")

	self:MinimapPing()
end

MER:RegisterModule(module:GetName())
