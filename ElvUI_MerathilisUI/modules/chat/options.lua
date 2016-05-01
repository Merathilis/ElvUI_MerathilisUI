local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERC = E:GetModule('muiChat');

-- Cache global variables
-- Lua functions
local _G = _G
local tinsert = table.insert
-- WoW API / Variables
local texPath = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\role\]]
local texPathE = [[Interface\AddOns\ElvUI\media\textures\]]

local function Chat()
	E.Options.args.mui.args.Chat = {
		order = 13,
		type = 'group',
		name = L['Chat'],
		disabled = function() return not E.private.chat.enable end,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER:cOption(L['Chat']),
			},
			chat = {
				order = 2,
				type = "group",
				name = L["Chat"],
				guiInline = true,
				args = {
					roleIcons = {
						order = 1,
						type = "select",
						name = L["Chat Icons"],
						desc = L["Choose what icon set will chat use."],
						get = function(info) return E.db.mui.unitframes.roleIcons end,
						set = function(info, value) E.db.mui.unitframes.roleIcons = value; E:GetModule('Chat'):CheckLFGRoles() end,
						values = {
							["ElvUI"] = "ElvUI ".."|T"..texPathE.."tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPathE.."dps:15:15:0:0:64:64:2:56:2:56|t ",
							["SupervillainUI"] = "Supervillain UI ".."|T"..texPath.."svui-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."svui-dps:15:15:0:0:64:64:2:56:2:56|t ",
							["Blizzard"] = "Blizzard ".."|T"..texPath.."blizz-tank:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-healer:15:15:0:0:64:64:2:56:2:56|t ".."|T"..texPath.."blizz-dps:15:15:0:0:64:64:2:56:2:56|t ",
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Chat)
