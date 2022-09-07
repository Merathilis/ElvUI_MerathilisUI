local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')
local LSM = E.LSM

local hooksecurefunc = hooksecurefunc

function module:Configure_Power(frame)
	local power = frame.Power
	local db = E.db.mui.unitframes.power

	if power and not power.__MERSkin then
		power:Styling(false, false, true)

		power.__MERSkin = true
	end
end

function module:UnitFrames_Configure_Power(_, f)
	if f.shadow then return end

	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.shadow
		if f.POWERBAR_DETACHED then
			if not shadow then
				S:CreateBackdropShadow(f.Power, true)
			else
				shadow:Show()
			end
		else
			if shadow then
				shadow:Hide()
			end
		end
	end
end

function module:ChangeUnitPowerBarTexture()
    local bar = LSM:Fetch("statusbar", E.db.mui.unitframes.power.texture)

	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.Power then
			unitframe.Power:SetStatusBarTexture(bar)
		end
	end
end

function module:ChangePowerBarTexture()
	module:ChangeUnitPowerBarTexture()
end
hooksecurefunc(UF, 'Update_StatusBars', module.ChangePowerBarTexture)
