local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

function module:HomeBound()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.homeBound then
		return
	end

	local mainFrame = _G.HB_MainFrame
	S:HandleFrame(mainFrame)

	local supportFrame = _G.HB_SupportFrame
	S:HandleFrame(supportFrame)

	--[[
		ToDO: Skin the MainFrame Close Button, Tooltip sutff
	]]

	for _, child in pairs({ _G.HB_MainFrame:GetChildren() }) do
		local objectType = child.GetObjectType and child:GetObjectType()
		if objectType == "Button" and child.Text and child:GetText() then
			S:HandleButton(child, true)
		elseif objectType == "CheckButton" then
			S:HandleCheckBox(child)
		elseif objectType == "Slider" then
			S:HandleSliderFrame(child)
		elseif objectType == "ScrollFrame" then
			local scrollBar = child.ScrollBar
			if scrollBar then
				S:HandleScrollBar(scrollBar)
				if scrollBar.backdrop then
					scrollBar.backdrop:Hide()
				end
			end
		end
	end

	for _, child in pairs({ _G.HB_SupportFrame:GetChildren() }) do
		local objectType = child.GetObjectType and child:GetObjectType()
		if objectType == "Button" then -- currently only one Button
			S:HandleCloseButton(child)
		elseif objectType == "EditBox" then
			S:HandleEditBox(child)
		end
	end
end

module:AddCallbackForAddon("HomeBound")
