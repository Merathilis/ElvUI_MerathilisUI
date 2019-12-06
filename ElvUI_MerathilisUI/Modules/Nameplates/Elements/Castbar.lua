local MER, E, L, V, P, G = unpack(select(2, ...))
local MNP = MER:GetModule('mUINamePlates')
local NP = E:GetModule('NamePlates')

--Cache global variables
--Lua functions
local _G = _G
local strjoin = strjoin
--WoW API / Variables
local UnitCanAttack = UnitCanAttack
local UnitChannelInfo = UnitChannelInfo
local UnitClass = UnitClass
local UnitCastingInfo = UnitCastingInfo
local UnitName = UnitName
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

-- Castbar Shield
function MNP:Castbar_CheckInterrupt(unit)
	if (unit == 'vehicle') then
		unit = 'player'
	end

	if (self.notInterruptible and UnitCanAttack('player', unit)) then
		self:SetStatusBarColor(NP.db.colors.castNoInterruptColor.r, NP.db.colors.castNoInterruptColor.g, NP.db.colors.castNoInterruptColor.b)

		if self.Icon and NP.db.colors.castbarDesaturate then
			self.Icon:SetDesaturated(true)
		end

		if self.Shield then
			self.Shield:Show()
		end
	else
		self:SetStatusBarColor(NP.db.colors.castColor.r, NP.db.colors.castColor.g, NP.db.colors.castColor.b)

		if self.Icon then
			self.Icon:SetDesaturated(false)
		end
		if self.Shield then
			self.Shield:Hide()
		end
	end
end

function MNP:Construct_Castbar(nameplate)
	local Castbar = _G[nameplate:GetDebugName()..'Castbar']

	if E.db.mui.nameplates.castbarShield then
		Castbar.Shield = Castbar:CreateTexture(nil, 'OVERLAY')
		Castbar.Shield:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\Shield.tga")
		Castbar.Shield:Point("RIGHT", Castbar, "LEFT", 10, 0)
		Castbar.Shield:SetSize(12, 12)
		Castbar.Shield:Hide()
	end
	Castbar.CheckInterrupt = MNP.Castbar_CheckInterrupt
end
hooksecurefunc(NP, "Construct_Castbar", MNP.Construct_Castbar)
