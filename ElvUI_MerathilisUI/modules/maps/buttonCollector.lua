local MER, E, L, V, P, G = unpack(select(2, ...))
local MM = E:GetModule("mUIMinimap")

--Cache global variables
--Lua functions
local _G = _G
local pairs, ipairs, select = pairs, ipairs, select
local find, upper = string.find, string.upper
local tinsert = table.insert
--WoW API / Variables
local C_TimerAfter = C_Timer.After
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local buttons = {}
local blackList = {
	["MiniMapTracking"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["MiniMapLFGFrame"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["MiniMapMailFrame"] = true,
	["BattlefieldMinimap"] = true,
	["MinimapBackdrop"] = true,
	["GameTimeFrame"] = true,
	["TimeManagerClockButton"] = true,
	["FeedbackUIButton"] = true,
	["HelpOpenTicketButton"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["QueueStatusMinimapButton"] = true,
	["MinimapButtonCollectFrame"] = true,
	["GarrisonLandingPageMinimapButton"] = true,
	["MinimapZoneTextButton"] = true,
}

function MM:ArrangeMinimapButtons(parent)
	if #buttons == 0 then
		parent:Hide()
		return
	end

	local space
	if #buttons > 5 then
		space = -5
	else
		space = 0
	end

	local lastbutton
	for k, button in pairs(buttons) do
		button:ClearAllPoints()
		if button:IsShown() then
			if not lastbutton then
				button:SetPoint("LEFT", parent, "LEFT", 0, 0)
			else
				button:SetPoint("LEFT", lastbutton, "RIGHT", space, 0)
			end
			lastbutton = button
		end
	end
end

function MM:CollectMinimapButtons(parent)
	for i, child in ipairs({_G["Minimap"]:GetChildren()}) do
		if child:GetName() and not blackList[child:GetName()] then
			if child:GetObjectType() == "Button" or upper(child:GetName()):match("BUTTON") then
				child:SetParent(parent)
				for j = 1, child:GetNumRegions() do
					local region = select(j, child:GetRegions())
					if region:GetObjectType() == "Texture" then
						local texture = region:GetTexture()
						if texture then
							if (find(texture, "Interface\\CharacterFrame") or find(texture, "Interface\\Minimap")) then
								region:SetTexture(nil)
							elseif texture == 136430 or texture == 136467 then
								region:SetTexture(nil)
							end
						end
					end
					region:SetDrawLayer("ARTWORK")
					region:Size(22)
					region.SetPoint = function() return end
				end

				child:HookScript("OnShow", function()
					MM:ArrangeMinimapButtons(parent)
				end)
				child:HookScript("OnShow", function()
					MM:ArrangeMinimapButtons(parent)
				end)
				child:HookScript("OnHide", function()
					MM:ArrangeMinimapButtons(parent)
				end)
				child:HookScript("OnEnter", function()
					E:UIFrameFadeIn(parent, .5, parent:GetAlpha(), 1)
				end)
				child:HookScript("OnLeave", function()
					E:UIFrameFadeOut(parent, .5, parent:GetAlpha(), 0)
				end)
				child:SetScript("OnDragStart", nil)
				child:SetScript("OnDragStop", nil)
				tinsert(buttons, child)
			end
		end
	end
end

function MM:ButtonCollectorInit()
	if E.db.mui.maps.minimap.buttonCollector.enable ~= true then return end

	local MBCF = CreateFrame("Frame", "MinimapButtonCollectFrame", Minimap)
	MBCF:SetFrameStrata("HIGH")
	MBCF:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -1, 2)
	MBCF:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", -1, 2)
	MBCF:SetHeight(20)
	
	MBCF.bg = MBCF:CreateTexture(nil, "BACKGROUND")
	MBCF.bg:SetTexture(E["media"].blankTex)
	MBCF.bg:SetAllPoints(MBCF)
	MBCF.bg:SetGradientAlpha("HORIZONTAL", 0, 0, 0, .8, 0, 0, 0, 0)

	MBCF:SetScript("OnEvent", function(self)
		C_TimerAfter(0.3, function()
			MM:CollectMinimapButtons(MBCF)
			MM:ArrangeMinimapButtons(MBCF)
		end)
		self:SetAlpha(0)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end)

	MBCF:RegisterEvent("PLAYER_ENTERING_WORLD")

	MBCF:SetScript("OnEnter", function(self)
		E:UIFrameFadeIn(self, .5, self:GetAlpha(), 1)
	end)

	_G["Minimap"]:HookScript("OnEnter", function()
		E:UIFrameFadeIn(MBCF, .5, MBCF:GetAlpha(), 1)
	end)

	MBCF:SetScript("OnLeave", function(self)
		E:UIFrameFadeOut(self, .5, self:GetAlpha(), 0)
	end)

	_G["Minimap"]:HookScript("OnLeave", function()
		E:UIFrameFadeOut(MBCF, .5, MBCF:GetAlpha(), 0)
	end)
end