local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local random = random
-- WoW API / Variables
local optionPanel = _G["optionPanel"]

function MER:OptionPanel()
	-- Option Panel
	if not optionPanel then
		print("opanel")
		local optionPanel = CreateFrame("Button", "optionPanel", E.UIParent)
		optionPanel:SetFrameLevel(0)
		optionPanel:SetSize(300, 70)
		optionPanel:SetTemplate("Transparent")
		optionPanel:SetPoint("TOP", 0, -30)
		MER:StyleOutside(optionPanel)
		E:CreateMover(optionPanel, "OptionPanel", "Option Panel", nil, nil, nil, "ALL")
	
	--Move Button
		optionPanel.MoveBtn = CreateFrame("Button", "MoveBtn", optionPanel, "UIPanelButtonTemplate")
		optionPanel.MoveBtn:StripTextures()
		optionPanel.MoveBtn:SetTemplate('Transparent')
		optionPanel.MoveBtn:SetFrameStrata('HIGH')
		optionPanel.MoveBtn:Size(64, 64)
		optionPanel.MoveBtn:SetAlpha(.1)
		optionPanel.MoveBtn:SetText("")
		optionPanel.MoveBtn:Point("LEFT", 1, 0)
		S:HandleButton(optionPanel.MoveBtn, true)
		
		optionPanel.MoveBtnT = optionPanel:CreateTexture('MoveButton')
		optionPanel.MoveBtnT:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\move.tga')
		optionPanel.MoveBtnT:Point('LEFT', "optionPanel", 1, 0)
		MoveBtn:SetScript("OnClick", function() E:ToggleConfigMode() end)
		
		optionPanel:Hide()
	end
end

function MER:LoadOptionPanel()
	self:OptionPanel()
end