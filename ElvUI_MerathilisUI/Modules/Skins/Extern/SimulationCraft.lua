local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G

function module:Simulationcraft_SkinMainFrame()
	if not _G.SimcFrame or _G.SimcFrame.__MERSkin then
		return
	end

	_G.SimcFrame:SetTemplate("Transparent")
	self:CreateShadow(_G.SimcFrame)

	S:HandleButton(_G.SimcFrameButton)
	S:HandleCheckBox(_G.SimcFrame.CheckButton)
	S:HandleScrollBar(_G.SimcScrollFrameScrollBar)

	F.SetFontOutline(_G.SimcFrameButton:GetNormalFontObject())
	F.SetFontOutline(_G.SimcEditBox)
	F.SetFontOutline(_G.SimcFrame.CheckButton.Text)
	F.Move(_G.SimcFrame.CheckButton.Text, 0, -3)

	_G.SimcFrame.__MERSkin = true
end

function module:Simulationcraft()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.simc then
		return
	end

	self:DisableAddOnSkins("Simulationcraft")

	local addon = _G.LibStub("AceAddon-3.0"):GetAddon("Simulationcraft")

	if addon then
		self:SecureHook(addon, "GetMainFrame", "Simulationcraft_SkinMainFrame")
	end
end

module:AddCallbackForAddon("Simulationcraft")
