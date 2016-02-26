local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function Datatexts()
	E.Options.args.mui.args.config.args.datatexts = {
		order = 14,
		type = 'group',
		name = L["DataTexts"],
		args = {
			muiSystemDT = {
				order = 1,
				type = 'group',
				name = L["System Datatext"],
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
		},
	}
end
tinsert(MER.Config, Datatexts)