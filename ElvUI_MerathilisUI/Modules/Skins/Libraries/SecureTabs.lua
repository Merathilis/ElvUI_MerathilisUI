local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local pairs = pairs
local tInsertUnique = tInsertUnique

function module:ReskinSecureTabs(lib, panel)
	if lib.tabs[panel] then
		for _, tab in pairs(lib.tabs[panel]) do
			if not tab.__MER then
				self:HandleTab(tab)
			end
		end
	end

	if lib.covers[panel] then
		for _, cover in pairs(lib.covers[panel]) do
			if not cover.__MER then
				S:HandleTab(cover)
			end
		end
	end
end

function module:SecureTabs(lib)
	if lib.Add and lib.Update then
		E:Delay(2, print, 1)
		self:SecureHook(lib, "Add", "ReskinSecureTabs")
		self:SecureHook(lib, "Update", "ReskinSecureTabs")
	end

	local existingPanel = {}
	for panel in pairs(lib.tabs) do
		tInsertUnique(existingPanel, panel)
	end
	for panel in pairs(lib.covers) do
		tInsertUnique(existingPanel, panel)
	end

	for _, panel in pairs(existingPanel) do
		self:ReskinSecureTabs(lib, panel)
	end
end

module:AddCallbackForLibrary("SecureTabs-2.0", "SecureTabs")
