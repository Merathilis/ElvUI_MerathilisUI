local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local C = W.Utilities.Color

local options = module.options.information.args

local format, gsub, strjoin, strsplit = string.format, string.gsub, strjoin, strsplit
local ipairs, mod, tonumber, tostring, unpack = ipairs, mod, tonumber, tostring, unpack
local tconcat, tsort = table.concat, table.sort

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end

local DONATORS = {
	"enii",
	"Hope",
	"Kisol",
	"Natsuruseno",
	"Rylok",
	"Amenitra",
	"zarbol",
	"Olli2k",
	"Dlarge",
	"N3",
	"Aary",
	"Daniel",
	"skychilde",
	"Grougwarth",
	"Sylfarion",
	"Andrey",
	"Jake",
	"Jiberish",
	"Xu Dehua",
	"Baraius",
	"Dream",
}
tsort(DONATORS, SortList)
local DONATOR_STRING = tconcat(DONATORS, ", ")

local PATRONS = {
	"Graldur",
	"Deezyl",
	"Zhadar",
	"Dadedadeur",
}
tsort(PATRONS, SortList)
local PATRONS_STRING = tconcat(PATRONS, ", ")

local DEVELOPER = {
	"|cff0070DEAzilroka|r",
	"|cffd12727Blazeflack|r",
	"|cff00c0faBenik|r",
	"|cff9482c9Darth Predator|r",
	"|TInterface/AddOns/ElvUI/Core/Media/ChatLogos/Beer:15:15:0:0:64:64:5:59:5:59|t |cfff48cbaRepooc|r",
	E:TextGradient(
		"Simpy but my name needs to be longer",
		0.27,
		0.72,
		0.86,
		0.51,
		0.36,
		0.80,
		0.69,
		0.28,
		0.94,
		0.94,
		0.28,
		0.63,
		1.00,
		0.51,
		0.00,
		0.27,
		0.96,
		0.43
	),
	"fgprodigal",
	C.StringByTemplate("fang2hou", "blue-400"),
	"siweia",
	"|cff0080ffWitness|r (NDui_Plus)",
	"|cff1784d1Eltreum|r",
	"|cff18a8ffToxi|r",
	"mcc1",
}

local URL = {
	website = MER.WebsiteURL,
	discord = MER.DiscordURL,
	issues = "https://github.com/Merathilis/ElvUI_MerathilisUI/issues",
	curseforge = "https://www.curseforge.com/wow/addons/merathilis-ui",
	wago = "https://addons.wago.io/addons/elvui-merathilisui",
	development = "https://github.com/Merathilis/ElvUI_MerathilisUI/archive/refs/heads/development.zip",
	patreon = "https://www.patreon.com/merathilisui",
	sponsors = "https://github.com/sponsors/Merathilis",
	kofi = "https://ko-fi.com/C0C2CR58G",
	paypal = "https://paypal.me/merathilis",
	tukui = "https://tukui.org/",
	tukuiDiscord = "https://discord.gg/xFWcfgE",
}

-- Brand colors, used for the hover border of the tiles and the supporter labels
local COLOR = {
	website = "ff7d0a",
	discord = "5865f2",
	curseforge = "f16537",
	patreon = "ff424d",
	sponsors = "ea4aaa",
	kofi = "ff5e5c",
	paypal = "009cde",
	tukui = "ff7a1e",
	warning = "ffb333",
}

-- Exact fractions would add up to a hair more than the row width in floating
-- point and push the last tile into the next row
local THIRD, QUARTER = 0.333, 0.25

local BRAND = I.Media.Icons.Brands

local function InlineIcon(icon)
	return format("|T%s:16:16:0:0:64:64:0:64:0:64|t", icon)
end

local function Highlight(text)
	return E:RGBToHex(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b) .. text .. "|r"
end

local function ShowURL(url)
	E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, url)
end

local function Header(order, name)
	return {
		order = order,
		type = "header",
		name = name,
	}
end

local function Spacer(order)
	return {
		order = order,
		type = "description",
		name = " ",
		width = "full",
	}
end

-- A clickable tile with a logo; the link opens in the copy popup
local function LinkTile(order, title, subtitle, icon, color, url, relWidth)
	return {
		order = order,
		type = "execute",
		dialogControl = "MERLinkTile",
		name = title,
		desc = url,
		image = icon,
		width = "relative",
		relWidth = relWidth,
		arg = { subtitle = subtitle, color = color },
		func = function()
			ShowURL(url)
		end,
	}
end

local function TextCard(order, title, icon, color, text)
	return {
		order = order,
		type = "description",
		dialogControl = "MERTextCard",
		fontSize = "medium",
		name = text,
		arg = { title = title, icon = icon, color = color },
	}
