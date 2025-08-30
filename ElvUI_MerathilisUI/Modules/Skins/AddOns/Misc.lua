local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local getn = getn

local hooksecurefunc = hooksecurefunc

function module:BlizzMisc()
	if not self:CheckDB("misc", "misc") then
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

	-- Chat Menus
	local chatMenus = { "ChatMenu", "EmoteMenu", "LanguageMenu", "VoiceMacroMenu" }

	for _, menu in pairs(chatMenus) do
		local target = _G[menu] and _G[menu].NineSlice
		if target then
			self:SecureHookScript(target, "OnShow", "CreateShadow")
		end
	end

	-- Chat Config
	if E.private.skins.blizzard.blizzardOptions then
		self:CreateShadow(_G.ChatConfigFrame)
	end

	--DropDownMenu
	hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
		local listFrame = _G["DropDownList" .. level]
		local listFrameName = listFrame:GetName()

		local Backdrop = _G[listFrameName .. "Backdrop"]
		if Backdrop and not Backdrop.__MERSkin then
			self:CreateBackdropShadow(Backdrop)
			Backdrop.__MERSkin = true
		end

		local menuBackdrop = _G[listFrameName .. "MenuBackdrop"]
		if menuBackdrop and not menuBackdrop.__MERSkin then
			self:CreateShadow(menuBackdrop)
			menuBackdrop.__MERSkin = true
		end
	end)

	--LibDropDown
	local DropDown = _G.ElvUI_MerathilisUIMenuBackdrop
	if DropDown then
		self:CreateShadow(DropDown)
	end

	-- Dropdown Menu
	self:SecureHook(S, "DropDownMenu_SkinMenu", function(_, prefix, name)
		local backdrop = prefix and _G[name]
		if not backdrop then
			return
		end

		if backdrop.NineSlice then
			backdrop = backdrop.NineSlice
		end

		if backdrop.template then
			self:CreateShadow(backdrop)
		end
	end)

	-- What's New
	_G.SplashFrame:CreateBackdrop("Transparent")
	self:CreateShadow(_G.SplashFrame)

	-- Action Status
	if _G.ActionStatus.Text then
		F.SetFontDB(_G.ActionStatus.Text, E.private.mui.skins.actionStatus)
	end

	self:SecureHook(S, "HandleIconSelectionFrame", function(_, frame)
		self:CreateShadow(frame)
	end)

	-- Basic Message Dialog
	local MessageDialog = _G.BasicMessageDialog
	if MessageDialog then
		self:CreateShadow(MessageDialog)
	end

	-- Spirit Healer
	self:CreateShadow(_G.GhostFrameContentsFrame)

	-- Cinematic Frame
	self:CreateShadow(_G.CinematicFrameCloseDialog)
end

module:AddCallback("BlizzMisc")
