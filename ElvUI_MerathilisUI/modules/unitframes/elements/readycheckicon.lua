local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

--Cache global variables
--Lua functions
--WoW API / Variables

function MUF:Construct_ReadyCheckIcon(frame)
	local tex = frame.RaisedElementParent:CreateTexture(nil, "OVERLAY", nil, 7)
	tex:Size(12)
	tex:Point("BOTTOM", frame.Health, "BOTTOM", 0, 2)

	--Custom textures
	tex.readyTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\ready.tga]]
	tex.notReadyTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\notready.tga]]
	tex.waitingTexture = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\noresponse.tga]]

	return tex
end

function MUF:Configure_ReadyCheckIcon(frame)
	if not frame:IsElementEnabled('ReadyCheck') then
		frame:EnableElement('ReadyCheck')
	end
end