end

local args = {}

options.name = {
	order = 1,
	type = "group",
	name = module:AddCategorieIcon(L["Information"], "info"),
	args = args,
}

-- Links
args.linksHeader = Header(1, L["Support & Downloads"])
args.website = LinkTile(2, L["Website"], "merathilisui.com", BRAND.MerathilisUI, COLOR.website, URL.website, THIRD)
args.discord = LinkTile(3, "Discord", L["Join the community"], BRAND.Discord, COLOR.discord, URL.discord, THIRD)
args.issues = LinkTile(4, "GitHub", L["Report bugs and suggestions"], BRAND.GitHub, nil, URL.issues, THIRD)
args.curseforge =
	LinkTile(5, "CurseForge", L["Via the CurseForge app"], BRAND.CurseForge, COLOR.curseforge, URL.curseforge, THIRD)
args.wago = LinkTile(6, "Wago Addons", L["Via the Wago app"], BRAND.Wago, nil, URL.wago, THIRD)
args.development =
	LinkTile(7, L["Development Version"], L["Latest development build"], BRAND.GitHub, nil, URL.development, THIRD)
args.bugReport = TextCard(
	8,
	L["Found a Bug?"],
	I.Media.Icons.Warning,
	COLOR.warning,
	format(
		L["Before you submit a bug, please enable debug mode with %s and test it one more time."],
		Highlight("/muidebug")
	)
		.. "\n"
		.. format(
			L["If you get an error, open the Status Report with %s, click %s and paste the text into your report."],
			Highlight("/mui status"),
			Highlight("Copy Report")
		)
)

-- Donations
args.supportSpacer = Spacer(10)
args.supportHeader = Header(11, L["Support the Project"])
args.supportText = {
	order = 12,
	type = "description",
	fontSize = "medium",
	width = "full",
	name = L["MerathilisUI is free and I work on it in my spare time. If you enjoy it, you can support its development here."]
		.. "\n ",
}
args.patreon = LinkTile(13, "Patreon", L["Monthly support"], BRAND.Patreon, COLOR.patreon, URL.patreon, QUARTER)
args.sponsors = LinkTile(
	14,
	"GitHub Sponsors",
	L["Monthly or one-time"],
	BRAND.GitHubSponsors,
	COLOR.sponsors,
	URL.sponsors,
	QUARTER
)
args.kofi = LinkTile(15, "Ko-fi", L["Buy me a coffee"], BRAND.KoFi, COLOR.kofi, URL.kofi, QUARTER)
args.paypal = LinkTile(16, "PayPal", L["One-time donation"], BRAND.PayPal, COLOR.paypal, URL.paypal, QUARTER)
args.supporters = TextCard(
	17,
	L["Thank You!"],
	I.Media.Icons.Favorite,
	nil,
	format(
		"%s  |cff%s%s|r\n%s\n\n%s  |cff%s%s|r\n%s",
		InlineIcon(BRAND.Patreon),
		COLOR.patreon,
		L["Patrons"],
		PATRONS_STRING,
		InlineIcon(BRAND.PayPal),
		COLOR.paypal,
		"PayPal",
		DONATOR_STRING
	)
)

-- Tukui
args.tukuiSpacer = Spacer(20)
args.tukuiHeader = Header(21, L["Tukui"])
args.tukui = LinkTile(22, "Tukui", L["Home of ElvUI"], BRAND.Tukui, COLOR.tukui, URL.tukui, THIRD)
args.tukuiDiscord = LinkTile(
	23,
	L["Tukui Discord Server"],
	L["ElvUI support and community"],
	BRAND.Discord,
	COLOR.discord,
	URL.tukuiDiscord,
	THIRD
)

-- Credits
args.creditsSpacer = Spacer(30)
args.creditsHeader = Header(31, L["Credits"])
args.testing = TextCard(
	32,
	L["Testing & Inspiration"],
	nil,
	nil,
	"Benik, Darth Predator, Rockxana, " .. InlineIcon(BRAND.Tukui) .. " The Tukui Community"
)
args.coding = TextCard(
	33,
	L["Coding"],
	nil,
	nil,
	format(
		L["Many thanks to these wonderful persons for letting me use some of their code: %s."],
		strjoin(", ", unpack(DEVELOPER))
	)
)

