local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local unpack = unpack

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:Blizzard_Calendar()
	if not module:CheckDB("calendar", "calendar") then
		return
	end

	local CalendarFrame = _G.CalendarFrame

	module:CreateBackdropShadow(CalendarFrame)
	module:CreateShadow(_G.CalendarCreateEventFrame)
	module:CreateShadow(_G.CalendarViewHolidayFrame)
	module:CreateShadow(_G.CalendarViewEventFrame)
	module:CreateShadow(_G.CalendarMassInviteFrame)
	module:CreateShadow(_G.CalendarViewRaidFrame)
	module:CreateShadow(_G.CalendarEventPickerFrame)

	for index in next, _G.CLASS_SORT_ORDER do
		local button = _G["CalendarClassButton" .. index]
		if button then
			module:CreateShadow(button)
		end
	end

	module:CreateShadow(_G.CalendarClassTotalsButton)

	for i = 1, 42 do
		_G["CalendarDayButton" .. i .. "DarkFrame"]:SetAlpha(.5)
		local bu = _G["CalendarDayButton" .. i]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(E["media"].normTex)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .2)
		hl.SetAlpha = MER.dummy
		hl:SetPoint("TOPLEFT", -1, 1)
		hl:SetPoint("BOTTOMRIGHT")
	end

	for i = 1, 7 do
		_G["CalendarWeekday" .. i .. "Background"]:SetAlpha(0)
	end

	_G.CalendarWeekdaySelectedTexture:SetDesaturated(true)
	_G.CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b, 1)

	_G.CalendarViewEventAcceptButton.flashTexture:SetTexture("")
	_G.CalendarViewEventTentativeButton.flashTexture:SetTexture("")
	_G.CalendarViewEventDeclineButton.flashTexture:SetTexture("")

	if _G.CalendarTodayFrame.backdrop then
		_G.CalendarTodayFrame:SetBackdropBorderColor(r, g, b)
	end
end

module:AddCallbackForAddon("Blizzard_Calendar")
