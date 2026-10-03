local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local options = module.options.presets.args

F.MarkTabAsNew("presets")

local format, ipairs, strtrim, tconcat = format, ipairs, strtrim, table.concat

local PRESETS_URL = MER.WebsiteURL .. "/presets"

local COLOR_ERROR = "ff4d4d"

local function Highlight(text)
	return E:RGBToHex(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b) .. text .. "|r"
end

local function ShowURL(url)
	E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, url)
end

local function WebsiteTile(order, title, subtitle)
	return {
		order = order,
		type = "execute",
		dialogControl = "MERLinkTile",
		name = title,
		desc = PRESETS_URL,
		image = I.Media.Icons.Brands.MerathilisUI,
		width = "full",
		arg = { subtitle = subtitle, color = "ff7d0a" },
		func = function()
			ShowURL(PRESETS_URL)
		end,
	}
end

local APPLY_TEXT =
	L["Apply the preset %s as a new ElvUI profile? Your current profile stays untouched, the private settings of this character are kept as a backup. The UI reloads afterwards."]

--[[-----------------------------------------------------------------------------
Official
-------------------------------------------------------------------------------]]
do
	-- Exact thirds would add up to a hair more than the row width
	local THIRD = 0.333

	E.PopupDialogs.MERATHILISUI_APPLY_BUILTIN_PRESET = {
		text = APPLY_TEXT,
		button1 = _G.ACCEPT,
		button2 = _G.CANCEL,
		button3 = L["Copy Code"],
		OnAccept = function(_, def)
			F.Presets.Apply({ kind = "builtin", key = def.key })
		end,
		OnAlt = function(_, def)
			ShowURL(F.Presets.GetBuiltinCode(def.key))
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
	}

	local args = {
		desc = {
			order = 1,
			type = "description",
			fontSize = "medium",
			width = "full",
			name = format(
				L["Presets made by the author of %s. Each one starts from the current MerathilisUI layout, so it stays up to date with every release."],
				MER.Title
			) .. "\n ",
		},
	}

	for i, def in ipairs(F.Presets.GetBuiltins()) do
		args[def.key] = {
			order = 10 + i,
			type = "execute",
			dialogControl = "MERPresetCard",
			name = def.name,
			image = def.preview,
			imageCoords = def.previewCoords,
			width = "relative",
			relWidth = THIRD,
			arg = { desc = def.desc },
			func = function()
				E:StaticPopup_Show("MERATHILISUI_APPLY_BUILTIN_PRESET", F.String.MERATHILISUI(def.name), nil, def)
			end,
		}
	end

	options.official = {
		order = 1,
		type = "group",
		name = L["Official Presets"],
		args = args,
	}
end

