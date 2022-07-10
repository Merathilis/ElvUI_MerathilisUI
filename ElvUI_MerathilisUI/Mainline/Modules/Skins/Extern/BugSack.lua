local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("BugSack") then return; end

local _G = _G

function module:BugSack_InterfaceOptionOnShow(frame)
	if frame.__MERSkin then
		return
	end

	if _G.BugSackFontSize then
		local dropdown = _G.BugSackFontSize
		S:HandleDropDownBox(dropdown)

		local point, relativeTo, relativePoint, xOffset, yOffset = dropdown:GetPoint(1)
		dropdown:ClearAllPoints()
		dropdown:SetPoint(point, relativeTo, relativePoint, xOffset - 1, yOffset)

		dropdown.__MERSkinMarked = true
	end

	if _G.BugSackSoundDropdown then
		local dropdown = _G.BugSackSoundDropdown
		S:HandleDropDownBox(dropdown)

		local point, relativeTo, relativePoint = dropdown:GetPoint(1)
		dropdown:ClearAllPoints()
		dropdown:SetPoint(point, relativeTo, relativePoint)

		dropdown.__MERSkinMarked = true
	end

	for _, child in pairs {frame:GetChildren()} do
		if child.__MERSkinMarked then
			child.__MERSkinMarked = nil
		else
			local objectType = child:GetObjectType()
			if objectType == "Button" then
				S:HandleButton(child)
			elseif objectType == "CheckButton" then
				S:HandleButton(child)

				-- fix master channel checkbox position
				local point, relativeTo, relativePoint = child:GetPoint(1)
				if point == "LEFT" and relativeTo == _G.BugSackSoundDropdown then
					child:ClearAllPoints()
					child:SetPoint(point, relativeTo, relativePoint, 0, 3)
				end
			end
		end
	end

	frame.__MERSkin = true
end

 function module:BugSack_OpenSack()
	if _G.BugSackFrame.__MERSkin then
		return
	end

	local bugSackFrame = _G.BugSackFrame

	bugSackFrame:StripTextures()
	bugSackFrame:SetTemplate("Transparent")
	bugSackFrame:Styling()
	module:CreateShadow(bugSackFrame)

	for _, child in pairs {bugSackFrame:GetChildren()} do
		local numRegions = child:GetNumRegions()

		if numRegions == 1 then
			local text = child:GetRegions()
			if text and text:GetObjectType() == "FontString" then
				F.SetFontOutline(text)
			end
		elseif numRegions == 4 then
			S:HandleCloseButton(child)
		end
	end

	S:HandleScrollBar(_G.BugSackScrollScrollBar)

	for _, region in pairs {_G.BugSackScrollText:GetRegions()} do
		if region and region:GetObjectType() == "FontString" then
			F.SetFontOutline(region)
		end
	end

	S:HandleButton(_G.BugSackNextButton)
	S:HandleButton(_G.BugSackPrevButton)
	S:HandleButton(_G.BugSackSendButton)

	local tabs = {
		_G.BugSackTabAll,
		_G.BugSackTabLast,
		_G.BugSackTabSession
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

	module:SecureHookScript(_G.BugSack.frame, "OnShow", "BugSack_InterfaceOptionOnShow")
	module:SecureHook(_G.BugSack, "OpenSack", "BugSack_OpenSack")
	module:DisableAddOnSkin("BugSack")
end

module:AddCallbackForAddon("BugSack")
