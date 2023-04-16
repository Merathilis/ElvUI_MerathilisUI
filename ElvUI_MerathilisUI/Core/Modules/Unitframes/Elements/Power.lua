local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')
local LSM = E.LSM


function module:Configure_Power(frame)
	local db = frame.db
	local power = frame.Power
	power.origParent = frame

	if power and not power.__MERSkin then
		power:Styling()

		power.__MERSkin = true
	end
end

function module:UnitFrames_Configure_Power(_, f)
	if f.MERshadow then return end

	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.MERshadow
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

	for _, frame in pairs(UF.units) do
		if frame.Power then
			frame.Power:SetStatusBarTexture(bar)
		end
	end
end

function module:ChangePowerBarTexture()
	module:ChangeUnitPowerBarTexture()
end
