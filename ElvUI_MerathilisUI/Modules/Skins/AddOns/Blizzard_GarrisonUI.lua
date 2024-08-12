local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local function SkinMissionFrame(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	module:CreateShadow(frame)
	S:HandleCloseButton(frame.CloseButton)
	frame.GarrCorners:Hide()

	if frame.OverlayElements then
		frame.OverlayElements:SetAlpha(0)
	end
	if frame.ClassHallIcon then
		frame.ClassHallIcon:Hide()
	end

	if frame.MapTab then
		frame.MapTab.ScrollContainer.Child.TiledBackground:Hide()
	end
end

function module:Blizzard_GarrisonUI()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local frames = {
		_G.GarrisonCapacitiveDisplayFrame,
		_G.GarrisonMissionFrame,
		_G.GarrisonLandingPage,
		_G.GarrisonBuildingFrame,
		_G.GarrisonShipyardFrame,
		_G.OrderHallMissionFrame,
		_G.OrderHallCommandBar,
		_G.BFAMissionFrame,
		_G.CovenantMissionFrame,
	}

	local tabs = {
		_G.GarrisonMissionFrameTab1,
		_G.GarrisonMissionFrameTab2,
		_G.GarrisonLandingPageTab1,
		_G.GarrisonLandingPageTab2,
		_G.GarrisonLandingPageTab3,
		_G.GarrisonShipyardFrameTab1,
		_G.GarrisonShipyardFrameTab2,
		_G.OrderHallMissionFrameTab1,
		_G.OrderHallMissionFrameTab2,
		_G.OrderHallMissionFrameTab3,
		_G.BFAMissionFrameTab1,
		_G.BFAMissionFrameTab2,
		_G.BFAMissionFrameTab3,
		_G.CovenantMissionFrameTab1,
		_G.CovenantMissionFrameTab2,
	}

	for _, frame in pairs(frames) do
		if frame then
			frame:StripTextures(true)
			module:CreateShadow(frame)
		end
	end

	for _, tab in pairs(tabs) do
		module:ReskinTab(tab)
	end

	local CovenantMissionFrame = _G.CovenantMissionFrame
	CovenantMissionFrame.RaisedBorder:SetAlpha(0)
	SkinMissionFrame(CovenantMissionFrame)
end

module:AddCallbackForAddon("Blizzard_GarrisonUI")
