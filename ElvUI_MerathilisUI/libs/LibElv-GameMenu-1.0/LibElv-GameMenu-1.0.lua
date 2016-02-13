local MAJOR, MINOR = "LibElv-GameMenu-1.0", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end
local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local TT = E:GetModule("Tooltip")
local _G = _G
local tinsert = tinsert

local width, height = _G["GameMenuButtonHelp"]:GetWidth(), _G["GameMenuButtonHelp"]:GetHeight()
local LibHolder = CreateFrame("Frame", "LibGameMenuHolder", _G["GameMenuFrame"])
LibHolder:SetSize(width, 1)
LibHolder:SetPoint("TOP", _G["GameMenuButtonAddons"], "BOTTOM", 0, 0)

lib.buttons = {}

function lib:UpdateHolder()
	LibHolder:SetSize(width, 1 + (height * #lib.buttons))
	if #lib.buttons > 0 then
		LibHolder:ClearAllPoints()
		LibHolder:SetPoint("TOP", _G["GameMenuButtonAddons"], "BOTTOM", 0, -16)
	end
	for i = 1, #lib.buttons do
		local button = lib.buttons[i]
		if lib.buttons[i-1] then
			button:SetPoint("TOP", lib.buttons[i-1], "BOTTOM", 0 , -1)
		else
			button:SetPoint("TOP", LibHolder, "TOP", 0 , -1)
		end
		
	end
end

--[[data is the table of:
- name - button name
- text - text on button
- func - function to execute on click
]]
function lib:AddMenuButton(data)
	if not data then return end
	if _G[data.name] then return end
	local button = CreateFrame("Button", data.name, _G["GameMenuFrame"], "GameMenuButtonTemplate")
	button:Size(width, height)
	button:SetScript("OnClick", data.func)
	button:SetText(data.text)

	if E.private.skins.blizzard.enable == true and E.private.skins.blizzard.misc == true then
		S:HandleButton(button)
	end

	tinsert(lib.buttons, button)
end

_G["GameMenuFrame"]:HookScript("OnShow", function()
	_G["GameMenuButtonLogout"]:ClearAllPoints()
	_G["GameMenuButtonLogout"]:SetPoint("TOP", LibHolder, "BOTTOM", 0, -16)
	
	_G["GameMenuFrame"]:Height(_G["GameMenuFrame"]:GetHeight() + 17 + (height * #lib.buttons))
end)


if not LibStub("LibElvUIPlugin-1.0").plugins[MAJOR] then
	LibStub("LibElvUIPlugin-1.0"):RegisterPlugin(MAJOR, function() end, true)
end