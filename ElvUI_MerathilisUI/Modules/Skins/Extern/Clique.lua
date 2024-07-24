local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs, unpack = pairs, unpack

local function SkinFrame()
	local mainFrame = _G.CliqueUIBindingFrame
	S:HandlePortraitFrame(mainFrame)
	module:CreateShadow(mainFrame)

	local scrollFrame = _G.CliqeUIConfigUIScrollFrame

	local browsePage = _G.CliqueConfigUIBindingFrameBrowsePage
	S:HandleButton(browsePage.AddButton)
	S:HandleButton(browsePage.EditButton)
	S:HandleButton(browsePage.QuickbindMode)
	S:HandleButton(browsePage.OptionsButton)
	S:HandleScrollBar(_G.CliqueConfigUIScrollBar)

	local actionCatalog = _G.CliqueConfigUIActionCatalogFrame
	actionCatalog:StripTextures()
	actionCatalog:SetTemplate("Transparent")
	module:CreateShadow(actionCatalog)
	actionCatalog:ClearAllPoints()
	actionCatalog:Point("LEFT", _G.CliqueUIBindingFrame, "RIGHT", 2, 0)
	S:HandleEditBox(_G.CliqueConfigUISpellbookSearch)
	S:HandleButton(_G.CliqueConfigUISpellbookFilterButton)
	S:HandleNextPrevButton(actionCatalog.prev)
	S:HandleNextPrevButton(actionCatalog.next)

	local editPage = _G.CliqueConfigUIBindingFrameEditPage
	editPage.bindSummary:StripTextures()
	editPage.bindSummary:SetTemplate()
	S:HandleButton(editPage.changeBinding)
	S:HandleButton(editPage.CancelButton)
	S:HandleButton(editPage.SaveButton)

	local checkBoxes = {
		editPage.BindSetCheckButtonDefault,
		editPage.BindSetCheckButtonOOC,
		editPage.BindSetCheckButtonFriend,
		editPage.BindSetCheckButtonEnemy,
		editPage.BindSetCheckButtonHovercast,
		editPage.BindSetCheckButtonGlobal,
		editPage.BindSetCheckButtonSpec1,
		editPage.BindSetCheckButtonSpec2,
		editPage.BindSetCheckButtonSpec3,
	}

	for _, checkBox in pairs(checkBoxes) do
		if checkBox then
			S:HandleCheckBox(checkBox)
		end
	end
end

local function SkinTabButton()
	local tab = _G.Clique.spellbookTab
	if not tab then
		return
	end

	S:HandleFrame(tab)

	tab:SetNormalTexture(I.General.MediaPath .. "Textures\\clique") --override the Texture to take account for Simpy's Icon pack
	tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	tab:GetNormalTexture():SetInside()

	tab:SetPushedTexture(I.General.MediaPath .. "Textures\\clique") -- override the Texture to take account for Simpy's Icon pack
	tab:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	tab:GetPushedTexture():SetInside()

	tab:SetHighlightTexture(I.General.MediaPath .. "Textures\\clique") -- override the Texture to take account for Simpy's Icon pack
	tab:GetHighlightTexture():SetTexCoord(unpack(E.TexCoords))
	tab:GetHighlightTexture():SetInside()

	tab:CreateBackdrop("Transparent")
	tab.backdrop:SetAllPoints()
	tab:StyleButton()
end

function module:Clique()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.cl then
		return
	end

	module:DisableAddOnSkins("Clique", false)

	hooksecurefunc(_G.Clique, "ShowBindingConfig", SkinFrame)
	hooksecurefunc(_G.Clique, "ShowSpellBookButton", SkinTabButton)
end

module:AddCallbackForAddon("Clique")
