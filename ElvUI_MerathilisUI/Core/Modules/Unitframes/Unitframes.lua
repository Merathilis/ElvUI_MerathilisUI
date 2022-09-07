local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

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
	hl:SetVertexColor(1, 1, .6)
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
	local db = E.db.mui.unitframes.power

	if db and db.enable then
		if not frame.animation then
			local animation = CreateFrame("PlayerModel", "MER_PowerBarEffect", frame.Power)
			frame.animation = animation

			if db.type == "DEFAULT" then
				if E.Retail then
					frame.animation:SetModel(1715069)
					frame.animation:MakeCurrentCameraCustom()
					frame.animation:SetTransform(-0.035, 0, 0, rad(270), 0, 0, 0.580)
					frame.animation:SetPortraitZoom(1)
					frame.animation:SetAlpha(0.65)
				else
					frame.animation:SetModel("spells/arcanepower_state_chest.m2")
					frame.animation:SetPosition(1.1, 0, 0)
					frame.animation:SetAlpha(0.65)
				end
			elseif db.type == "CUSTOM" then
				if E.Retail then
					frame.animation:SetModel(db.retailModel)
				else
					frame.animation:SetModel(db.classicModel)
				end
			end

			frame.animation:SetAllPoints(frame:GetStatusBarTexture())
			frame.animation:SetFrameLevel(frame:GetFrameLevel()+1)
			frame.animation:SetInside(frame:GetStatusBarTexture(), 0, 0)

			frame.animation:Show()
		else
			frame.animation:Hide()
		end

		if not frame.modelFrame then
			frame.modelFrame = CreateFrame("FRAME", nil, frame.Power)

			local sparkle = CreateFrame("PlayerModel", nil, frame.modelFrame)
			frame.modelFrame.sparkle = sparkle
			frame.modelFrame.sparkle:SetKeepModelOnHide(true)

			frame.modelFrame.sparkle:SetModel(1630153)
			frame.modelFrame.sparkle:ClearTransform()
			frame.modelFrame.sparkle:SetPosition(4, 0.32, 1.85, 0)

			local h = frame:GetHeight()
			frame.modelFrame.sparkle:SetPoint("RIGHT", frame.modelFrame)
			frame.modelFrame.sparkle:SetSize(h*2, h)
			frame.modelFrame.sparkle:SetAlpha(0.20)

			frame.modelFrame:SetAllPoints(frame:GetStatusBarTexture())
			frame.modelFrame:SetClipsChildren(true)

			frame.modelFrame:Show()
		else
			frame.modelFrame:Hide()
		end
	end
end

function module:CreateUFShadows()
	self:SecureHook(UF, "UpdateNameSettings", "UnitFrames_UpdateNameSettings")
	self:SecureHook(UF, "Configure_Threat", "UnitFrames_Configure_Threat")
	self:SecureHook(UF, "Configure_Power", "UnitFrames_Configure_Power")
	self:SecureHook(UF, "Configure_ClassBar", "UnitFrames_Configure_ClassBar")
end

function module:LoadUnits()
	local db = E.db.mui.unitframes
	-- Player
	hooksecurefunc(UF, "Update_PlayerFrame", module.Update_PlayerFrame)
	-- Target
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
	hooksecurefunc(UF, "Configure_Castbar", module.Configure_Castbar)
	-- Power
    hooksecurefunc(UF, "Configure_Power", module.Configure_Power)
	-- Power Textures
	module:ChangePowerBarTexture()
	hooksecurefunc(UF, 'Update_AllFrames', module.ChangeUnitPowerBarTexture)
	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)
    -- Auras
	if db.auras then
		module:SecureHook(UF, "PostUpdateAura", "ElvUI_PostUpdateDebuffs")
	end
	-- RoleIcons
	module:Configure_RoleIcons()
	-- Shadows
	module:CreateUFShadows()
end

function module:Initialize()
	if not E.private.unitframe.enable then
		return
	end

	hooksecurefunc(UF, "LoadUnits", module.LoadUnits)

	self:RegisterEvent("ADDON_LOADED")
end

MER:RegisterModule(module:GetName())
