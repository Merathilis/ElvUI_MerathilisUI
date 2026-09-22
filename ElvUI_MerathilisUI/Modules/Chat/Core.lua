local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")

function module:DatabaseUpdate()
	self.chatDB = E.db.mui.chat
	self.db = self.chatDB.sidebar

	self:SettingsUpdate()
	self:UpdateResizeGrips()
	self:UpdateCombatLog()
	self:UpdateEditBoxes()
	self:UpdateTabs()
end

function module:Initialize()
	if self.Initialized then
		return
	end

	-- Sidebar, resize grips, tabs and the edit box style live on ElvUI's chat; the
	-- combat log style rides on ElvUI's skin and checks that itself.
	if E.private.chat.enable then
		self:InitializeSidebar()
		self:InitializeResizeGrips()
		self:InitializeEditBox()
		self:InitializeTabs()
	end
	self:InitializeCombatLog()

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
