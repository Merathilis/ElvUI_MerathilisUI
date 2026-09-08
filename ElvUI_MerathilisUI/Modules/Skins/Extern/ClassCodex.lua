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
	tab.backdrop:SetInside(tab)
end

-- Side tabs dock against the panel's TOPRIGHT/BOTTOMRIGHT with a hardcoded
-- SIDE_TAB_ANCHOR_X = -3 (Core/ClassCodex.lua, UI/AnchorPane.lua), slightly
-- overlapping the panel edge by design. ElvUI's border/shadow around the
-- panel eats into that 3px, so the tabs read as touching/overlapping it.
-- ClassCodex re-applies that same hardcoded SetPoint on every relayout (tab
-- switch, drag reorder, visibility update), which wipes a one-off correction,
-- so hook SetPoint itself and re-add the extra gap on every call instead.
local SIDE_TAB_FRAME_GAP = 4

local function ApplySideTabFrameGap(tab, frame, point, relativeTo, relativePoint, xOfs, yOfs)
	if relativeTo ~= frame or not relativePoint then
		return
	end

	local direction = relativePoint:find("RIGHT") and 1 or (relativePoint:find("LEFT") and -1)
	if not direction then
		return
	end

	tab.MERGapAdjusting = true
	tab:SetPoint(point, relativeTo, relativePoint, (xOfs or 0) + direction * SIDE_TAB_FRAME_GAP, yOfs or 0)
	tab.MERGapAdjusting = false
end

local function HookSideTabGap(tab, frame)
	if tab.MERGapHooked then
		return
	end
	tab.MERGapHooked = true

	ApplySideTabFrameGap(tab, frame, tab:GetPoint(1))

	hooksecurefunc(tab, "SetPoint", function(self, point, relativeTo, relativePoint, xOfs, yOfs)
		if self.MERGapAdjusting then
			return
		end
		ApplySideTabFrameGap(self, frame, point, relativeTo, relativePoint, xOfs, yOfs)
	end)
end

local function SkinSideTabs(parent)
	for _, child in next, { parent:GetChildren() } do
		if child.tabKey and child.bg then
			SkinSideTab(child)
			HookSideTabGap(child, parent)
		end
	end
end

local function SkinFrame(frame)
	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	SkinSideTabs(frame)

	if not frame.MEROnShowHooked then
		frame.MEROnShowHooked = true
		-- Catches any side tab created/added after this initial pass (both
		-- SkinSideTab and HookSideTabGap no-op on ones already handled).
		frame:HookScript("OnShow", SkinSideTabs)
	end
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
