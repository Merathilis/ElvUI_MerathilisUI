local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

V.general = {
	install_complete = nil,
}

V.skins = {
	enable = true,
	shadowOverlay = false,
	addonSkins = {
		enable = true,
		acp = true,
		bSync = true,
		abp = true,
		btwQ = true,
		bui = true,
		bs = true,
		pa = true,
		ls = true,
		cl = true,
		cbn = true,
		et = true,
		pf = true,
		au = true,
		gil = true,
		pawn = true,
		sam = true,
		mmt = true,
		mys = true,
		mdt = true,
		cap = true,
		pbs = true,
		tle = true,
		wim = true,
		wowLua = true,
		sd = true,
		mrp = true,
		klf = true,
		paragonReputation = true,
		manuscriptsJournal = true,
		homeBound = true,
		bw = {
			enable = true,
			queueTimer = {
				enable = true,
				smooth = true,
				spark = true,
				colorLeft = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
				colorRight = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 },
				countDown = {
					name = I.Fonts.Primary,
					size = 16,
					style = "SHADOWOUTLINE",
					offsetX = 0,
					offsetY = -3,
				},
			},
			normalBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 0.32941, g = 0.52157, b = 0.93333, a = 1 },
				colorRight = { r = 0.25882, g = 0.84314, b = 0.86667, a = 1 },
			},
			emphasizedBar = {
				smooth = true,
				spark = true,
				colorOverride = true,
				colorLeft = { r = 1, g = 0.23, b = 0.0, a = 1 },
				colorRight = { r = 1, g = 0.48, b = 0.03, a = 1 },
			},
		},
		dt = {
			enable = true,
			gradientName = true,
			gradientBars = true,
		},
	},

	embed = {
		enable = false,
		toggleDirection = 1,
		mouseOver = false,
	},

	actionStatus = {
		name = E.db.general.font,
		size = 15,
		style = "SHADOWOUTLINE",
	},
}
