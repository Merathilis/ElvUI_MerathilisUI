local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local getn = getn
local next, pairs = next, pairs
local tinsert = table.insert
-- WoW API
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After
local WorldStateAlwaysUpFrame = _G["WorldStateAlwaysUpFrame"]
-- GLOBALS: hooksecurefunc, NUM_ALWAYS_UP_UI_FRAMES

local MAX_STATIC_POPUPS = 4

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.misc) then return end

	-- Graveyard button (a bit ugly if you press it)
	_G.GhostFrame:StripTextures()
	_G.GhostFrameContentsFrame:StripTextures()
	_G.GhostFrame:CreateBackdrop("Transparent")
	_G.GhostFrame.backdrop:Styling()

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
		"QueueStatusFrame",
		"LFDReadyCheckPopup",
		"LFDRoleCheckPopup",
	}

	for i = 1, getn(skins) do
		_G[skins[i]]:Styling()
		MER:CreateBackdropShadow(_G[skins[i]])
	end

	--DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList"..level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName.."Backdrop"]
		if Backdrop and not Backdrop.IsSkinned then
			Backdrop:Styling()
			Backdrop.IsSkinned = true
		end

		local menuBackdrop = _G[listFrameName.."MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.IsSkinned then
			menuBackdrop:Styling()
			menuBackdrop.IsSkinned = true
		end
	end)

	--DropDownMenu library support
	if _G.LibStub("LibUIDropDownMenu", true) then
		_G.L_DropDownList1Backdrop:Styling()
		_G.L_DropDownList1MenuBackdrop:Styling()
		hooksecurefunc("L_UIDropDownMenu_CreateFrames", function()
			if not _G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"].template then
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."Backdrop"]:Styling()
				_G["L_DropDownList".._G.L_UIDROPDOWNMENU_MAXLEVELS.."MenuBackdrop"]:Styling()
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

	-- What's New
	_G.SplashFrame:CreateBackdrop('Transparent')
	_G.SplashFrame.backdrop:Styling()
	MER:CreateShadow(_G.SplashFrame)

	-- Chat Config
	_G.ChatConfigFrame:Styling()

	-- ElvUI Stuff
	_G.LeftChatDataPanel:Styling()
	_G.RightChatDataPanel:Styling()
	_G.ElvUI_TopPanel:Styling()
	_G.ElvUI_BottomPanel:Styling()

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

S:AddCallback("mUIBlizzMisc", LoadSkin)
