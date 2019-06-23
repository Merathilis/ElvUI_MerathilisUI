local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("MUIFlightMode")
local COMP = MER:GetModule("mUICompatibility");
module.modName = L["FlightMode"]

--Cache global variables

--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function module:Initialize()
	if not COMP.BUI then return end
	local BFM = E:GetModule("BUIFlightMode")
	if E.db.mui.general.FlightMode then

		-- Hide BenikUI Logo
		BFM.FlightMode.bottom.logo:Hide()

		-- Hide BenikUI Version
		BFM.FlightMode.bottom.benikui:Hide()

		-- Location Frame
		BFM.FlightMode.top.location:SetTemplate("Transparent")
		BFM.FlightMode.top.location:Point("TOP", BFM.FlightMode.top, "CENTER", 0, -25)
		BFM.FlightMode.top.location:Height(30)

		-- Coords X frame
		BFM.FlightMode.top.location.x:SetTemplate("Transparent")
		BFM.FlightMode.top.location.x:Height(30)

		-- Coords Y frame
		BFM.FlightMode.top.location.y:SetTemplate("Transparent")
		BFM.FlightMode.top.location.y:Height(30)

		-- Top Frame
		BFM.FlightMode.top:Styling()

		-- Bottom Frame
		BFM.FlightMode.bottom:Styling()

		-- Time flying
		BFM.FlightMode.bottom.timeFlying:SetTemplate("Transparent")
		BFM.FlightMode.bottom.timeFlying:Styling()

		-- FPS
		BFM.FlightMode.bottom.fps:SetTemplate("Transparent")
		BFM.FlightMode.bottom.fps:Styling()

		-- MerathilisUI Logo
		BFM.FlightMode.bottom.logo = BFM.FlightMode:CreateTexture(nil, "OVERLAY")
		BFM.FlightMode.bottom.logo:Size(180, 90)
		BFM.FlightMode.bottom.logo:Point("CENTER", BFM.FlightMode.bottom, "CENTER", 0, 45)
		BFM.FlightMode.bottom.logo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI.tga")

		-- MerathilisUI Version
		BFM.FlightMode.bottom.merathilisui = CreateFrame("Frame", nil, BFM.FlightMode.bottom)
		BFM.FlightMode.bottom.merathilisui:Point("CENTER", BFM.FlightMode.bottom, "CENTER", -10, 0)
		BFM.FlightMode.bottom.merathilisui:SetTemplate("Transparent")
		BFM.FlightMode.bottom.merathilisui:Styling()
		BFM.FlightMode.bottom.merathilisui:SetSize(70,30)
		BFM.FlightMode.bottom.merathilisui.txt = MER:CreateText(BFM.FlightMode.bottom.merathilisui, "OVERLAY", 14)
		BFM.FlightMode.bottom.merathilisui.txt:SetFormattedText("v%s", MER.Version)
		BFM.FlightMode.bottom.merathilisui.txt:SetPoint("CENTER", BFM.FlightMode.bottom.merathilisui, "CENTER")
		BFM.FlightMode.bottom.merathilisui.txt:SetTextColor(1, 1, 1)

		-- Pepe!
		BFM.FlightMode.top.npcHolder = CreateFrame("Frame", nil, BFM.FlightMode.top)
		BFM.FlightMode.top.npcHolder:SetSize(60, 60)
		BFM.FlightMode.top.npcHolder:SetPoint("CENTER", BFM.FlightMode.top, "CENTER", 0, -2)

		BFM.FlightMode.top.pepe = CreateFrame("PlayerModel", nil, BFM.FlightMode.top.npcHolder)
		BFM.FlightMode.top.pepe:SetPoint("CENTER", BFM.FlightMode.top.npcHolder, "CENTER")
		BFM.FlightMode.top.pepe:ClearModel()
		BFM.FlightMode.top.pepe:SetCreature(86470)
		BFM.FlightMode.top.pepe:SetSize(45, 45)
		BFM.FlightMode.top.pepe:SetFacing(6.5)
		BFM.FlightMode.top.pepe:SetCamDistanceScale(1)
		BFM.FlightMode.top.pepe.isIdle = nil
		BFM.FlightMode.top.pepe:Show()
	end
end

local function InitializeCallback()
	module:Initialize()
end

MER:RegisterModule(module:GetName(), InitializeCallback)
