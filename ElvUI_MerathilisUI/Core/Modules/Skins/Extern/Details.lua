local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')

local DetailsGradient = {
	["WARRIOR"] = { r1 = 0.60, g1 = 0.40, b1 = 0.20, r2 = 0.66, g2 = 0.53, b2 = 0.34 },
	["PALADIN"] = { r1 = 0.9, g1 = 0.47, b1 = 0.64, r2 = 0.96, g2 = 0.65, b2 = 0.83 },
	["HUNTER"] = { r1 = 0.58, g1 = 0.69, b1 = 0.29, r2 = 0.78, g2 = 1, b2 = 0.38 },
	["ROGUE"] = { r1 = 1, g1 = 0.68, b1 = 0, r2 = 1, g2 = 0.83, b2 = 0.25 },
	["PRIEST"] = { r1 = 0.65, g1 = 0.65, b1 = 0.65, r2 = 0.98, g2 = 0.98, b2 = 0.98 },
	["DEATHKNIGHT"] = { r1 = 0.79, g1 = 0.07, b1 = 0.14, r2 = 1, g2 = 0.18, b2 = 0.23 },
	["SHAMAN"] = { r1 = 0, g1 = 0.25, b1 = 0.50, r2 = 0, g2 = 0.43, b2 = 0.87 },
	["MAGE"] = { r1 = 0, g1 = 0.73, b1 = 0.83, r2 = 0.49, g2 = 0.87, b2 = 1 },
	["WARLOCK"] = { r1 = 0.50, g1 = 0.30, b1 = 0.70, r2 = 0.7, g2 = 0.53, b2 = 0.83 },
	["MONK"] = { r1 = 0, g1 = 0.77, b1 = 0.45, r2 = 0.22, g2 = 0.90, b2 = 1 },
	["DRUID"] = { r1 = 1, g1 = 0.23, b1 = 0.0, r2 = 1, g2 = 0.48, b2 = 0.03 },
	["DEMONHUNTER"] = { r1 = 0.36, g1 = 0.13, b1 = 0.57, r2 = 0.74, g2 = 0.19, b2 = 1 },
	["EVOKER"] = { r1 = 0.20, g1 = 0.58, b1 = 0.50, r2 = 0, g2 = 1, b2 = 0.60 },

	["PET"] = { r1 = 0.97, g1 = 0.55, b1 = 0.73, r2 = 1, g2 = 0, b2 = 0 },
	["UNKNOW"] = { r1 = 0.97, g1 = 0.55, b1 = 0.73, r2 = 1, g2 = 0, b2 = 0 },
	["UNGROUPPLAYER "] = { r1 = 0.97, g1 = 0.55, b1 = 0.73, r2 = 1, g2 = 0, b2 = 0 },
	["ENEMY "] = { r1 = 0.97, g1 = 0.55, b1 = 0.73, r2 = 1, g2 = 0, b2 = 0 },
	["MONSTER "] = { r1 = 0.97, g1 = 0.55, b1 = 0.73, r2 = 1, g2 = 0, b2 = 0 },
}

local classes = {
	["WARRIOR"] = true,
	["PALADIN"] = true,
	["HUNTER"] = true,
	["MONK"] = true,
	["ROGUE"] = true,
	["PRIEST"] = true,
	["DEATHKNIGHT"] = true,
	["SHAMAN"] = true,
	["MAGE"] = true,
	["WARLOCK"] = true,
	["DRUID"] = true,
	["DEMONHUNTER"] = true,
	["EVOKER"] = true
}

local function GradientBars()
	local class
	hooksecurefunc(_detalhes, "InstanceRefreshRows", function(instancia)
		if instancia.barras and instancia.barras[1] then
			for _, row in next, instancia.barras do
				if row and row.textura then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						if row.minha_tabela and row.minha_tabela.name then
							class = row.minha_tabela:class()
							if class ~= 'UNKNOW' and classes[class] then
								row.textura:SetGradient("Horizontal", CreateColor(DetailsGradient[class].r1 - 0.2, DetailsGradient[class].g1 - 0.2,	DetailsGradient[class].b1 - 0.2, 0.9), CreateColor(DetailsGradient[class].r2 + 0.2, DetailsGradient[class].g2 + 0.2, DetailsGradient[class].b2 + 0.2, 0.9))
							else
								row.textura:SetGradient("Horizontal", CreateColor(r - 0.5, g - 0.5, b - 0.5, 0.9), CreateColor(r + 0.2, g + 0.2, b + 0.2, 0.9))
							end
						else
							row.textura:SetGradient("Horizontal", CreateColor(r - 0.5, g - 0.5, b - 0.5, 0.9), CreateColor(r + 0.2, g + 0.2, b + 0.2, 0.9))
						end
					end)
				end
			end
		end
	end)
