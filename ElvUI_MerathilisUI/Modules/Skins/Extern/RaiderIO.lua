local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local LibStub = _G.LibStub

local skinned = false
function module:RaiderIO_DelayedSkinning()
	if skinned then
		return
	end

	local RaiderIO_ProfileTooltip = _G.RaiderIO_ProfileTooltip

	skinned = true
	if RaiderIO_ProfileTooltip then
		-- SetTemplate/Shadow is handled with tt:SetStyle: FrameXML/GameTooltip
		local point, relativeTo, relativePoint, xOffset, yOffset = RaiderIO_ProfileTooltip:GetPoint()
		if xOffset and yOffset and xOffset == 0 and yOffset == 0 then
			RaiderIO_ProfileTooltip.__SetPoint = RaiderIO_ProfileTooltip.SetPoint
			hooksecurefunc(
				RaiderIO_ProfileTooltip,
				"SetPoint",
				function(self, point, relativeTo, relativePoint, xOffset, yOffset)
					if xOffset and yOffset and xOffset == 0 and yOffset == 0 then
						self:__SetPoint(point, relativeTo, relativePoint, 4, 0)
					end
				end
			)
		end
	end

	local RaiderIO_SearchFrame = _G.RaiderIO_SearchFrame
	if RaiderIO_SearchFrame then
		RaiderIO_SearchFrame:StripTextures()
		RaiderIO_SearchFrame:SetTemplate("Transparent")
		module:CreateShadow(RaiderIO_SearchFrame)
		S:HandleCloseButton(RaiderIO_SearchFrame.close)

		for _, child in pairs({ RaiderIO_SearchFrame:GetChildren() }) do
			local numRegions = child:GetNumRegions()
			if numRegions == 9 then
				if child and child:GetObjectType() == "EditBox" then
					if not child.IsSkinned then
						child:DisableDrawLayer("BACKGROUND")
						child:DisableDrawLayer("BORDER")
						S:HandleEditBox(child)
						child:SetTextInsets(2, 2, 2, 2)
						child:SetHeight(30)

						if child:GetNumPoints() == 1 then
							local point, relativeTo, relativePoint, xOffset, yOffset = child:GetPoint(1)
							yOffset = -3
							child:ClearAllPoints()
							child:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
						end

						child.IsSkinned = true
					end
				end
			end
		end
	end

	local configFrame
	for _, frame in pairs({ _G.UIParent:GetChildren() }) do
		if frame.scrollbar and frame.scrollframe then
			for _, child in pairs({ frame:GetChildren() }) do
				if child ~= frame.scrollbar and child ~= frame.scrollframe then
					local numChildren = child.GetNumChildren and child:GetNumChildren()
					if numChildren then
						if numChildren == 1 then
							frame.titleFrame = child
							local title = child:GetChildren(1)
							local titleText = title and title.text and title.text:GetText()
							if titleText and strfind(titleText, "Raider.IO") then
								configFrame = frame
							end
						elseif numChildren == 3 then
							frame.buttonFrame = child
						end
					end
				end
			end
		end
	end

	if configFrame then
		configFrame:SetTemplate("Transparent")
		module:CreateShadow(configFrame)

		S:HandleScrollBar(configFrame.scrollbar)

		for _, frame in pairs({ configFrame.buttonFrame:GetChildren() }) do
			if frame:GetObjectType() == "Button" then
				frame:SetScript("OnEnter", nil)
				frame:SetScript("OnLeave", nil)
				F.SetFontOutline(frame.text)
				S:HandleButton(frame)
				frame.Center:Show()
			end
		end

		if configFrame.scrollframe and configFrame.scrollframe.content then
			for _, line in pairs({ configFrame.scrollframe.content:GetChildren() }) do
				for _, child in pairs({ line:GetChildren() }) do
					if child:GetObjectType() == "CheckButton" then
						S:HandleCheckBox(child)
					end
				end
			end
		end
	end
end

function module:RaiderIO_GuildWeeklyFrame()
	E:Delay(0.15, function()
		if _G.RaiderIO_GuildWeeklyFrame then
			local frame = _G.RaiderIO_GuildWeeklyFrame
			frame:StripTextures()
			frame:SetTemplate("Transparent")
			F.SetFontOutline(frame.Title)
			frame.Title:SetShadowColor(0, 0, 0, 0)
			F.SetFontOutline(frame.SubTitle)
			frame.SubTitle:SetShadowColor(0, 0, 0, 0)
			frame.SwitchGuildBest:SetSize(18, 18)
			S:HandleCheckBox(frame.SwitchGuildBest)
		end
	end)
end

function module:RaiderIO()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rio then
		return
	end

	module:DisableAddOnSkins("RaiderIO", false)
	module:AddCallbackForEnterWorld("RaiderIO_DelayedSkinning")
	module:SecureHook(_G.PVEFrame, "Show", "RaiderIO_GuildWeeklyFrame")
end

module:AddCallbackForAddon("RaiderIO")
