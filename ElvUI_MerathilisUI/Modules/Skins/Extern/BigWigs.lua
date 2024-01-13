local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G
local unpack = unpack
local format = format

local C_Timer_NewTicker = C_Timer.NewTicker

local pool = {
	spark = {},
	backdrops = {}
}

function pool:Get(type)
	if type == "backdrop" then
		if #pool.backdrops > 0 then
			return tremove(pool.backdrops)
		end

		local backdrop = CreateFrame("Frame", nil, E.UIParent)
		backdrop:SetTemplate("Transparent")
		module:CreateShadow(backdrop)
		backdrop:Styling()
		backdrop.MERPoolType = "backdrop"

		return backdrop
	elseif type == "spark" then
		if #pool.spark > 0 then
			return tremove(pool.spark)
		end

		local spark = E.UIParent:CreateTexture(nil, "ARTWORK", nil, 1)
		spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		spark:SetBlendMode("ADD")
		spark:SetSize(4, 26)

		spark.MERPoolType = "spark"

		return spark
	end
end

function pool:Release(target)
	if target.MERPoolType == "backdrop" then
		target:Hide()
		target:SetParent(E.UIParent)
		target:ClearAllPoints()
		tinsert(pool.backdrops, target)
	elseif target.MERPoolType == "spark" then
		target:Hide()
		target:SetParent(E.UIParent)
		target:ClearAllPoints()
		tinsert(pool.spark, target)
	end
end

