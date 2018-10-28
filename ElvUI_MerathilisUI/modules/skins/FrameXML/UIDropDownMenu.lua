local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleUIDropDownMenu()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("UIDropDownMenu_CreateFrames", function()
		local listFrame = _G["DropDownList1"];
		local listFrameName = listFrame:GetName();
		local index = listFrame and (listFrame.numButtons + 1) or 1;
		local expandArrow = _G[listFrameName.."Button"..index.."ExpandArrow"];
		if expandArrow then
			expandArrow:SetNormalTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow')
			expandArrow:SetSize(12, 12)
			expandArrow:GetNormalTexture():SetVertexColor(1, 1, 1)
			expandArrow:GetNormalTexture():SetRotation(MERS.ArrowRotation['RIGHT'])
		end
	end)
end

S:AddCallback("mUIUIDropDownMenu", styleUIDropDownMenu)
