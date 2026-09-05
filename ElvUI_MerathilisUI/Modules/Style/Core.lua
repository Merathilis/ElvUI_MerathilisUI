local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Style")

local assert = assert
local pairs, next, type = pairs, next, type
local getmetatable = getmetatable
local EnumerateFrames = EnumerateFrames
local CreateFrame = CreateFrame
local CreateColor = CreateColor
local hooksecurefunc = hooksecurefunc

---Is this frame the ElvUI options window (or something inside it)?
---E:Config_GetWindow() is called fresh each time (cheap: it's just a table lookup) rather than
---cached, since the window frame only exists once it's actually been opened.
---The gradient/stripe look is meant for game frames, not ElvUI's own settings UI.
local function IsElvUIConfigFrame(frame)
	local configFrame = E.Config_GetWindow and E:Config_GetWindow()
	if not configFrame then
		return false
	end

	local parent = frame
	while parent do
		if parent == configFrame then
			return true
		end
		parent = parent.GetParent and parent:GetParent()
	end

	return false
end

function module:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame.__MERGradient
	if not gf then
		gf = frame:CreateTexture(nil, "BACKGROUND")
		gf:SetAllPoints()
		gf:SetTexture(E.media.blankTex)
		frame.__MERGradient = gf
	end

	gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

function module:UpdateTemplateStrata(frame)
	local style = frame.MERStyle
	if not style then
		return
	end

	style:OffsetFrameLevel(nil, frame)
	style:SetFrameStrata(frame:GetFrameStrata())
end

local function WatchPixelSnap(frame, snap)
	if frame and not frame:IsForbidden() and E:NotSecretTable(frame) and frame.PixelSnapDisabled and snap then
		frame.PixelSnapDisabled = nil
	end
end

local function DisablePixelSnap(frame)
	if not frame or frame:IsForbidden() or frame.PixelSnapDisabled or not E:NotSecretTable(frame) then
		return
	end

	if frame.SetSnapToPixelGrid then
		frame:SetSnapToPixelGrid(false)
		frame:SetTexelSnappingBias(0)
	elseif frame.GetStatusBarTexture then
		local texture = frame:GetStatusBarTexture()
		if type(texture) == "table" and texture.SetSnapToPixelGrid then
			texture:SetSnapToPixelGrid(false)
			texture:SetTexelSnappingBias(0)
		end
	end

	frame.PixelSnapDisabled = true
end

---Applies (or ensures visible) the MERStyle gradient overlay on a qualifying frame.
---Shared by the normal Enable-gated path and the always-on config-window path below.
local function ApplyMERStyle(frame, template, glossTex, isUnitFrameElement, isNamePlateElement)
	module.MERStyle = module.MERStyle or {}

	template = template or frame.template or "Default"
	glossTex = glossTex or frame.glossTex

	-- Cheap status-bar detection (hash first, then type checks)
	local isStatusBar = false
	local parent = frame:GetParent()
	if parent then
		if E.statusBars[parent] then
			isStatusBar = true
		elseif parent.IsObjectType and (parent:IsObjectType("Texture") or parent:IsObjectType("Statusbar")) then
			isStatusBar = true
		end
	end

	local skinForUnitFrame = isUnitFrameElement and not isNamePlateElement
	local skinForTransparent = template == "Transparent" and not isNamePlateElement and not isStatusBar
	local skinForTexture = template == "Default"
		and not glossTex
		and not isUnitFrameElement
		and not isNamePlateElement
		and not isStatusBar

	if not (skinForTransparent or skinForUnitFrame or isStatusBar or skinForTexture) then
		if frame.MERStyle then
			frame.MERStyle:Hide()
		end
		return
	end

	if frame.IsProtected and frame:IsProtected() then
		return
	end

	if frame.Center then
		frame.Center:SetDrawLayer("BACKGROUND", -7)
	end

	-- Already styled → just ensure visible (CreateStyle is a no-op when MERStyle exists)
	if frame.MERStyle then
		frame.MERStyle:Show()
		module.MERStyle[frame] = true
		return
	end

	if not frame.CreateStyle then
		WF.Developer.LogDebug("API functions not found!", "MERCreateStyle", true)
		return
	end

	frame:CreateStyle()
	if frame.MERStyle then
		module.MERStyle[frame] = true
	end
end

---Hooked after ElvUI's SetTemplate. Adds MER style overlay when applicable.
function module:SetTemplate(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
	-- Frame may carry previous call args
	ignoreUpdates = ignoreUpdates or frame.ignoreUpdates
	if ignoreUpdates then
		return
	end

	-- The ElvUI options window is handled unconditionally by MERConfigWindowStyle below,
	-- regardless of the Enable setting - leave it alone here either way.
	if IsElvUIConfigFrame(frame) then
		return
	end

	-- Module disabled → nothing to do (hooks are removed on Disable, but guard anyway)
	local db = self.db
	if not db or not db.enable then
		if frame.MERStyle then
			frame.MERStyle:Hide()
		end
		return
	end

	ApplyMERStyle(frame, template, glossTex, isUnitFrameElement, isNamePlateElement)
end

---Plain (non-AceHook) hook: always keeps the ElvUI options window styled/opaque, independent of
---the addon's own Enable toggle - ElvUI's "Transparent" template (which the window uses) is very
---see-through on its own, and the gradient overlay is what makes it look solid. Registered outside
---AceHook so module:Disable()'s UnhookAll() never removes it (see module:API below).
local function MERConfigWindowStyle(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
	ignoreUpdates = ignoreUpdates or frame.ignoreUpdates
	if ignoreUpdates then
		return
	end

	if not IsElvUIConfigFrame(frame) then
		return
	end

	ApplyMERStyle(frame, template, glossTex, isUnitFrameElement, isNamePlateElement)
end

-- ElvUI frame API (resolved at load; only injected if missing on metatable)
local API = {
	Kill = Kill,
	Size = Size,
	Point = Point,
	Width = Width,
	Height = Height,
	PointXY = PointXY,
	GrabPoint = GrabPoint,
	NudgePoint = NudgePoint,
	SetOutside = SetOutside,
	SetInside = SetInside,
	SetTemplate = SetTemplate,
	CreateBackdrop = CreateBackdrop,
	CreateShadow = CreateShadow,
	FontTemplate = FontTemplate,
	StripTextures = StripTextures,
	StripTexts = StripTexts,
	StyleButton = StyleButton,
	OffsetFrameLevel = OffsetFrameLevel,
	CreateCloseButton = CreateCloseButton,
	SetTexCoords = SetTexCoords,
	GetChild = GetChild,
}

function module:API(object)
	local mt = getmetatable(object)
	if not mt then
		return
	end

	local mk = mt.__index
	if type(mk) ~= "table" then
		return
	end

	for method, func in next, API do
		if func and not object[method] and not mk[method] then
			mk[method] = func
		end
	end

	if
		not mk.DisabledPixelSnap
		and (
			mk.SetSnapToPixelGrid
			or mk.SetStatusBarTexture
			or mk.SetColorTexture
			or mk.SetVertexColor
			or mk.CreateTexture
			or mk.SetTexCoord
			or mk.SetTexture
		)
	then
		if mk.SetSnapToPixelGrid then
			hooksecurefunc(mk, "SetSnapToPixelGrid", WatchPixelSnap)
		end
		if mk.SetStatusBarTexture then
			hooksecurefunc(mk, "SetStatusBarTexture", DisablePixelSnap)
		end
		if mk.SetColorTexture then
			hooksecurefunc(mk, "SetColorTexture", DisablePixelSnap)
		end
		if mk.SetVertexColor then
			hooksecurefunc(mk, "SetVertexColor", DisablePixelSnap)
		end
		if mk.CreateTexture then
			hooksecurefunc(mk, "CreateTexture", DisablePixelSnap)
		end
		if mk.SetTexCoord then
			hooksecurefunc(mk, "SetTexCoord", DisablePixelSnap)
		end
		if mk.SetTexture then
			hooksecurefunc(mk, "SetTexture", DisablePixelSnap)
		end

		mk.DisabledPixelSnap = true
	end

	if mk.SetTemplate and not mk.MERSkin then
		if not mk.CreateStyle then
			mk.CreateStyle = F.CreateStyle
		end

		-- Hook ElvUI SetTemplate once per metatable
		if not self:IsHooked(mk, "SetTemplate") then
			self:SecureHook(mk, "SetTemplate", "SetTemplate")
		end

		-- Plain hook (not via AceHook) so it survives module:Disable()'s UnhookAll()
		hooksecurefunc(mk, "SetTemplate", MERConfigWindowStyle)

		if mk.SetFrameLevel and not self:IsHooked(mk, "SetFrameLevel") then
			self:SecureHook(mk, "SetFrameLevel", "UpdateTemplateStrata")
		end

		if mk.SetFrameStrata and not self:IsHooked(mk, "SetFrameStrata") then
			self:SecureHook(mk, "SetFrameStrata", "UpdateTemplateStrata")
		end

		mk.MERSkin = true
	end
end

function module:ForceRefresh()
	E:UpdateFrameTemplates()
	E:UpdateMediaItems(true)
end

function module:MetatableScan()
	self.MERStyle = self.MERStyle or {}
end

function module:Disable()
	if not self.Initialized then
		return
	end

	self.isEnabled = false

	-- Hide existing style overlays before clearing registry (the ElvUI options window is
	-- always kept styled by MERConfigWindowStyle, regardless of Enable, so leave it alone)
	if self.MERStyle then
		for frame in pairs(self.MERStyle) do
			if frame.MERStyle and not IsElvUIConfigFrame(frame) then
				frame.MERStyle:Hide()
			end
		end
	end
	self.MERStyle = {}

	self:UnhookAll()

	-- Refresh ElvUI templates so overlays are no longer expected
	if self.db and not self.db.enable then
		self:ForceRefresh()
	end
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self:MetatableScan() -- monitor this
	self:ForceRefresh()

	self.isEnabled = true
end

function module:SettingsUpdate()
	if not self.Initialized or not self.isEnabled then
		return
	end

	local show = self.db and self.db.enable
	for frame in pairs(self.MERStyle) do
		local style = frame.MERStyle
		if style then
			if show then
				style:Show()
			else
				style:Hide()
			end
		end
	end
end

function module:DatabaseUpdate()
	self.db = E.db.mui.style

	local shouldBeEnabled = self.db and self.db.enable
	if self.isEnabled == shouldBeEnabled then
		return
	end

	F.Event.ContinueOutOfCombat(function()
		if shouldBeEnabled then
			self:Enable()
		else
			self:Disable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	self.isEnabled = false
	self.MERStyle = {}

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("module.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("module.SettingsUpdate", self.SettingsUpdate, self)

	self.Initialized = true
end

local handled = {
	Frame = true,
	Button = true,
}

local object = CreateFrame("Frame")
module:API(object)
module:API(object:CreateTexture())
module:API(object:CreateFontString())
module:API(object:CreateMaskTexture())

object = EnumerateFrames()
while object do
	local objType = object:GetObjectType()
	if E:NotSecretValue(object) and not object:IsForbidden() and not handled[objType] then
		module:API(object)
		handled[objType] = true
	end

	object = EnumerateFrames(object)
end

MER:RegisterModule(module:GetName())
