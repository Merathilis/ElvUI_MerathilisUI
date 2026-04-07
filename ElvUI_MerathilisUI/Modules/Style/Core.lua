local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Style")

local assert = assert
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable

local CreateFrame = CreateFrame
local CreateColor = CreateColor

function module:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(E.media.blankTex)
	gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

function module:UpdateTemplateStrata(frame)
	if frame.MERStyle then
		frame.MERStyle:OffsetFrameLevel(nil, frame)
		frame.MERStyle:SetFrameStrata(frame:GetFrameStrata())
	end
end

local function WatchPixelSnap(frame, snap)
	if E:NotSecretTable(frame) and (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and snap then
		frame.PixelSnapDisabled = nil
	end
end

local function DisablePixelSnap(frame)
	if E:NotSecretTable(frame) and (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
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
end

function module:SetTemplate(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
	template = template or frame.template or "Default"
	glossTex = glossTex or frame.glossTex or nil
	ignoreUpdates = ignoreUpdates or frame.ignoreUpdates or false

	if ignoreUpdates then
		return
	end

	local isStatusBar = false
	local parent = frame:GetParent()

	if parent then
		if parent.IsObjectType and (parent:IsObjectType("Texture") or parent:IsObjectType("Statusbar")) then
			isStatusBar = true
		elseif E.statusBars[parent] ~= nil then
			isStatusBar = true
		end
	end

	local skinForUnitFrame = isUnitFrameElement and not isNamePlateElement
	local skinForTransparent = (template == "Transparent") and not isNamePlateElement and not isStatusBar
	local skinForTexture = (template == "Default" and not glossTex)
		and not isUnitFrameElement
		and not isNamePlateElement
		and not isStatusBar

	if (skinForTransparent or skinForUnitFrame or isStatusBar or skinForTexture) and (self.db and self.db.enable) then
		if frame.Center ~= nil then
			frame.Center:SetDrawLayer("BACKGROUND", -7)
		end

		if not frame.CreateStyle then
			return WF.Developer.LogDebug("API functions not found!", "MERCreateStyle", not frame.CreateStyle)
		end

		frame:CreateStyle()
	else
		if frame.MERStyle then
			frame.MERStyle:Hide()
		end
	end
end

function module:SetTemplateAS(_, frame, template, _)
	self:SetTemplate(frame, template)
end

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
	local mk = getmetatable(object).__index
	for method, func in next, API do
		if not object[method] then
			mk[method] = func
		end
	end

	if
		not object.DisabledPixelSnap
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
		if not object.CreateStyle then
			mk.CreateStyle = F.CreateStyle
		end

		-- Hook elvui template
		if not self:IsHooked(mk, "SetTemplate") then
			self:SecureHook(mk, "SetTemplate", "SetTemplate")
		end

		-- Hook FrameLevel
		if mk.SetFrameLevel and (not self:IsHooked(mk, "SetFrameLevel")) then
			self:SecureHook(mk, "SetFrameLevel", "UpdateTemplateStrata")
		end

		-- Hook FrameStrata
		if mk.SetFrameStrata and (not self:IsHooked(mk, "SetFrameStrata")) then
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
	self.MERStyle = {}

	local handled = {
		Frame = true,
		Button = true,
	}

	local object = CreateFrame("Frame")
	self:API(object)
	self:API(object:CreateTexture())
	self:API(object:CreateFontString())
	self:API(object:CreateMaskTexture())

	object = EnumerateFrames()
	while object do
		local objType = object:GetObjectType()
		if not object:IsForbidden() and not handled[objType] then
			self:API(object)
			handled[objType] = true
		end

		object = EnumerateFrames(object)
	end
end

function module:Disable()
	if not self.Initialized then
		return
	end

	self.isEnabled = false

	self.MERStyle = {}

	if self.Initialized and self.db and not self.db.enable then
		self:ForceRefresh()
	end

	self:UnhookAll()
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self.isEnabled = true

	self:MetatableScan()
	self:ForceRefresh()
end

function module:SettingsUpdate()
	if not self.Initialized then
		return
	end
	if not self.isEnabled then
		return
	end

	for frame, _ in pairs(self.MERStyle) do
		if frame.MERStyle then
			if self.db.enable then
				frame.MERStyle:Show()
			else
				frame.MERStyle:Hide()
			end
		end
	end
end

function module:DatabaseUpdate()
	self.db = F.GetDBFromPath("mui.style")

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

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("module.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("module.SettingsUpdate", self.SettingsUpdate, self)

	self.MERStyle = {}

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
