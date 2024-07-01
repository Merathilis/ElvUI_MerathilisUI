local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_SplashScreen")

local CreateFrame = CreateFrame

function module:CreateFrame()
	module.backgroundFade = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	module.backgroundFade:SetAllPoints(E.UIParent)
	module.backgroundFade:SetFrameStrata("TOOLTIP")
	module.backgroundFade:SetFrameLevel(10000)
	module.backgroundFade:EnableMouse(true)
	module.backgroundFade:EnableMouseWheel(true)
	module.backgroundFade:SetAlpha(1)
	module.backgroundFade:Hide()

	MER:CreateInnerNoise(module.backgroundFade)
	MER:CreateInnerShadow(module.backgroundFade)

	local bg = F.Table.HexToRGB("#282828cc")
	local gr = F.Table.HexToRGB(I.Strings.Colors[I.Enum.Colors.MER])

	module.backgroundFade.bg = module.backgroundFade:CreateTexture(nil, "BACKGROUND")
	module.backgroundFade.bg:SetAllPoints()
	module.backgroundFade.bg:SetTexture(E.media.blankTex)
	module.backgroundFade.bg:SetVertexColor(bg.r, bg.g, bg.b, bg.a)

	module.backgroundFade.gradient = module.backgroundFade:CreateTexture(nil, "ARTWORK")
	module.backgroundFade.gradient:Point("BOTTOM", module.backgroundFade, "BOTTOM", 0, 0)
	module.backgroundFade.gradient:Size(F.PerfectScale(E.screenWidth), 40)
	module.backgroundFade.gradient:SetTexture(I.Media.Textures.WorldStateScore)
	module.backgroundFade.gradient:SetVertexColor(1, 1, 1, 1)
	F.SetGradientRGB(
		module.backgroundFade.gradient,
		I.Enum.GradientMode.Mode[I.Enum.GradientMode.Mode.VERTICAL],
		gr.r,
		gr.g,
		gr.b,
		0.35,
		gr.r,
		gr.g,
		gr.b,
		0
	)

	module.backgroundFade.logo = module.backgroundFade:CreateTexture(nil, "OVERLAY")
	module.backgroundFade.logo:Point("BOTTOMRIGHT", module.backgroundFade, "BOTTOMRIGHT", -25, 25)
	module.backgroundFade.logo:SetTexture(I.Media.Logos.Logo)
	module.backgroundFade.logo:Size(128)

	module.backgroundFade.text = module.backgroundFade:CreateFontString(nil, "OVERLAY")
	module.backgroundFade.text:Point("BOTTOMLEFT", module.backgroundFade, "BOTTOMLEFT", 25, 25)
	module.backgroundFade.text:FontTemplate(nil, F.FontSizeScaled(64), "NONE")
	module.backgroundFade.text:SetTextColor(1, 1, 1, 1)
	module.backgroundFade.text:SetText(" ")
end
function module:Show(text)
	module.backgroundFade.text:SetText(text)
	module.backgroundFade:Show()
end

function module:Hide()
	module:CancelAllTimers()
	module.backgroundFade:Hide()
end

function module:Wrap(text, func, manualHide)
	module:CancelAllTimers()
	module:Show(text)

	module:ScheduleTimer(function()
		F.EventManagerDelayed(function()
			F.ProtectedCall(func)
			if not manualHide then
				F.EventManagerDelayed(module.Hide, self)
			end
		end)
	end, 0.2)

	-- Always force hide
	module:ScheduleTimer(function()
		F.EventManagerDelayed(module.Hide, self)
	end, 15)
end

function module:Initialize()
	if module.Initialized then
		return
	end

	-- Login Logo
	module:Logo_CheckStatus()

	module:CreateFrame()

	module.Initialized = true
end

MER:RegisterModule(module:GetName())
