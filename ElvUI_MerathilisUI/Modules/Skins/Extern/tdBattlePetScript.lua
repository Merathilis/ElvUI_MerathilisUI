local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

function module:SkinMainPanel()
	local tdBattlePetScript = LibStub("AceAddon-3.0"):GetAddon("PetBattleScripts", true)
	if not tdBattlePetScript then
		print("PetBattleScripts not found!")
		return
	end

	local uiModule = tdBattlePetScript:GetModule("UI.MainPanel", true)
	if not uiModule or not uiModule.MainPanel then
		print("UI.MainPanel not found!")
		return
	end

	local mainPanel = uiModule.MainPanel

	S:HandleFrame(mainPanel, nil, nil, true)

	local function SkinFrame(frame)
		if not frame or frame.MERSkin then
			return
		end

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region.GetTexture and region:GetTexture() and type(region:GetTexture()) == "string" then
				local tex = strlower(region:GetTexture())
				if
					strfind(tex, "ui%-background%-marble")
					or strfind(tex, "ui%-frame%-")
					or strfind(tex, "ui%-dialog%-")
				then
					region:SetTexture(nil)
				end
			end
		end

		if frame:IsObjectType("Button") then
			-- S:HandleButton(frame) -- find a way to handle different buttons
		elseif frame:IsObjectType("CheckButton") then
			S:HandleCheckBox(frame)
		elseif frame:IsObjectType("EditBox") then
			-- S:HandleEditBox(frame) -- Its an dynamic editbox
			frame:StripTextures(true)
		elseif frame:IsObjectType("Frame") and frame.ScrollBar then
			S:HandleScrollBar(frame.ScrollBar)
		elseif frame:IsObjectType("Frame") and frame.DropDown then
			S:HandleDropDownBox(frame.DropDown)
		elseif frame:IsObjectType("Frame") and frame.CloseButton then
			S:HandleCloseButton(frame.CloseButton)
		end

		for i = 1, frame:GetNumChildren() do
			local child = select(i, frame:GetChildren())
			SkinFrame(child)
		end

		frame.MERSkin = true
	end

	SkinFrame(mainPanel)
end

function module:tdBattlePetScript()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pbs then
		return
	end

	self:DisableAddOnSkins("tdBattlePetScript", false)
	self:SkinMainPanel()
end

module:AddCallbackForAddon("tdBattlePetScript")
