local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_NamePlates')
local NP = E:GetModule('NamePlates')

local paladin, warrior, shaman, druid, deathknight, demonhunter, monk, rogue, mage, hunter, warlock
local npchostile, npcneutral, npcfriendly

paladin = {r = "0.95686066150665", g = "0.54901838302612", b = "0.72941017150879"}
warrior = {r = "0.77646887302399", g = "0.60784178972244", b = "0.4274500310421"}
shaman = {r = "0", g = "0.4392147064209", b = "0.86666476726532"}
druid = {r = "0.99999779462814", g = "0.48627343773842", b = "0.039215601980686"}
deathknight = {r = "0.76862573623657", g = "0.11764679849148", b = "0.2274504750967"}
demonhunter = {r = "0.63921427726746", g = "0.1882348805666", b = "0.78823357820511"}
monk = {r = "0", g = "0.99999779462814", b = "0.59607714414597"}
rogue = {r = "0.99999779462814", g = "0.95686066150665", b = "0.40784224867821"}
mage = {r = "0.24705828726292", g = "0.78039044141769", b = "0.92156660556793"}
hunter = {r = "0.66666519641876", g = "0.82744914293289", b = "0.44705784320831"}
warlock = {r = "0.52941060066223", g = "0.53333216905594", b = "0.93333131074905"}
npcfriendly = {r = "0.1999995559454", g = "0.7098023891449", b = "0"}
npcneutral = {r = "0.99999779462814", g = "0.85097849369049", b = "0.1999995559454"}
npchostile = {r = "0.78039044141769", g = "0.25097984075546", b = "0.25097984075546"}

function module:Health_UpdateColor(_, unit)
	if not E.db.mui.nameplates.gradient then return end

	if not unit or self.unit ~= unit then return end
	local element = self.Health

	if element then
		local r, g, b = element:GetStatusBarColor()
		r = tostring(r)
		g = tostring(g)
		b = tostring(b)

		if ((r == paladin.r) and (g == paladin.g) and (b == paladin.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("PALADIN"))
		elseif ((r == warrior.r) and (g == warrior.g) and (b == warrior.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("WARRIOR"))
		elseif ((r == druid.r) and (g == druid.g) and (b == druid.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("DRUID"))
		elseif ((r == deathknight.r) and (g == deathknight.g) and (b == deathknight.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("DEATHKNIGHT"))
		elseif ((r == demonhunter.r) and (g == demonhunter.g) and (b == demonhunter.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("DEMONHUNTER"))
		elseif ((r == monk.r) and (g == monk.g) and (b == monk.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("MONK"))
		elseif ((r == rogue.r) and (g == rogue.g) and (b == rogue.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("ROGUE"))
		elseif ((r == mage.r) and (g == mage.g) and (b == mage.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("MAGE"))
		elseif ((r == hunter.r) and (g == hunter.g) and (b == hunter.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("HUNTER"))
		elseif ((r == shaman.r) and (g == shaman.g) and (b == shaman.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("SHAMAN"))
		elseif ((r == warlock.r) and (g == warlock.g) and (b == warlock.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("WARLOCK"))
		elseif ((r == npchostile.r) and (g == npchostile.g) and (b == npchostile.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCHOSTILE"))
		elseif ((r == npcneutral.r) and (g == npcneutral.g) and (b == npcneutral.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCNEUTRAL"))
		elseif ((r == npcfriendly.r) and (g == npcfriendly.g) and (b == npcfriendly.b)) then
			element:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCFRIENDLY"))
		end
	end
end

hooksecurefunc(NP, 'Health_UpdateColor', module.Health_UpdateColor)
