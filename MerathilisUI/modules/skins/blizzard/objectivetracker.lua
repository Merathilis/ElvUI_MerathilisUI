local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
-- local unpack = unpack

hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true then return end
	
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local classColor = RAID_CLASS_COLORS[E.myclass]
	local dummy = function() return end

	if not progressBar.styled then
		local label = bar.Label

		bar.BarBG:Hide()
		bar.BarFrame:Hide()
		bar.BarGlow:Kill()
		bar:SetSize(220, 18)

		bar:SetStatusBarTexture(E['media'].MuiFlat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		bar:SetTemplate('Transparent')
		bar:SetFrameLevel(1)

		label:ClearAllPoints()
		label:SetPoint('CENTER')
		label:FontTemplate()

		BonusObjectiveTrackerProgressBar_PlayFlareAnim = dummy
		progressBar.styled = true
	end

	bar.IconBG:Hide()
end)