local function getPoints(object)
	local points = {}
	local point, relativeTo, relativePoint, xOfs, yOfs = object:GetPoint()
	while point do
		points[#points + 1] = { point, relativeTo, relativePoint, xOfs, yOfs }
		point, relativeTo, relativePoint, xOfs, yOfs = object:GetPoint(#points + 1)
	end
	return points
end

local function applyPoints(object, points)
	if not points or #points == 0 then
		return
	end

	object:ClearAllPoints()
	for i = 1, #points do
		local point, relativeTo, relativePoint, xOfs, yOfs = unpack(points[i])
		object:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
	end
end

local function modifyStyle(frame)
	local emphasized = frame:Get("bigwigs:emphasized")

	local db = emphasized and E.private.mui.skins.addonSkins.bw.emphasizedBar or E.private.mui.skins.addonSkins.bw.normalBar

	E:SetSmoothing(frame.candyBarBar, db.smooth)

	local barColor = frame:Get("bigwigs:merathilisui:barcolor")

	if db.colorOverride then
		local statusBarTexture = frame.candyBarBar:GetStatusBarTexture()

		if not barColor then
			frame:Set("bigwigs:merathilisui:barcolor", { statusBarTexture:GetVertexColor() })
		end

		statusBarTexture:SetGradient("HORIZONTAL", F.CreateColorFromTable(db.colorLeft), F.CreateColorFromTable(db.colorRight))
	else
		if barColor then
			frame.candyBarBar:GetStatusBarTexture():SetVertexColor(unpack(barColor))
		end
	end

	local spark = frame:Get("bigwigs:merathilisui:spark")

	if spark then
		spark:SetSize(4, frame.candyBarBar:GetHeight() * 2)
		spark:SetShown(db.spark)
	end
end

local function applyStyle(frame)
	-- BigWigs update the bar type after styling, need hook Set method to update the style
	if not module:IsHooked(frame, "Set") then
		module:SecureHook(frame, "Set", function(self, key, value)
			if key == "bigwigs:emphasized" then
				modifyStyle(self)
			end
		end)
	end

	local height = frame:GetHeight()
	frame:SetHeight(height/2)
	frame:Set("bigwigs:merathilisui:originalheight", height)

	local spark = pool:Get("spark")
	spark:SetParent(frame.candyBarBar)
	spark:ClearAllPoints()
	spark:SetPoint("CENTER", frame.candyBarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
	spark:SetBlendMode("ADD")
	spark:Show()
	frame:Set("bigwigs:merathilisui:spark", spark)

	modifyStyle(frame)

	local barBackdrop = pool:Get("backdrop")
	barBackdrop:SetParent(frame.candyBarBar)
	barBackdrop:ClearAllPoints()
	barBackdrop:SetOutside(frame.candyBarBar, E.twoPixelsPlease and 2 or 1, E.twoPixelsPlease and 2 or 1)
	barBackdrop:SetFrameStrata(frame.candyBarBackdrop:GetFrameStrata())
	barBackdrop:SetFrameLevel(frame.candyBarBackdrop:GetFrameLevel())
	barBackdrop:Show()
	frame:Set("bigwigs:merathilisui:barbackdrop", barBackdrop)

	frame:Set("bigwigs:merathilisui:barbackgroundisshown", frame.candyBarBackground:IsShown())
	frame.candyBarBackground:Hide()

	local tex = frame:GetIcon()
	if tex then
		frame:SetIcon(nil)
		frame.candyBarIconFrame:SetTexture(tex)
		frame.candyBarIconFrame:Show()

		frame:Set("bigwigs:merathilisui:iconpoints", getPoints(frame.candyBarIconFrame))

		if frame.iconPosition == "RIGHT" then
			frame.candyBarIconFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
		else
			frame.candyBarIconFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -5, 0)
		end

		frame.candyBarIconFrame:SetSize(height + 2, height + 2)
		frame:Set("bigwigs:merathilisui:tex", tex)

		local iconBackdrop = pool:Get("backdrop")
		iconBackdrop:SetParent(frame)
		iconBackdrop:ClearAllPoints()
		iconBackdrop:SetOutside(frame.candyBarIconFrame, E.twoPixelsPlease and 2 or 1, E.twoPixelsPlease and 2 or 1)
		iconBackdrop:SetFrameStrata(frame.candyBarIconFrameBackdrop:GetFrameStrata())
		iconBackdrop:SetFrameLevel(frame.candyBarIconFrameBackdrop:GetFrameLevel())
		iconBackdrop:Show()
		frame:Set("bigwigs:merathilisui:iconbackdrop", iconBackdrop)
	end

	frame:Set("bigwigs:merathilisui:durationpoints", getPoints(frame.candyBarDuration))
	frame.candyBarLabel:SetShadowOffset(0, 0)
	frame.candyBarLabel:ClearAllPoints()
	frame.candyBarLabel:SetPoint("BOTTOMLEFT", frame.candyBarBar, "TOPLEFT", 3, -height * 0.22)

	frame:Set("bigwigs:merathilisui:labelpoints", getPoints(frame.candyBarLabel))
	frame.candyBarDuration:SetShadowOffset(0, 0)
	frame.candyBarDuration:ClearAllPoints()
	frame.candyBarDuration:SetPoint("BOTTOMRIGHT", frame.candyBarBar, "TOPRIGHT", -3, -height * 0.22)
end

local function barStopped(frame)
	local durationPoints = frame:Get("bigwigs:merathilisui:durationpoints")
	if durationPoints then
		applyPoints(frame.candyBarDuration, durationPoints)
		frame:Set("bigwigs:merathilisui:durationpoints", nil)
	end

	local labelPoints = frame:Get("bigwigs:merathilisui:labelpoints")
	if labelPoints then
		applyPoints(frame.candyBarLabel, labelPoints)
		frame:Set("bigwigs:merathilisui:labelpoints", nil)
	end

	local iconBackdrop = frame:Get("bigwigs:merathilisui:iconbackdrop")
	if iconBackdrop then
		pool:Release(iconBackdrop)
		iconBackdrop:Hide()
		frame:Set("bigwigs:merathilisui:iconbackdrop", nil)
	end

	local iconPoints = frame:Get("bigwigs:merathilisui:iconpoints")
	if iconPoints then
		applyPoints(frame.candyBarIconFrame, iconPoints)
		frame:Set("bigwigs:merathilisui:iconpoints", nil)
	end

	local tex = frame:Get("bigwigs:merathilisui:tex")
	if tex then
		frame:SetIcon(tex)
		frame:Set("bigwigs:merathilisui:tex", nil)
	end

	local barBackgroundIsShown = frame:Get("bigwigs:merathilisui:barbackgroundisshown")
	if barBackgroundIsShown then
		frame.candyBarBackground:SetShown(barBackgroundIsShown)
		frame:Set("bigwigs:merathilisui:barbackgroundisshown", nil)
	end

	local barBackdrop = frame:Get("bigwigs:merathilisui:barbackdrop")
	if barBackdrop then
		pool:Release(barBackdrop)
		barBackdrop:Hide()
		frame:Set("bigwigs:merathilisui:barbackdrop", nil)
	end

	local spark = frame:Get("bigwigs:merathilisui:spark")
	if spark then
		spark:Hide()
		pool:Release(spark)
		frame:Set("bigwigs:merathilisui:spark", nil)
	end

	local barColor = frame:Get("bigwigs:merathilisui:barcolor")
	if barColor then
		frame.candyBarBar:GetStatusBarTexture():SetVertexColor(unpack(barColor))
		frame:Set("bigwigs:merathilisui:barcolor", nil)
	end

	E:SetSmoothing(frame.candyBarBar, false)

	local height = frame:Get("bigwigs:merathilisui:originalheight")
	if height then
		frame:SetHeight(height)
	end
end

function module:BigWigs_Plugins()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bw.enable then
		return
	end

	if not _G.BigWigs or not _G.BigWigsAPI then
		return
	end

	_G.BigWigsAPI:RegisterBarStyle(
		MER.Title,
		{
			apiVersion = 1,
			version = 1,
			barSpacing = function(bar) return bar:GetHeight()+7 end,
			fontSizeNormal = 13,
			fontSizeEmphasized = 15,
			fontOutline = "SHADOWOUTLINE",
			ApplyStyle = applyStyle,
			BarStopped = barStopped,
			GetStyleName = function()
				return MER.Title
			end
		}
	)
end

function module:BigWigs_QueueTimer()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.bw.queueTimer.enable then
		return
	end

	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage("MerathilisUI", "BigWigs_FrameCreated", function(_, frame, name)
			local db = E.private.mui.skins.addonSkins.bw.queueTimer
			if name == "QueueTimer" then
				local parent = frame:GetParent()
				frame:StripTextures()
				frame:CreateBackdrop("Transparent")
				frame.backdrop:Styling()
				self:CreateBackdropShadow(frame)

				E:SetSmoothing(frame, db.smooth)

				local statusBarTexture = frame:GetStatusBarTexture()
				statusBarTexture:SetTexture(E.media.normTex)
				statusBarTexture:SetGradient("HORIZONTAL", F.CreateColorFromTable(db.colorLeft), F.CreateColorFromTable(db.colorRight))

				if db.spark then
					frame.spark = frame:CreateTexture(nil, "ARTWORK", nil, 1)
					frame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
					frame.spark:SetBlendMode("ADD")
					frame.spark:SetSize(4, frame:GetHeight())
				end

				frame:SetSize(parent:GetWidth(), 10)
				frame:ClearAllPoints()
				frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 1, -5)
				frame:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", -1, -5)
				frame.text.SetFormattedText = function(self, _, time)
					self:SetText(format("%d", time))
				end
				F.SetFontDB(frame.text, db.countDown)
				frame.text:ClearAllPoints()
				frame.text:SetPoint("TOP", frame, "TOP", db.countDown.offsetX, db.countDown.offsetY)
			end
		end)

		E:Delay(2, function()
			_G.BigWigsLoader.UnregisterMessage("AddOnSkins", "BigWigs_FrameCreated")
		end)
	end
end

module:AddCallbackForAddon("BigWigs_Plugins")
module:AddCallbackForEnterWorld("BigWigs_QueueTimer")
