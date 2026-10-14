local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local unpack = unpack
local CreateFrame = CreateFrame

-- The example toast of the Notification module, with the title and text fonts
-- from the options. Used as `dialogControl` on a description named
-- "notification". Size and layout follow CreateToast in
-- Modules/Notification/Core.lua.

local BANNER_WIDTH, BANNER_HEIGHT = 255, 68
local HEIGHT = BANNER_HEIGHT + 24
local SAMPLE_ICON = [[INTERFACE\ICONS\SPELL_FROST_ARCTICWINDS]]

local function Build(widget)
	local toast = CreateFrame("Frame", nil, widget.frame, "BackdropTemplate")
	toast:SetSize(BANNER_WIDTH, BANNER_HEIGHT)
	toast:SetPoint("CENTER")
	toast:CreateBackdrop("Transparent")
	toast:CreateCloseButton(10)
	toast.CloseButton:EnableMouse(false)
	widget.toast = toast

	local icon = toast:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", toast, "LEFT", 9, 0)
	icon:SetTexture(SAMPLE_ICON)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	MER:GetModule("MER_Skins"):CreateBG(icon)

	local sep = toast:CreateTexture(nil, "BACKGROUND")
	sep:SetSize(2, BANNER_HEIGHT)
	sep:SetPoint("LEFT", icon, "RIGHT", 9, 0)
	widget.sep = sep

	local title = toast:CreateFontString(nil, "OVERLAY")
	title:FontTemplate()
	title:SetShadowOffset(1, -1)
	title:SetPoint("TOPLEFT", sep, "TOPRIGHT", 3, -5)
	title:SetPoint("TOP", toast, "TOP", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetNonSpaceWrap(true)
	title:SetText(F.cOption("MerathilisUI:", "gradient"))
	widget.title = title

	-- The toast's own width math (right edge minus separator) is done once at creation there
	local text = toast:CreateFontString(nil, "OVERLAY")
	text:FontTemplate()
	text:SetShadowOffset(1, -1)
	text:SetPoint("BOTTOMLEFT", sep, "BOTTOMRIGHT", 3, 17)
	text:SetPoint("RIGHT", toast, -9, 0)
	text:SetJustifyH("LEFT")
	text:SetText(L["This is an example of a notification."])
	widget.text = text
end

local function Update(widget)
	local db = E.db.mui.notification

	widget.sep:SetColorTexture(unpack(E.media.rgbvaluecolor))
	WF.SetFontWithDB(widget.title, db.titleFont)
	WF.SetFontWithDB(widget.text, db.textFont)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERNotificationPreview", 1, HEIGHT, Build, Update)
