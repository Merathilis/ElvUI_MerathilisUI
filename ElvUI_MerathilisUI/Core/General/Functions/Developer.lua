local MER, F, E, L, V, P, G = unpack(select(2, ...))

MER.IsDev = {
	["Asragoth"] = true,
	["Damará"] = true,
	["Jazira"] = true,
	["Jústice"] = true,
	["Maithilis"] = true,
	["Mattdemôn"] = true,
	["Melisendra"] = true,
	["Merathilis"] = true,
	["Mérathilis"] = true,
	["Merathilîs"] = true,
	["Róhal"] = true,
	["Brítt"] = true,
	["Jahzzy"] = true,

	["Dâmara"] = true,
}

-- Don't forget to update realm name(s) if we ever transfer realms.
-- If we forget it could be easly picked up by another player who matches these combinations.
-- End result we piss off people and we do not want to do that. :(
MER.IsDevRealm = {
	-- Live
	["Shattrath"] = true,
	["Garrosh"] = true,

	-- Beta
	["The Maw"] = true,
	["Torghast"] = true,

	-- PTR
	["Broxigar"] = true,
}

function F.IsDeveloper()
	return MER.IsDev[E.myname] or false
end

function F.IsDeveloperRealm()
	return MER.IsDevRealm[E.myrealm] or false
end