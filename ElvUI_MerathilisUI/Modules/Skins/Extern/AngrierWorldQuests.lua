local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local AWQ = LibStub("AceAddon-3.0"):GetAddon("AngrierWorldQuests")

local function HookQuestFrame_Update()
	local headerButton = _G.AngrierWorldQuestsHeader
	if not headerButton or headerButton.MERSkin then
		return
	end

	headerButton:StripTextures()
	headerButton:CreateBackdrop("Transparent")
	headerButton:GetHighlightTexture():SetColorTexture(F.r, F.g, F.b, 0.25)
	headerButton.ButtonText:FontTemplate(nil, 16)

	headerButton.MERSkin = true
end

function module:AngrierWorldQuests()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.awq then
		return
	end

	local QuestFrameModule = AWQ:GetModule("QuestFrameModule")
	if not QuestFrameModule then
		return
	end

	hooksecurefunc(QuestFrameModule, "QuestLog_Update", HookQuestFrame_Update)
end

module:AddCallbackForAddon("AngrierWorldQuests")
