local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:BtWQuests()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.btwQ then
		return
	end

	local QuestFrame = _G.BtWQuestsFrame

	S:HandlePortraitFrame(QuestFrame)
	module:CreateShadow(QuestFrame)
	S:HandleFrame(QuestFrame.navBar, true, nil, -2)
	QuestFrame.navBar.overlay:StripTextures(true)
	QuestFrame.Inset:StripTextures(true)

	S:HandleNextPrevButton(QuestFrame.NavBack)
	S:HandleNextPrevButton(QuestFrame.NavForward)
	S:HandleNextPrevButton(QuestFrame.NavHere, "up", nil, true)

	QuestFrame.NavBack:ClearAllPoints()
	QuestFrame.NavBack:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 2, -2)
	QuestFrame.NavForward:ClearAllPoints()
	QuestFrame.NavForward:SetPoint("LEFT", QuestFrame.NavBack, "RIGHT", 1, 0)
	QuestFrame.NavHere:ClearAllPoints()
	QuestFrame.NavHere:SetPoint("LEFT", QuestFrame.NavForward, "RIGHT", 1, 0)

	QuestFrame.CharacterDropDown:CreateBackdrop()
	QuestFrame.CharacterDropDown.backdrop:SetPoint("TOPLEFT", QuestFrame.CharacterDropDown, "TOPLEFT", 18, -5)
	QuestFrame.CharacterDropDown.backdrop:SetPoint("BOTTOMRIGHT", QuestFrame.CharacterDropDown, "BOTTOMRIGHT", 5, 11)

	F.Reskin(QuestFrame.OptionsButton)

	S:HandleButton(_G.BtWQuestsFrameHomeButton, true)
	_G.BtWQuestsFrameHomeButton.xoffset = 1
	_G.BtWQuestsFrameHomeButton.isSkinned = true

	S:HandleScrollBar(_G.BtWQuestsChainScrollFrameScrollBar)
	S:HandleScrollBar(_G.BtWQuestsFrameCategoryScrollBar)
end

module:AddCallbackForAddon("BtWQuests")
