local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local DEFAULT_NP_WIDTH = 0

local function ApplyClip(fs, widthPx, nameDb)
	if not fs or not fs.GetParent or not fs.SetParent then
		return
	end

	widthPx = tonumber(widthPx) or 0
	nameDb = nameDb or {}
	if widthPx <= 0 then
		if fs.SetWidth then
			fs:SetWidth(0)
		end
		return
	end

	if fs.SetJustifyH then
		local point = nameDb.position or "CENTER"
		if point:find("RIGHT") then
			fs:SetJustifyH("RIGHT")
		elseif point:find("LEFT") then
			fs:SetJustifyH("LEFT")
		else
			fs:SetJustifyH("CENTER")
		end
	end

	if fs.SetWidth then
		fs:SetWidth(widthPx)
	end
	fs:SetWordWrap(false)
	if fs.SetNonSpaceWrap then
		fs:SetNonSpaceWrap(false)
	end
end

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

local function ApplyNameplate(nameplate)
	if nameplate and nameplate.Name then
		local unitType = nameplate.frameType
		local unitDb = unitType and E.db.nameplates and E.db.nameplates.units and E.db.nameplates.units[unitType]
		local width = unitDb and unitDb.name and unitDb.name.clipWidth
		if width == nil then
			width = DEFAULT_NP_WIDTH
		end
		ApplyClip(nameplate.Name, width, unitDb and unitDb.name)

		local castbar = nameplate.CastBar
		if castbar and castbar.Text and unitDb and unitDb.castbar then
			ApplyWidthOnly(castbar.Text, unitDb.castbar.nameLength or 0)
		end
	end
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

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Options" then
		return
	end

	module:UnregisterEvent(event)
end

function module:Initialize()
	if not E.private.nameplates.enable then
		return
	end

	hooksecurefunc(NP, "Update_TagText", function(_, nameplate, element, dbTag, hide)
		if element == nameplate.Name and dbTag and dbTag.enable and not hide then
			ApplyNameplate(nameplate)
		end
	end)
	hooksecurefunc(NP, "Castbar_SetText", function(_, castbar, db)
		if castbar and castbar.Text and db then
			ApplyWidthOnly(castbar.Text, db.nameLength or 0)
		end
	end)

	self:RegisterEvent("ADDON_LOADED")

	RefreshAll()
end

MER:RegisterModule(module:GetName())
