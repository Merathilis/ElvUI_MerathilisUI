local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')

local hooksecurefunc = hooksecurefunc

function module:Configure_Power(frame)
	local power = frame.Power
	local db = E.db.mui.unitframes.power

	if power and not power.__MERSkin then
		power:Styling(false, false, true)

		power.__MERSkin = true
	end

	if not power.animation then
		power.animation = CreateFrame("PlayerModel", "MER_PowerBarEffect", power)

		if db and db.enable then
			if db.type == "DEFAULT" then
				if E.Retail then
					power.animation:SetModel(1630153) -- spells/cfx_priest_holyprecast_precastarm.m2
					power.animation:SetPosition(4, 0.32, 1.85, 0)
					power.animation:ClearTransform()
					power.animation:SetTransform(-0.035, 0, 0, rad(270), 0, 0, 0.580)
					power.animation:SetAlpha(0.65)
				else
					power.animation:SetModel("spells/arcanepower_state_chest.m2")
					power.animation:SetPosition(1.1, 0, 0)
				end
			elseif db.type == "CUSTOM" then
				if E.Retail then
					power.animation:SetModel(db.retailModel)
				else
					power.animation:SetModel(db.classicModel)
				end
			end

			power.animation:SetAllPoints(power:GetStatusBarTexture())
			power.animation:SetFrameLevel(power:GetFrameLevel()+1)
			power.animation:SetInside(power:GetStatusBarTexture(), 0, 0)
			power.animation:Show()
		else
			power.animation:Hide()
		end

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

function module:InitPower()
	hooksecurefunc(UF, "Configure_Power", module.Configure_Power)
end
