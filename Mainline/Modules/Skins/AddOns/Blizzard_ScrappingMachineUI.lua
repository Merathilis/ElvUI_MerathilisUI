local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')
local B = E:GetModule('Bags')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local weShown = false;

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.scrapping ~= true or E.private.muiSkins.blizzard.Scrapping ~= true then return end

	local MachineFrame = _G.ScrappingMachineFrame
	MachineFrame:Styling()
	MER:CreateBackdropShadow(MachineFrame)
end

S:AddCallbackForAddon('Blizzard_ScrappingMachineUI', "mUIScrappingMachine", LoadSkin)
