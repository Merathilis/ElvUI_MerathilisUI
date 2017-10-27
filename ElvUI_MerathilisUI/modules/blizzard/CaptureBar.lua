local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, NUM_EXTENDED_UI_FRAMES

local function CaptureUpdate()
	if NUM_EXTENDED_UI_FRAMES then
		local captureBar
		for i = 1, NUM_EXTENDED_UI_FRAMES do
			captureBar = _G["WorldStateCaptureBar" .. i]

			if captureBar and captureBar:IsVisible() then
				captureBar:ClearAllPoints()

				if (i == 1) then
					captureBar:SetPoint("TOP", E.UIParent, "TOP", 0, -170)
				else
					captureBar:SetPoint("TOPLEFT", _G["WorldStateCaptureBar" .. i - 1], "TOPLEFT", 0, -45)
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)
end)