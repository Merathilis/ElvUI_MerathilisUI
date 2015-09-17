local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

if E.db.Merathilis == nil then E.db.Merathilis = {} end

function MER:AddOptions()
	E.Options.args.Merathilis = {
		order = 9001,
		type = 'group',
		name = MER.Title,
		args = {
			name = {
				order = 1,
				type = 'header',
				name = MER.Title..MER:cOption(MER.Version)..L['by Merathilis (EU-Shattrath)'],
			},
			logo = {
				order = 2,
				type = 'description',
				name = L['MerathilisUI is an external ElvUI mod. Mostly based on |cff00c0faElvUI BenikUI|r. '] ..'\n\n'..MER:cOption(L['Credits:'])..L[' Benik, Azilroka, Elv, Blazeflack'],
				fontSize = 'medium',
				image = function() return 'Interface\\AddOns\\MerathilisUI\\media\\textures\\merathilis_logo.tga', 200, 100 end,
				imageCoords = {0,0.99,0.01,0.99},
			},			
			install = {
				order = 3,
				type = 'execute',
				name = L['Install'],
				desc = L['Run the installation process.'],
				func = function() MER:SetupUI(); E:ToggleConfig(); end,
			},
			spacer1 = {
				order = 4,
				type = 'header',
				name = '',
			},
			general = {
				order = 5,
				type = 'group',
				name = L['General'],
				guiInline = true,
				args = {
					LoginMsg = {
						order = 1,
						type = 'toggle',
						name = L['Login Message'],
						desc = L['Enable/Disable the Login Message in Chat'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; end,	
					},
					GameMenu = {
						order = 2,
						type = 'toggle',
						name = L['GameMenu'],
						desc = L['Enable/Disable the MerathilisUI Style from the Blizzard GameMenu.'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
			spacer2 = {
				order = 6,
				type = 'header',
				name = '',
			},
			unitframes = {
				order = 7,
				type = 'group',
				guiInline = true,
				name = L['UnitFrames'],
				args = {
					HoverClassColor = {
						order = 1,
						type = 'toggle',
						name = L['Hover ClassColor'],
						desc = L['Adds an Hovereffect for ClassColor to the Raidframes.'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
			misc = {
				order = 8,
				type = 'group',
				guiInline = true,
				name = L['Misc'],
				args = {
					TooltipIcon = {
						order = 1,
						type = 'toggle',
						name = L['Tooltip Icon'],
						desc = L['Adds an Icon for Items/Spells/Achievement on the Tooltip'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; end,
					},
					Screenshot = {
						order = 2,
						type = 'toggle',
						name = L['Screenshot'],
						desc = L['Takes an automatic Screenshot on Achievement earned.'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; end,
					},
					TabBinder = {
						order = 3,
						type = 'toggle',
						name = L['TabBinder'],
						desc = L['Auto change Tab key to only target enemy players'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; end,
					},
					Cinematic = {
						order = 4,
						type = 'toggle',
						name = L['Skip Cinematic'],
						desc = L['Automatically skips Cinematics'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; end,
					},
				},
			},
			skins = {
				order = 9,
				type = 'group',
				guiInline = true,
				name = L['Skins'],
				args = {
					MasterPlan = {
						order = 1,
						type = 'toggle',
						name = L['MasterPlan'],
						desc = L['Skins the additional Tabs from MasterPlan.'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
