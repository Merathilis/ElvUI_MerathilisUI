local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:BugSack_OpenSack()
	-- Credits to Luckyone for the initial idea
	local bugSackFrame = _G.BugSackFrame
	if not bugSackFrame or bugSackFrame.__MERVersionLabel then
		return
	end

	local countLabel
	for i = 1, bugSackFrame:GetNumRegions() do
		local region = select(i, bugSackFrame:GetRegions())
		if region and region:IsObjectType("FontString") and region:GetJustifyH() == "RIGHT" then
			countLabel = region
			break
		end
	end

	if countLabel then
		local _, elvVersion = E:ParseVersionString("ElvUI")
		local classColor = E:ClassColor(E.myclass)
		local hex = E:RGBToHex(classColor.r, classColor.g, classColor.b, "|cff")
		local versionLabel = bugSackFrame:CreateFontString(nil, "ARTWORK")
		versionLabel:SetFontObject(countLabel:GetFontObject())
		versionLabel:SetTextColor(countLabel:GetTextColor())
		versionLabel:SetText(
			format(
				"%sElvUI:|r %s %sWindTools:|r %s %sMerathilisUI:|r %s %sPage:|r",
				hex,
				elvVersion,
				hex,
				W.DisplayVersion,
				hex,
				MER.DisplayVersion,
				hex
			)
		)
		versionLabel:SetPoint("RIGHT", countLabel, "LEFT", -6, 0)
		bugSackFrame.__MERVersionLabel = versionLabel
	end
end

function module:BugSack()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bugSack then
		return
	end

	if not _G.BugSack then
		return
	end

	-- BugSack creates its frame lazily on the first open
	module:SecureHook(_G.BugSack, "OpenSack", "BugSack_OpenSack")
end

module:AddCallbackForAddon("BugSack")
