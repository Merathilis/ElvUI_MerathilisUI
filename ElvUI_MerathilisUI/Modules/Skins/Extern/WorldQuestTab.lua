local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local next = next
local hooksecurefunc = hooksecurefunc

local function PositionTabIcons(icon, _, anchor)
	if anchor then
		icon:SetPoint("CENTER")
	end
end

-- Copy from ElvUI WorldMap skin
local function reskinTab(tab)
	if not tab then
		return
	end

	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		tab.Icon:ClearAllPoints()
		tab.Icon:Point("CENTER")

		hooksecurefunc(tab.Icon, "SetPoint", PositionTabIcons)
	end

	if tab.Background then
		tab.Background:SetAlpha(0)
	end

	if tab.SelectedTexture then
		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
		tab.SelectedTexture:SetAllPoints()
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.3)
			region:SetAllPoints()
		end
	end

	if tab.backdrop then
		module:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end
end

local function reskinQuestButton(frame)
	if not frame or frame.__MERSkin then
		return
	end

	frame.Bg:SetTexture(E.media.blankTex)
	frame.Bg:SetVertexColor(1, 1, 1, 0.1)

	frame.Highlight:StripTextures()
	local tex = frame.Highlight:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(E.media.blankTex)
	tex:SetVertexColor(1, 1, 1, 0.2)
	tex:SetAllPoints(frame.Bg)
	frame.Highlight.MERTex = tex
end

local function reskinQuestContainer(container)
	S:HandleDropDownBox(container.SortDropdown)
	S:HandleButton(container.FilterDropdown, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true, "right")

	S:HandleTrimScrollBar(container.ScrollBar)

	hooksecurefunc(container.QuestScrollBox, "Update", function(scrollBox)
		scrollBox:ForEachFrame(reskinQuestButton)
	end)

	container:CreateBackdrop("Transparent")
	container.Background:Hide()
	container.BorderFrame:Hide()
	container.FilterBar:StripTextures()
end

local function reskinWhatsNew(container)
	container.BorderFrame:Hide()
	container.Background:Hide()
	container:CreateBackdrop("Transparent")
	container.backdrop:SetOutside(container.Background)

	S:HandleCloseButton(container.CloseButton)
	container.CloseButton:Size(20, 20)
	S:HandleTrimScrollBar(container.ScrollBar)
end

local function reskinSetting(container) end

function module:WorldQuestTab()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wqt then
		return
	end

	local WQT_QuestMapTab = _G.WQT_QuestMapTab

	if WQT_QuestMapTab then
		reskinTab(WQT_QuestMapTab)
		WQT_QuestMapTab.__SetPoint = WQT_QuestMapTab.SetPoint

		-- hooksecurefunc(WQT_QuestMapTab, "SetPoint", function() -- C Stack error
		-- F.MoveFrameWithOffset(WQT_QuestMapTab, 0, -2)
		-- end)
	end

	if _G.WQT_ListContainer then
		reskinQuestContainer(_G.WQT_ListContainer)
	end

	if _G.WQT_WhatsNewFrame then
		reskinWhatsNew(_G.WQT_WhatsNewFrame)
	end

	if _G.WQT_SettingsFrame then
		reskinSetting(_G.WQT_SettingsContainer)
	end
end

module:AddCallbackForAddon("WorldQuestTab")