do
	local localizationList = {
		{ "Deutsch (deDE)", I.Media.Icons.German, { "|cff00c0faDlarge|r" } },
		{ "한국어 (koKR)", I.Media.Icons.Korean, { "Crazyyoungs @ GitHub" } },
		{ "русский язык (ruRU)", I.Media.Icons.Russian, { "Hollicsh @ GitHub" } },
	}

	local lines = {}
	for _, entry in ipairs(localizationList) do
		local language, flag, credits = unpack(entry)
		lines[#lines + 1] = format(
			"%s  %s:  %s",
			F.GetIconString(flag, 10, 20),
			C.StringByTemplate(language, "blue-500"),
			tconcat(credits, ", ")
		)
	end

	args.localization = TextCard(34, L["Localization"], nil, nil, tconcat(lines, "\n"))
end

options.changelog = {
	order = 2,
	type = "group",
	childGroups = "select",
	name = module:AddCategorieIcon(L["Changelog"], "Changelog"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = L["Changelog"],
		},
	},
}

-- Hide the "I got it!" button once read, and for versions newer than the installed one
local function IsChangelogConfirmHidden(changelogVer, addonVer)
	local readVer = E.global.mui and tonumber(E.global.mui.changelogRead)
	return readVer and readVer >= changelogVer or addonVer < changelogVer
end

local function renderChangeLogLine(line)
	line = gsub(line, "%[[^%[]+%]", function(text)
		return C.StringByTemplate(text, "blue-500")
	end)
	return line
end

for version, data in next, MER.Changelog do
	local versionString = format("%d.%02d", version / 100, mod(version, 100))
	local changelogVer = tonumber(versionString)
	local addonVer = MER.Version and tonumber(MER.Version) or 0
	local dateTable = { strsplit("/", data.RELEASE_DATE) }
	local dateString = data.RELEASE_DATE
	if #dateTable == 3 then
		dateString = L["%day%-%month%-%year%"]
		dateString = gsub(dateString, "%%day%%", dateTable[1])
		dateString = gsub(dateString, "%%month%%", dateTable[2])
		dateString = gsub(dateString, "%%year%%", dateTable[3])
	end

	options.changelog.args[tostring(version)] = {
		order = 1000 - version,
		name = versionString,
		type = "group",
		args = {},
	}

	local page = options.changelog.args[tostring(version)].args

	page.date = {
		order = 1,
		type = "description",
		name = "|cffbbbbbb" .. dateString .. " " .. L["Released"] .. "|r",
		fontSize = "small",
	}

	page.version = {
		order = 2,
		type = "description",
		name = L["Version"] .. " " .. F.String.MERATHILISUI(versionString),
		fontSize = "large",
	}

	local warningIcon = F.GetIconString(I.Media.Icons.Warning, 12)
	local thunderIcon = F.GetIconString(I.Media.Icons.Flash, 12)
	local newIcon = F.GetIconString(I.Media.Icons.New, 12)

	local fixPart = data and data.FIXES
	if fixPart and #fixPart > 0 then
		page.importantHeader = {
			order = 3,
			type = "header",
			name = warningIcon .. " " .. F.String.FastGradientHex(L["Fixes"], "#ffa270", "#c63f17"),
		}
		page.important = {
			order = 4,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(fixPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local newPart = data and data.NEW
	if newPart and #newPart > 0 then
		page.newHeader = {
			order = 5,
			type = "header",
			name = newIcon .. " " .. F.String.FastGradientHex(L["New"], "#fffd61", "#c79a00"),
		}
		page.new = {
			order = 6,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(newPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	local improvementPart = data and data.IMPROVEMENTS
	if improvementPart and #improvementPart > 0 then
		page.improvementHeader = {
			order = 7,
			type = "header",
			name = thunderIcon .. " " .. F.String.FastGradientHex(L["Improvements"], "#98ee99", "#338a3e"),
		}
		page.improvement = {
			order = 8,
			type = "description",
			name = function()
				local text = ""
				for index, line in ipairs(improvementPart) do
					text = text .. format("%02d", index) .. ". " .. renderChangeLogLine(line) .. "\n"
				end
				return text .. "\n"
			end,
			fontSize = "medium",
		}
	end

	page.beforeConfirm1 = {
		order = 9,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			return IsChangelogConfirmHidden(changelogVer, addonVer)
		end,
	}

	page.beforeConfirm2 = {
		order = 10,
		type = "description",
		name = " ",
		width = "full",
		hidden = function()
			return IsChangelogConfirmHidden(changelogVer, addonVer)
		end,
	}

	page.confirm = {
		order = 11,
		type = "execute",
		name = C.StringByTemplate(L["I got it!"], "teal-400"),
		desc = L["Mark as read, the changelog message will be hidden when you login next time."],
		width = "full",
		hidden = function()
			return IsChangelogConfirmHidden(changelogVer, addonVer)
		end,
		func = function()
			E.global.mui.changelogRead = versionString
		end,
	}
end
