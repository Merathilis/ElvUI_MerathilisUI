local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")

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

function module:BagSync()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bSync then
		return
	end

	local BagSync = _G.BagSync
	if not BagSync then
		return
	end

	for name, modules in pairs(BagSync._modulesByName) do
		SkinBagSyncFrame(name, modules)
	end

	local ExtTip = BagSync:GetModule("ExtTip")
	if ExtTip then
		F:SecureHook(ExtTip, "EnsureTip", function(self)
			TT:SetStyle(self.extTip)
		end)
	end
end

module:AddCallbackForAddon("BagSync")
