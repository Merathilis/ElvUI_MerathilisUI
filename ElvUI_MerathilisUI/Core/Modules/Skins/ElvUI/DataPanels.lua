local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = MER:GetModule('MER_Skins')
local DT = E:GetModule("DataTexts")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function hookPanelSetTemplate(panel, template)
	if not panel.shadow then
		return
	end

	if template == "NoBackdrop" then
		panel.MERshadow:Hide()
		panel.MERstyle.stripes:Hide()
		panel.MERstyle.gradient:Hide()
		panel.MERstyle.mshadow:Hide()

	else
		panel.MERshadow:Show()
		panel.MERstyle.stripes:Show()
		panel.MERstyle.gradient:Show()
		panel.MERstyle.mshadow:Show()
	end
end

local function createPanelShadow(panel)
	if panel.MERshadow and panel.shadow.__MERSkin then
		return
	end
	S:CreateShadow(panel)
	panel:Styling()
	hooksecurefunc(panel, "SetTemplate", hookPanelSetTemplate)
	hookPanelSetTemplate(panel, panel.template)
end

function S:ElvUI_SkinDataPanel(_, name)
	local panel = DT:FetchFrame(name)
	createPanelShadow(panel)
end

function S:ElvUI_DataPanels()
	if not (E.private.mui.skins.shadow.enable) then
		return
	end

	if DT.PanelPool.InUse then
		for name, frame in pairs(DT.PanelPool.InUse) do
			createPanelShadow(frame)
		end
	end

	if DT.PanelPool.Free then
		for name, frame in pairs(DT.PanelPool.Free) do
			createPanelShadow(frame)
		end
	end

	self:SecureHook(DT, "BuildPanelFrame", "ElvUI_SkinDataPanel")
end

S:AddCallback("ElvUI_DataPanels")
