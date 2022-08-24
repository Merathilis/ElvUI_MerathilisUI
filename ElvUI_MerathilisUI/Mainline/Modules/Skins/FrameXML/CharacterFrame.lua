local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame
	local CharacterModelFrame = _G.CharacterModelFrame

	CharacterFrame:Styling()
	module:CreateShadow(CharacterFrame)
	module:CreateShadow(_G.GearManagerDialogPopup)
	module:CreateShadow(_G.EquipmentFlyoutFrameButtons)

	for i = 1, 4 do
		module:ReskinTab(_G["CharacterFrameTab" .. i])
	end

	if CharacterModelFrame and CharacterModelFrame.BackgroundTopLeft and CharacterModelFrame.BackgroundTopLeft:IsShown() then
		CharacterModelFrame.BackgroundTopLeft:Hide()
		CharacterModelFrame.BackgroundTopRight:Hide()
		CharacterModelFrame.BackgroundBotLeft:Hide()
		CharacterModelFrame.BackgroundBotRight:Hide()
		_G.CharacterModelFrameBackgroundOverlay:Hide()

		if _G.CharacterModelFrame.backdrop then
			_G.CharacterModelFrame.backdrop:Hide()
		end
	end
end

S:AddCallback("CharacterFrame", LoadSkin)