end

local function SetupInstance(instance)
	if instance.skinned then return end

	if not instance.baseframe then
		instance:ShowWindow()
		instance.wasHidden = true
	end

	instance.baseframe:CreateBackdrop('Transparent')
	instance.baseframe.backdrop:SetPoint("TOPLEFT", -1, 18)
	instance.baseframe.backdrop:Styling()
	module:CreateGradient(instance.baseframe.backdrop)
	module:CreateBackdropShadow(instance.baseframe)

	if instance:GetId() < 4 then
		local open, close = module:CreateToggle(instance.baseframe)
		open:HookScript("OnClick", function()
			instance:ShowWindow()
		end)
		close:HookScript("OnClick", function()
			instance:HideWindow()
		end)
		if instance.wasHidden then
			close:Click()
		end
	end

	instance.skinned = true
end

local function EmbedWindow(instance, x, y, width, height)
	if not instance.baseframe then return end

	instance.baseframe:ClearAllPoints()
	instance.baseframe:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", x, y)
	instance:SetSize(width, height)
	instance:SaveMainWindowPosition()
	instance:RestoreMainWindowPosition()
	instance:LockInstance(true)
end

local function isDefaultOffset(offset)
	return offset and abs(offset) < 10
end

local function IsDefaultAnchor(instance)
	local frame = instance and instance.baseframe
	if not frame then return end
	local relF, _, relT, x, y = frame:GetPoint()

	return (relF == "CENTER" and relT == "CENTER" and isDefaultOffset(x) and isDefaultOffset(y))
end

function module:ResetDetailsAnchor(force)
	local Details = _G.Details
	if not Details then return end

	local height = 144
	local instance1 = Details:GetInstance(1)
	local instance2 = Details:GetInstance(2)
	local instance3 = Details:GetInstance(3)
	if instance1 and (force or IsDefaultAnchor(instance1)) then
		if instance2 then
			height = 96
			EmbedWindow(instance2, -3, 165, 340, height)
		end
		if instance3 then
			height = 96
			EmbedWindow(instance3, -3, 284, 340, height)
		end
		EmbedWindow(instance1, -3, 49, 340, height)
	end

	return instance1
end

local function ReskinDetails()
	local Details = _G.Details
	Details.tabela_instancias = Details.tabela_instancias or {}
	Details.instances_amount = Details.instances_amount or 5

	local index = 1
	local instance = Details:GetInstance(index)
	while instance do
		SetupInstance(instance)
		index = index + 1
		instance = Details:GetInstance(index)
	end

	-- Reanchor
	local instance1 = module:ResetDetailsAnchor()

	local listener = Details:CreateEventListener()
	listener:RegisterEvent("DETAILS_INSTANCE_OPEN")
	function listener:OnDetailsEvent(event, instance)
		if event == "DETAILS_INSTANCE_OPEN" then
			if not instance.styled and instance:GetId() == 2 then
				instance1:SetSize(340, 96)
				EmbedWindow(instance, -3, 165, 340, 96)
			end
			if not instance.styled and instance:GetId() == 3 then
				EmbedWindow(instance, -3, 284, 340, 96)
			end
			SetupInstance(instance)
		end
	end

	-- Reset to one window
	Details.OpenWelcomeWindow = function()
		if instance1 then
			EmbedWindow(instance1, -3, 24, 340, 96)
		end
	end
end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable then
		return
	end

	if E.private.mui.skins.addonSkins.dt then
		if E.Retail then
			GradientBars()
		end
	end

	if E.private.mui.skins.embed and E.private.mui.skins.embed.enable then
		ReskinDetails()
	end
end

module:AddCallbackForAddon('Details', LoadSkin)
