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
		local optionPanel = CreateFrame("Frame", "optionPanel", E.UIParent)
		optionPanel:SetFrameLevel(0)
		optionPanel:SetSize(300, 70)
		optionPanel:SetTemplate("Transparent")
		optionPanel:SetPoint("TOP", 0, -30)
		MER:StyleOutside(optionPanel)
		E:CreateMover(optionPanel, "OptionPanel", "Option Panel", nil, nil, nil, "ALL")
	
	--Move Button
		optionPanel.MoveBtn = CreateFrame("Button", "MoveBtn", optionPanel)
		optionPanel.MoveBtn:SetTemplate('Transparent')
		optionPanel.MoveBtn:SetFrameStrata('MEDIUM')
		optionPanel.MoveBtn:Size(64, 64)
		optionPanel.MoveBtn:SetAlpha(.1)
		optionPanel.MoveBtn:SetText("")
		optionPanel.MoveBtn:Point("LEFT", 1, 0)
		S:HandleButton(optionPanel.MoveBtn, true)
		optionPanel.MoveBtn:SetScript("OnClick", function() E:ToggleConfigMode(); optionPanel:Hide(); end)
		
		optionPanel.MoveBtnT = optionPanel:CreateTexture('MoveButton')
		optionPanel.MoveBtnT:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\move.tga')
		optionPanel.MoveBtnT:Point('LEFT', "optionPanel", 1, 0)
		
	-- AddOn Button
		optionPanel.AddOnBtn = CreateFrame("Button", "AddOnBtn", optionPanel)
		optionPanel.AddOnBtn:SetTemplate('Transparent')
		optionPanel.AddOnBtn:SetFrameStrata('MEDIUM')
		optionPanel.AddOnBtn:Size(64, 64)
		optionPanel.AddOnBtn:SetAlpha(.1)
		optionPanel.AddOnBtn:SetText("")
		optionPanel.AddOnBtn:Point("RIGHT", optionPanel.MoveBtn, 64, 0)
		S:HandleButton(optionPanel.AddOnBtn, true)
		optionPanel.AddOnBtn:SetScript("OnClick", function() GameMenuButtonAddons:Click(); end)
		
		optionPanel.AddOnBtnT = optionPanel:CreateTexture('AddOnButton')
		optionPanel.AddOnBtnT:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\addons.tga')
		optionPanel.AddOnBtnT:Point('RIGHT', optionPanel.MoveBtn, 64, 0)
	
	-- Close Button
		optionPanel.CloseBtn = CreateFrame("Button", "CloseButton", optionPanel)
		optionPanel.CloseBtn:SetTemplate('Transparent')
		optionPanel.CloseBtn:SetFrameStrata('MEDIUM')
		optionPanel.CloseBtn:Size(64, 64)
		optionPanel.CloseBtn:SetAlpha(.1)
		optionPanel.CloseBtn:SetText("")
		optionPanel.CloseBtn:Point('RIGHT', optionPanel.MoveBtn, 64, 0)
		S:HandleButton(optionPanel.CloseBtn, true)
		optionPanel.CloseBtn:SetScript("OnClick", function() optionPanel:Hide() end)
		
		optionPanel.CloseBtnT = optionPanel:CreateTexture('CloseButton')
		optionPanel.CloseBtnT:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\close.tga')
		optionPanel.CloseBtnT:Point('RIGHT', optionPanel.AddOnBtn, 64, 0)
		
		optionPanel:Hide()
	end
end

function MER:LoadOptionPanel()
	self:OptionPanel()
end