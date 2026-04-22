local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc

local DEFAULT_UF_WIDTH = 0

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

local function ApplyUnitframe(frame)
	if frame and frame.Name and frame.db and frame.db.name then
		local width = frame.db.name.clipWidth
		if width == nil then
			width = DEFAULT_UF_WIDTH
		end
		ApplyClip(frame.Name, width, frame.db.name)
	end
end

local function RefreshAll()
	if not ElvUF or not ElvUF.objects then
		return
	end

	for _, frame in ipairs(ElvUF.objects) do
		ApplyUnitframe(frame)
	end
end

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Options" then
		return
	end

	module:UnregisterEvent(event)
end

function module:CreateHighlight(frame)
	if not frame then
		return
	end
	if not E.db.mui.unitframes.highlight then
		return
	end

	local hl = frame:CreateTexture(nil, "BACKGROUND")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, 0.5, 1)
	hl:SetVertexColor(1, 1, 0.6, 1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	frame.Highlight = hl

	frame:HookScript("OnEnter", function()
		frame.Highlight:Show()
	end)
	frame:HookScript("OnLeave", function()
		frame.Highlight:Hide()
	end)
end

function module:Initialize()
	if not E.private.unitframe.enable then
		return
	end

	-- Player
	hooksecurefunc(UF, "Update_PlayerFrame", module.Update_PlayerFrame)
	-- Target
	hooksecurefunc(UF, "Update_TargetFrame", module.Update_TargetFrame)
	-- TargetTarget
	hooksecurefunc(UF, "Update_TargetTargetFrame", module.Update_TargetTargetFrame)
	-- Pet
	hooksecurefunc(UF, "Update_PetFrame", module.Update_PetFrame)
	-- Focus
	hooksecurefunc(UF, "Update_FocusFrame", module.Update_FocusFrame)
	-- FocusTarget
	hooksecurefunc(UF, "Update_FocusTargetFrame", module.Update_FocusTargetFrame)
	-- Party
	hooksecurefunc(UF, "Update_PartyFrames", module.Update_PartyFrames)
	-- Raid
	hooksecurefunc(UF, "Update_RaidFrames", module.Update_RaidFrames)
	-- Boss
	hooksecurefunc(UF, "Update_BossFrames", module.Update_BossFrames)
	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)

	-- Portraits
	module:Portraits(true)

	-- Name Clip
	hooksecurefunc(UF, "UpdateNameSettings", function(_, frame)
		ApplyUnitframe(frame)
	end)
	hooksecurefunc(UF, "PostNamePosition", function(_, frame)
		ApplyUnitframe(frame)
	end)

	self:RegisterEvent("ADDON_LOADED")

	RefreshAll()
end

MER:RegisterModule(module:GetName())
