local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local pairs, select = pairs, select

local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function ResultOnEnter(self)
	self.hl:Show()
end

local function ResultOnLeave(self)
	self.hl:Hide()
end

local function HeaderOnEnter(self)
	self.hl:Show()
end

local function HeaderOnLeave(self)
	self.hl:Hide()
end

local function LoadSkin()
	if not module:CheckDB("lfg", "lfg") then
		return
	end

	local LFGListFrame = _G.LFGListFrame

	S:HandleButton(_G.LFGListFrame.SearchPanel.ScrollBox.StartGroupButton)

	-- Category selection
	local CategorySelection = LFGListFrame.CategorySelection

	CategorySelection.Inset.Bg:Hide()
	CategorySelection.Inset:DisableDrawLayer("BORDER")

	hooksecurefunc("LFGListCategorySelection_AddButton", function(self, btnIndex)
		local bu = self.CategoryButtons[btnIndex]

		if bu then
			if not bu.__MERSkin then
				bu.Icon:SetTexCoord(.01, .99, .01, .99)
				module:CreateGradient(bu)
				bu.__MERSkin = true
			end
		end
	end)

	_G.LFGListInviteDialog.GroupName:ClearAllPoints()
	_G.LFGListInviteDialog.GroupName:SetPoint("TOP", 0, -33)

	_G.LFGListInviteDialog.ActivityName:ClearAllPoints()
	_G.LFGListInviteDialog.ActivityName:SetPoint("TOP", 0, -80)

	-- Nothing available
	local NothingAvailable = LFGListFrame.NothingAvailable
	NothingAvailable.Inset:DisableDrawLayer("BORDER")

	-- [[ Search panel ]]
	local SearchPanel = LFGListFrame.SearchPanel

	SearchPanel.ResultsInset.Bg:Hide()
	SearchPanel.ResultsInset:DisableDrawLayer("BORDER")

	-- Auto complete frame
	SearchPanel.AutoCompleteFrame.BottomLeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomRightBorder:Hide()
	SearchPanel.AutoCompleteFrame.BottomBorder:Hide()
	SearchPanel.AutoCompleteFrame.LeftBorder:Hide()
	SearchPanel.AutoCompleteFrame.RightBorder:Hide()

	local numResults = 1
	hooksecurefunc("LFGListSearchPanel_UpdateAutoComplete", function(self)
		local AutoCompleteFrame = self.AutoCompleteFrame

		for i = numResults, #AutoCompleteFrame.Results do
			local result = AutoCompleteFrame.Results[i]

			if numResults == 1 then
				result:SetPoint("TOPLEFT", AutoCompleteFrame.LeftBorder, "TOPRIGHT", -8, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.RightBorder, "TOPLEFT", 5, 1)
			else
				result:SetPoint("TOPLEFT", AutoCompleteFrame.Results[i-1], "BOTTOMLEFT", 0, 1)
				result:SetPoint("TOPRIGHT", AutoCompleteFrame.Results[i-1], "BOTTOMRIGHT", 0, 1)
			end

			result:SetNormalTexture("")
			result:SetPushedTexture("")
			result:SetHighlightTexture("")

			local hl = result:CreateTexture(nil, "BACKGROUND")
			hl:SetAllPoints()
			hl:SetTexture(E["media"].normTex)
			hl:SetVertexColor(r, g, b, .2)
			hl:Hide()
			result.hl = hl

			result:CreateBackdrop('Transparent')

			result:HookScript("OnEnter", ResultOnEnter)
			result:HookScript("OnLeave", ResultOnLeave)

			numResults = numResults + 1
		end
	end)

	-- Application viewer
	local ApplicationViewer = LFGListFrame.ApplicationViewer

	ApplicationViewer.InfoBackground:Hide()

	ApplicationViewer.Inset.Bg:Hide()
	ApplicationViewer.Inset:DisableDrawLayer("BORDER")

	for _, headerName in pairs({"NameColumnHeader", "RoleColumnHeader", "ItemLevelColumnHeader"}) do
		local header = ApplicationViewer[headerName]
		header.Left:Hide()
		header.Middle:Hide()
		header.Right:Hide()

		header:SetHighlightTexture("")

		local hl = header:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints()
		hl:SetTexture(E["media"].normTex)
		hl:SetVertexColor(r, g, b, .2)
		hl:Hide()
		header.hl = hl

		header:CreateBackdrop('Transparent')

		header:HookScript("OnEnter", HeaderOnEnter)
		header:HookScript("OnLeave", HeaderOnLeave)
	end

	ApplicationViewer.RoleColumnHeader:SetPoint("LEFT", ApplicationViewer.NameColumnHeader, "RIGHT", 1, 0)
	ApplicationViewer.ItemLevelColumnHeader:SetPoint("LEFT", ApplicationViewer.RoleColumnHeader, "RIGHT", 1, 0)

	-- Entry creation
	local EntryCreation = LFGListFrame.EntryCreation

	EntryCreation.Inset.Bg:Hide()
	EntryCreation.Inset:DisableDrawLayer("BORDER")

	for i = 1, 9 do
		select(i, EntryCreation.Description:GetRegions()):Hide()
	end

	-- Activity finder
	local ActivityFinder = EntryCreation.ActivityFinder

	ActivityFinder.Background:SetTexture("")
	ActivityFinder.Dialog.Bg:Hide()
	for i = 1, 9 do
		select(i, ActivityFinder.Dialog.BorderFrame:GetRegions()):Hide()
	end

	ActivityFinder.Dialog:CreateBackdrop('Transparent')
	ActivityFinder.Dialog:SetBackdropColor(.2, .2, .2, .9)

	-- Application dialog ]]
	local LFGListApplicationDialog = _G.LFGListApplicationDialog
	LFGListApplicationDialog:Styling()

	for i = 1, 9 do
		select(i, LFGListApplicationDialog.Description:GetRegions()):Hide()
	end

	LFGListApplicationDialog:CreateBackdrop('Transparent')
	LFGListApplicationDialog.Description:CreateBackdrop('Transparent')

	-- [[ Invite dialog ]]
	local LFGListInviteDialog = _G.LFGListInviteDialog
	LFGListInviteDialog:CreateBackdrop('Transparent')
end

S:AddCallback("LFGList", LoadSkin)
