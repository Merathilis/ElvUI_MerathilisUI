local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local function HookQuestFrame_Update()
	local button = _G.AngrierWorldQuestsHeader

	if button and not button.MERSkin then
		button:StripTextures()
		button:CreateBackdrop("Transparent")
		button:GetHighlightTexture():SetColorTexture(F.r, F.g, F.b, 0.25)
		button.ButtonText:FontTemplate(nil, 16)

		button.MERSkin = true
	end
end

function module:AngrierWorldQuests()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.awq then
		return
	end

	hooksecurefunc("QuestLogQuests_Update", HookQuestFrame_Update)
end

module:AddCallbackForAddon("AngrierWorldQuests")
