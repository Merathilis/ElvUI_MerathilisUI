local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Style")
local S = MER:GetModule("MER_Skins")

local assert = assert
local EnumerateFrames = EnumerateFrames
local getmetatable = getmetatable
local unpack = pairs

local CreateFrame = CreateFrame
local CreateColor = CreateColor

local backdropr, backdropg, backdropb, backdropa = unpack(E.media.backdropcolor)
local borderr, borderg, borderb, bordera = unpack(E.media.bordercolor)

function module:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
	assert(frame, "doesn't exist!")

	frame:Size(w, h)
	frame:SetFrameStrata("BACKGROUND")

	local gf = frame:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(E.media.blankTex)
	gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
end

function module:CreateOverlay(f)
	if f.overlay then
		return
	end

	local overlay = f:CreateTexture("$parentOverlay", "BORDER", f)
	overlay:Point("TOPLEFT", 2, -2)
	overlay:Point("BOTTOMRIGHT", -2, 2)
	overlay:SetTexture(E["media"].blankTex)
	overlay:SetVertexColor(0.1, 0.1, 0.1, 1)
	f.overlay = overlay
end

function module:CreateBorder(f, i, o)
	if i then
		if f.iborder then
			return
		end
		local border = CreateFrame("Frame", "$parentInnerBorder", f)
		border:Point("TOPLEFT", E.mult, -E.mult)
		border:Point("BOTTOMRIGHT", -E.mult, E.mult)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.iborder = border
	end

	if o then
		if f.oborder then
			return
		end
		local border = CreateFrame("Frame", "$parentOuterBorder", f)
		border:Point("TOPLEFT", -E.mult, E.mult)
		border:Point("BOTTOMRIGHT", E.mult, -E.mult)
		border:SetFrameLevel(f:GetFrameLevel() + 1)
		border:CreateBackdrop()
		border.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
		f.oborder = border
	end
end

function module:CreatePanel(f, t, w, h, a1, p, a2, x, y)
	f:Width(w)
	f:Height(h)
	f:SetFrameLevel(3)
	f:SetFrameStrata("BACKGROUND")
	f:Point(a1, p, a2, x, y)
	f:CreateBackdrop()

	if t == "Transparent" then
		backdropa = 0.45
		module:CreateBorder(f, true, true)
		S:CreateBackdropShadow(f.backdrop)
	elseif t == "Overlay" then
		backdropa = 1
		module:CreateOverlay(f)
		S:CreateBackdropShadow(f.backdrop)
	elseif t == "Invisible" then
		backdropa = 0
		bordera = 0
	else
		backdropa = 1
	end

	f.backdrop:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
	f.backdrop:SetBackdropBorderColor(borderr, borderg, borderb, bordera)
end

function module:UpdateTemplateStrata(frame)
	if frame.MERStyle then
		frame.MERStyle:SetFrameLevel(frame:GetFrameLevel())
		frame.MERStyle:SetFrameStrata(frame:GetFrameStrata())
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
		elseif parent.IsObjectType and (parent:IsObjectType("EditBox") or parent:IsObjectType("Slider")) then
			return
		end
	end

	local skinForUnitFrame = isUnitFrameElement and not isNamePlateElement
	local skinForTransparent = (template == "Transparent") and not isNamePlateElement and not isStatusBar
	local skinForTexture = (template == "Default" and not glossTex)
		and not isUnitFrameElement
		and not isNamePlateElement
		and not isStatusBar

	if (skinForTransparent or skinForTexture) and (self.db and self.db.enable) then
		if not frame.CreateStyle then
			return F.Developer.LogDebug("API functions not found!", "MERCreateStyle", not frame.CreateStyle)
		end

		frame:CreateStyle()
	else
		if frame.MERStyle then
			frame.MERStyle:Hide()
		end
	end
end

function module:API(object)
	local mt = getmetatable(object).__index

	if not mt or not mt.SetTemplate then
		return
	end

	if not object.CreateOverlay then
		mt.CreateOverlay = module.CreateOverlay
	end
	if not object.CreateBorder then
		mt.CreateBorder = module.CreateBorder
	end
	if not object.CreatePanel then
		mt.CreatePanel = module.CreatePanel
	end
	if not object.CreateStyle then
		mt.CreateStyle = F.CreateStyle
	end

	-- Hook elvui template
	if not self:IsHooked(mt, "SetTemplate") then
		self:SecureHook(mt, "SetTemplate", "SetTemplate")
	end

	-- Hook FrameLevel
	if mt.SetFrameLevel and (not self:IsHooked(mt, "SetFrameLevel")) then
		self:SecureHook(mt, "SetFrameLevel", "UpdateTemplateStrata")
	end

	-- Hook FrameStrata
	if mt.SetFrameStrata and (not self:IsHooked(mt, "SetFrameStrata")) then
		self:SecureHook(mt, "SetFrameStrata", "UpdateTemplateStrata")
	end
end

function module:ForceRefresh()
	E:UpdateFrameTemplates()
	E:UpdateMediaItems(true)
end

function module:MetatableScan()
	local handled = {
		Region = true,
		Texture = true,
		Cooldown = true,
		Slider = true,
		ScrollFrame = true,
		ModelScene = true,
	}

	local object = CreateFrame("Frame")
	self:API(object)
	self:API(object:CreateTexture())
	self:API(object:CreateFontString())
	self:API(object:CreateMaskTexture())

	object = EnumerateFrames()
	while object do
		if not object:IsForbidden() and not handled[object:GetObjectType()] then
			self:API(object)
			handled[object:GetObjectType()] = true
		end

		object = EnumerateFrames(object)
	end
end

function module:Disable()
	if not self.Initialized then
		return
	end

	self.isEnabled = false

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

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
