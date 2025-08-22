local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

local C_Timer_After = C_Timer.After

function module:SilverDragon()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.sd then
		return
	end

	self:DisableAddOnSkins("SilverDragon")

	local SilverDragon = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
	if not SilverDragon then
		return
	end

	-- Setup popup styling
	local clickModule = SilverDragon:GetModule("ClickTarget", true)
	if clickModule then
		self:SetupSilverDragonPopups(clickModule)
	end

	-- Setup other UI elements
	self:SetupSilverDragonHistory(SilverDragon)
	self:SetupSilverDragonOverlay(SilverDragon)
end

-- Common styling utilities
function module:StyleSilverDragonText(fontString, size, color)
	if not fontString then
		return
	end

	F.SetFontOutline(fontString)
	fontString:SetFont(E.LSM:Fetch("font", E.db.general.font), size, "OUTLINE")
	fontString:SetTextColor(color and unpack(color) or 1, 1, 1, 1)
	fontString:SetShadowOffset(1, -1)
	fontString:SetShadowColor(0, 0, 0, 0.8)
end

function module:StyleSilverDragonFrame(frame, withShadow)
	if not frame or frame.__MERToolsStyled then
		return
	end

	S:HandleFrame(frame)
	if withShadow then
		self:CreateShadow(frame)
	end
	frame.__MERToolsStyled = true
end

function module:SetupSilverDragonPopups(module)
	-- Register the ElvUI_MerathilisUI look
	function module.Looks:ElvUI_MerathilisUI(popup, config)
		module:StyleSilverDragonPopup(popup, module)
	end

	-- Register look configuration
	module:RegisterLookConfig("ElvUI_MerathilisUI", {
		classcolor = {
			type = "toggle",
			name = "Class colored border",
			desc = "Color the border of the popup by your class color",
		},
		background = { type = "color", name = "Background color", hasAlpha = true },
	}, {
		classcolor = false,
		background = { 0, 0, 0, 0.8 },
	}, function(_, popup, config)
		module:ConfigureSilverDragonPopup(popup, config, module)
	end)

	-- Set default style if needed
	if module.db.profile.style == "SilverDragon" then
		module.db.profile.style = "ElvUI_MerathilisUI"
	end
end

function module:StyleSilverDragonPopup(popup, module)
	-- Style the main frame
	S:HandleFrame(popup)
	self:CreateShadow(popup)

	-- Style elements
	self:StyleSilverDragonPopupElements(popup)

	-- Override source text behavior
	popup.SetSource = function(_, source)
		if module.db.profile.model then
			popup.source:SetText(source or "")
		else
			popup.source:SetText(source and source:sub(0, 1) or "")
		end
	end
end

function module:StyleSilverDragonPopupElements(popup)
	-- Background
	if popup.background then
		popup.background:SetAllPoints()
	end

	-- Close button
	if popup.close then
		S:HandleCloseButton(popup.close)
		popup.close:ClearAllPoints()
		popup.close:SetFrameLevel(popup:GetFrameLevel() + 2)
		popup.close:Point("TOPRIGHT", popup, "TOPRIGHT", -3, -3)
		popup.close:SetSize(18, 18)
		if popup.close.backdrop then
			self:CreateShadow(popup.close.backdrop)
		end
	end

	-- Loot icon
	if popup.lootIcon then
		S:HandleButton(popup.lootIcon)
		if popup.lootIcon.backdrop then
			popup.lootIcon.backdrop:SetOutside(popup.lootIcon.texture)
		end
		popup.lootIcon.texture:SetAtlas("VignetteLoot")
		popup.lootIcon:HookScript("OnClick", function()
			C_Timer_After(0.1, function()
				if popup.lootIcon.window then
					module:StyleSilverDragonLootWindow(popup.lootIcon.window)
				end
			end)
		end)
	end

	-- Text elements
	self:StyleSilverDragonText(popup.title, E.db.general.fontSize + 2)
	self:StyleSilverDragonText(popup.source, E.db.general.fontSize - 1, { 0.8, 0.8, 0.8, 1 })
	self:StyleSilverDragonText(popup.status, E.db.general.fontSize, { 1, 0.8, 0, 1 })
	if popup.lootIcon and popup.lootIcon.count then
		self:StyleSilverDragonText(popup.lootIcon.count, E.db.general.fontSize - 2)
	end

	-- Visual effects
	if popup.glow then
		popup.glow:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
		popup.glow:SetAllPoints()
	end
	if popup.shine then
		popup.shine:Point("TOPLEFT", 0, 0)
		popup.shine:Point("BOTTOMLEFT", 0, 0)
		popup.shine:SetWidth(32)
	end
	if popup.dead then
		popup.dead:SetAtlas([[XMarksTheSpot]])
		popup.dead:SetAlpha(0)
	end
	if popup.raidIcon then
		popup.raidIcon:SetSize(20, 20)
		popup.raidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	end
