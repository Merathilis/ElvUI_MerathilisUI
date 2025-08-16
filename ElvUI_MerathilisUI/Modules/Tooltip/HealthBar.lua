local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local ET = E:GetModule("Tooltip")

function module:ChangeHealthBarPosition(_, tt)
	local barYOffset = E.db.mui.tooltip.healthBar.barYOffset
	local textYOffset = E.db.mui.tooltip.healthBar.yOffsetOfHealthText

	if barYOffset == 0 and textYOffset == 0 then
		return
	end

	if E.private.tooltip.enable ~= true then
		return
	end

	if tt:IsForbidden() or not ET.db.visibility then
		return
	end

	if tt:GetAnchorType() ~= "ANCHOR_NONE" then
		return
	end

	if tt.StatusBar then
		if ET.db.healthBar.statusPosition == "BOTTOM" then
			if not tt.StatusBar.anchoredToTop then
				tt.StatusBar:ClearAllPoints()
				tt.StatusBar:Point("TOPLEFT", tt, "BOTTOMLEFT", E.Border, -(E.Spacing * 3) + barYOffset)
				tt.StatusBar:Point("TOPRIGHT", tt, "BOTTOMRIGHT", -E.Border, -(E.Spacing * 3) + barYOffset)
				if tt.StatusBar.text then
					tt.StatusBar.text:Point("CENTER", tt.StatusBar, 0, textYOffset)
				end
			end
		else
			if tt.StatusBar.anchoredToTop then
				tt.StatusBar:ClearAllPoints()
				tt.StatusBar:Point("BOTTOMLEFT", tt, "TOPLEFT", E.Border, (E.Spacing * 3) + barYOffset)
				tt.StatusBar:Point("BOTTOMRIGHT", tt, "TOPRIGHT", -E.Border, (E.Spacing * 3) + barYOffset)
				if tt.StatusBar.text then
					tt.StatusBar.text:Point("CENTER", tt.StatusBar, 0, textYOffset)
				end
			end
		end
	end
end

function module:HealthBar()
	module:SecureHook(ET, "GameTooltip_SetDefaultAnchor", "ChangeHealthBarPosition")
end

module:AddCallback("HealthBar")
