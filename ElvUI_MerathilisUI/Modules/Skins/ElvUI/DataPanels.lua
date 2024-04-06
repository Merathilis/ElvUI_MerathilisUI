local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule("MER_Skins")
local DT = E:GetModule("DataTexts")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function hookPanelSetTemplate(panel, template)
	if not panel.MERshadow then
		return
	end

	if template == "NoBackdrop" then
		panel.MERshadow:Hide()
		panel.MERshadow.stripes:Hide()
		panel.MERshadow.mshadow:Hide()
	else
		panel.MERshadow:Show()
		panel.MERshadow.stripes:Show()
		panel.MERshadow.mshadow:Show()
	end
end

local function createPanelShadow(panel)
	if panel.MERshadow and panel.shadow.__MER then
		return
	end

	S:CreateShadow(panel)

	hooksecurefunc(panel, "SetTemplate", hookPanelSetTemplate)
	hookPanelSetTemplate(panel, panel.template)
end

function S:ElvUI_SkinDataPanel(_, name)
	local panel = DT:FetchFrame(name)
	createPanelShadow(panel)
end

function S:ElvUI_DataPanels()
	if not E.private.mui.skins.shadow.enable then
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
