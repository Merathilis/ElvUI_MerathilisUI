local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local pairs, tonumber = pairs, tonumber
local find = string.find

local DEFAULT_NP_WIDTH = 0

local function ApplyWidthOnly(fs, widthPx)
	if not fs or not fs.SetWidth then
		return
	end

	widthPx = tonumber(widthPx) or 0
	if widthPx <= 0 then
		fs:SetWidth(0)
		return
	end
	fs:SetWidth(widthPx)
	fs:SetWordWrap(false)
	if fs.SetNonSpaceWrap then
		fs:SetNonSpaceWrap(false)
	end
end

local function ApplyClip(fs, widthPx, nameDb)
	if not fs or not fs.GetParent or not fs.SetParent then
		return
	end

	widthPx = tonumber(widthPx) or 0
	if widthPx > 0 and fs.SetJustifyH then
		nameDb = nameDb or {}
		local point = nameDb.position or "CENTER"
		if find(point, "RIGHT") then
			fs:SetJustifyH("RIGHT")
		elseif find(point, "LEFT") then
			fs:SetJustifyH("LEFT")
		else
			fs:SetJustifyH("CENTER")
		end
	end

	ApplyWidthOnly(fs, widthPx)
end

local function GetUnitDb(nameplate)
	local unitType = nameplate.frameType
	local nameplatesDB = E.db.nameplates
	return unitType and nameplatesDB and nameplatesDB.units and nameplatesDB.units[unitType]
end

local function ApplyNameplateName(nameplate)
	if not (nameplate and nameplate.Name) then
		return
	end

	local unitDb = GetUnitDb(nameplate)
	local width = unitDb and unitDb.name
	if width == nil then
		width = DEFAULT_NP_WIDTH
	end
	ApplyClip(nameplate.Name, width, unitDb and unitDb.name)
end

local function ApplyNameplateCastbar(nameplate)
	local castbar = nameplate and nameplate.CastBar
	if not (castbar and castbar.Text) then
		return
	end

	local unitDb = GetUnitDb(nameplate)
	if unitDb and unitDb.castbar then
		ApplyWidthOnly(castbar.Text, unitDb.castbar.nameLength or 0)
	end
end

local function ApplyNameplate(nameplate)
	ApplyNameplateName(nameplate)
	ApplyNameplateCastbar(nameplate)
end

local function RefreshAll()
	if not ElvUF or not ElvUF.objects then
		return
	end

	if NP and NP.Plates then
		for plate in pairs(NP.Plates) do
			ApplyNameplate(plate)
		end
	end
end

function module:Initialize()
	if not E.private.nameplates.enable then
		return
	end

	hooksecurefunc(NP, "Update_TagText", function(_, nameplate, element, dbTag, hide)
		if element == nameplate.Name and dbTag and dbTag.enable and not hide then
			ApplyNameplateName(nameplate)
		end
	end)
	hooksecurefunc(NP, "Castbar_SetText", function(_, castbar, db)
		if castbar and castbar.Text and db then
			ApplyWidthOnly(castbar.Text, db.nameLength or 0)
		end
	end)

	RefreshAll()
end

MER:RegisterModule(module:GetName())
