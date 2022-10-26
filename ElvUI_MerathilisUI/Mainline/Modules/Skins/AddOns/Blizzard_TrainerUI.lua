local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local next, unpack = next, unpack

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("trainer", "trainer") then
		return
	end


	local ClassTrainerFrame = _G.ClassTrainerFrame
	ClassTrainerFrame:Styling()
	module:CreateShadow(ClassTrainerFrame)

	_G.ClassTrainerStatusBarSkillRank:ClearAllPoints()
	_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar, "CENTER", 0, 0)

	local bg = CreateFrame("Frame", nil, _G.ClassTrainerFrameSkillStepButton)
	bg:SetPoint("TOPLEFT", 42, -2)
	bg:SetPoint("BOTTOMRIGHT", 0, 2)
	bg:SetFrameLevel(_G.ClassTrainerFrameSkillStepButton:GetFrameLevel()-1)
	bg:CreateBackdrop('Transparent')

	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("TOPLEFT", 43, -3)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetPoint("BOTTOMRIGHT", -1, 3)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(E["media"].normTex)
	_G.ClassTrainerFrameSkillStepButton.selectedTex:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, _G.ClassTrainerStatusBar)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameLevel(_G.ClassTrainerStatusBar:GetFrameLevel()-1)
	bd:CreateBackdrop('Transparent')
end

S:AddCallbackForAddon("Blizzard_TrainerUI", LoadSkin)
