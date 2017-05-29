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
end

S:AddCallbackForAddon("Blizzard_Calendar", "mUICalendar", styleCalendar)