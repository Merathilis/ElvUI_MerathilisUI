local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')
local S = MER:GetModule('MER_Skins')

function module:UnitFrames_Configure_ClassBar(_, f)
	if f.MERshadow then return end

	local bars = f[f.ClassBar]
	if bars and not bars.backdrop.MERshadow then
		bars.backdrop:Styling()
		S:CreateShadow(bars.backdrop)
	end

	if f.MERshadow then
		f.MERshadow:ClearAllPoints()
		if f.USE_MINI_CLASSBAR and not f.CLASSBAR_DETACHED then
			f.MERshadow:Point('TOPLEFT', f.Health.backdrop, 'TOPLEFT')
			f.MERshadow:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT')
			bars.backdrop.MERshadow:Show()
		elseif not f.CLASSBAR_DETACHED then
			bars.backdrop.MERshadow:Hide()
		else
			bars.backdrop.MERshadow:Show()
		end
	end

	if f.ClassBar == 'ClassPower' or f.ClassBar == 'Runes' then
		local maxBars = max(UF['classMaxResourceBar'][E.myclass] or 0, _G.MAX_COMBO_POINTS)
		for i = 1, maxBars do
			if not bars[i].backdrop.MERshadow then
				bars[i].backdrop:Styling()
				S:CreateShadow(bars[i].backdrop)
			end
		end
	end
end
