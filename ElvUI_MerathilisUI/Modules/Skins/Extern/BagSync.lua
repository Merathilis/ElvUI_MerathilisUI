local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Call the AddOn
local AddOn = E.Libs.AceAddon:GetAddon('BagSync')

function module:BagSyncSearch()
    local Search = AddOn:GetModule('Search')

    S:HandleFrame(Search.frame, true)
    module:CreateBackdropShadow(Search.frame)
    Search.frame:Styling()

    S:HandleCloseButton(Search.frame.closeBtn)
    S:HandleEditBox(Search.frame.SearchBox)
    S:HandleButton(Search.frame.PlusButton)
    S:HandleButton(Search.frame.RefreshButton)
    S:HandleButton(Search.frame.HelpButton)
    S:HandleButton(Search.frame.advSearchBtn)
    S:HandleButton(Search.frame.resetButton)

    local header = Search.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end

    S:HandleFrame(Search.helpFrame, true)
    module:CreateBackdropShadow(Search.helpFrame)
    Search.helpFrame:Styling()
    S:HandleCloseButton(Search.helpFrame.CloseButton)
    S:HandleScrollBar(Search.helpFrame.ScrollFrame.ScrollBar)

    S:HandleFrame(Search.savedSearch, true)
    module:CreateBackdropShadow(Search.savedSearch)
    Search.savedSearch:Styling()
    S:HandleCloseButton(Search.savedSearch.CloseButton)
    S:HandleButton(Search.savedSearch.addSavedBtn)
    S:HandleScrollBar(Search.savedSearch.scrollFrame.scrollBar)
    S:HandleFrame(Search.savedSearch.scrollFrame.scrollChild)
    Search.savedSearch.scrollFrame.scrollBar.thumbTexture:SetTexture(E.media.normTex)
    Search.savedSearch.scrollFrame.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
end

function module:BagSyncAdvancedSearch()
    local adv = AddOn:GetModule('AdvancedSearch')

    S:HandleFrame(adv.frame, true)
    module:CreateBackdropShadow(adv.frame)
    adv.frame:Styling()

    S:HandleCloseButton(adv.frame.closeBtn)
    S:HandleEditBox(adv.frame.SearchBox)
    S:HandleButton(adv.frame.PlusButton)
    S:HandleButton(adv.frame.RefreshButton)

    S:HandleButton(adv.frame.selectAllButton)
    S:HandleButton(adv.frame.resetButton)

    local header = adv.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncCurrency()
    local Currency = AddOn:GetModule('Currency')

    S:HandleFrame(Currency.frame, true)
    module:CreateBackdropShadow(Currency.frame)
    Currency.frame:Styling()

    S:HandleCloseButton(Currency.frame.closeBtn)

    local header = Currency.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncProfessions()
    local Professions = AddOn:GetModule('Professions')

    S:HandleFrame(Professions.frame, true)
    module:CreateBackdropShadow(Professions.frame)
    Professions.frame:Styling()

    S:HandleCloseButton(Professions.frame.closeBtn)

    local header = Professions.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncBlacklist()
    local Blacklist = AddOn:GetModule('Blacklist')

    S:HandleFrame(Blacklist.frame, true)
    module:CreateBackdropShadow(Blacklist.frame)
    Blacklist.frame:Styling()

    S:HandleCloseButton(Blacklist.frame.closeBtn)
    S:HandleDropDownBox(Blacklist.frame.guildDD)
    S:HandleButton(Blacklist.frame.addGuildBtn)
    S:HandleButton(Blacklist.frame.addItemIDBtn)
    S:HandleEditBox(Blacklist.frame.itemIDBox)

    local header = Blacklist.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncWhitelist()
    local Whitelist = AddOn:GetModule("Whitelist")

    S:HandleFrame(Whitelist.frame, true)
    module:CreateBackdropShadow(Whitelist.frame)
    Whitelist.frame:Styling()

    S:HandleCloseButton(Whitelist.frame.closeBtn)
    S:HandleButton(Whitelist.frame.addItemIDBtn)
    S:HandleEditBox(Whitelist.frame.itemIDBox)

    local header = Whitelist.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end

    S:HandleFrame(Whitelist.warningFrame, true)
    module:CreateBackdropShadow(Whitelist.warningFrame)
    Whitelist.warningFrame:Styling()

    S:HandleCloseButton(Whitelist.warningFrame.CloseButton)
end

function module:BagSyncGold()
    local Gold = AddOn:GetModule('Gold')

    S:HandleFrame(Gold.frame, true)
    module:CreateBackdropShadow(Gold.frame)
    Gold.frame:Styling()

    S:HandleCloseButton(Gold.frame.closeBtn)

    local header = Gold.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncProfiles()
    local Profiles = AddOn:GetModule('Profiles')

    S:HandleFrame(Profiles.frame, true)
    module:CreateBackdropShadow(Profiles.frame)
    Profiles.frame:Styling()

    S:HandleCloseButton(Profiles.frame.closeBtn)

    local header = Profiles.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b)
        end
    end
end

function module:BagSyncSortOrder()
    local SortOrder = AddOn:GetModule('SortOrder')
    S:HandleFrame(SortOrder.frame, true)
    module:CreateBackdropShadow(SortOrder.frame)
    SortOrder.frame:Styling()

    S:HandleCloseButton(SortOrder.frame.closeBtn)

    local header = SortOrder.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group then
            if group.scrollChild then
                for itemnumber = 1, group.scrollChild:GetNumChildren() do
                    local frame = select(itemnumber, group.scrollChild:GetChildren())
                    if frame.SortBox then
                        S:HandleEditBox(frame.SortBox)
                    end
                end
            end

            if group.scrollBar then
                S:HandleScrollBar(group.scrollBar)
                group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
                group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b, 1)
            end
        end
    end

    S:HandleFrame(SortOrder.warningFrame, true)
    module:CreateBackdropShadow(SortOrder.warningFrame)
    SortOrder.warningFrame:Styling()

    S:HandleCloseButton(SortOrder.warningFrame.CloseButton)
end

function module:BagSyncDetails()
    local Details = AddOn:GetModule('Details')

    S:HandleFrame(Details.frame, true)
    module:CreateBackdropShadow(Details.frame)
    Details.frame:Styling()

    S:HandleCloseButton(Details.frame.closeBtn)

    local header = Details.frame
    for i = 1, header:GetNumChildren() do
        local group = select(i, header:GetChildren())
        if group and group.scrollBar then
            S:HandleScrollBar(group.scrollBar)
            S:HandleFrame(group)
            group.scrollBar.thumbTexture:SetTexture(E.media.normTex)
            group.scrollBar.thumbTexture:SetVertexColor(F.r, F.g, F.b, 1)
        end
    end
end

function module:BagSync()
    if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.bSync then
        return
    end

    module:DisableAddOnSkins('BagSync', false)

    -- We need to set a delay, cause it loads very early
    E:Delay(0.1, function()
        module:BagSyncSearch()     -- Main Search
        module:BagSyncAdvancedSearch() -- Advanced Search

        --Modules
        module:BagSyncCurrency()
        module:BagSyncProfessions()
        module:BagSyncBlacklist()
        module:BagSyncWhitelist()
        module:BagSyncGold()
        module:BagSyncProfiles()
        module:BagSyncSortOrder()
        module:BagSyncDetails()
    end)
end

module:AddCallbackForAddon("BagSync")
