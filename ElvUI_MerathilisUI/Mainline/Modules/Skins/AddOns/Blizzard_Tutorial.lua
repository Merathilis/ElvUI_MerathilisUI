local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
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
end

S:AddCallbackForAddon("Blizzard_Tutorial", LoadSkin)
