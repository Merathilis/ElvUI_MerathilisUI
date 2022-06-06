local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("BugSack") then return; end

local _G = _G

local function BugSack_Open()
	local BugSackFrame = _G.BugSackFrame

	if BugSackFrame.MERStyle then
		return
	end

	BugSackFrame:StripTextures()
	BugSackFrame:CreateBackdrop('Transparent')
	if BugSackFrame.backdrop then
		BugSackFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(BugSackFrame)

	for _, child in pairs {_G.BugSackFrame:GetChildren()} do
		local numRegions = child:GetNumRegions()

		if numRegions == 1 then
			local text = child:GetRegions()
			if text and text.SetText then
				F.SetFontOutline(text)
				text.MERStyle = true
			end
		elseif numRegions == 4 then
			S:HandleCloseButton(child)
			child.MERStyle = true
		end
	end

	S:HandleScrollBar(_G.BugSackScrollScrollBar)

	for _, region in pairs {_G.BugSackScrollText:GetRegions()} do
		if region and region.SetText then
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
		tab.backdrop:SetTemplate("Transparent")
		MER:CreateBackdropShadow(tab)

		local point, relativeTo, relativePoint, xOffset, yOffset = tab:GetPoint(1)
		tab:ClearAllPoints()
		if yOffset ~= 0 then
			yOffset = -1
		end
		tab:Point(point, relativeTo, relativePoint, xOffset, yOffset)

		local text = _G[tab:GetName() .. "Text"]
		if text then
			F.SetFontOutline(text)
		end
	end

	BugSackFrame.MERStyle = true
end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bs then return end

	module:DisableAddOnSkin("BugSack")

	module:SecureHook(_G.BugSack, "OpenSack", BugSack_Open)
end

module:AddCallbackForAddon("BugSack", LoadSkin)
