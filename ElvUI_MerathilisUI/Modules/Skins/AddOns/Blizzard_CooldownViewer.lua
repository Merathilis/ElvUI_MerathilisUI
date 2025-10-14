local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

function module:Blizzard_CooldownViewer()
	if not self:CheckDB("cooldownManager", "cooldownViewer") then
		return
	end

	local CooldownViewerSettings = _G.CooldownViewerSettings
	if not CooldownViewerSettings then
		return
	end

	self:CreateShadow(CooldownViewerSettings)

	for i, tab in ipairs({ CooldownViewerSettings.SpellsTab, CooldownViewerSettings.AurasTab }) do
		if tab.backdrop then
			self:CreateBackdropShadow(tab)
			tab.backdrop:SetTemplate("Transparent")
		end

		if i == 1 then
			hooksecurefunc(tab, "SetPoint", function(theTab, _, _, _, x, y)
				if x == 1 and y == -10 then
					theTab:ClearAllPoints()
					_G.UIParent.SetPoint(theTab, "TOPLEFT", CooldownViewerSettings, "TOPRIGHT", 3, -10)
				end
			end)

			tab:ClearAllPoints()
			_G.UIParent.SetPoint(tab, "TOPLEFT", CooldownViewerSettings, "TOPRIGHT", 3, -10)
		else
			F.Move(tab, 0, -2)
		end
	end

	self:SecureHook(S, "CooldownManager_SkinIcon", function(_, _, icon)
		if icon.__MERSkin then
			return
		end
		self:CreateBackdropShadow(icon)
		icon.__MERSkin = true
	end)

	self:SecureHook(S, "CooldownManager_SkinBar", function(_, _, bar)
		---@cast bar StatusBar
		if bar.__MERSkin then
			return
		end

		bar:SetStatusBarTexture(E.media.normTex)
		bar:GetStatusBarTexture():SetTextureSliceMode(0)

		for _, region in pairs({ bar:GetRegions() }) do
			if region:IsObjectType("Texture") and region.backdrop then
				self:CreateBackdropShadow(region)
				break
			end
		end
		bar.__MERSkin = true
	end)
end

module:AddCallbackForAddon("Blizzard_CooldownViewer")
