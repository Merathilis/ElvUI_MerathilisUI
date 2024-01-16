local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local getn = getn

local hooksecurefunc = hooksecurefunc

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_TimerAfter = C_Timer.After

local r, g, b = unpack(E["media"].rgbvaluecolor)
local MAX_STATIC_POPUPS = 4

local function LoadSkin()
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
			_G[skins[i]]:Styling()
			module:CreateShadow(_G[skins[i]])
		end
	end

	--DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList" .. level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName .. "Backdrop"]
		if Backdrop and not Backdrop.__MERSkin then
			Backdrop:Styling()
			module:CreateBackdropShadow(Backdrop)
			Backdrop.__MERSkin = true
		end

		local menuBackdrop = _G[listFrameName .. "MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.__MERSkin then
			menuBackdrop:Styling()
			module:CreateShadow(menuBackdrop)
			menuBackdrop.__MERSkin = true
		end
	end)

	--LibDropDown
	local DropDown = _G.ElvUI_MerathilisUIMenuBackdrop
	if DropDown then
		DropDown:Styling()
		module:CreateShadow(DropDown)
	end

	if _G.CopyChatFrame then
		_G.CopyChatFrame:Styling()
	end

	local function StylePopups()
		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G["ElvUI_StaticPopup" .. i]
			if frame and not frame.skinned then
				frame:Styling()
				frame.skinned = true
				module:CreateShadow(frame)
			end
		end
	end
	C_TimerAfter(1, StylePopups)

	local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
	if TalentMicroButtonAlert then
		TalentMicroButtonAlert:Styling()
	end

	-- What's New
	_G.SplashFrame:CreateBackdrop('Transparent')
	_G.SplashFrame.backdrop:Styling()
	module:CreateShadow(_G.SplashFrame)

	-- Chat Config
	if E.private.skins.blizzard.blizzardOptions then
		_G.ChatConfigFrame:Styling()
		module:CreateShadow(_G.ChatConfigFrame)
	end

	-- Mirror Timers
	if E.private.skins.blizzard.mirrorTimers then
		hooksecurefunc(_G.MirrorTimerContainer, 'SetupTimer', function(container, timer)
			local bar = container:GetAvailableTimer(timer)
			if bar then
				module:CreateShadow(bar)
				bar:Styling()
			end
		end)
	end

	if _G.ActionStatus.Text then
		F.SetFontDB(_G.ActionStatus.Text, E.private.mui.skins.actionStatus)
	end

	-- DataStore
	if C_AddOns_IsAddOnLoaded("DataStore") then
		local frame = _G.DataStoreFrame
		if frame then
			frame:Styling()
		end
	end

	module:SecureHook(S, "HandleIconSelectionFrame", function(_, frame)
		module:CreateShadow(frame)
	end)

	-- Basic Message Dialog
	local MessageDialog = _G.BasicMessageDialog
	if MessageDialog then
		module:CreateShadow(MessageDialog)
		MessageDialog:Styling()
	end
end

S:AddCallback("BlizzMisc", LoadSkin)
