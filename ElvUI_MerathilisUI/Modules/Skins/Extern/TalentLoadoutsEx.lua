local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local hooksecurefunc = hooksecurefunc
local next = next

local function ReskinTlxScrollChild(self)
	for _, child in next, { self.ScrollTarget:GetChildren() } do
		local top = child.BgTop
		local middle = child.BgMiddle
		local bottom = child.BgBottom

		if top and not top.Skinned then
			top:Hide()
			top.Skinned = true
		end
		if middle and not middle.Skinned then
			middle:Hide()
			middle.Skinned = true
		end
		if bottom and not bottom.Skinned then
			bottom:Hide()
			bottom.Skinned = true
		end
	end
end

local function ReskinTlxScrollBox(frame)
	frame:DisableDrawLayer("BACKGROUND")
	frame:StripTextures()
	hooksecurefunc(frame, "Update", ReskinTlxScrollChild)
end

function module:TalentLoadoutsEx()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.tlx then
		return
	end

	hooksecurefunc(TLX.Frame, "OnLoad", function()
		if TlxFrame.IsSkinned then
			return
		end

		-- Main Frame
		TlxFrame.NineSlice:SetTemplate("Transparent")
		TlxFrame:Height(885)
		module:CreateShadow(TlxFrame)

		local buttons = {
			TlxFrame.LoadButton,
			TlxFrame.EditButton,
			TlxFrame.UpButton,
			TlxFrame.SaveButton,
			TlxFrame.DeleteButton,
			TlxFrame.DownButton,
		}

		for _, button in pairs(buttons) do
			if button then
				S:HandleButton(button)
			end
		end

		-- Scroll
		S:HandleTrimScrollBar(TlxFrame.ScrollBar)
		ReskinTlxScrollBox(TlxFrame.ScrollBox)

		-- Misc
		TlxFrame.Bg:Kill()

		-- Reposition for pixel perfect style
		TlxFrame:ClearAllPoints()
		TlxFrame:Point("TOPLEFT", _G.ClassTalentFrame, "TOPRIGHT", 2, 0)

		TlxFrame.IsSkinned = true
	end)

	hooksecurefunc(TlxPopupMixin, "OnShow", function()
		if TlxFrame.PopupFrame.Skinned then
			return
		end

		-- Main Frame
		TlxFrame.PopupFrame:StripTextures()
		TlxFrame.PopupFrame:SetTemplate("Transparent")
		TlxFrame.PopupFrame.BorderBox:StripTextures()
		module:CreateShadow(TlxFrame.PopupFrame)

		-- Buttons
		S:HandleButton(TlxFrame.PopupFrame.BorderBox.OkayButton)
		S:HandleButton(TlxFrame.PopupFrame.BorderBox.CancelButton)

		-- Scroll
		S:HandleTrimScrollBar(TlxFrame.PopupFrame.IconSelector.ScrollBar)

		-- EditBox
		TlxFrame.PopupFrame.BorderBox.IconSelectorEditBox:StripTextures()
		S:HandleEditBox(TlxFrame.PopupFrame.BorderBox.IconSelectorEditBox)

		-- Notes
		local notice = TlxFrame.PopupFrame.SearchNotice.NineSlice
		if notice then
			notice:SetTemplate("Transparent")
			notice:Point("TOPLEFT", TlxFrame.PopupFrame, "BOTTOMLEFT", 6, 1)
			notice:Point("TOPRIGHT", TlxFrame.PopupFrame, "BOTTOMRIGHT", -5, 1)
		end

		TlxFrame.PopupFrame.Skinned = true
	end)
end

module:AddCallbackForAddon("TalentLoadoutsEx")
