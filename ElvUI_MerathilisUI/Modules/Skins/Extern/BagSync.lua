local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local Skins = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pairs = ipairs, pairs

local hooksecurefunc = hooksecurefunc

local function SkinScrollBar(self)
	if not self then
		WF.Developer.ThrowError("scrollbar is nil")
		return
	end

	S:HandleScrollBar(self.scrollBar or self.ScrollBar)
end

local function SkinInfoFrame(self)
	if not self then
		WF.Developer.ThrowError("frame is nil")
		return
	end

	self:StripTextures()
	self:CreateBackdrop("Transparent")
	S:HandleCloseButton(self.CloseButton)
	WS:CreateShadow(self)
end

local function SkinSortOrder(self)
	if not self.UpdateList then
		WF.Developer.ThrowError("func is nil")
		return
	end

	hooksecurefunc(self, "RefreshList", function()
		local buttons = self.scrollFrame and self.scrollFrame.buttons
		if buttons then
			for _, bu in ipairs(buttons) do
				if not bu.IsSkinned then
					S:HandleEditBox(bu.SortBox)
					bu.IsSkinned = true
				end
			end
		end
	end)
end

local function SkinBagSyncFrame(name, module)
	local frame = module.frame
	if not frame then
		return
	end

	frame:StripTextures()
	S:HandleFrame(frame)
	WS:CreateShadow(frame)

	if frame.closeBtn then
		S:HandleCloseButton(frame.closeBtn)
	end

	if frame.SearchBox then
		S:HandleEditBox(frame.SearchBox)
	end

	if module.scrollFrame then
		S:HandleScrollBar(module.scrollFrame.scrollBar)
	end

	if module.warningFrame then
		SkinInfoFrame(module.warningFrame)
	end

	for _, key in ipairs({ "PlusButton", "RefreshButton", "HelpButton" }) do
		local bu = frame[key]
		if bu then
			S:HandleButton(bu)
		end
	end

	if name == "Search" then
		S:HandleButton(frame.searchFiltersBtn)
		S:HandleButton(frame.resetButton)
		SkinInfoFrame(module.helpFrame)
		SkinScrollBar(module.helpFrame.ScrollFrame)
		SkinInfoFrame(module.savedSearch)
		SkinScrollBar(module.savedSearch.scrollFrame)
		S:HandleButton(module.savedSearch.addSavedBtn)
	elseif name == "SearchFilters" then
		SkinScrollBar(module.playerScroll)
		SkinScrollBar(module.locationScroll)
		S:HandleButton(frame.selectAllButton)
		S:HandleButton(frame.resetButton)
	elseif name == "Blacklist" then
		S:HandleDropDownBox(frame.guildDD)
		S:HandleButton(frame.addGuildBtn)
		S:HandleButton(frame.addItemIDBtn)
		S:HandleEditBox(frame.itemIDBox)
	elseif name == "Whitelist" then
		S:HandleButton(frame.addItemIDBtn)
		S:HandleEditBox(frame.itemIDBox)
	elseif name == "SortOrder" then
		SkinSortOrder(module)
	end
end

function Skins:BagSync()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bSync then
		return
	end

	local BagSync = _G.BagSync
	if not BagSync then
		return
	end

	for name, module in pairs(BagSync._modulesByName) do
		SkinBagSyncFrame(name, module)
	end

	local Tooltip = BagSync:GetModule("Tooltip")
	if Tooltip then
		hooksecurefunc(Tooltip, "TallyUnits", function(self, objTooltip)
			if not self.qTip then
				return
			end

			local BPBIDTooltip
			if objTooltip == _G.FloatingBattlePetTooltip then
				BPBIDTooltip = _G["BPBID_BreedTooltip2"]
			else
				BPBIDTooltip = _G["BPBID_BreedTooltip"]
			end

			self.qTip:ClearAllPoints()
			self.qTip:SetPoint(
				"TOPRIGHT",
				BPBIDTooltip and BPBIDTooltip:IsVisible() and BPBIDTooltip or objTooltip,
				"BOTTOMRIGHT",
				0,
				2 * E.mult
			)
		end)
	end
end

Skins:AddCallbackForAddon("BagSync")
