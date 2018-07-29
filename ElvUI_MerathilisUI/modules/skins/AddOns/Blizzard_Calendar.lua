local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleCalendar()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.calendar ~= true or E.private.muiSkins.blizzard.calendar ~= true then return end

	_G["CalendarFrame"].backdrop:Styling()
	_G["CalendarCreateEventFrame"]:Styling()
	_G["CalendarViewHolidayFrame"]:Styling()
	_G["CalendarViewEventFrame"]:Styling()

	for i = 1, 42 do
		_G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
		local bu = _G["CalendarDayButton"..i]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(E["media"].normTex)
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		hl.SetAlpha = MER.dummy
		hl:SetPoint("TOPLEFT", -1, 1)
		hl:SetPoint("BOTTOMRIGHT")
	end

	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end

	_G["CalendarWeekdaySelectedTexture"]:SetDesaturated(true)
	_G["CalendarWeekdaySelectedTexture"]:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	_G["CalendarViewEventAcceptButton"].flashTexture:SetTexture("")
	_G["CalendarViewEventTentativeButton"].flashTexture:SetTexture("")
	_G["CalendarViewEventDeclineButton"].flashTexture:SetTexture("")
end

S:AddCallbackForAddon("Blizzard_Calendar", "mUICalendar", styleCalendar)