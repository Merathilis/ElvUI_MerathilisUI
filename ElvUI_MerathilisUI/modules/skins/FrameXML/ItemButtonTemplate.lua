local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

do --[[ FrameXML\ItemButtonTemplate.lua ]]
	local size = 6
	local vertexOffsets = {
		{"TOPLEFT", 4, -size},
		{"BOTTOMLEFT", 3, -size},
		{"TOPRIGHT", 2, size},
		{"BOTTOMRIGHT", 1, size},
	}

	local function SetRelic(button, isRelic, color)
		if isRelic then
			if not button._auroraRelicTex then
				local relic = CreateFrame("Frame", nil, button)
				relic:SetAllPoints(button._auroraIconBorder)

				for i = 1, 4 do
					local tex = relic:CreateTexture(nil, "OVERLAY")
					tex:SetSize(size, size)

					local vertexInfo = vertexOffsets[i]
					tex:SetPoint(vertexInfo[1])
					tex:SetVertexOffset(vertexInfo[2], vertexInfo[3], 0)
					relic[i] = tex
				end

				button._auroraRelicTex = relic
			end

			for i = 1, #button._auroraRelicTex do
				local tex = button._auroraRelicTex[i]
				tex:SetColorTexture(color.r, color.g, color.b)
			end
			button._auroraRelicTex:Show()
		elseif button._auroraRelicTex then
			button._auroraRelicTex:Hide()
		end
	end

	function MERS.SetItemButtonQuality(button, quality, itemIDOrLink)
		if button._auroraIconBorder then
			local isRelic = (itemIDOrLink and _G.IsArtifactRelicItem(itemIDOrLink))

			if quality then
				local color = _G.type(quality) == "table" and quality or _G.BAG_ITEM_QUALITY_COLORS[quality]
				if color and color == quality or quality >= _G.LE_ITEM_QUALITY_COMMON then
					SetRelic(button, isRelic, color)
					button._auroraIconBorder:SetBackdropBorderColor(color.r, color.g, color.b)
					button.IconBorder:Hide()
				else
					SetRelic(button, false)
					button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
				end
			else
				SetRelic(button, false)
				button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
end
hooksecurefunc("SetItemButtonQuality", MERS.SetItemButtonQuality)