local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G
local next = next

local Details = _G.Details

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
	["EVOKER"] = true,
}

local function GradientBars()
	hooksecurefunc(Details, "InstanceRefreshRows", function(instancia)
		if instancia.barras and instancia.barras[1] then
			for _, row in next, instancia.barras do
				if row and row.textura and not row.textura.__MERSkin then
					hooksecurefunc(row.textura, "SetVertexColor", function(_, r, g, b)
						if row.minha_tabela and row.minha_tabela.name then
							local class = row.minha_tabela:class()
							if classes[class] then
								if E.db.mui.gradient.customColor.enableClass then
									row.textura:SetGradient("Horizontal", F.GradientColorsDetailsCustom(class))
								else
									row.textura:SetGradient("Horizontal", F.GradientColorsDetails(class))
								end
							else
								row.textura:SetGradient(
									"Horizontal",
									CreateColor(r - 0.5, g - 0.5, b - 0.5, 0.9),
									CreateColor(r + 0.2, g + 0.2, b + 0.2, 0.9)
								)
							end
						else
							row.textura:SetGradient(
								"Horizontal",
								CreateColor(r - 0.5, g - 0.5, b - 0.5, 0.9),
								CreateColor(r + 0.2, g + 0.2, b + 0.2, 0.9)
							)
						end
					end)
					row.textura.__MERSkin = true
				end
			end
		end
	end)
end

local function GradientNames()
	hooksecurefunc(Details.atributo_damage, "RefreshLine", function(_, detailsDB, lineContainer, whichRowLine)
		local thisLine = lineContainer[whichRowLine]
		if not thisLine then
			return
		end
		if thisLine.lineText1 then
			local name = E:StripString(thisLine.lineText1:GetText())
			if detailsDB.use_multi_fontstrings and detailsDB.use_auto_align_multi_fontstrings then
				thisLine.lineText1:SetText(
					F.GradientName(F:ShortenString(name, 10, true), thisLine.minha_tabela:class())
				)
			else
				thisLine.lineText1:SetText(F.GradientName(name, thisLine.minha_tabela:class()))
			end
			thisLine.lineText1:SetShadowOffset(2, -2)
		end
	end)

	hooksecurefunc(Details.atributo_heal, "RefreshLine", function(_, instancia, _, whichRowLine)
		local thisLine = instancia.barras[whichRowLine]
		if not thisLine then
			return
		end
		if thisLine.lineText1 then
			local name = E:StripString(thisLine.lineText1:GetText())
			if instancia.use_multi_fontstrings and instancia.use_auto_align_multi_fontstrings then
				thisLine.lineText1:SetText(
					F.GradientName(F:ShortenString(name, 10, true), thisLine.minha_tabela:class())
				)
			else
				thisLine.lineText1:SetText(F.GradientName(name, thisLine.minha_tabela:class()))
			end
			thisLine.lineText1:SetShadowOffset(2, -2)
		end
	end)
end

local function SetupInstance(instance)
	if instance.skinned then
		return
	end

	if not instance.baseframe then
		instance:ShowWindow()
		instance.wasHidden = true
	end

	instance.baseframe:CreateBackdrop("Transparent")
	instance.baseframe.backdrop:SetPoint("TOPLEFT", -1, 18)
	WS:CreateBackdropShadow(instance.baseframe)

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
	if not instance.baseframe then
		return
	end

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
	if not frame then
		return
	end
	local relF, _, relT, x, y = frame:GetPoint()

	return (relF == "CENTER" and relT == "CENTER" and isDefaultOffset(x) and isDefaultOffset(y))
end

function module:ResetDetailsAnchor(force)
	if not Details then
		return
	end

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

function module:Details()
	if not E.private.mui.skins.addonSkins.enable then
		return
	end

	local db = E.private.mui.skins.addonSkins.dt
	if db and db.enable then
		if db.gradientBars then
			GradientBars()
		end
		if db.gradientName then
			GradientNames()
		end
	end

	if E.private.mui.skins.embed and E.private.mui.skins.embed.enable then
		ReskinDetails()
	end
end

module:AddCallbackForAddon("Details")
