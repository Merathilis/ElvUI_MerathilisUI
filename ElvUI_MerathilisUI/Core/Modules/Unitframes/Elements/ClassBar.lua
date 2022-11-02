local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')
local S = MER:GetModule('MER_Skins')

function module:UnitFrames_Configure_ClassBar(_, f)
	if f.shadow then return end

	local bars = f[f.ClassBar]
	if bars and not bars.backdrop.shadow then
		bars.backdrop:Styling()
		S:CreateShadow(bars.backdrop)
	end

	if f.shadow then
		f.shadow:ClearAllPoints()
		if f.USE_MINI_CLASSBAR and not f.CLASSBAR_DETACHED then
			f.shadow:Point('TOPLEFT', f.Health.backdrop, 'TOPLEFT')
			f.shadow:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT')
			bars.backdrop.shadow:Show()
		elseif not f.CLASSBAR_DETACHED then
			bars.backdrop.shadow:Hide()
		else
			bars.backdrop.shadow:Show()
		end
	end

	if f.ClassBar == 'ClassPower' or f.ClassBar == 'Runes' then
		local maxBars = max(UF['classMaxResourceBar'][E.myclass] or 0, _G.MAX_COMBO_POINTS)
		for i = 1, maxBars do
			if not bars[i].backdrop.shadow then
				bars[i].backdrop:Styling()
				S:CreateShadow(bars[i].backdrop)
			end
		end
	end
end
