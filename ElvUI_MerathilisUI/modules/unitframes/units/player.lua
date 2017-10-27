local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local CreateFrame = CreateFrame
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: hooksecurefunc

function MUF:Construct_PlayerFrame()
	local frame = _G["ElvUF_Player"]

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateShadow("Default")
		frame.Portrait.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangePlayer()
end

function MUF:ArrangePlayer()
	local frame = _G["ElvUF_Player"]
	local db = E.db["unitframe"]["units"].player

	do
		frame.PORTRAIT_DETACHED = E.db.mui.unitframes.player.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.mui.unitframes.player.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.mui.unitframes.player.portraitShadow

		frame.PORTRAIT_STYLING = E.db.mui.unitframes.player.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.mui.unitframes.player.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.mui.unitframes.player.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.mui.unitframes.player.portraitHeight
		frame.DETACHED_PORTRAIT_STRATA = E.db.mui.unitframes.player.portraitFrameStrata

		frame.PORTRAIT_AND_INFOPANEL = E.db.mui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
		frame.POWER_VERTICAL = db.power.vertical
	end

	-- InfoPanel
	MUF:Configure_Infopanel(frame)

	-- Portrait
	MUF:Configure_Portrait(frame, true)

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, "Update_PlayerFrame", MUF.ArrangePlayer)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "player" then
			MUF:Configure_Portrait(frame, true)
		end
	end)
end