local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
-- GLOBALS:

local function LoadAddOnSkin()
	if E.private.muiSkins.addonSkins.et ~= true then return end

	-- Main Frame
	local frame = _G.EventTrackerFrame
	frame:StripTextures()
	frame:CreateBackdrop('Transparent')
	frame.backdrop:Styling()
	_G.EventTrackerFrameBorder:CreateBackdrop('Transparent')
	S:HandleScrollBar(_G.EventTracker_DetailsScrollBar)
	S:HandleButton(_G.ExpandCollapseButton)
	S:HandleButton(_G.EventTrackerFrameOnOffButton)
	S:HandleButton(_G.EventTrackerFramePurgeButton)
	S:HandleButton(_G.EventTrackerFrameCloseButton)

	-- Details Frame
	_G.EventDetailFrame:ClearAllPoints()
	_G.EventDetailFrame:SetPoint("LEFT", frame, "RIGHT", 3, 0)
	_G.EventDetailFrame:StripTextures()
	_G.EventDetailFrame:CreateBackdrop('Transparent')
	_G.EventDetailFrame.backdrop:Styling()

	_G.Event_Argument_Frame:StripTextures()
	_G.Event_Argument_FrameTexture:CreateBackdrop('Transparent')
	S:HandleScrollBar(_G.EventTracker_ArgumentsScrollBar)

	_G.Event_Frame_Frame:StripTextures()
	_G.Event_Frame_FrameTexture:CreateBackdrop('Transparent')
	S:HandleScrollBar(_G.EventTracker_FramesScrollBar)
end

S:AddCallbackForAddon('EventTracker', 'ADDON_LOADED', LoadAddOnSkin)
