local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local LOP
if type(LibStub) == "table" and type(LibStub.GetLibrary) == "function" then
	LOP = LibStub:GetLibrary("LibObjectiveProgress-1.0", true)
end
module.LOP = LOP

module.COLOR_DEFAULT = { r = 1, g = 1, b = 1 }
module.COLOR_DEAD = { r = 136 / 255, g = 136 / 255, b = 136 / 255 }
module.COLOR_HOSTILE = { r = 1, g = 68 / 255, b = 68 / 255 }
module.COLOR_NEUTRAL = { r = 1, g = 1, b = 68 / 255 }
module.COLOR_HOSTILE_UNATTACKABLE = { r = 210 / 255, g = 76 / 255, b = 56 / 255 }
module.COLOR_RARE = { r = 226 / 255, g = 228 / 255, b = 226 / 255 }
module.COLOR_ELITE = { r = 213 / 255, g = 154 / 255, b = 18 / 255 }
module.COLOR_COMPLETE = { r = 136 / 255, g = 136 / 255, b = 136 / 255 }
module.ICON_CHECKMARK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:11|t"
module.ICON_LIST = "- "

local function UpdateFrameContents(f)
	local frameName = module:GetTopMouseFocusName()
	if frameName ~= nil and frameName ~= "" and frameName ~= "WorldFrame" then
		return
	end

	local unitName = UnitName("mouseover")
	if unitName == nil then
		return
	end
	local unitText = module:GetTextWithColor(unitName, module:GetUnitNameColor("mouseover"))
	local levelText = module:GetLevelText()
	local targetText = module:GetTargetText()
	local statusText = module:GetStatusText()
	local classText = module:GetClassificationText()
	local tooltips = module:GetTooltipData()

	local mainText = levelText .. unitText .. targetText
	local headerText = statusText .. classText
	f.mainText:SetText(mainText)
	f.headerText:SetText(headerText)

	-- F.Developer.LogDebug(string.format("Unit: %s (%s)", mainText, headerText))

	local offset = 0
	local subTexts = module:CombineTables(module:GetQuestText("mouseover", tooltips))
	if subTexts and #subTexts > 0 then
		offset = 12 * #subTexts
		f.subText:SetText(table.concat(subTexts, "\n"))
	else
		f.subText:SetText("")
	end

	local width, height
	local mainTextValue = f.mainText:GetText()
	if mainTextValue and not issecretvalue(mainTextValue) then
		local okW, w = pcall(f.mainText.GetStringWidth, f.mainText)
		local okH, h = pcall(f.mainText.GetStringHeight, f.mainText)
		if okW and not issecretvalue(w) and type(w) == "number" then
			width = w
		end
		if okH and not issecretvalue(h) and type(h) == "number" then
			height = h
		end
	end

	width = width or 100
	height = height or 14

	local subCount = (subTexts and #subTexts) or 0
	width = math.max(1, width + 16)
	height = math.max(1, height + (12 * subCount))
	f:SetSize(width, height)
	f.mainText:SetPoint("TOP", f, "TOP", 0, offset)
	f.headerText:SetPoint("TOPLEFT", f.mainText, "TOPLEFT", 0, 12)
	f.subText:SetPoint("BOTTOMLEFT", f.mainText, "BOTTOMLEFT", 12, -1 + (-12 * subCount))

	f:Show()
end

local function UpdateFramePosition(f)
	if not UnitExists("mouseover") then
		f:Hide()
		return
	end

	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale + 15)
end

function module:Initialize()
	module.db = E.db.mui.nameHover

	if not module.db.enable or module.Initialized then
		return
	end

	local frame = CreateFrame("Frame", "MER_NameHoverFrame", E.UIParent)
	frame:SetFrameStrata("TOOLTIP")

	frame.mainText = frame:CreateFontString(nil, "OVERLAY")
	frame.mainText:FontTemplate(
		nil,
		module.db.mainTextSize or 14,
		module.db.mainTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.headerText = frame:CreateFontString(nil, "OVERLAY")
	frame.headerText:FontTemplate(
		nil,
		module.db.headerTextSize or 11,
		module.db.headerTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.subText = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	frame.subText:FontTemplate(nil, module.db.subTextSize or 11, module.db.subTextOutline and "SHADOWOUTLINE" or "NONE")

	frame:SetScript("OnUpdate", function(self)
		UpdateFramePosition(self)
	end)
	frame:SetScript("OnEvent", function(self)
		UpdateFrameContents(self)
	end)
	frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	module.Initialized = true
end

MER:RegisterModule(module:GetName())
