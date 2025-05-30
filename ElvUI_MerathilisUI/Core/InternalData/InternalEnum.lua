local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.Enum = {}

I.Enum.Requirements = F.Enum({
	"MERUI_PROFILE",
	"GRADIENT_MODE_ENABLED",
	"GRADIENT_MODE_DISABLED",
	"ELVUI_ACTIONBARS_ENABLED",
	"ELTRUISM_DISABLED",
})

I.Enum.Colors = F.Enum({
	"MER",
	"DETAILS",
	"BIGWIGS",
	"OMNICD",
	"WT",
	"AS",
	"FCT",
	"ELVUI",
	"ELVUI_VALUE",
	"CLASS",
	"GOOD",
	"ERROR",
	"INSTALLER_WARNING",
	"WARNING",
	"WHITE",
	"GREY",

	"SILVER",
	"GOLD",

	"LEGENDARY",
	"EPIC",
	"RARE",
	"BETA",
})

-- Used for gradient theme
I.Enum.GradientMode = {
	Direction = F.Enum({ "LEFT", "RIGHT" }),
	Mode = F.Enum({ "HORIZONTAL", "VERTICAL" }),
	Color = F.Enum({ "SHIFT", "NORMAL" }),
}

I.Enum.Flavor = F.Enum({ "MOP", "RETAIL" })
