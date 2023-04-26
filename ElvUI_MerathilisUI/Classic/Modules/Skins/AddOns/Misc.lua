local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local getn = getn

local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After

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
		"InterfaceOptionsFrame",
		"VideoOptionsFrame",
		"AudioOptionsFrame",
		"AutoCompleteBox",
		"ReadyCheckFrame",
		"StackSplitFrame",
	}

	for i = 1, getn(skins) do
		_G[skins[i]]:Styling()
		module:CreateBackdropShadow(_G[skins[i]])
	end

	--DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList"..level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName.."Backdrop"]
		if Backdrop and not Backdrop.__MERSkin then
			Backdrop:Styling()
			module:CreateShadow(Backdrop)
			Backdrop.__MERSkin = true
		end

		local menuBackdrop = _G[listFrameName.."MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.__MERSkin then
			menuBackdrop:Styling()
			menuBackdrop.__MERSkin = true
		end
	end)

	--DropDownMenu library support
	if _G.LibStub("LibUIDropDownMenu", true) then
		_G.L_DropDownList1Backdrop:Styling()
		_G.L_DropDownList1MenuBackdrop:Styling()
		hooksecurefunc("L_UIDropDownMenu_CreateFrames", function()
			if not _G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"].template then
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"]:Styling()
				module:CreateShadow(_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"])
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."MenuBackdrop"]:Styling()
				module:CreateShadow(_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."MenuBackdrop"])
			end
		end)
	end

	if _G.CopyChatFrame then
		_G.CopyChatFrame:Styling()
	end

	local function StylePopups()
		for i = 1, MAX_STATIC_POPUPS do
			local frame = _G["ElvUI_StaticPopup"..i]
			if frame and not frame.skinned then
				frame:Styling()
				frame.skinned = true
			end
		end
	end
	C_TimerAfter(1, StylePopups)

	local TalentMicroButtonAlert = _G.TalentMicroButtonAlert
	if TalentMicroButtonAlert then
		TalentMicroButtonAlert:Styling()
	end

	-- Chat Config
	_G.ChatConfigFrame:Styling()

	-- Mirror Timers
	if _G.MirrorTimer1StatusBar.backdrop then
		_G.MirrorTimer1StatusBar.backdrop:Styling()
	end

	if _G.MirrorTimer2StatusBar.backdrop then
		_G.MirrorTimer2StatusBar.backdrop:Styling()
	end

	if _G.MirrorTimer3StatusBar.backdrop then
		_G.MirrorTimer3StatusBar.backdrop:Styling()
	end

	-- DataStore
	if IsAddOnLoaded("DataStore") then
		local frame = _G.DataStoreFrame
		if frame then
			frame:Styling()
		end
	end
end

S:AddCallback("Misc", LoadSkin)
