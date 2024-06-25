local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function ReskinScrollFrameItems(frame, template)
	if template == "SimpleAddonManagerAddonItem" or template == "SimpleAddonManagerCategoryItem" then
		for _, btn in pairs(frame.buttons) do
			if not btn.__MERSkin then
				F.SetFontOutline(btn.Name)
				S:HandleCheckBox(btn.EnabledButton)
				if btn.ExpandOrCollapseButton then
					S:HandleCollapseTexture(btn.ExpandOrCollapseButton)
				end
				btn.__MERSkin = true
			end
		end
	end
end

local function ReskinModules(frame)
	-- MainFrame
	S:HandleButton(frame.OkButton)
	S:HandleButton(frame.CancelButton)
	S:HandleButton(frame.EnableAllButton)
	S:HandleButton(frame.DisableAllButton)
	S:HandleDropDownBox(frame.CharacterDropDown)

	frame.OkButton:ClearAllPoints()
	frame.OkButton:SetPoint("RIGHT", frame.CancelButton, "LEFT", -2, 0)
	frame.DisableAllButton:ClearAllPoints()
	frame.DisableAllButton:SetPoint("LEFT", frame.EnableAllButton, "RIGHT", 2, 0)

	-- SearchBox
	S:HandleEditBox(frame.SearchBox)

	-- AddonListFrame
	S:HandleScrollBar(frame.ScrollFrame.ScrollBar)

	-- CategoryFrame
	S:HandleButton(frame.CategoryFrame.NewButton)
	S:HandleButton(frame.CategoryFrame.SelectAllButton)
	S:HandleButton(frame.CategoryFrame.ClearSelectionButton)
	S:HandleButton(frame.CategoryButton)
	S:HandleScrollBar(frame.CategoryFrame.ScrollFrame.ScrollBar)

	frame.CategoryFrame.NewButton:ClearAllPoints()
	frame.CategoryFrame.NewButton:SetHeight(20)
	frame.CategoryFrame.NewButton:SetPoint("BOTTOMLEFT", frame.CategoryFrame.SelectAllButton, "TOPLEFT", 0, 2)
	frame.CategoryFrame.NewButton:SetPoint("BOTTOMRIGHT", frame.CategoryFrame.ClearSelectionButton, "TOPRIGHT", 0, 2)

	-- Profile
	S:HandleButton(frame.SetsButton)
	S:HandleButton(frame.ConfigButton)

	-- Misc
	hooksecurefunc("HybridScrollFrame_CreateButtons", ReskinScrollFrameItems)
	ReskinScrollFrameItems(frame.ScrollFrame, "SimpleAddonManagerAddonItem")
	ReskinScrollFrameItems(frame.CategoryFrame.ScrollFrame, "SimpleAddonManagerCategoryItem")
end

function module:SimpleAddonManager()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.sam then
		return
	end

	if not _G.SimpleAddonManager then
		return
	end

	hooksecurefunc(_G.SimpleAddonManager, "Initialize", ReskinModules)

	_G.SimpleAddonManager:StripTextures(true)
	_G.SimpleAddonManager:SetTemplate("Transparent")
	module:CreateShadow(_G.SimpleAddonManager)
	S:HandleCloseButton(_G.SimpleAddonManager.CloseButton)

	local edd = _G.LibStub("ElioteDropDownMenu-1.0", true)
	if edd then
		hooksecurefunc(edd, "UIDropDownMenu_CreateFrames", function(level)
			if _G["ElioteDDM_DropDownList" .. level] and not _G["ElioteDDM_DropDownList" .. level].__windSkin then
				_G["ElioteDDM_DropDownList" .. level .. "Backdrop"]:SetTemplate("Transparent")
				_G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"]:SetTemplate("Transparent")
				module:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "Backdrop"])
				module:CreateShadow(_G["ElioteDDM_DropDownList" .. level .. "MenuBackdrop"])
				_G["ElioteDDM_DropDownList" .. level].__windSkin = true
			end
		end)
	end
end

module:AddCallbackForAddon("SimpleAddonManager")
