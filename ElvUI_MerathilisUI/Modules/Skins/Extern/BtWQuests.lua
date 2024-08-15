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
	QuestFrame.NavBack:Point("TOPLEFT", QuestFrame, "TOPLEFT", 2, -2)
	QuestFrame.NavForward:ClearAllPoints()
	QuestFrame.NavForward:Point("LEFT", QuestFrame.NavBack, "RIGHT", 1, 0)
	QuestFrame.NavHere:ClearAllPoints()
	QuestFrame.NavHere:Point("LEFT", QuestFrame.NavForward, "RIGHT", 1, 0)

	QuestFrame.CharacterDropDown:CreateBackdrop()
	QuestFrame.CharacterDropDown.backdrop:Point("TOPLEFT", QuestFrame.CharacterDropDown, "TOPLEFT", 18, -5)
	QuestFrame.CharacterDropDown.backdrop:Point("BOTTOMRIGHT", QuestFrame.CharacterDropDown, "BOTTOMRIGHT", 5, 11)

	QuestFrame.OptionsButton:ClearAllPoints()
	QuestFrame.OptionsButton:Point("RIGHT", QuestFrame.CloseButton, "LEFT", -1, 0)
	S:HandleButton(QuestFrame.OptionsButton, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")
	QuestFrame.OptionsButton:Size(18)

	if not _G.BtWQuestsFrameHomeButton.IsSkinned then
		S:HandleButton(_G.BtWQuestsFrameHomeButton, true)
		_G.BtWQuestsFrameHomeButton.xoffset = 1

		_G.BtWQuestsFrameHomeButton.IsSkinned = true
	end

	S:HandleEditBox(QuestFrame.SearchBox)

	S:HandleScrollBar(_G.BtWQuestsChainScrollFrameScrollBar)
	S:HandleScrollBar(_G.BtWQuestsFrameCategoryScrollBar)

	local ExpansionList = QuestFrame.ExpansionList
	local expansions = {
		ExpansionList.Expansion1,
		ExpansionList.Expansion2,
	}

	for _, frame in pairs(expansions) do
		if frame then
			frame:StripTextures(true)
			frame:CreateBackdrop("Transparent")
			frame.backdrop:SetAllPoints()
		end
	end
end

module:AddCallbackForAddon("BtWQuests")