end

function module:ConfigureSilverDragonPopup(popup, config, module)
	-- Set background color
	local r, g, b, a = unpack(config.background)
	popup:SetBackdropColor(r, g, b, a)

	-- Set border color
	if config.classcolor then
		local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
		if classColor then
			popup:SetBackdropBorderColor(classColor:GetRGB())
		end
	else
		popup:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	-- Layout elements based on model setting
	popup.title:ClearAllPoints()
	popup.status:ClearAllPoints()
	popup.source:ClearAllPoints()

	if module.db.profile.model then
		self:LayoutSilverDragonWithModel(popup, module)
	else
		self:LayoutSilverDragonCompact(popup)
	end

	-- Style loot icon backdrop
	if popup.lootIcon and popup.lootIcon.backdrop then
		popup.lootIcon.backdrop:SetBackdropColor(0, 0, 0, 0.6)
		popup.lootIcon.backdrop:SetBackdropBorderColor(0.8, 0.6, 0, 1)
	end
end

function module:LayoutSilverDragonWithModel(popup, module)
	popup:SetSize(276, 80)
	popup.model:Show()

	popup.modelbg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
	popup.modelbg:SetVertexColor(0.2, 0.2, 0.2, 0.8)
	popup.modelbg:Point("TOPLEFT", 2, -2)
	popup.modelbg:Point("BOTTOMLEFT", 2, 2)
	popup.modelbg:SetWidth(popup:GetHeight() - 4)
	module:SizeModel(popup, 0, 0)

	popup.title:Point("TOPLEFT", popup.modelbg, "TOPRIGHT", 8, -8)
	popup.title:Point("TOPRIGHT", popup, "TOPRIGHT", -25, -8)
	popup.status:Point("TOPLEFT", popup.title, "BOTTOMLEFT", 0, -4)
	popup.status:Point("TOPRIGHT", popup.title, "BOTTOMRIGHT", 0, -4)
	popup.source:Point("BOTTOMRIGHT", -8, 4)

	popup.raidIcon:Point("BOTTOM", popup.modelbg, "TOP", 0, 2)
	popup.lootIcon:Point("BOTTOMLEFT", popup.modelbg, "BOTTOMLEFT", -2, -2)
	popup.lootIcon:SetSize(24, 24)

	popup.dead:SetAllPoints(popup.modelbg)
	popup.shine.animIn.translate:SetOffset(240, 0)
end

function module:LayoutSilverDragonCompact(popup)
	popup:SetSize(240, 50)
	popup.model:Hide()

	popup.title:Point("TOPLEFT", popup, "TOPLEFT", 8, -8)
	popup.title:Point("TOPRIGHT", popup, "TOPRIGHT", -25, -8)
	popup.status:Point("BOTTOM", 0, 8)
	popup.status:SetJustifyH("CENTER")
	popup.source:Point("BOTTOMRIGHT", -8, 4)

	popup.raidIcon:Point("BOTTOM", popup.title, "TOP", 0, 2)
	popup.lootIcon:Point("BOTTOMLEFT", 4, 4)
	popup.lootIcon:SetSize(20, 20)

	popup.dead:SetAllPoints(popup)
	popup.shine.animIn.translate:SetOffset(180, 0)
end

function module:StyleSilverDragonLootWindow(lootWindow)
	if not lootWindow or lootWindow.__MERToolsStyled then
		return
	end

	-- Style frame
	self:StyleSilverDragonFrame(lootWindow, true)

	-- Style title
	if lootWindow.title then
		self:StyleSilverDragonText(lootWindow.title, E.db.general.fontSize)
	end

	-- Style close button
	if lootWindow.close then
		S:HandleCloseButton(lootWindow.close)
		lootWindow.close:SetSize(18, 18)
		lootWindow.close:ClearAllPoints()
		lootWindow.close:Point("TOPRIGHT", lootWindow, "TOPRIGHT", -4, -4)
	end
end

function module:SetupSilverDragonHistory(silverDragon)
	local historyModule = silverDragon:GetModule("History", true)
	if not historyModule then
		return
	end

	-- Style existing window if it exists
	if historyModule.window then
		self:StyleSilverDragonHistoryWindow(historyModule.window)
	end

	-- Hook window creation for future styling
	if historyModule.ShowWindow then
		local originalShowWindow = historyModule.ShowWindow
		historyModule.ShowWindow = function(module, ...)
			local result = originalShowWindow(module, ...)
			if module.window then
				self:StyleSilverDragonHistoryWindow(module.window)
			end
			return result
		end
	end