--[[-----------------------------------------------------------------------------
Import
-------------------------------------------------------------------------------]]
do
	local code, preset, err = "", nil, nil

	-- MERTextCard reads its title, icon and color from `arg` on every redraw
	local previewArg = {}

	local function UpdatePreview()
		if err then
			previewArg.title = L["Invalid Code"]
			previewArg.icon = I.Media.Icons.Warning
			previewArg.color = COLOR_ERROR
			return
		end

		local meta = preset.meta
		previewArg.title = meta.name ~= "" and meta.name or L["Preset"]
		previewArg.icon = I.Media.Icons.Brands.MerathilisUI
		previewArg.color = nil
	end

	-- AceConfigDialog reads the name of hidden options too, so it runs without a code as well
	local function PreviewText()
		if err then
			return err
		elseif not preset then
			return ""
		end

		local meta = preset.meta
		local lines = {}

		if preset.kind == "builtin" then
			lines[#lines + 1] = format(L["Official preset, included in %s."], MER.Title)
		else
			if meta.author and meta.author ~= "" then
				lines[#lines + 1] = format("%s: %s", L["Author"], Highlight(meta.author))
			end

			local client = meta.client == "forever" and "WoW Forever" or "Retail"
			lines[#lines + 1] = format("%s: %s %s, %s", L["Made with"], MER.Title, meta.mer or "?", client)
		end

		if meta.desc and meta.desc ~= "" then
			lines[#lines + 1] = " "
			lines[#lines + 1] = meta.desc
		end

		local warnings = F.Presets.GetWarnings(preset)
		if #warnings > 0 then
			lines[#lines + 1] = " "
			for _, warning in ipairs(warnings) do
				lines[#lines + 1] = F.String.Warning(warning)
			end
		end

		return tconcat(lines, "\n")
	end

	local function SetCode(value)
		code = strtrim(value or "")
		preset, err = nil, nil

		if code ~= "" then
			preset, err = F.Presets.Decode(code)
			UpdatePreview()
		end
	end

	E.PopupDialogs.MERATHILISUI_APPLY_PRESET = {
		text = APPLY_TEXT,
		button1 = _G.ACCEPT,
		button2 = _G.CANCEL,
		OnAccept = function()
			if preset then
				F.Presets.Apply(preset)
			end
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
	}

	options.import = {
		order = 2,
		type = "group",
		name = L["Import"],
		args = {
			desc = {
				order = 1,
				type = "description",
				fontSize = "medium",
				width = "full",
				name = format(
					L["Paste a preset code from %s or from another player. The preset becomes a new ElvUI profile, so you can switch back to your current one at any time."],
					Highlight("merathilisui.com/presets")
				) .. "\n ",
			},
			code = {
				order = 2,
				type = "input",
				name = L["Preset Code"],
				multiline = 8,
				width = "full",
				get = function()
					return code
				end,
				set = function(_, value)
					SetCode(value)
				end,
			},
			preview = {
				order = 3,
				type = "description",
				dialogControl = "MERTextCard",
				fontSize = "medium",
				name = function()
					return PreviewText()
				end,
				arg = previewArg,
				hidden = function()
					return code == ""
				end,
			},
			apply = {
				order = 4,
				type = "execute",
				name = L["Apply Preset"],
				disabled = function()
					return not preset
				end,
				func = function()
					local name = preset.meta.name ~= "" and preset.meta.name or L["Preset"]
					E:StaticPopup_Show("MERATHILISUI_APPLY_PRESET", F.String.MERATHILISUI(name))
				end,
			},
			spacer = {
				order = 5,
				type = "description",
				name = " ",
				width = "full",
			},
			website = WebsiteTile(6, L["Find More Presets"], L["Browse the presets of the community on merathilisui.com"]),
		},
	}
end

--[[-----------------------------------------------------------------------------
Export
-------------------------------------------------------------------------------]]
do
	local name, author, desc, output = "", E.myname, "", ""

	options.export = {
		order = 3,
		type = "group",
		name = L["Export"],
		args = {
			desc = {
				order = 1,
				type = "description",
				fontSize = "medium",
				width = "full",
				name = L["Turn your current setup into a preset code: the active ElvUI profile with all MerathilisUI settings and the private settings of this character."]
					.. "\n ",
			},
			name = {
				order = 2,
				type = "input",
				name = L["Name"],
				get = function()
					return name
				end,
				set = function(_, value)
					name = strtrim(value)
					output = ""
				end,
			},
			author = {
				order = 3,
				type = "input",
				name = L["Author"],
				get = function()
					return author
				end,
				set = function(_, value)
					author = strtrim(value)
					output = ""
				end,
			},
			description = {
				order = 4,
				type = "input",
				name = L["Description"],
				multiline = 3,
				width = "full",
				get = function()
					return desc
				end,
				set = function(_, value)
					desc = strtrim(value)
					output = ""
				end,
			},
			create = {
				order = 5,
				type = "execute",
				name = L["Create Code"],
				disabled = function()
					return name == ""
				end,
				func = function()
					output = F.Presets.Export(name, author, desc) or ""
				end,
			},
			output = {
				order = 6,
				type = "input",
				name = L["Preset Code"],
				desc = L["Select the code with CTRL+A and copy it with CTRL+C."],
				multiline = 8,
				width = "full",
				hidden = function()
					return output == ""
				end,
				get = function()
					return output
				end,
				set = E.noop,
			},
			spacer = {
				order = 7,
				type = "description",
				name = " ",
				width = "full",
			},
			website = WebsiteTile(8, L["Share Your Preset"], L["Upload it with a few screenshots on merathilisui.com"]),
		},
	}
end
