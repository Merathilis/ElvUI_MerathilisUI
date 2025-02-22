local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
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

	if not mt or type(mt) == "function" then
		return
	end

	if mt.SetTemplate and not mt.MERSkin then
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

		mt.MERSkin = true
	end
end

function module:ForceRefresh()
	E:UpdateFrameTemplates()
	E:UpdateMediaItems(true)
end

local object = CreateFrame("Frame")
local handled = {
	Frame = true,
	Button = true,
	ModelScene = true,
	Slider = true,
	ScrollFrame = true,
}

function module:MetatableScan()
	self.MERStyle = {}

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
