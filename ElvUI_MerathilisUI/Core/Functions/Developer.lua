local MER, W, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local _, WF = unpack(WindTools or {})
F.Developer = {}

MER.IsDev = {
	["Asragoth"] = true,
	["Anonia"] = true,
	["Damará"] = true,
	["Damara"] = true, -- Legion Remix
	["Jhazzy"] = true, -- Legion Remix
	["Jazira"] = true,
	["Jústice"] = true,
	["Maithilis"] = true,
	["Mattdemôn"] = true,
	["Melisendra"] = true,
	["Merathilis"] = true,
	["Mérathilis"] = true,
	["Merathilîs"] = true,
	["Róhal"] = true,
	["Ronan"] = true,
	["Brítt"] = true,
	["Brìtt"] = true,
	["Jahzzy"] = true,
	["Dâmara"] = true,
	["Meravoker"] = true,

	-- Beta
	["Jalenna"] = true,
}

-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	-- Live
	["Shattrath"] = true,
	["Garrosh"] = true,

	-- Beta
	["Turnips Delight"] = true,

	-- PTR
	["Broxigar"] = true,
}

function F.IsDeveloper()
	return MER.IsDev[E.myname] and MER.IsDevRealm[E.myrealm] or false
end
