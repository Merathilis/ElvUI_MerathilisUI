local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local next = next

-- ClassCodexPanel and ClassCodexCompendium both anchor their section tabs as
-- plain Buttons (CreateSideTab in Core/ClassCodex.lua and UI/AnchorPane.lua)
-- using the QuestLog side-tab atlas, identified by .tabKey/.bg since neither
-- addon gives them global names.
local function SkinSideTab(tab)
	if not tab or tab.MERSkinned then
		return
	end
	tab.MERSkinned = true

	if tab.bg then
		tab.bg:SetAlpha(0)
	end

	if tab.selectedGlow then
		tab.selectedGlow:SetColorTexture(1, 0.82, 0, 0.3)
		tab.selectedGlow:SetAllPoints(tab)
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.25)
			region:SetAllPoints(tab)
		end
	end

	tab:CreateBackdrop("Transparent")
	tab.backdrop:SetAllPoints(tab)
end

local function SkinSideTabs(parent)
	for _, child in next, { parent:GetChildren() } do
		if child.tabKey and child.bg then
			SkinSideTab(child)
		end
	end
end

local function SkinFrame(frame)
	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	SkinSideTabs(frame)
end

-- Several ClassCodex frames are only created on demand (Compendium on first
-- /cc or minimap click, the talent icon when Blizzard_PlayerSpells loads), so
-- their global names don't exist yet at ADDON_LOADED. Poll for them instead.
local function WatchForGlobal(name, callback)
	local existing = _G[name]
	if existing then
		callback(existing)
		return
	end

	local ticker
	ticker = C_Timer.NewTicker(0.5, function()
		local frame = _G[name]
		if frame then
			ticker:Cancel()
			callback(frame)
		end
	end)
end

local function GetRegionByLayer(frame, layer)
	for _, region in next, { frame:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetDrawLayer() == layer then
			return region
		end
	end
end

-- Floating logo button ClassCodex docks to the top-right of PaperDollFrame.
local function SkinWidgetButton(btn)
	if not btn or btn.MERSkinned then
		return
	end
	btn.MERSkinned = true

	local icon = GetRegionByLayer(btn, "ARTWORK")
	if icon then
		S:HandleIcon(icon, true)
	end
end

-- Compare/preview icon ClassCodex docks onto PlayerSpellsFrame.TalentsFrame,
-- plus the small toast-style pill (ClassCodexTalentIconContainer) around it.
local function SkinTalentIcon(btn)
	if not btn or btn.MERSkinned then
		return
	end
	btn.MERSkinned = true

	local icon = btn.icon or GetRegionByLayer(btn, "ARTWORK")
	if icon then
		S:HandleIcon(icon, true)
	end

	local container = btn:GetParent()
	if container and not container.MERSkinned then
		container.MERSkinned = true
		container:StripTextures()
		container:CreateBackdrop("Transparent")
	end
end

function module:ClassCodex()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.classCodex then
		return
	end

	if _G.ClassCodexPanel then
		SkinFrame(_G.ClassCodexPanel)
	end

	WatchForGlobal("ClassCodexCompendium", SkinFrame)
	WatchForGlobal("ClassCodexWidgetButton", SkinWidgetButton)
	WatchForGlobal("ClassCodexTalentIcon", SkinTalentIcon)
end

module:AddCallbackForAddon("ClassCodex")
