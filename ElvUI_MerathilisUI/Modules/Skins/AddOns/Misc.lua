local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local getn = getn

local hooksecurefunc = hooksecurefunc
local After = C_Timer.After

local r, g, b = unpack(E["media"].rgbvaluecolor)
local MAX_STATIC_POPUPS = 4

function module:BlizzMisc()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local skins = {
		"StaticPopup1",
		"StaticPopup2",
		"StaticPopup3",
		"StaticPopup4",
		"AutoCompleteBox",
		"ReadyCheckFrame",
		"StackSplitFrame",
		"QueueStatusFrame",
		"LFDReadyCheckPopup",
		"LFDRoleCheckPopup",
	}

	for i = 1, getn(skins) do
		if skins then
			module:CreateShadow(_G[skins[i]])
		end
	end

	--DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList" .. level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName .. "Backdrop"]
		if Backdrop and not Backdrop.__MERSkin then
			module:CreateBackdropShadow(Backdrop)
			Backdrop.__MERSkin = true
		end

		local menuBackdrop = _G[listFrameName .. "MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.__MERSkin then
			module:CreateShadow(menuBackdrop)
			menuBackdrop.__MERSkin = true
		end
	end)

	--LibDropDown
	local DropDown = _G.ElvUI_MerathilisUIMenuBackdrop
	if DropDown then
		module:CreateShadow(DropDown)
	end

	local function StylePopups()
		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G["ElvUI_StaticPopup" .. i]
			if frame and not frame.skinned then
				module:CreateShadow(frame)
				frame.skinned = true
			end
		end
	end
	After(1, StylePopups)

	-- What's New
	_G.SplashFrame:CreateBackdrop("Transparent")
	module:CreateShadow(_G.SplashFrame)

	-- Chat Config
	if E.private.skins.blizzard.blizzardOptions then
		module:CreateShadow(_G.ChatConfigFrame)
	end

	if _G.ActionStatus.Text then
		F.SetFontDB(_G.ActionStatus.Text, E.private.mui.skins.actionStatus)
	end

	module:SecureHook(S, "HandleIconSelectionFrame", function(_, frame)
		module:CreateShadow(frame)
	end)

	-- Basic Message Dialog
	local MessageDialog = _G.BasicMessageDialog
	if MessageDialog then
		module:CreateShadow(MessageDialog)
	end
end

module:AddCallback("BlizzMisc")
