local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')
local AB = E:GetModule('ActionBars')

local CreateVector3D = CreateVector3D
local hooksecurefunc = hooksecurefunc

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end

	module:UnregisterEvent(event)
end

function module:CreateHighlight(frame)
	if not frame then return end
	if not E.db.mui.unitframes.highlight then return end

	local hl = frame:CreateTexture(nil, "BACKGROUND")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, .5, 1)
	hl:SetVertexColor(1, 1, .6, 1)
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

function module:CreateAnimatedBars(frame)
	if not frame then return end
	if not E.db.unitframe.units.player.power.enable then return end -- only Player for now

	local db = E.db.mui.unitframes.power
	frame.__MERAnim = CreateFrame("FRAME", nil, frame) -- Main Frame

	if db and db.enable then
		if not frame.animation then
			local animation = CreateFrame("PlayerModel", "MER_PowerBarEffect", frame.__MERAnim)

			if db.type == "DEFAULT" then
				animation:SetModel(1715069)
				animation:MakeCurrentCameraCustom()
				animation:SetPortraitZoom(1)
				animation:SetTransform(CreateVector3D(-0.035, 0, 0), CreateVector3D(4.7123889803847, 0, 0), 1)
				animation:SetAlpha(0.65)
			elseif db.type == "CUSTOM" then
				animation:SetModel(db.model)
			end

			animation:SetKeepModelOnHide(true)
			animation:SetInside(frame:GetStatusBarTexture(), 0, 0)

			frame.animation = animation
		end

		if not frame.sparkle then
			local sparkle = CreateFrame("PlayerModel", nil, frame.__MERAnim)
			sparkle:SetKeepModelOnHide(true)
			sparkle:SetModel(1630153)
			sparkle:ClearTransform()
			sparkle:SetPosition(4, 0.32, 1.85, 0)

			local h = frame:GetHeight()
			sparkle:SetPoint("RIGHT", frame.__MERAnim)
			sparkle:SetInside(frame:GetStatusBarTexture(), 0, 0)
			sparkle:SetSize(h * 2, h)
			sparkle:SetAlpha(0.2)

			frame.sparkle = sparkle
		end

		frame.__MERAnim:SetAllPoints(frame:GetStatusBarTexture())
		frame.__MERAnim:Show()

		frame.__MERAnim:RegisterEvent("PLAYER_ENTERING_WORLD")
		frame.__MERAnim:RegisterEvent("PORTRAITS_UPDATED")
		frame.__MERAnim:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		frame.__MERAnim:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		frame.__MERAnim:RegisterEvent("CINEMATIC_STOP")
		frame.__MERAnim:RegisterUnitEvent("PLAYER_FLAGS_CHANGED", "player")
	else
		frame.__MERAnim:Hide()
	end
end

local function HookConstructUnitFrames()
	hooksecurefunc(UF, 'Construct_PartyFrames', module.Construct_PartyFrames)
end

function module:Initialize()
	if not E.private.unitframe.enable then
		return
	end

	local db = E.db.mui.unitframes

	HookConstructUnitFrames()

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
	-- Castbar
	hooksecurefunc(UF, "LoadUnits", module.CastBarHooks)
	hooksecurefunc(UF, "LoadUnits", module.UpdateAllCastbars)
	-- Power
	hooksecurefunc(UF, "Configure_Power", module.Configure_Power)
	-- Power Textures
	module:ChangePowerBarTexture()
	hooksecurefunc(UF, 'Update_StatusBars', module.ChangePowerBarTexture)
	hooksecurefunc(UF, 'Update_AllFrames', module.ChangeUnitPowerBarTexture)
	hooksecurefunc(AB, 'StyleShapeShift', module.ChangeUnitPowerBarTexture)
	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)
	-- RoleIcons
	module:Configure_RoleIcons()

	--Auras
	if db.auras then
		module:SecureHook(UF, "PostUpdateAura", "ElvUI_PostUpdateDebuffs")
	end

	self:RegisterEvent("ADDON_LOADED")
end

MER:RegisterModule(module:GetName())
