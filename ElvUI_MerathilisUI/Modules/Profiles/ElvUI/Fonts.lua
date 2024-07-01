local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")
local SP = MER:GetModule("MER_SplashScreen")

local ipairs, unpack = ipairs, unpack

local function customTextSize(args)
	local ret = {}
	for _, v in ipairs(args) do
		if not v then
			return
		end
		local name, font, size, outline, stopOverride = unpack(v)
		ret[name] = {
			font = stopOverride and font or F.FontOverride(font),
			size = F.FontSizeScaled(size),
			fontOutline = stopOverride and outline or F.FontStyleOverride(font, outline),
		}
	end
	return ret
end

function module:ElvUIFont()
	F.Table.Crush(E.db, {
		-- General
		general = {
			font = F.FontOverride(I.Fonts.Primary),
			fontSize = F.FontSizeScaled(10, 11),
			fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},

		fonts = {
			cooldown = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},

			errortext = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},

			mailbody = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
			},

			pvpsubzone = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},

			pvpzone = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},

			questsmall = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
			},

			questtext = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
			},

			questtitle = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "NONE"),
			},

			worldsubzone = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},

			worldzone = {
				enable = true,
				font = F.FontOverride(I.Fonts.Primary),
				outline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
			},
		},

		itemLevel = {
			itemLevelFont = F.FontOverride(I.Fonts.Primary),
			itemLevelFontSize = F.FontSize(12),
			itemLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

			totalLevelFont = F.FontOverride(I.Fonts.Primary),
			totalLevelFontSize = F.FontSize(13),
			totalLevelFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},

		altPowerBar = {
			font = F.FontOverride(I.Fonts.Primary),
			fontSize = F.FontSizeScaled(11),
			fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},

		minimap = {
			locationFont = F.FontOverride(I.Fonts.Primary),
			locationFontSize = F.FontSizeScaled(10),
			locationFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),

			icons = {
				queueStatus = {
					font = F.FontOverride(I.Fonts.Primary),
					fontSize = F.FontSizeScaled(11),
					fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
				},
			},
		},

		lootRoll = {
			nameFont = F.FontOverride(I.Fonts.Primary),
			nameFontSize = F.FontSizeScaled(14),
			nameFontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},

		totems = {
			font = F.FontOverride(I.Fonts.Primary),
			fontSize = F.FontSizeScaled(14),
			fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},

		addonCompartment = {
			font = F.FontOverride(I.Fonts.Primary),
			fontSize = F.FontSizeScaled(16),
			fontOutline = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},
	})
end

function module:ApplyFontChange()
	SP:Wrap("Applying fonts ...", function()
		-- Apply Fonts
		self:ElvUIFont()

		-- Update ElvUI Media
		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			-- Hide Splash
			MER:GetModule("MER_SplashScreen"):Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true)
end
