local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local twipe = table.wipe

function MER:LoadOmniCDProfile()
	--[[----------------------------------
	--	OmnicCD - Settings
	--]]
	----------------------------------

	local profileName = I.ProfileNames.Default

	if OmniCDDB["profiles"][profileName] then
		tinsert(OmniCDDB.profileKeys, E.mynameRealm)
		OmniCDDB["profileKeys"][E.mynameRealm] = profileName
	else
		OmniCDDB["profiles"][profileName] = {}
		OmniCDDB["profiles"][profileName] = {
			["Party"] = {
				["noneZoneSetting"] = "party",
				["party"] = {
					["extraBars"] = {
						["raidCDBar"] = {
							["enabled"] = false,
						},
						["raidBar0"] = {
							["scale"] = 0.6000000000000001,
							["statusBarWidth"] = 280,
							["showRaidTargetMark"] = true,
							["locked"] = true,
							["manualPos"] = {
								["raidBar0"] = {
									["y"] = 131.9110817531737,
									["x"] = 437.6887692789205,
								},
							},
							["hideSpark"] = true,
						},
						["interruptBar"] = {
							["barColors"] = {
								["useClassColor"] = {
									["inactive"] = true,
								},
								["inactiveColor"] = {
									["a"] = 1,
									["b"] = 0.1176470588235294,
								},
							},
							["useIconAlpha"] = true,
							["hideSpark"] = true,
							["locked"] = true,
							["statusBarWidth"] = 220,
						},
					},
					["manualPos"] = {
						[5] = {
							["y"] = 384.3555214597109,
							["x"] = 682.3111276328564,
						},
						["raidCDBar"] = {
							["y"] = 384.3555214597109,
							["x"] = 682.3111276328564,
						},
						["interruptBar"] = {
							["y"] = 111.2888047781235,
							["x"] = 436.9776147478115,
						},
					},
					["icons"] = {
						["scale"] = 1,
						["showTooltip"] = false,
					},
					["position"] = {
						["columns"] = 5,
						["paddingX"] = 2,
						["uf"] = "ElvUI",
						["offsetX"] = 2,
						["paddingY"] = 0,
					},
					["general"] = {
						["showPlayerEx"] = false,
						["showPlayer"] = true,
					},
				},
				["arena"] = {
					["manualPos"] = {
						["raidCDBar"] = {
							["y"] = 384.3555214597109,
							["x"] = 682.3111276328564,
						},
						["interruptBar"] = {
							["y"] = 384.3555214597109,
							["x"] = 682.3111276328564,
						},
					},
					["icons"] = {
						["scale"] = 1.1,
						["showTooltip"] = true,
					},
					["position"] = {
						["attach"] = "TOPLEFT",
						["preset"] = "TOPLEFT",
						["offsetX"] = 3,
						["anchor"] = "TOPRIGHT",
					},
					["general"] = {
						["showPlayer"] = true,
						["zoneSelected"] = "party",
					},
				},
				["visibility"] = {
					["scenario"] = true,
					["finder"] = false,
					["arena"] = false,
				},
				["scenarioZoneSetting"] = "party",
			},
			["General"] = {
				["fonts"] = {
					["statusBar"] = {
						["font"] = I.Fonts.Primary,
						["flag"] = "SHADOWOUTLINE",
					},
					["icon"] = {
						["font"] = I.Fonts.Primary,
						["flag"] = "SHADOWOUTLINE",
					},
					["anchor"] = {
						["font"] = I.Fonts.Primary,
						["flag"] = "SHADOWOUTLINE",
					},
				},
				["textures"] = {
					["statusBar"] = {
						["BG"] = "ElvUI Norm1",
						["bar"] = "ElvUI Norm1",
					},
				},
				["notifyNew"] = true,
			},
			["Default"] = {
				["Party"] = {
					["party"] = {
						["general"] = {
							["showPlayer"] = true,
						},
						["manualPos"] = {
							["raidCDBar"] = {
								["y"] = 384.3555214597109,
								["x"] = 682.3111276328564,
							},
							["interruptBar"] = {
								["y"] = 384.3555214597109,
								["x"] = 682.3111276328564,
							},
						},
					},
				},
			},
		}
	end

	for _, profile in pairs({ profileName }) do
		for _, frame in pairs({ "party", "arena" }) do
			OmniCDDB["profiles"][profileName]["Party"][frame]["spells"] = OmniCDDB["profiles"][profileName]["Party"][frame]["spells"]
				or {}
			OmniCDDB["profiles"][profileName]["Party"][frame]["spells"] = {
				["326059"] = true,
				["118038"] = false,
				["198589"] = false,
				["322109"] = true,
				["312202"] = true,
				["8143"] = false,
				["12975"] = true,
				["279302"] = true,
				["115750"] = false,
				["22812"] = false,
				["212295"] = false,
				["187650"] = false,
				["8122"] = false,
				["235219"] = false,
				["329554"] = true,
				["205180"] = true,
				["328923"] = true,
				["48020"] = false,
				["1122"] = true,
				["113860"] = true,
				["5246"] = false,
				["114050"] = true,
				["306830"] = true,
				["319952"] = true,
				["210918"] = false,
				["118000"] = true,
				["108978"] = false,
				["46924"] = true,
				["213602"] = false,
				["317320"] = true,
				["102560"] = true,
				["107574"] = true,
				["108968"] = false,
				["325289"] = true,
				["314793"] = true,
				["1719"] = true,
				["109964"] = false,
				["328278"] = true,
				["137639"] = true,
				["47568"] = true,
				["10060"] = true,
				["132578"] = true,
				["53480"] = false,
				["63560"] = true,
				["325197"] = true,
				["312321"] = true,
				["48707"] = false,
				["324143"] = true,
				["210256"] = false,
				["338142"] = true,
				["323436"] = false,
				["323639"] = true,
				["23920"] = false,
				["198111"] = false,
				["236320"] = false,
				["327104"] = true,
				["102543"] = true,
				["31230"] = false,
				["152173"] = true,
				["194223"] = true,
				["205636"] = true,
				["204336"] = false,
				["307443"] = true,
				["152279"] = true,
				["228049"] = false,
				["328547"] = true,
				["205179"] = false,
				["325727"] = true,
				["325028"] = true,
				["327661"] = true,
				["322118"] = true,
				["121471"] = true,
				["123904"] = true,
				["122470"] = false,
				["324386"] = true,
				["108238"] = false,
				["324724"] = true,
				["215982"] = false,
				["204018"] = true,
				["314791"] = true,
				["321792"] = true,
				["199452"] = false,
				["49206"] = true,
				["316958"] = true,
				["86659"] = true,
				["51052"] = false,
				["198838"] = false,
				["55342"] = true,
				["265187"] = true,
				["325640"] = true,
				["55233"] = true,
				["205604"] = false,
				["342245"] = false,
				["323654"] = true,
				["197268"] = false,
				["64044"] = false,
				["19574"] = true,
				["77761"] = true,
				["50334"] = true,
				["328231"] = true,
				["853"] = false,
				["323673"] = true,
				["114051"] = true,
				["12042"] = true,
				["30884"] = false,
				["323547"] = true,
				["42650"] = true,
				["106951"] = true,
				["6789"] = false,
				["113858"] = true,
				["109304"] = false,
				["325886"] = true,
				["193530"] = true,
				["243435"] = false,
				["102342"] = false,
				["325013"] = true,
				["47536"] = false,
				["114556"] = false,
				["320674"] = true,
				["328204"] = true,
				["62618"] = false,
				["227847"] = true,
				["86949"] = false,
				["324149"] = true,
				["122783"] = false,
				["304971"] = true,
				["308491"] = true,
				["2094"] = false,
				["108271"] = false,
				["325216"] = true,
				["310454"] = true,
				["328305"] = true,
				["12472"] = true,
				["326860"] = true,
				["307865"] = true,
				["324128"] = true,
				["102558"] = true,
				["288613"] = true,
				["275699"] = true,
				["5277"] = false,
				["1856"] = false,
				["319454"] = true,
				["20711"] = false,
				["265202"] = false,
				["323764"] = true,
				["311648"] = true,
				["19236"] = false,
				["114018"] = true,
				["192249"] = true,
				["323546"] = true,
				["315443"] = true,
				["324220"] = true,
				["317009"] = true,
				["198067"] = true,
				["104773"] = false,
				["184364"] = false,
			}
		end
	end
end
