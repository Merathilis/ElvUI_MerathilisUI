local lib = LibStub:NewLibrary("LibAuras", 1)

if not lib then return end

if not lib.frame then
    lib.frame = CreateFrame("Frame")
end

lib.AURAS = lib.AURAS or {}

local FILTERS, getGuidAndCheckAuras, getBuff, getDebuff, getAura, nameToSpellId, getAurasForUnit, addBuff, addDebuff, addAura


lib.frame:RegisterEvent("UNIT_AURA")
lib.frame:SetScript("OnEvent", function(self, event)
    if event == "UNIT_AURA" then lib.AURAS = {} end
end)

function lib:UnitBuff(unitId, spellIdOrName, filter)
    local guid = getGuidAndCheckAuras(unitId)
    if not guid then return end

    return getBuff(guid, spellIdOrName, filter or "")
end

function lib:UnitDebuff(unitId, spellIdOrName, filter)
    local guid = getGuidAndCheckAuras(unitId)
    if not guid then return end

    return getDebuff(guid, spellIdOrName, filter or "")
end

function lib:UnitAura(unitId, spellIdOrName, filter)
    local guid = getGuidAndCheckAuras(unitId)
    if not guid then return end

    local result = {getBuff(guid, spellIdOrName, filter or "")}
    if #result < 2 then
        return getDebuff(guid, spellIdOrName, filter or "")
    end
    return unpack(result)
end

local FILTERS = {
    HELPFUL = false,
    HARMFUL = false,
    PLAYER = false,
    RAID = false,
    CANCELABLE = false,
    NOTCANCELABLE = false
}

getGuidAndCheckAuras = function(unitId)
    local guid = UnitGUID(unitId)
    if not guid then return nil end
    if not lib.AURAS[guid] then
        getAurasForUnit(unitId, guid)
    end
    return guid
end

getBuff = function(guid, spellIdOrName, filter)
    return getAura(guid, spellIdOrName, "HELPFUL " .. filter)
end

getDebuff = function(guid, spellIdOrName, filter)
    return getAura(guid, spellIdOrName, "HARMFUL " .. filter)
end

getAura = function(guid, spellIdOrName, filter)
    local filters = {}
    for k in pairs(FILTERS) do filters[k] = FILTERS[k] end
    for s in filter:gmatch("%a+") do
        if filters[s:upper()] ~= nil then
            filters[s:upper()] = true
        end
    end

    local auraType = "BUFF"
    if not filters["HELPFUL"] and not filters["HARMFUL"] then
        error("filter must contain either \"HELPFUL\" or \"HARMFUL\"")
    elseif filters["HELPFUL"] and filters["HARMFUL"] then
        return
    elseif filters["HARMFUL"] then
        auraType = "DEBUFF"
    end

    local spellId = nameToSpellId(spellIdOrName, guid, auraType)
    local aura = lib.AURAS[guid][auraType][spellId]
    if not aura then return
    elseif filters["PLAYER"] and aura.unitCaster ~= "player" then return
    end
    return aura.name, aura.icon, aura.count, aura.debuffType, aura.duration, aura.expirationTime, aura.unitCaster, aura.canStealOrPurge, aura.nameplateShowPersonal, spellId, aura.canApplyAura, aura.isBossDebuff, aura.isCastByPlayer, aura.nameplateShowAll, aura.timeMod, aura.value1, aura.value2, aura.value3
end

nameToSpellId = function(spellIdOrName, guid, auraType)
    if type(spellIdOrName) == "number" then
        return spellIdOrName
    elseif type(spellIdOrName) == "string" then
        local spellId = lib.AURAS[guid][auraType].NAMES[spellIdOrName]
        if not spellId then return nil end
        return spellId
    end
    return nil
end

getAurasForUnit = function(unitId, guid)
    lib.AURAS[guid] = {}
    lib.AURAS[guid]["BUFF"] = {}
    lib.AURAS[guid]["BUFF"].NAMES = {}
    lib.AURAS[guid]["DEBUFF"] = {}
    lib.AURAS[guid]["DEBUFF"].NAMES = {}
    for i = 1, 40 do
        if not addBuff(unitId, guid, i) then break end
    end
    for i = 1, 40 do
        if not addDebuff(unitId, guid, i) then break end
    end
end

addBuff = function(unitId, guid, index)
    return addAura(unitId, guid, index, "BUFF")
end

addDebuff = function(unitId, guid, index)
    return addAura(unitId, guid, index, "DEBUFF")
end

addAura = function(unitId, guid, index, type)
    local filter = nil
    if type == "BUFF" then filter = "HELPFUL" end
    if type == "DEBUFF" then filter = "HARMFUL" end
    if not filter then return end
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll, timeMod, value1, value2, value3 = UnitAura(unitId, index, filter)
    if not name then
        return false
    end
    lib.AURAS[guid][type][spellId] = {}
    lib.AURAS[guid][type][spellId].name = name
    lib.AURAS[guid][type][spellId].icon = icon
    lib.AURAS[guid][type][spellId].count = count
    lib.AURAS[guid][type][spellId].debuffType = debuffType
    lib.AURAS[guid][type][spellId].duration = duration
    lib.AURAS[guid][type][spellId].expirationTime = expirationTime
    lib.AURAS[guid][type][spellId].unitCaster = unitCaster
    lib.AURAS[guid][type][spellId].canStealOrPurge = canStealOrPurge
    lib.AURAS[guid][type][spellId].nameplateShowPersonal = nameplateShowPersonal
    lib.AURAS[guid][type][spellId].canApplyAura = canApplyAura
    lib.AURAS[guid][type][spellId].isBossDebuff = isBossDebuff
    lib.AURAS[guid][type][spellId].isCastByPlayer = isCastByPlayer
    lib.AURAS[guid][type][spellId].nameplateShowAll = nameplateShowAll
    lib.AURAS[guid][type][spellId].timeMod = timeMod
    lib.AURAS[guid][type][spellId].value1 = value1
    lib.AURAS[guid][type][spellId].value2 = value2
    lib.AURAS[guid][type][spellId].value3 = value3
    if not lib.AURAS[guid][type].NAMES[name] then
        lib.AURAS[guid][type].NAMES[name] = spellId
    end
    return true
end

-- DEBUG stuff
--[[
function libAurasTest()
    print("Starting Tests")
    LA = LibStub:GetLibrary("LibAuras")
    print(":UnitAura(\"player\", 186406) (Sign of the Critter)")
    print(LA:UnitAura("player", 186406))
    print(":UnitBuff(\"pet\", \"Dire Frenzy\"")
    print(LA:UnitBuff("pet", "Dire Frenzy"))
    print(":UnitDeuff(\"target\", \"Growl\"")
    print(LA:UnitDebuff("target", "Growl"))
    LA:printAurasTable()
end

function lib:printAurasTable()
    print(".AURAS")
    for k in pairs(self.AURAS) do
        print(k)
        lib:printTable(self.AURAS[k], "  ")
    end
end

function lib:printTable(table, prefix)
    if not table then return end
    for k in pairs(table) do
        if type(table[k]) ~= "table" then
            print(prefix .. k .. " = " .. tostring(table[k]))
        else
            print(prefix .. tostring(k))
            lib:printTable(table[k], prefix .. "  ")
        end
    end
end
]]
