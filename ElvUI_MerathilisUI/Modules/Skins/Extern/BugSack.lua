local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G

function module:BugSack_OpenSack()
	if _G.BugSackFrame.__MERSkin then
		return
	end

	local bugSackFrame = _G.BugSackFrame

	bugSackFrame:StripTextures()
	bugSackFrame:SetTemplate("Transparent")
	module:CreateShadow(bugSackFrame)

	for _, child in pairs({ bugSackFrame:GetChildren() }) do
		local numRegions = child:GetNumRegions()

		if numRegions == 1 then
			local text = child:GetRegions()
			if text and text:GetObjectType() == "FontString" then
				F.SetFont(text)
			end
		elseif numRegions == 4 then
			S:HandleCloseButton(child)
		end
	end

	S:HandleScrollBar(_G.BugSackScrollScrollBar)

	for _, region in pairs({ _G.BugSackScrollText:GetRegions() }) do
		if region and region:GetObjectType() == "FontString" then
			F.SetFont(region)
		end
	end

	if _G.BugSackNextButton and _G.BugSackPrevButton and _G.BugSackSendButton then
		local width, height = _G.BugSackSendButton:GetSize()
		_G.BugSackSendButton:SetSize(width - 8, height)
		_G.BugSackSendButton:ClearAllPoints()
		_G.BugSackSendButton:SetPoint("LEFT", _G.BugSackPrevButton, "RIGHT", 4, 0)
		_G.BugSackSendButton:SetPoint("RIGHT", _G.BugSackNextButton, "LEFT", -4, 0)

		S:HandleButton(_G.BugSackNextButton)
		S:HandleButton(_G.BugSackPrevButton)
		S:HandleButton(_G.BugSackSendButton)
	end

	local tabs = {
		_G.BugSackTabAll,
		_G.BugSackTabLast,
		_G.BugSackTabSession,
	}

	for _, tab in pairs(tabs) do
		S:HandleTab(tab)
		module:CreateBackdropShadow(tab)

		local point, relativeTo, relativePoint, xOffset, yOffset = tab:GetPoint(1)

		tab:ClearAllPoints()

		if yOffset ~= 0 then
			yOffset = -2
		end

		tab:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	end

	bugSackFrame.__MERSkin = true
end

function module:BugSack()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bs then
		return
	end

	if not _G.BugSack then
		return
	end

	module:DisableAddOnSkins("BugSack", false)

	self:SecureHook(_G.BugSack, "OpenSack", "BugSack_OpenSack")

	-- Handle the special dropdown in settings
	hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, "Update", function(scrollBox)
		scrollBox:ForEachFrame(function(frame)
			if frame.soundDropdown and frame.soundDropdown.intrinsic == "DropdownButton" then
				self:Proxy("HandleDropDownBox", frame.soundDropdown)
			end
		end)
	end)
end

module:AddCallbackForAddon("BugSack")
