local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

I.Enum = {}

I.Enum.Layouts = F.Enum({ "VERTICAL", "HORIZONTAL" })

I.Enum.Requirements = F.Enum({
	"MERUI_PROFILE",
	"ELVUI_ACTIONBARS_ENABLED",
	"ELVUI_UNITFRAMES_ENABLED",
	"ELVUI_NAMEPLATES_ENABLED",
	"ELVUI_CHAT_ENABLED",
	"ELVUI_MINIMAP_ENABLED",
	"ELTRUISM_DISABLED",
})

I.Enum.Colors = F.Enum({
	"MER",
	"DETAILS",
	"BIGWIGS",
	"ELVUI",
	"GOOD",
	"ERROR",
	"WARNING",
	"EPIC",
	"MUTED",
})

-- Used for gradient theme
I.Enum.GradientMode = {
	Direction = F.Enum({ "LEFT", "RIGHT" }),
	Mode = F.Enum({ "HORIZONTAL", "VERTICAL" }),
	Color = F.Enum({ "SHIFT", "NORMAL" }),
}
