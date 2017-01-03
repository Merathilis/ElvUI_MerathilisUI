local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule("muiUnits");
local UF = E:GetModule("UnitFrames");

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Configure_ReadyCheckIcon(frame)
	local tex = frame.ReadyCheck

	tex.readyTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\ready]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\notready]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\noresponse]]
end

hooksecurefunc(UF, "Configure_ReadyCheckIcon", MUF.Configure_ReadyCheckIcon)
