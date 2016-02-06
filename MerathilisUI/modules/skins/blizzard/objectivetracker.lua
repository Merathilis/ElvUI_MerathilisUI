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

	if not progressBar.styled then
		local label = bar.Label

		bar.BarFrame:Hide()
		bar.BarGlow:Kill()
		bar:SetSize(203, 18)
		bar:SetStatusBarTexture(E['media'].MuiFlat)
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

		label:ClearAllPoints()
		label:SetPoint("CENTER")
		label:FontTemplate()

		-- icon:SetMask(nil)
		-- icon:SetDrawLayer("OVERLAY")
		-- icon:SetTexture(nil)
		-- icon:SetPoint("RIGHT", 24, 0)
		-- icon:SetTexCoord(unpack(E.TexCoords))
		-- icon:SetSize(17, 17)

		-- local bg = icon:GetParent():CreateTexture(icon, "BACKGROUND")
		-- bg:SetPoint("TOPLEFT", icon, -3, 3)
		-- bg:SetPoint("BOTTOMRIGHT", icon, 3, -3)
		-- bg:SetTexture(E['media'].MuiFlat)
		-- bg:SetVertexColor(unpack(E["media"].backdropcolor))

		-- local bg = icon:GetParent():CreateTexture(icon, "BACKGROUND")
		-- bg:SetPoint("TOPLEFT", icon, -2, 2)
		-- bg:SetPoint("BOTTOMRIGHT", icon, 2, -2)
		-- bg:SetTexture(E['media'].MuiFlat)
		-- bg:SetVertexColor(unpack(E["media"].bordercolor))

		-- local bg = icon:GetParent():CreateTexture(icon, "BACKGROUND")
		-- bg:SetPoint("TOPLEFT", icon, -1, 1)
		-- bg:SetPoint("BOTTOMRIGHT", icon, 1, -1)
		-- bg:SetTexture(E['media'].MuiFlat)
		-- bg:SetVertexColor(unpack(E["media"].backdropcolor))

		progressBar.styled = true
	end

	bar.IconBG:Hide()
end)