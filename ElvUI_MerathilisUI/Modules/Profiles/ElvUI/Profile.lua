local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:BuildColorsProfile()
	local pf = {
		unitframe = {
			colors = {},
		},
	}

	F.Table.Crush(pf, {
		-- UnitFrames Colors CastBar
		castColor = F.Table.HexToRGB("#ffb300"),
		castNoInterrupt = F.Table.HexToRGB("#808080"),
		castInterruptedColor = F.Table.HexToRGB("#ff1a1a"),

		-- UnitFrames Colors
		borderColor = F.Table.HexToRGB("#000000"),
		disconnected = F.Table.HexToRGB("#ff9387"),
		health_backdrop_dead = F.ChooseForTheme(F.Table.HexToRGB("#ff0015"), F.Table.HexToRGB("#9c0c00")),

		-- UnitFrames Colors heal prediction
		healPrediction = {
			absorbs = F.Table.HexToRGB("#ff00f180"),
			overabsorbs = F.Table.HexToRGB("#ff00c180"),
		},

		-- UnitFrame Colors MouseOver Glow
		frameGlow = {
			mouseoverGlow = {
				texture = I.Media.Textures.MER_Stripes,
			},
		},

		power = { -- RIGHT
			ALT_POWER = F.Table.HexToRGB("#2175d4"), -- swap alt
			MANA = F.Table.HexToRGB("#35a4ff"), -- mana
			RAGE = F.Table.HexToRGB("#ed3333"), -- rage
			FOCUS = F.Table.HexToRGB("#db753b"), -- focus
			ENERGY = F.Table.HexToRGB("#ffe169"), -- energy
			RUNIC_POWER = F.Table.HexToRGB("#1cd6ff"), -- runic
			PAIN = F.Table.HexToRGB("#f5f5f5"), -- pain
			FURY = F.Table.HexToRGB("#e81ff5"), -- fury
			LUNAR_POWER = F.Table.HexToRGB("#9c54ff"), -- astral
			INSANITY = F.Table.HexToRGB("#9629bd"), -- insanity
			MAELSTROM = F.Table.HexToRGB("#0096ff"), -- maelstrom
		},
	})

	return pf
end

