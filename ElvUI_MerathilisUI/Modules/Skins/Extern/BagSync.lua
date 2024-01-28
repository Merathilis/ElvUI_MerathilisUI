local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

function module:BagSyncSearch()
	local Search = module.AddOn:GetModule('Search')

	S:HandleFrame(Search.frame, true)
	module:CreateBackdropShadow(Search.frame)

	S:HandleCloseButton(Search.frame.closeBtn)
	S:HandleEditBox(Search.frame.SearchBox)
	S:HandleButton(Search.frame.PlusButton)
	S:HandleButton(Search.frame.RefreshButton)
	S:HandleButton(Search.frame.HelpButton)
	S:HandleButton(Search.frame.advSearchBtn)
	S:HandleButton(Search.frame.resetButton)

	local header = Search.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end

	S:HandleFrame(Search.helpFrame, true)
	module:CreateBackdropShadow(Search.helpFrame)
	S:HandleCloseButton(Search.helpFrame.CloseButton)
	S:HandleScrollBar(Search.helpFrame.ScrollFrame.ScrollBar)

	S:HandleFrame(Search.savedSearch, true)
	module:CreateBackdropShadow(Search.savedSearch)
	S:HandleCloseButton(Search.savedSearch.CloseButton)
	S:HandleButton(Search.savedSearch.addSavedBtn)
	S:HandleScrollBar(Search.savedSearch.scrollFrame.scrollBar)
	S:HandleFrame(Search.savedSearch.scrollFrame.scrollChild)
	Search.savedSearch.scrollFrame.scrollBar.thumbTexture:SetTexture(E.media.normTex)
	Search.savedSearch.scrollFrame.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
end

function module:BagSyncAdvancedSearch()
	local adv = module.AddOn:GetModule('AdvancedSearch')

	S:HandleFrame(adv.frame, true)
	module:CreateBackdropShadow(adv.frame)

	S:HandleCloseButton(adv.frame.closeBtn)
	S:HandleEditBox(adv.frame.SearchBox)
	S:HandleButton(adv.frame.PlusButton)
	S:HandleButton(adv.frame.RefreshButton)

	S:HandleButton(adv.frame.selectAllButton)
	S:HandleButton(adv.frame.resetButton)

	local header = adv.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncCurrency()
	local Currency = module.AddOn:GetModule('Currency')

	S:HandleFrame(Currency.frame, true)
	module:CreateBackdropShadow(Currency.frame)
	S:HandleCloseButton(Currency.frame.closeBtn)

	local header = Currency.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncProfessions()
	local Professions = module.AddOn:GetModule('Professions')

	S:HandleFrame(Professions.frame, true)
	module:CreateBackdropShadow(Professions.frame)
	S:HandleCloseButton(Professions.frame.closeBtn)

	local header = Professions.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncBlacklist()
	local Blacklist = module.AddOn:GetModule('Blacklist')

	S:HandleFrame(Blacklist.frame, true)
	module:CreateBackdropShadow(Blacklist.frame)
	S:HandleCloseButton(Blacklist.frame.closeBtn)
	S:HandleDropDownBox(Blacklist.frame.guildDD)
	S:HandleButton(Blacklist.frame.addGuildBtn)
	S:HandleButton(Blacklist.frame.addItemIDBtn)
	S:HandleEditBox(Blacklist.frame.itemIDBox)

	local header = Blacklist.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncWhitelist()
	local Whitelist = module.AddOn:GetModule("Whitelist")

	S:HandleFrame(Whitelist.frame, true)
	module:CreateBackdropShadow(Whitelist.frame)
	S:HandleCloseButton(Whitelist.frame.closeBtn)
	S:HandleButton(Whitelist.frame.addItemIDBtn)
	S:HandleEditBox(Whitelist.frame.itemIDBox)

	local header = Whitelist.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end

	S:HandleFrame(Whitelist.warningFrame, true)
	module:CreateBackdropShadow(Whitelist.warningFrame)
	S:HandleCloseButton(Whitelist.warningFrame.CloseButton)
end

function module:BagSyncGold()
	local Gold = module.AddOn:GetModule('Gold')

	S:HandleFrame(Gold.frame, true)
	module:CreateBackdropShadow(Gold.frame)
	S:HandleCloseButton(Gold.frame.closeBtn)

	local header = Gold.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncProfiles()
	local Profiles = module.AddOn:GetModule('Profiles')

	S:HandleFrame(Profiles.frame, true)
	module:CreateBackdropShadow(Profiles.frame)
	S:HandleCloseButton(Profiles.frame.closeBtn)

	local header = Profiles.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
		end
	end
end

function module:BagSyncSortOrder()
	local SortOrder = module.AddOn:GetModule('SortOrder')
	S:HandleFrame(SortOrder.frame, true)
	module:CreateBackdropShadow(SortOrder.frame)
	S:HandleCloseButton(SortOrder.frame.closeBtn)

	local header = SortOrder.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group then
			if group.scrollChild then
				for itemnumber = 1, group.scrollChild:GetNumChildren() do
					local frame = select(itemnumber, group.scrollChild:GetChildren())
					if frame.SortBox then
						S:HandleEditBox(frame.SortBox)
					end
				end
			end

			if group.scrollBar then
				S:HandleScrollBar(group.scrollBar)
				group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
				group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b, 1)
			end
		end
	end

	S:HandleFrame(SortOrder.warningFrame, true)
	module:CreateBackdropShadow(SortOrder.warningFrame)
	S:HandleCloseButton(SortOrder.warningFrame.CloseButton)
end

function module:BagSyncDetails()
	local Details = module.AddOn:GetModule('Details')

	S:HandleFrame(Details.frame, true)
	module:CreateBackdropShadow(Details.frame)
	S:HandleCloseButton(Details.frame.closeBtn)

	local header = Details.frame
	for i = 1, header:GetNumChildren() do
		local group = select(i, header:GetChildren())
		if group and group.scrollBar then
			S:HandleScrollBar(group.scrollBar)
			S:HandleFrame(group)
			group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
			group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b, 1)
		end
	end
end

function module:BagSync()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bSync then
		return
	end

	-- Call the AddOn
	self.AddOn = E.Libs.AceAddon:GetAddon('BagSync')

	module:DisableAddOnSkins('BagSync', false)

	-- We need to set a delay, cause it loads very early
	E:Delay(0.1, function()
		self:BagSyncSearch()   -- Main Search
		self:BagSyncAdvancedSearch() -- Advanced Search

		--Modules
		self:BagSyncCurrency()
		self:BagSyncProfessions()
		self:BagSyncBlacklist()
		self:BagSyncWhitelist()
		self:BagSyncGold()
		self:BagSyncProfiles()
		self:BagSyncSortOrder()
		self:BagSyncDetails()
	end)
end

module:AddCallbackForAddon("BagSync")
