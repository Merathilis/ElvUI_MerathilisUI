local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = MER:GetModule("muiSkins")
MERB.modName = L["Bags"]

--Cache global variables
--Lua Variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERB:SkinBags()
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:Styling()
		ElvUI_ContainerFrameContainerHolder:Styling()
	end

	if ElvUIBags then
		ElvUIBags.backdrop:Styling()
	end
end

function MERB:SkinBank()
	if ElvUI_BankContainerFrame then
		ElvUI_BankContainerFrame:Styling()
		ElvUI_BankContainerFrameContainerHolder:Styling()
	end
end

function MERB:AllInOneBags()
	self:SkinBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'SkinBank')
end

function MERB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Styling()
		end
	end
	if BankFrame then
		BankFrame:Styling()
	end
end


function MERB:Initialize()
	if E.private.bags.enable ~= true then return end

	self:AllInOneBags()
	self:SkinBlizzBags()
	self:SkinBank()
end

local function InitializeCallback()
	MERB:Initialize()
end

MER:RegisterModule(MERB:GetName(), InitializeCallback)