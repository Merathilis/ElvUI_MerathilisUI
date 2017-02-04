local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API
local WorldStateAlwaysUpFrame = WorldStateAlwaysUpFrame
-- GLOBALS: hooksecurefunc, NUM_ALWAYS_UP_UI_FRAMES

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("WorldStateAlwaysUpFrame_AddFrame", function()
		WorldStateAlwaysUpFrame:ClearAllPoints()
		WorldStateAlwaysUpFrame:SetPoint("TOP", E.UIParent, "TOP", 0, -40)

		if _G["AlwaysUpFrame1"] then
			local _, _, _, _, y = _G["AlwaysUpFrame1"]:GetPoint()
			_G["AlwaysUpFrame1"]:SetPoint("TOP", WorldStateAlwaysUpFrame, "TOP", 0, y)
		end

		for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
			local frame = _G["AlwaysUpFrame"..i]

			local text = _G["AlwaysUpFrame"..i.."Text"]
			text:ClearAllPoints()
			text:SetPoint("CENTER", frame, "CENTER", 0, 0)
			text:SetJustifyH("CENTER")

			local icon = _G["AlwaysUpFrame"..i.."Icon"]
			icon:ClearAllPoints()
			icon:SetPoint("RIGHT", text, "LEFT", -5, 0)

			local dynamicIcon = _G["AlwaysUpFrame"..i.."DynamicIconButton"]
			dynamicIcon:ClearAllPoints()
			dynamicIcon:SetPoint("LEFT", text, "RIGHT", 5, 0)
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleMisc)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)