local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local unpack = unpack

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("calendar", "calendar") then
		return
	end

	local CalendarFrame = _G.CalendarFrame

	CalendarFrame.backdrop:Styling()
	module:CreateBackdropShadow(CalendarFrame)
	_G.CalendarCreateEventFrame:Styling()
	module:CreateBackdropShadow(_G.CalendarCreateEventFrame)
	_G.CalendarViewHolidayFrame:Styling()
	module:CreateBackdropShadow(_G.CalendarViewHolidayFrame)
	_G.CalendarViewEventFrame:Styling()
	module:CreateBackdropShadow(_G.CalendarViewEventFrame)
	_G.CalendarMassInviteFrame:Styling()
	module:CreateBackdropShadow(_G.CalendarMassInviteFrame)
	_G.CalendarViewRaidFrame:Styling()
	module:CreateBackdropShadow(_G.CalendarViewRaidFrame)

	for i = 1, 42 do
		_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
		local bu = _G["CalendarDayButton"..i]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(E["media"].normTex)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl.SetAlpha = MER.dummy
		hl:SetPoint("TOPLEFT", -1, 1)
		hl:SetPoint("BOTTOMRIGHT")
	end

	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end

	_G.CalendarWeekdaySelectedTexture:SetDesaturated(true)
	_G.CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b, 1)

	_G.CalendarViewEventAcceptButton.flashTexture:SetTexture("")
	_G.CalendarViewEventTentativeButton.flashTexture:SetTexture("")
	_G.CalendarViewEventDeclineButton.flashTexture:SetTexture("")

	_G.CalendarTodayFrame:SetBackdropBorderColor(r, g, b)
end

S:AddCallbackForAddon("Blizzard_Calendar", LoadSkin)
