local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")
local WS = MER.Modules.WidgetSkin
module.Widgets = WS

local abs = abs
local pcall = pcall
local pairs, type = pairs, type
local strlower = strlower
local wipe = wipe

WS.LazyLoadTable = {}

function WS.IsUglyYellow(...)
	local r, g, b = ...
	return abs(r - 1) + abs(g - 0.82) + abs(b) < 0.02
end

function WS:Ace3_RegisterAsWidget(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "Button" or widgetType == "Button-ElvUI" then
		self:HandleButton(nil, widget)
	end
end

function WS:Ace3_RegisterAsContainer(_, widget)
	local widgetType = widget.type

	if not widgetType then
		return
	end

	if widgetType == "TreeGroup" then
		self:HandleTreeGroup(widget)
	end
end

function WS:IsReady()
	return E.private and E.private.mui and E.private.mui.skins and E.private.mui.skins.widgets
end

function WS:RegisterLazyLoad(frame, func)
	if not frame then
		self:Log("debug", "frame is nil.")
		return
	end

	if type(func) ~= "function" then
		if self[func] and type(self[func]) == "function" then
			func = self[func]
		else
			self:Log("debug", func .. " is not a function.")
			return
		end
	end

	self.LazyLoadTable[frame] = func
end

function WS:LazyLoad()
	for frame, func in pairs(self.LazyLoadTable) do
		if frame and func then
			pcall(func, self, frame)
		end
	end

	wipe(self.LazyLoadTable)
end

function WS:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:LazyLoad()
end

WS:SecureHook(S, "Ace3_RegisterAsWidget")
WS:SecureHook(S, "Ace3_RegisterAsContainer")
WS:RegisterEvent("PLAYER_ENTERING_WORLD")
