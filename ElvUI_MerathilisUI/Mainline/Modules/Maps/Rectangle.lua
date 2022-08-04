local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_RectangleMinimap')
local MM = E:GetModule('Minimap')

local _G = _G
local floor = floor
local format = format

local InCombatLockdown = InCombatLockdown

function module:ChangeShape()
	if not self.db then
		return
	end

	if InCombatLockdown() then
		return
	end

	local Minimap = _G.Minimap
	local MMHolder = _G.MMHolder
	local MinimapPanel = _G.MinimapPanel
	local MinimapBackdrop = _G.MinimapBackdrop

	local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
	local texturePath = format("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\MinimapMasks\\%d.tga", fileID)
	local heightPct = fileID / 128
	local newHeight = E.MinimapSize * heightPct
	local diff = E.MinimapSize - newHeight
	local halfDiff = ceil(diff / 2)

	Minimap:SetClampedToScreen(true)
	Minimap:SetMaskTexture(texturePath)
	Minimap:Size(E.MinimapSize, E.MinimapSize)
	Minimap:SetHitRectInsets(0, 0, (diff / 2) * E.mult, (diff / 2) * E.mult)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	_G.MinimapMover:SetClampRectInsets(0, 0, (diff / 2) * E.mult, -(diff / 2) * E.mult)
	Minimap:ClearAllPoints()
	Minimap:Point("TOPLEFT", MMHolder, "TOPLEFT", E.Border, -E.Border + diff / 2)
	Minimap.backdrop:SetOutside(Minimap, 1, -(diff / 2) + 1)
	MinimapBackdrop:SetOutside(Minimap.backdrop)

	if _G.HybridMinimap then
		local mapCanvas = _G.HybridMinimap.MapCanvas
		local rectangleMask = _G.HybridMinimap:CreateMaskTexture()
		rectangleMask:SetTexture(texturePath)
		rectangleMask:SetAllPoints(_G.HybridMinimap)
		_G.HybridMinimap.RectangleMask = rectangleMask
		mapCanvas:SetMaskTexture(rectangleMask)
		mapCanvas:SetUseMaskTexture(true)
	end

	if Minimap.location then
		Minimap.location:ClearAllPoints()
		Minimap.location:Point("TOP", MMHolder, "TOP", 0, -5)
	end

	if MinimapPanel:IsShown() then
		MinimapPanel:ClearAllPoints()
		MinimapPanel:Point("TOPLEFT", Minimap, "BOTTOMLEFT", -E.Border, (E.PixelMode and 0 or -3) + halfDiff)
		MinimapPanel:Point("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", E.Border, -23 + halfDiff)
	end

	self:MMHolder_Size()
end

do
	local isRunning
	function module:MMHolder_Size()
		if isRunning then
			return
		end

		isRunning = true

		local MinimapPanel = _G.MinimapPanel
		local MMHolder = _G.MMHolder

		local fileID = self.db.enable and self.db.heightPercentage and floor(self.db.heightPercentage * 128) or 128
		local newHeight = E.MinimapSize * fileID / 128

		local borderWidth, borderHeight = E.PixelMode and 2 or 6, E.PixelMode and 2 or 8
		local panelSize, joinPanel =
			(MinimapPanel:IsShown() and MinimapPanel:GetHeight()) or (E.PixelMode and 1 or -1),
			1
		local holderHeight = newHeight + (panelSize - joinPanel)

		MMHolder:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)
		_G.MinimapMover:Size(E.MinimapSize + borderWidth, holderHeight + borderHeight)

		isRunning = false
	end
end

function module:SetUpdateHook()
	if not self.Initialized then
		self:SecureHook(MM, "SetGetMinimapShape", "ChangeShape")
		self:SecureHook(MM, "UpdateSettings", "ChangeShape")
		self:SecureHook(MM, "Initialize", "ChangeShape")
		self:SecureHook(E, "UpdateAll", "ChangeShape")
		self:SecureHook(_G.MMHolder, "Size", "MMHolder_Size")

		self.Initialized = true
	end

	self:ChangeShape()
	E:Delay(1, self.ChangeShape, self)
end

function module:PLAYER_ENTERING_WORLD()
	if self.initialized then
		E:Delay(1, self.ChangeShape, self)
	else
		self:SetUpdateHook()
	end
end

function module:ADDON_LOADED(_, addon)
	if addon == "Blizzard_HybridMinimap" then
		self:ChangeShape()
		self:UnregisterEvent('ADDON_LOADED')
	end
end

function module:AdjustSettings()
	if not E.db.mui.maps.minimap.rectangleMinimap.enable then return end

	if not E.db.movers then
		E.db.movers = {}
	end

	E.db["mui"]["maps"]["minimap"]["rectangleMinimap"]["enable"] = true
	E.db["mui"]["maps"]["minimap"]["rectangleMinimap"]["heightPercentage"] = 0.68

	E.db["general"]["minimap"]["size"] = 212
	E.db["general"]["minimap"]["icons"]["classHall"]["yOffset"] = -60
	E.db["general"]["minimap"]["icons"]["mail"]["yOffset"] = 30
	E.db["general"]["minimap"]["icons"]["difficulty"]["yOffset"] = -40
	E.db["general"]["minimap"]["icons"]["lfgEye"]["yOffset"] = 30
	E.db["movers"]["MinimapMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-4,47"

	E.db["movers"]["VehicleSeatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-489,116"
	E.db["movers"]["AutoButtonBar1Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-19,197"
	E.db["movers"]["AutoButtonBar2Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-19,232"
	E.db["movers"]["AutoButtonBar3Mover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-19,267"

	E.db["chat"]["panelWidthRight"] = 235
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-219,47"

	E.db["bags"]["bagWidth"] = 449

	if E.global["datatexts"]["customPanels"]["MER_RightChatTop"] then
		E.global["datatexts"]["customPanels"]["MER_RightChatTop"]["numPoints"] = 2
		E.global["datatexts"]["customPanels"]["MER_RightChatTop"]["width"] = 235
		E.db["datatexts"]["panels"]["MER_RightChatTop"] = {
			[1] = "Durability",
			[2] = "Gold",
			["enable"] = true,
		}
	end
end

function module:Initialize()
	self.db = E.db.mui.maps.minimap.rectangleMinimap

	if not self.db or not self.db.enable then
		return
	end

	-- Only adjust the settings for me
	if F.IsDeveloper() and F.IsDeveloperRealm() then
		module:AdjustSettings()
	end

	self:RegisterEvent('ADDON_LOADED')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function module:ProfileUpdate()
	self.db = E.db.mui.maps.minimap.rectangleMinimap

	if not self.db then
		return
	end

	if self.db.enable then
		self:SetUpdateHook()
	else
		self:ChangeShape()
	end
end

MER:RegisterModule(module:GetName())
