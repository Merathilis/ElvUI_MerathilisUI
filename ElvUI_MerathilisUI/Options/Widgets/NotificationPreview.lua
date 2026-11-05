local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

-- The example toast of the Notification module, with the title and text fonts
-- from the options. Used as `dialogControl` on a description named
-- "notification". The toast itself comes from BuildToastFrame in
-- Modules/Notification/Core.lua, so both always share one layout.

local HEIGHT = 80
local SAMPLE_ICON = [[INTERFACE\ICONS\SPELL_FROST_ARCTICWINDS]]
-- Shows the click arrow like a toast that opens something
local SAMPLE_CLICK = function() end
-- How far the timer bar has run down in the example
local SAMPLE_TIMER = 0.6

local function Build(widget)
	local toast = MER:GetModule("MER_Notification"):BuildToastFrame(widget.frame)
	toast:SetPoint("CENTER")
	toast.CloseButton:EnableMouse(false)
	toast.clickFunc = SAMPLE_CLICK
	widget.toast = toast

	toast.icon:SetTexture(SAMPLE_ICON)
	toast.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	toast.title:SetText(F.cOption("MerathilisUI:", "gradient"))
	toast.text:SetText(L["This is an example of a notification."])
end

local function Update(widget)
	local db = E.db.mui.notification
	local notification = MER:GetModule("MER_Notification")
	local toast = widget.toast

	WF.SetFontWithDB(toast.title, db.titleFont)
	WF.SetFontWithDB(toast.text, db.textFont)
	notification:LayoutToast(toast)
	notification:UpdateToastHover(toast)
	toast.timer:SetWidth(toast.timerWidth * SAMPLE_TIMER)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERNotificationPreview", 1, HEIGHT, Build, Update)
