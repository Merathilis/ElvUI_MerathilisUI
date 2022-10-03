local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

local function GradientColorClass(class)
	if class ~= nil then
		return F.ClassGradient[class].r1 - 0.2, F.ClassGradient[class].g1 - 0.2,
			F.ClassGradient[class].b1 - 0.2, 0.9, F.ClassGradient[class].r2 + 0.2,
			F.ClassGradient[class].g2 + 0.2, F.ClassGradient[class].b2 + 0.2, 0.9
	end
end

local function GradientBars()
	local class
	hooksecurefunc(_detalhes, "InstanceRefreshRows", function(instancia)
		if instancia.barras and instancia.barras[1] then
			for _, row in next, instancia.barras do
				if row and row.textura then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						-- row.textura:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\StatusBars\\Line4pixel")
						if row.minha_tabela and row.minha_tabela.name then
							class = row.minha_tabela:class()
							if class ~= 'UNKNOW' then
								row.textura:SetGradientAlpha("Horizontal", GradientColorClass(class))
							else
								row.textura:SetGradientAlpha("Horizontal", r - 0.5, g - 0.5, b - 0.5, 0.9, r + 0.2, g + 0.2, b + 0.2, 0.9)
							end
						end
					end)
				end
			end
		end
	end)
end

local function SetupInstance(instance)
	if instance.styled then return end
	-- if window is hidden on init, show it and hide later
	if not instance.baseframe then
		instance:ShowWindow()
		instance.wasHidden = true
	end
	-- reset texture if using Details default texture
	-- local needReset = instance.row_info.texture == "BantoBar"
	-- instance:ChangeSkin("Minimalistic")
	-- instance:InstanceWallpaper(false)
	-- instance:DesaturateMenu(true)
	-- instance:HideMainIcon(false)
	-- instance:SetBackdropTexture("None") -- if block window from resizing, then back to "Details Ground", needs review
	-- instance:MenuAnchor(16, 3)
	-- instance:ToolbarMenuButtonsSize(1)
	-- instance:AttributeMenu(true, 0, 3, DB.Font[1], 13, { 1, 1, 1 }, 1, true)
	-- instance:SetBarSettings(needReset and 18, needReset and "normTex")
	-- instance:SetBarTextSettings(needReset and 14, DB.Font[1], nil, nil, nil, true, true)

	local bg = module:SetBD(instance.baseframe)
	bg:SetPoint("TOPLEFT", -1, 18)
	instance.baseframe.bg = bg

	if instance:GetId() < 4 then -- only the top 3 windows
		local open, close = module:CreateToggle(instance.baseframe)
		open:HookScript("OnClick", function()
			instance:ShowWindow()
		end)
		close:HookScript("OnClick", function()
			instance:HideWindow()
		end)
		-- hide window if hidden on init
		if instance.wasHidden then
			close:Click()
		end
	end

	instance.styled = true
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
	if instance1 and (force or IsDefaultAnchor(instance1)) then
		if instance2 then
			height = 96
			EmbedWindow(instance2, -3, 140, 340, height)
		end
		EmbedWindow(instance1, -3, 49, 340, height)
	end

	return instance1
end

local function ReskinDetails()
	local Details = _G.Details
	-- instance table can be nil sometimes
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
				print(instance:GetId())
				instance1:SetSize(320, 96)
				EmbedWindow(instance, -3, 140, 320, 96)
			end
			SetupInstance(instance)
		end
	end

	-- Reset to one window
	Details.OpenWelcomeWindow = function()
		if instance1 then
			EmbedWindow(instance1, -3, 24, 320, 96)
		end
	end

	-- Disable some AddOnSkins settings
	local AS = unpack(AddOnSkins)
	AS.db["EmbedSystem"] = false
	AS.db["EmbedSystemDual"] = false
	AS.db["EmbedBelowTop"] = false
	AS.db["EmbedMain"] = ""
	AS.db["EmbedLeft"] = ""
	AS.db["EmbedRight"] = ""
end

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable then
		return
	end

	if E.private.mui.skins.addonSkins.dt then
		GradientBars()
	end

	if E.private.mui.skins.embed and E.private.mui.skins.embed.enable then
		ReskinDetails()
	end
end

module:AddCallbackForAddon('Details', LoadSkin)
