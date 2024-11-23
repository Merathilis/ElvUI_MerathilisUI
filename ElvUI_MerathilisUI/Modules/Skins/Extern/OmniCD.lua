local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local CreateFrame = CreateFrame

function module:OmniCD_ConfigGUI()
	local O = _G.OmniCD[1]

	hooksecurefunc(O.Libs.ACD, "Open", function(_, arg1)
		if arg1 == O.AddOn then
			local frame = O.Libs.ACD.OpenFrames.OmniCD.frame
			frame:SetTemplate("Transparent")
			module:CreateShadow(frame)
		end
	end)
end

function module:OmniCD_Party_Icon()
	local O = _G.OmniCD[1]

	if not O.Party or not O.Party.AcquireIcon then
		return
	end

	hooksecurefunc(O.Party, "AcquireIcon", function(_, barFrame, iconIndex, unitBar)
		local icon = barFrame.icons[iconIndex]
		if icon and not icon.__MERSkin then
			self:CreateShadow(icon)
			icon.__MERSkin = true
		end
	end)
end

local function updateBorderVisibility(self)
	local parent = self:GetParent()
	if not parent or not parent.__MERSkin then
		return
	end

	parent.__MERSkin:SetShown(self:IsShown())
end

function module:OmniCD_Party_ExtraBars()
	local O = _G.OmniCD[1]
	local colorDB = E.db.mui.gradient

	if not O.Party or not O.Party.AcquireStatusBar then
		return
	end

	hooksecurefunc(O.Party, "AcquireStatusBar", function(_, icon)
		if icon.statusBar then
			if not icon.statusBar.__MERSkin then
				icon.statusBar.__MERSkin = CreateFrame("Frame", nil, icon.statusBar)
				icon.statusBar.__MERSkin:SetFrameLevel(icon.statusBar:GetFrameLevel() - 1)

				-- bind the visibility to the original borders
				if icon.statusBar.borderTop then
					hooksecurefunc(icon.statusBar.borderTop, "SetShown", updateBorderVisibility)
					hooksecurefunc(icon.statusBar.borderTop, "Hide", updateBorderVisibility)
					hooksecurefunc(icon.statusBar.borderTop, "Show", updateBorderVisibility)
				end
			end

			local x = icon:GetSize()

			icon.statusBar.__MERSkin:ClearAllPoints()
			icon.statusBar.__MERSkin:SetPoint("TOPLEFT", icon.statusBar, "TOPLEFT", -x - 1, 0)
			icon.statusBar.__MERSkin:SetPoint("BOTTOMRIGHT", icon.statusBar, "BOTTOMRIGHT", 0, 0)
			module:CreateShadow(icon.statusBar.__MERSkin)

			if icon.statusBar.CastingBar then
				S:HandleStatusBar(icon.statusBar.CastingBar)
			end

			if icon.class then
				hooksecurefunc(icon.statusBar.BG, "SetVertexColor", function(bar)
					if colorDB.enable then
						if colorDB.customColor.enableClass then
							bar:SetGradient("HORIZONTAL", F.GradientColorsCustom(bar:GetParent():GetParent().class))
						else
							bar:SetGradient("HORIZONTAL", F.GradientColors(bar:GetParent():GetParent().class))
						end
					end
				end)
			end
		end
	end)
end

function module:OmniCD()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.omniCD then
		return
	end

	self:OmniCD_ConfigGUI()
	self:OmniCD_Party_Icon()
	self:OmniCD_Party_ExtraBars()
end

module:AddCallbackForAddon("OmniCD")
