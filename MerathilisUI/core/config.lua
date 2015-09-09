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
			spacer2 = {
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
					GameMenuButton = {
						order = 2,
						type = 'toggle',
						name = L['GameMenuButton'],
						desc = L['Enable/Disable the GameMenuButton from the Blizzard GameMenu.'],
						get = function(info) return E.db.Merathilis[ info[#info] ] end,
						set = function(info, value) E.db.Merathilis[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
				},
			},
		},
	}
end
