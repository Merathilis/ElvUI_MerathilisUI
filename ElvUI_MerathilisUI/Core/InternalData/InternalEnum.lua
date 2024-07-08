local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.Enum = {}

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
