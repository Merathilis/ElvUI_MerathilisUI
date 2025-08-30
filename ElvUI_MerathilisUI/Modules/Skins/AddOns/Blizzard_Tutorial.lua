local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_Tutorial()
	local TutorialKeyboardMouseFrame = _G.NPE_TutorialKeyboardMouseFrame_Frame
	if TutorialKeyboardMouseFrame then
		TutorialKeyboardMouseFrame:SetScale(0.00001)
		TutorialKeyboardMouseFrame:EnableMouse(false)
		TutorialKeyboardMouseFrame:UnregisterAllEvents()
	end

	local TutorialMainFrame = _G.NPE_TutorialMainFrame_Frame
	if TutorialMainFrame then
		TutorialMainFrame:SetScale(0.00001)
		TutorialMainFrame:EnableMouse(false)
		TutorialMainFrame:UnregisterAllEvents()
	end

	local TutorialWalk = _G.NPE_TutorialWalk_Frame
	if TutorialWalk then
		TutorialWalk:SetScale(0.00001)
		TutorialWalk:EnableMouse(false)
		TutorialWalk:UnregisterAllEvents()
	end

	local TutorialSingleKey = _G.NPE_TutorialSkingleKey_Frame
	if TutorialSingleKey then
		TutorialSingleKey:SetScale(0.00001)
		TutorialSingleKey:EnableMouse(false)
		TutorialSingleKey:UnregisterAllEvents()
	end

	local KeyboardMouseConfirmButton = _G.NPE_KeyboardMouseConfirmButton or _G.KeyboardMouseConfirmButton
	if KeyboardMouseConfirmButton then
		KeyboardMouseConfirmButton:SetScale(0.00001)
		KeyboardMouseConfirmButton:EnableMouse(false)
		KeyboardMouseConfirmButton:UnregisterAllEvents()
	end
end

module:AddCallbackForAddon("Blizzard_Tutorial")
