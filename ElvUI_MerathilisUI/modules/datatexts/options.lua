local MER, E, L, V, P, G = unpack(select(2, ...))
local LO = E:GetModule("Layout")
local DT = E:GetModule("DataTexts")

--Cache global variables
--Lua functions
local _G = _G
local pairs, print, type = pairs, print, type
--WoW API / Variables
local NONE = NONE

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: LibStub

function MER:LoadDataTexts()
	local db = E.db.mui.datatexts

	if db == nil then db = {} end

	if not db.panels then return end

	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i=1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]

			--Register Panel to Datatext
			for name, data in pairs(DT.RegisteredDataTexts) do
				for option, value in pairs(db.panels) do
					if value and type(value) == "table" then
						if option == panelName and db.panels[option][pointIndex] and db.panels[option][pointIndex] == name then
							DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						end
					elseif value and type(value) == "string" and value == name then
						if db.panels[option] == name and option == panelName then
							DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						end
					end
				end
			end
		end
	end
end
hooksecurefunc(DT, "LoadDataTexts", MER.LoadDataTexts)

local function Datatexts()
	E.Options.args.mui.args.modules.args.datatexts = {
		order = 13,
		type = "group",
		name = L["DataTexts"],
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["DataTexts"]),
			},
			muiSystemDT = {
				order = 2,
				type = "group",
				name = MER:cOption(L["System Datatext"]),
				guiInline = true,
				get = function(info) return E.db.mui.systemDT[ info[#info] ] end,
				set = function(info, value) E.db.mui.systemDT[ info[#info] ] = value; end,
				args = {
					maxAddons = {
						type = "range",
						order = 1,
						name = L["Max Addons"],
						desc = L["Maximum number of addons to show in the tooltip."],
						min = 1, max = 50, step = 1,
					},
					announceFreed = {
						type = "toggle",
						order = 2,
						name = L["Announce Freed"],
						desc = L["Announce how much memory was freed by the garbage collection."],
					},
					showFPS = {
						type = "toggle",
						order = 3,
						name = L["Show FPS"],
						desc = L["Show FPS on the datatext."],
					},
					showMemory = {
						type = "toggle",
						order = 4,
						name = L["Show Memory"],
						desc = L["Show total addon memory on the datatext."]
					},
					showMS = {
						type = "toggle",
						order = 5,
						name = L["Show Latency"],
						desc = L["Show latency on the datatext."],
					},
					latency = {
						type = "select",
						order = 6,
						name = L["Latency Type"],
						desc = L["Display world or home latency on the datatext. Home latency refers to your realm server. World latency refers to the current world server."],
						disabled = function() return not E.db.mui.systemDT.showMS end,
						values = {
							["home"] = L["Home"],
							["world"] = L["World"],
						},
					},
				},
			},
			general = {
				order = 2,
				type = "group",
				name = MER:cOption(L["General"]),
				guiInline = true,
				args = {
					rightChatTabDatatextPanel = {
						order = 1,
						type = "toggle",
						name = L["ChatTab Datatext Panel"],
						get = function(info) return E.db.mui.datatexts.rightChatTabDatatextPanel.enable end,
						set = function(info, value) E.db.mui.datatexts.rightChatTabDatatextPanel.enable = value; MER:GetModule("mUILayout"):ToggleChatPanel() end,
					},
					middleDTEnable = {
						order = 2,
						type = "toggle",
						name = L["Middle Datatext Panel"],
						get = function(info) return E.db.mui.datatexts.middle.enable end,
						set = function(info, value) E.db.mui.datatexts.middle.enable = value; MER:GetModule("mUILayout"):MiddleDatatextLayout() end,
					}
				},
			},
			middle = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Middle Datatext Panel"]),
				guiInline = true,
				args = {
					transparent = {
						order = 1,
						type = "toggle",
						name = L["Panel Transparency"],
						disabled = function() return not E.db.mui.datatexts.middle.enable end,
						get = function(info) return E.db.mui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.mui.datatexts.middle[ info[#info] ] = value; MER:GetModule('mUILayout'):MiddleDatatextLayout() end,
					},
					backdrop = {
						order = 2,
						type = "toggle",
						name = L["Backdrop"],
						disabled = function() return not E.db.mui.datatexts.middle.enable end,
						get = function(info) return E.db.mui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.mui.datatexts.middle[ info[#info] ] = value; MER:GetModule('mUILayout'):MiddleDatatextLayout() end,
					},
					width = {
						order = 3,
						type = "range",
						name = L["Width"],
						min = 200, max = 1400, step = 1,
						disabled = function() return not E.db.mui.datatexts.middle.enable end,
						get = function(info) return E.db.mui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.mui.datatexts.middle[ info[#info] ] = value; MER:GetModule('mUILayout'):MiddleDatatextDimensions() end,
					},
					height = {
						order = 4,
						type = "range",
						name = L["Height"],
						min = 10, max = 32, step = 1,
						disabled = function() return not E.db.mui.datatexts.middle.enable end,
						get = function(info) return E.db.mui.datatexts.middle[ info[#info] ] end,
						set = function(info, value) E.db.mui.datatexts.middle[ info[#info] ] = value; MER:GetModule('mUILayout'):MiddleDatatextDimensions() end,
					},
				},
			},
			panels = {
				order = 4,
				type = "group",
				name = MER:cOption(L["DataTexts"]),
				guiInline = true,
				args = {},
			},
			threatBar = {
				order = 5,
				type = "group",
				name = MER:cOption(L["Threat"]),
				guiInline = true,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						get = function(info) return E.db.mui.datatexts.threatBar.enable end,
						set = function(info, value) E.db.mui.datatexts.threatBar.enable = value; MER:GetModule("ThreatBar"):ToggleEnable()end,
						disabled = function() return not E.db.mui.datatexts.rightChatTabDatatextPanel end,
					},
					textSize = {
						order = 2,
						name = FONT_SIZE,
						type = "range",
						min = 6, max = 22, step = 1,
						get = function(info) return E.db.mui.datatexts.threatBar.textSize end,
						set = function(info, value) E.db.mui.datatexts.threatBar.textSize = value; MER:GetModule("ThreatBar"):UpdatePosition() end,
						disabled = function() return not E.db.mui.datatexts.threatBar.enable or not E.db.mui.datatexts.rightChatTabDatatextPanel end,
					},
					textOutline = {
						order = 3,
						name = L["Font Outline"],
						type = "select",
						get = function(info) return E.db.mui.datatexts.threatBar.textOutline end,
						set = function(info, value) E.db.mui.datatexts.threatBar.textOutline = value; MER:GetModule("ThreatBar"):UpdatePosition() end,
						disabled = function() return not E.db.mui.datatexts.threatBar.enable or not E.db.mui.datatexts.rightChatTabDatatextPanel end,
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
			gotodatatexts = {
				order = 5,
				type = "execute",
				name = L["ElvUI DataTexts"],
				func = function() LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "datatexts") end,
			},
		},
	}

	local datatexts = {}
	for name, _ in pairs(DT.RegisteredDataTexts) do
		datatexts[name] = name
	end
	datatexts[""] = NONE

	local table = E.Options.args.mui.args.modules.args.datatexts.args.panels.args
	local i = 0
	for pointLoc, tab in pairs(P.mui.datatexts.panels) do
		i = i + 1
		if not _G[pointLoc] then table[pointLoc] = nil; return; end
		if type(tab) == "table" then
			table[pointLoc] = {
				type = "group",
				args = {},
				name = L[pointLoc] or pointLoc,
				guiInline = true,
				order = i,
			}
			for option, value in pairs(tab) do
				table[pointLoc].args[option] = {
					type = "select",
					name = L[option] or option:upper(),
					values = datatexts,
					get = function(info) return E.db.mui.datatexts.panels[pointLoc][ info[#info] ] end,
					set = function(info, value) E.db.mui.datatexts.panels[pointLoc][ info[#info] ] = value; DT:LoadDataTexts() end,
				}
			end
		elseif type(tab) == "string" then
			table[pointLoc] = {
				type = "select",
				name = L[pointLoc] or pointLoc,
				values = datatexts,
				get = function(info) return E.db.mui.datatexts.panels[pointLoc] end,
				set = function(info, value) E.db.mui.datatexts.panels[pointLoc] = value; DT:LoadDataTexts() end,
				print(pointLoc)
			}
		end
	end
end
tinsert(MER.Config, Datatexts)