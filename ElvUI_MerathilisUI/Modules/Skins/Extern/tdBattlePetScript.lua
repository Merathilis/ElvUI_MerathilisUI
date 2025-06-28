local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

function module:tdBattlePetScript()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pbs then
		return
	end

	self:DisableAddOnSkins("tdBattlePetScript", false)

	--/run LibStub('AceAddon-3.0'):GetAddon('tdBattlePetScript'):GetModule('UI.MainPanel').MainPanel:SetTemplate()
	local tdBattlePetScript = LibStub("AceAddon-3.0"):GetAddon("PetBattleScripts"):GetModule("UI.MainPanel")

	S:HandleFrame(tdBattlePetScript.MainPanel, nil, nil, true)
	for i = 1, tdBattlePetScript.MainPanel:GetNumChildren() do
		local frame = select(i, tdBattlePetScript.MainPanel:GetChildren())
		if frame:IsObjectType("Frame") then
			for j = 1, frame:GetNumRegions() do
				local region = select(j, frame:GetRegions())
				if region.GetTexture and region:GetTexture() and type(region:GetTexture() == "string") then
					-- print(region:GetTexture())
					if strfind(strlower(region:GetTexture()), "ui%-background%-marble") then
						frame:StripTextures()
					elseif strfind(strlower(region:GetTexture()), "ui%-panel%-minimizebutton") then
						S:HandleCloseButton(frame)
					end
				end
			end
		end
	end

	local BlockDialog = tdBattlePetScript.BlockDialog
	S:HandleFrame(BlockDialog)
	BlockDialog:SetFrameStrata("DIALOG")
	BlockDialog:SetFrameLevel(10000)
	BlockDialog.Text:FontTemplate(nil, 12, "SHADOWOUTLINE")
	S:HandleButton(BlockDialog.AcceptButton)
	S:HandleButton(BlockDialog.CancelButton)
	S:HandleEditBox(BlockDialog.EditBox)
	tdBattlePetScript.MainPanel.Portrait.Border:Hide()
	S:HandleScrollBar(tdBattlePetScript.ScriptList.scrollBar)

	S:HandleButton(_G.tdBattlePetScriptAutoButton)
end

module:AddCallbackForAddon("tdBattlePetScript")
