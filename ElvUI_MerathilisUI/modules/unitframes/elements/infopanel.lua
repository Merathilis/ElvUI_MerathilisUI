local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")
UF.LSM = LSM

function MUF:Configure_Infopanel(frame)
	--
end

-- Units
function MUF:UnitInfoPanelColor()
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
			unitframe.InfoPanel.color:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		end
	end
end

function MUF:InfoPanelColor()
	MUF:UnitInfoPanelColor()
end