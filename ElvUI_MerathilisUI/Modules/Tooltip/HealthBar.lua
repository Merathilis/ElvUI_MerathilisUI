local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")
local ET = E:GetModule("Tooltip")

function module:ChangeHealthBarPosition(_, tt)
	local barOffset = E.db.mui.tooltip.yOffsetOfHealthBar
	local textOffset = E.db.mui.tooltip.yOffsetOfHealthText

	if barOffset == 0 and textOffset == 0 then
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
				tt.StatusBar:SetPoint("TOPLEFT", tt, "BOTTOMLEFT", E.Border, -(E.Spacing * 3) + barOffset)
				tt.StatusBar:SetPoint("TOPRIGHT", tt, "BOTTOMRIGHT", -E.Border, -(E.Spacing * 3) + barOffset)
				if tt.StatusBar.text then
					tt.StatusBar.text:SetPoint("CENTER", tt.StatusBar, 0, textOffset)
				end
			end
		else
			if tt.StatusBar.anchoredToTop then
				tt.StatusBar:ClearAllPoints()
				tt.StatusBar:SetPoint("BOTTOMLEFT", tt, "TOPLEFT", E.Border, (E.Spacing * 3) + barOffset)
				tt.StatusBar:SetPoint("BOTTOMRIGHT", tt, "TOPRIGHT", -E.Border, (E.Spacing * 3) + barOffset)
				if tt.StatusBar.text then
					tt.StatusBar.text:SetPoint("CENTER", tt.StatusBar, 0, textOffset)
				end
			end
		end
	end
end

function module:HealthBar()
	module:SecureHook(ET, "GameTooltip_SetDefaultAnchor", "ChangeHealthBarPosition")
end

module:AddCallback("HealthBar")