end

function module:StyleSilverDragonHistoryWindow(frame)
	if not frame or frame.__MERToolsStyled then
		return
	end

	-- Style main frame
	self:StyleSilverDragonFrame(frame, true)

	-- Style title
	if frame.title then
		self:StyleSilverDragonText(frame.title, E.db.general.fontSize)
	end

	-- Fix dragon textures
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			local texture = region:GetTexture()
			if texture and type(texture) == "string" and texture:find("Dragon") then
				region:SetTexCoord(unpack(E.TexCoords))
			end
		end
	end

	-- Style resize button
	if frame.resize then
		S:HandleButton(frame.resize)
	end

	-- Style container and setup line hooks
	if frame.container then
		self:StyleSilverDragonHistoryContainer(frame.container)
		if frame.container.scrollView then
			self:HookSilverDragonHistoryLines(frame)
		end
	end
end

function module:StyleSilverDragonHistoryContainer(container)
	if not container or container.__MERToolsStyled then
		return
	end

	-- Style scroll elements
	if container.scrollBox then
		S:HandleFrame(container.scrollBox)
	end
	if container.scrollBar then
		S:HandleScrollBar(container.scrollBar)
	end

	container.__MERToolsStyled = true
end

function module:HookSilverDragonHistoryLines(frame)
	local scrollBox = frame.container.scrollBox
	if not scrollBox or not scrollBox.Rebuild then
		return
	end

	-- Hook the rebuild function to style lines
	local originalRebuild = scrollBox.Rebuild
	scrollBox.Rebuild = function(box, ...)
		local result = originalRebuild(box, ...)
		C_Timer_After(0.01, function()
			self:StyleVisibleHistoryLines(scrollBox)
		end)
		return result
	end
end

function module:StyleVisibleHistoryLines(scrollBox)
	if not scrollBox then
		return
	end

	local frames = scrollBox:GetFrames()
	if frames then
		for _, line in ipairs(frames) do
			if line and not line.__MERToolsStyled then
				self:StyleSilverDragonHistoryLine(line)
			end
		end
	end
end

function module:StyleSilverDragonHistoryLine(line)
	if not line or line.__MERToolsStyled then
		return
	end

	-- Style line as button
	S:HandleButton(line)

	-- Style icon
	if line.icon then
		line.icon:SetTexCoord(unpack(E.TexCoords))
		if not line.iconBackdrop then
			line.iconBackdrop = line:CreateTexture(nil, "BACKGROUND")
			line.iconBackdrop:SetTexture(E.media.blankTex)
			line.iconBackdrop:SetVertexColor(0, 0, 0, 0.6)
			line.iconBackdrop:Point("TOPLEFT", line.icon, "TOPLEFT", -1, 1)
			line.iconBackdrop:Point("BOTTOMRIGHT", line.icon, "BOTTOMRIGHT", 1, -1)
		end
	end

	-- Style text elements
	if line.title then
		self:StyleSilverDragonText(line.title, E.db.general.fontSize - 1)
		line.title:SetJustifyH("LEFT")
	end
	if line.time then
		self:StyleSilverDragonText(line.time, E.db.general.fontSize - 2, { 0.8, 0.8, 0.8, 1 })
	end
	if line.source then
		self:StyleSilverDragonText(line.source, E.db.general.fontSize - 3, { 0.6, 0.6, 0.6, 1 })
	end

	-- Add hover effects
	line:HookScript("OnEnter", function(frame)
		if frame.backdrop then
			frame.backdrop:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
		end
	end)
	line:HookScript("OnLeave", function(frame)
		if frame.backdrop then
			frame.backdrop:SetBackdropColor(0, 0, 0, 0.6)
		end
	end)

	line.__MERToolsStyled = true
end

function module:SetupSilverDragonOverlay(silverDragon)
	local overlayModule = silverDragon:GetModule("Overlay", true)
	if not overlayModule or not overlayModule.ShowTooltip then
		return
	end

	-- Hook overlay tooltip to style loot windows
	local originalShowTooltip = overlayModule.ShowTooltip
	overlayModule.ShowTooltip = function(module, pin)
		local result = originalShowTooltip(module, pin)
		if module.lootwindow then
			self:StyleSilverDragonLootWindow(module.lootwindow)
		end
		return result
	end
end

module:AddCallbackForAddon("SilverDragon")
