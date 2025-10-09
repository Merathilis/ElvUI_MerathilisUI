local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local MF = MER:GetModule("MER_MoveFrames")

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

---Skin a profiling line frame
---@param frame Frame The profiling line frame to skin
local function SkinProfilingLine(frame)
	if not frame or frame.__MERSkin then
		return
	end

	if frame.progressBar then
		frame.progressBar:SetStatusBarTexture(E.media.normTex)
		F.SetFont(frame.progressBar.name)
	end

	if frame.time then
		F.SetFont(frame.time)
	end

	if frame.spike then
		F.SetFont(frame.spike)
	end

	frame.__MERSkin = true
end

---Skin the main profiling frame
---@param frame Frame The profiling frame to skin
local function SkinProfilingFrame(frame)
	if not frame or frame.__MERSkin then
		return
	end

	module:Proxy("HandlePortraitFrame", frame)
	module:CreateShadow(frame)
	MF:InternalHandle(frame, nil, false)

	for _, region in pairs({ frame.ResizeButton:GetRegions() }) do
		if region:IsObjectType("Texture") then
			region:SetTexture(E.Media.Textures.ArrowUp)
			region:SetTexCoord(0, 1, 0, 1)
			region:SetRotation(-2.35)
			region:SetAllPoints()
		end
	end

	frame.TitleBar:Hide()
	module:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MaximizeButton, "up", nil, true)
	module:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MinimizeButton, "down", nil, true)
	module:Proxy("HandleCloseButton", frame.CloseButton)
	frame.MaxMinButtonFrame:Size(20)

	if frame.buttons then
		module:Proxy("HandleButton", frame.buttons.report)
		module:Proxy("HandleButton", frame.buttons.stop)
		module:Proxy("HandleButton", frame.buttons.start)
		module:Proxy("HandleDropDownBox", frame.buttons.modeDropDown, frame.buttons.modeDropDown:GetWidth(), nil, true)
		module:Proxy(
			"HandleDropDownBox",
			frame.buttons.startDropDown,
			frame.buttons.startDropDown:GetWidth(),
			nil,
			true
		)
	end

	if frame.ColumnDisplay then
		frame.ColumnDisplay:StripTextures()
		if frame.ColumnDisplay.columnHeaders then
			for header in frame.ColumnDisplay.columnHeaders:EnumerateActive() do
				header:StripTextures()
				header:SetTemplate("Transparent")
			end
		end
	end

	module:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	local scrollBox = frame.ScrollBox ---@type WowScrollBoxList
	scrollBox:StripTextures()
	scrollBox:SetTemplate("Transparent")
	hooksecurefunc(scrollBox, "Update", function()
		scrollBox:ForEachFrame(SkinProfilingLine)
	end)

	if frame.stats then
		F.SetFont(frame.stats)
	end

	frame.__MERSkin = true
end

---Skin the profiling report frame
---@param frame Frame The profiling report frame to skin
local function SkinProfilingReport(frame)
	if not frame or frame.__MERSkin then
		return
	end

	module:Proxy("HandlePortraitFrame", frame)
	module:CreateShadow(frame)

	frame.TitleBar:Hide()
	module:Proxy("HandleCloseButton", frame.CloseButton)

	local scrollFrame = frame.ScrollBox
	scrollFrame:StripTextures()
	scrollFrame:SetTemplate("Transparent")
	module:Proxy("HandleTrimScrollBar", scrollFrame.ScrollBar)
	F.Move(scrollFrame.ScrollBar, 13, 0)

	if scrollFrame.messageFrame then
		F.SetFont(scrollFrame.messageFrame)
	end

	frame.__MERSkin = true
end

function module:SkinWeakAurasProfilingFrames()
	if not _G.WeakAurasProfilingFrame or not _G.WeakAurasProfilingReport then
		return false
	end

	module:SecureHook(_G.WeakAurasProfilingFrame, "Show", SkinProfilingFrame)
	module:SecureHook(_G.WeakAurasProfilingReport, "Show", SkinProfilingReport)

	if self:IsHooked(_G.WeakAuras, "ShowProfilingWindow") then
		self:Unhook(_G.WeakAuras, "ShowProfilingWindow")
	end

	return true
end

function module:WeakAurasProfiling()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.weakAurasOptions then
		return
	end

	if self:SkinWeakAurasProfilingFrames() then
		return
	end

	if _G.WeakAuras.ShowProfilingWindow then
		module:SecureHook(_G.WeakAuras, "ShowProfilingWindow", "SkinWeakAurasProfilingFrames")
	end
end

module:AddCallbackForAddon("WeakAuras", "WeakAurasProfiling")
