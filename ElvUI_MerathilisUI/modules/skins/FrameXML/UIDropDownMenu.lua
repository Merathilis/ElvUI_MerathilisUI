local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local unpack = unpack
--WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleUIDropDownMenu()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(r, g, b, 0.45)
			icon:SetHeight(1)
		end
	end)

	local function ShowBackdrop(bu, show)
		if show then
			bu.backdrop:Show()
		else
			bu.backdrop:Hide()
		end
	end

	local function isCheckTexture(check)
		if check and check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
			return true
		end
	end

	hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
		if not level then level = 1 end

		local uiScale = UIParent:GetScale()
		local listFrame = _G["DropDownList"..level]

		-- fix dropdown position
		if level == 1 then
			if not anchorName then
				local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
				local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
				local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
				local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
				local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

				listFrame:ClearAllPoints()
				listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

				-- make sure it doesn't go off the screen
				local offLeft = listFrame:GetLeft()/uiScale
				local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale
				local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale
				local offBottom = listFrame:GetBottom()/uiScale

				local xAddOffset, yAddOffset = 0, 0
				if offLeft < 0 then
					xAddOffset = -offLeft
				elseif offRight < 0 then
					xAddOffset = offRight
				end

				if offTop < 0 then
					yAddOffset = offTop
				elseif offBottom < 0 then
					yAddOffset = -offBottom
				end
				listFrame:ClearAllPoints()
				listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
			elseif anchorName ~= "cursor" then
				-- this part might be a bit unreliable
				local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
				if relPoint == "BOTTOMLEFT" and xOff == 0 and floor(yOff) == 5 then
					listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
				end
			end
		else
			local point, anchor, relPoint, _, y = listFrame:GetPoint()
			if point:find("RIGHT") then
				listFrame:SetPoint(point, anchor, relPoint, -14, y)
			else
				listFrame:SetPoint(point, anchor, relPoint, 9, y)
			end
		end

		for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local bu = _G["DropDownList"..level.."Button"..i]
			local _, _, _, x = bu:GetPoint()

			if bu:IsShown() and x then
				local hl = _G["DropDownList"..level.."Button"..i.."Highlight"]
				local check = _G["DropDownList"..level.."Button"..i.."Check"]
				hl:SetPoint("TOPLEFT", -x + 1, 0)
				hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

				if bu and not bu.backdrop then
					bu:CreateBackdrop("Transparent")
					bu.backdrop:ClearAllPoints()
					bu.backdrop:SetPoint("CENTER", check)
					bu.backdrop:SetSize(12, 12)
					hl:SetColorTexture(r, g, b, .2)

					local expandArrow = _G["DropDownList"..level.."Button"..i.."ExpandArrow"]
					expandArrow:SetNormalTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow')
					expandArrow:SetSize(12, 12)
					expandArrow:GetNormalTexture():SetVertexColor(1, 1, 1)
					expandArrow:GetNormalTexture():SetRotation(MERS.ArrowRotation['RIGHT'])
				end

				local uncheck = _G["DropDownList"..level.."Button"..i.."UnCheck"]
				if isCheckTexture(uncheck) then uncheck:SetTexture("") end

				if isCheckTexture(check) then
					if not bu.notCheckable then
						local _, co = check:GetTexCoord()
						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:SetSize(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(E["media"].normTex)
							check:SetVertexColor(r, g, b, .6)
							check:SetSize(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					else
						ShowBackdrop(bu, false)
					end
				else
					check:SetSize(16, 16)
				end
			end
		end
	end)
end

S:AddCallback("mUIUIDropDownMenu", styleUIDropDownMenu)
