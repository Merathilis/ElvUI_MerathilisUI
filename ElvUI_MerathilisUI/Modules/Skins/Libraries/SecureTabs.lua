local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local pairs = pairs

local function reskinTab(lib, panel)
	if lib.tabs[panel] then
		for _, tab in pairs(lib.tabs[panel]) do
			F.WaitFor(function()
				return E.private.mui and E.private.mui.skins and E.private.mui.skins.libraries
			end, function()
				if not E.private.mui.skins.libraries.secureTabs then
					return
				end

				if not tab.__MERSkin then
					module:Proxy("HandleTab", tab)
					module:ReskinTab(tab)
					tab:Hide()
					tab:Show()
					tab.__MERSkin = true
				end
			end)
		end
	end
end

local function reskinCoverTab(lib, panel)
	local cover = lib.covers[panel]
	F.WaitFor(function()
		return E.private.mui and E.private.mui.skins and E.private.mui.skins.libraries
	end, function()
		if not E.private.mui.skins.libraries.secureTabs then
			return
		end

		if cover and not cover.__MERSkin then
			module:Proxy("HandleTab", cover)
			cover.backdrop.Center:SetAlpha(0)
			cover:SetPushedTextOffset(0, 0)
			cover.__MERSkin = true
		end
	end)
end

function module:SecureTabs(lib)
	if lib.Add and lib.Update then
		self:SecureHook(lib, "Add", reskinTab)
		self:SecureHook(lib, "Update", reskinCoverTab)
	end

	if lib.tabs then
		for panel in pairs(lib.tabs) do
			reskinTab(lib, panel)
		end
	end

	if lib.covers then
		for panel in pairs(lib.covers) do
			reskinCoverTab(lib, panel)
		end
	end
end

module:AddCallbackForLibrary("SecureTabs-2.0", "SecureTabs")