function module:BuildProfile()
	-- Setup Local Tables
	local pf = {
		actionbar = {},
		auras = {
			buffs = {},
			debuffs = {},
		},
		bags = {},
		chat = {},
		cooldown = {},
		databars = {},
		datatexts = {
			panels = {},
		},
		general = {},
		movers = {},
		tooltip = {},
		unitframe = {
			colors = {},
			units = {},
		},
	}

	local colors = self:BuildColorsProfile()

	-- Setup Unit Tables & Disable Info Panel
	for _, unit in
		next,
		{
			"player",
			"target",
			"targettarget",
			"targettargettarget",
			"focus",
			"focustarget",
			"pet",
			"pettarget",
			"boss",
			"arena",
			"party",
			"raid1",
			"raid2",
			"raid3",
			"raidpet",
			"tank",
			"assist",
		}
	do
		pf.unitframe.units[unit] = {
			infoPanel = {
				enable = false,
			},
		}
	end

	-- Setup DataText Panels Tables & Disable Panels
	for _, panel in next, { "LeftChatDataPanel", "RightChatDataPanel" } do
		pf.datatexts.panels[panel] = {
			enable = false,
		}
	end

	-- Special Case:
	local WAAnchorY = { 470, 359 }

	local defaultPadding = 4

	-- Movers
	F.Table.Crush(pf.movers, {
		-- F.Position(1, 2, 3)
		-- 1 => Anchor position of SELECTED FRAME
		-- 2 => Anchor Parent
		-- 3 => Anchor position of PARENT FRAME

		-- Movers: Pop-ups
		MicrobarMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -19),
		LootFrameMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -495, -457),
		AlertFrameMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 205, -210),

		-- Movers: Bars
		ExperienceBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 1),
		ReputationBarMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 470, 1),
		ThreatBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 62),

		MirrorTimer1Mover = F.Position("TOP", "ElvUIParent", "TOP", 0, -60),
		MirrorTimer2Mover = F.Position("TOP", "MirrorTimer1Mover", "BOTTOM", 0, -defaultPadding),
		MirrorTimer3Mover = F.Position("TOP", "MirrorTimer2Mover", "BOTTOM", 0, -defaultPadding),

		-- Movers: ActionBars
		ElvAB_1 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 115),
		ElvAB_2 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 146),
		ElvAB_3 = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 175),
		ElvAB_4 = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", 0, 367),
		ElvAB_6 = F.Position("BOTTOM", "ElvAB_1", "BOTTOM", 0, 13),

		ElvAB_5 = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 430, 47), -- Unused
		ElvAB_7 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -73, -401), -- Unused
		ElvAB_8 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -109, -401), -- Unused
		ElvAB_9 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -144, -401), -- Unused
		ElvAB_10 = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -180, -401), -- Unused

		PetAB = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", -289, 15),
		VehicleLeaveButton = F.Position("BOTTOM", "ElvAB_4", "BOTTOM", 304, 140),
		DurabilityFrameMover = F.Position("BOTTOMLEFT", "ElvAB_4", "BOTTOMRIGHT", 34, 0),
		ShiftAB = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 10, 14),

		-- Movers: UnitFrames
		ElvUF_PlayerMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 244, 209),
		ElvUF_PlayerCastbarMover = F.Position("BOTTOM", "ElvUF_Player", "BOTTOM", 0, 89),

		ElvUF_TargetMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 325, 350),
		ElvUF_TargetCastbarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 244, 188),

		ElvUF_TargetTargetMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -510, 188),

		ElvUF_PetMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 510, 188),
		ElvUF_PetCastbarMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 510, 177),

		ElvUF_FocusMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -518, 293),
		ElvUF_FocusCastbarMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -518, 273),

		ElvUF_PartyMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 268, 326),

		ElvUF_Raid1Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 2, 215),
		ElvUF_Raid2Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 2, 215),
		ElvUF_Raid3Mover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 2, 215),

		-- Arena Frames
		ArenaHeaderMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -305, -305),

		-- Boss Frames
		BossHeaderMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -305, -305),

		ElvUF_TankMover = F.Position("TOPLEFT", "LeftChatMover", "TOPRIGHT", defaultPadding, 0),
		ElvUF_AssistMover = F.Position("TOPLEFT", "ElvUF_TankMover", "BOTTOMLEFT", 0, -defaultPadding),

		-- Movers: Chat
		LeftChatMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 2, 47),
		RightChatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -149, 47),

		-- Movers: Bags
		ElvUIBagMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -4, 194),
		ElvUIBankMover = F.Position("BOTTOMLEFT", "ElvUIParent", "BOTTOMLEFT", 2, 194),

		-- Movers: Buffs
		BuffsMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", defaultPadding, -defaultPadding),
		DebuffsMover = F.Position("TOPLEFT", "BuffsMover", "BOTTOMLEFT", 0, -defaultPadding),

		-- Movers: Misc
		BelowMinimapContainerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -148),
		BNETMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -70),
		GMMover = F.Position("TOPLEFT", "ElvUIParent", "TOPLEFT", 229, -20),
		MinimapMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -defaultPadding, -25),
		TooltipMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -10, 280),
		TopCenterContainerMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -105),
		VOICECHAT = F.Position("TOPLEFT", "ElvUIParent", "BOTTOMLEFT", 368, -210),

		-- Movers: MerathilisUI
		MERWAAnchorMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, WAAnchorY[1]),

		-- Movers: Bars Retail Only
		AltPowerBarMover = F.Position("TOP", "ElvUIParent", "TOP", 0, -201),
		AzeriteBarMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -470, 1),
		ClassBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 230),
		HonorBarMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 52),

		-- Movers: ActionBars Retail Only
		BossButton = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 305, 50),
		ZoneAbility = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 305, 92),

		-- Movers: Misc Retail Only
		LossControlMover = F.Position("BOTTOM", "ElvUIParent", "BOTTOM", 0, 465),
		VehicleSeatMover = F.Position("BOTTOMRIGHT", "ElvUIParent", "BOTTOMRIGHT", -474, 120),
		AddonCompartmentMover = F.Position("TOPRIGHT", "ElvUIParent", "TOPRIGHT", -213, -17),
	})
end
