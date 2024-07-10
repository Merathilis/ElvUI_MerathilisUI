local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadOmniCDProfile()
	local pf = {}
	local db = _G.OmniCD and _G.OmniCD[1]

	local profile = db.DB.profile

	F.Table.Crush(pf, {
		General = {
			fonts = {
				statusBar = {
					font = I.Fonts.Primary,
					flag = "SHADOWOUTLINE",
				},
				icon = {
					font = I.Fonts.Primary,
					flag = "SHADOWOUTLINE",
				},
				anchor = {
					font = I.Fonts.Primary,
					flag = "SHADOWOUTLINE",
				},
			},
			textures = {
				statusBar = {
					BG = "ElvUI Norm1",
					bar = "ElvUI Norm1",
				},
			},
			notifyNew = true,
		},

		Default = {
			Party = {
				party = {
					general = {
						showPlayer = true,
					},
					manualPos = {
						raidCDBar = {
							y = 384.3555214597109,
							x = 682.3111276328564,
						},
						interruptBar = {
							y = 384.3555214597109,
							x = 682.3111276328564,
						},
					},
				},
			},
		},

		Party = {
			noneZoneSetting = "party",
			party = {
				extraBars = {
					raidCDBar = {
						enabled = false,
					},
					raidBar0 = {
						scale = 0.6000000000000001,
						statusBarWidth = 280,
						showRaidTargetMark = true,
						locked = true,
						manualPos = {
							raidBar0 = {
								y = 131.9110817531737,
								x = 437.6887692789205,
							},
						},
						hideSpark = true,
					},
					interruptBar = {
						barColors = {
							useClassColor = {
								inactiv = true,
							},
							inactiveColor = {
								a = 1,
								b = 0.1176470588235294,
							},
						},
						useIconAlpha = true,
						hideSpark = true,
						locked = true,
						statusBarWidth = 220,
					},
				},
				manualPos = {
					[5] = {
						y = 384.3555214597109,
						x = 682.3111276328564,
					},
					raidCDBar = {
						y = 384.3555214597109,
						x = 682.3111276328564,
					},
					interruptBar = {
						y = 111.2888047781235,
						x = 436.9776147478115,
					},
				},
				icons = {
					scale = 1,
					showTooltip = false,
				},
				position = {
					columns = 5,
					paddingX = 2,
					uf = "ElvUI",
					offsetX = 2,
					paddingY = 0,
				},
				general = {
					showPlayerEx = false,
					showPlayer = true,
				},
			},

			arena = {
				manualPos = {
					raidCDBar = {
						y = 384.3555214597109,
						x = 682.3111276328564,
					},
					interruptBar = {
						y = 384.3555214597109,
						x = 682.3111276328564,
					},
				},
				icons = {
					scale = 1.1,
					showTooltip = true,
				},
				position = {
					attach = "TOPLEFT",
					preset = "TOPLEFT",
					offsetX = 3,
					anchor = "TOPRIGHT",
				},
				general = {
					showPlayer = true,
					zoneSelected = "party",
				},
			},
			visibilit = {
				scenario = true,
				finder = false,
				arena = false,
			},
			scenarioZoneSetting = "party",
		},
	})

	return pf
end

function module:ApplyOmniCDProfile()
	if not E:IsAddOnEnabled("OmniCD") then
		F.Developer.LogWarning("OmniCD is not enabled. Will not apply profile.")
		return
	end

	local db = _G.OmniCD and _G.OmniCD[1]
	if not db then
		F.Developer.LogWarning("Database not found for OmniCD -- will not apply profile.")
		return
	end

	module:Wrap("Applying OmniCD Profile ...", function()
		local profileName = I.ProfileNames.Default
		local profile = self:LoadOmniCDProfile() or {}

		db.DB:SetProfile(profileName)
		db.DB:ResetProfile(profileName)
		F.Table.Crush(db.DB.profile, profile)

		E:UpdateMedia()
		E:UpdateFontTemplates()

		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "OmniCD")
end
