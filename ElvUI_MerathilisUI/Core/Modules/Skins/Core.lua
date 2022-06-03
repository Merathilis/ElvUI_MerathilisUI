local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

local _G = _G

function module:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

function module:ShadowOverlay()
	-- Based on ncShadow
	if not E.private.mui.skins.shadowOverlay then return end

	self.f = CreateFrame("Frame", MER.Title.."ShadowBackground")
	self.f:Point("TOPLEFT")
	self.f:Point("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")

	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Overlay]])
	self.f.tex:SetAllPoints(self.f)

	self.f:SetAlpha(0.7)
end

function module:Initialize()
	if not E.private.mui.skins.enable then
		return
	end

	self:ShadowOverlay()
end

MER:RegisterModule(module:GetName())