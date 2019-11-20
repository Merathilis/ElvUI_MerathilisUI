local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E.UnitFrames
local LSM = E.LSM
UF.LSM = LSM

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
--WoW API / Variables
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:Configure_Infopanel(frame)
	--
end

-- Units
function module:UnitInfoPanelColor()
	if E.db.mui.unitframes.infoPanel.style ~= true then return end

	local bar = LSM:Fetch("statusbar", "MerathilisOnePixel")
	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.InfoPanel then
			if not unitframe.InfoPanel.color then
				unitframe.InfoPanel.color = unitframe.InfoPanel:CreateTexture(nil, "OVERLAY")
				unitframe.InfoPanel.color:SetAllPoints()
			end
			unitframe.InfoPanel.color:SetTexture(bar)
			unitframe.InfoPanel.color:SetVertexColor(r, g, b)
		end
	end
end

function module:InfoPanelColor()
	module:UnitInfoPanelColor()
end
