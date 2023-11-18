local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded



function MER:mMediaTag()
    if not IsAddOnLoaded("ElvUI_mMediaTag") then return end

    E.db["mMT"]["general"]["greeting"] = false
    E.db["mMT"]["nameplate"]["executemarker"]["enable"] = true
end
