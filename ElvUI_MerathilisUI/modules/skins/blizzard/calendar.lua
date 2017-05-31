local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
--WoW API / Variables

local function styleCalendar()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.calendar ~= true or E.private.muiSkins.blizzard.calendar ~= true then return end

	if not CalendarFrame.stripes then
		MERS:CreateStripes(CalendarFrame)
	end

	if not CalendarCreateEventFrame.stripes then
		MERS:CreateStripes(CalendarCreateEventFrame)
	end

	if not CalendarViewHolidayFrame.stripes then
		MERS:CreateStripes(CalendarViewHolidayFrame)
	end
end

S:AddCallbackForAddon("Blizzard_Calendar", "mUICalendar", styleCalendar)