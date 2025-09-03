local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

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
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	hooksecurefunc(P, "CreateIconFramePool", function()
		if not P.IconPool then
			return
		end
		hooksecurefunc(P.IconPool, "Acquire", function(pool)
			for icon in pool:EnumerateActive() do
				if not icon.__MERSkin then
					self:CreateShadow(icon)
					icon.__MERSkin = true
				end
			end
		end)
	end)
end

function module:OmniCD_Party_StatusBar()
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	local function updateBorderVisibility(borderTex)
		local parent = borderTex:GetParent()
		if not parent or not parent.MERshadow then
			return
		end

		parent.MERshadow:SetShown(borderTex:IsShown())
	end

	hooksecurefunc(P, "CreateStatusBarFramePool", function()
		if not P.StatusBarPool then
			return
		end

		hooksecurefunc(P.StatusBarPool, "Acquire", function(pool)
			for bar in pool:EnumerateActive() do
				if not bar.__MERSkin then
					self:CreateLowerShadow(bar)

					-- bind the visibility to the original borders
					if bar.borderTop then
						hooksecurefunc(bar.borderTop, "SetShown", updateBorderVisibility)
						hooksecurefunc(bar.borderTop, "Hide", updateBorderVisibility)
						hooksecurefunc(bar.borderTop, "Show", updateBorderVisibility)
					end
					bar.__MERSkin = true
				end
			end
		end)
	end)
end

function module:OmniCD_Party_ExtraBars()
	local P = _G.OmniCD[1] and _G.OmniCD[1].Party
	if not P or not P.CreateStatusBarFramePool then
		return
	end

	hooksecurefunc(P, "CreateExBarFramePool", function()
		if not P.ExBarPool then
			return
		end

		hooksecurefunc(P.ExBarPool, "Acquire", function(pool)
			for bar in pool:EnumerateActive() do
				if not bar.__MERSkin then
					bar.anchor:StripTextures()
					bar.anchor:SetTemplate("Transparent")
					self:CreateShadow(bar.anchor)
					bar.anchor:SetHeight(bar.anchor:GetHeight() + 8)
					F.InternalizeMethod(bar.anchor, "SetPoint")
					hooksecurefunc(bar.anchor, "SetPoint", function()
						F.Move(bar.anchor, 0, bar.db and bar.db.growUpward and -11 or 3)
					end)

					bar.__MERSkin = true
				end
			end
		end)
	end)
end

function module:OmniCD()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.omniCD then
		return
	end

	self:OmniCD_ConfigGUI()
	self:OmniCD_Party_StatusBar()
	self:OmniCD_Party_ExtraBars()
end

module:AddCallbackForAddon("OmniCD")
