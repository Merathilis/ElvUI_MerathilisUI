local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.changelog.args
local C = MER.Utilities.Color

local function Color(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end
	return C.StringWithRGB(string, E.db.general.valuecolor)
end

options.changelog = {
	order = 1,
	type = "group",
	childGroups = "select",
	name = L["Changelog"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Changelog"], "orange"),
		},
	},
}

local function renderChangeLogLine(line)
	line = gsub(line, "%[!%]", E.NewSign)
	line = gsub(line, "%[[^%[]+%]", Color)
	return line
end

for version, data in pairs(MER.Changelog) do
	local versionString = format("%d.%02d", version / 100, mod(version, 100))
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
end
