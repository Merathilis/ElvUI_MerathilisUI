local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function MER:mMediaTag()
    if not IsAddOnLoaded("ElvUI_mMediaTag") then return end

    E.db["mMT"]["general"]["greeting"] = false
    E.db["mMT"]["nameplate"]["executemarker"]["enable"] = true
    E.db["mMT"]["afk"]["misc"]["enable"] = false
    E.db["mMT"]["afk"]["values"]["enable"] = false
    E.db["mMT"]["afk"]["infoscreen"] = false
    E.db["mMT"]["afk"]["garbage"] = false
    E.db["mMT"]["afk"]["progress"]["enable"] = false
    E.db["mMT"]["afk"]["attributes"]["enable"] = false
    E.db["mMT"]["interruptoncd"]["enable"] = true
end
