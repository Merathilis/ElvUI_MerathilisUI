local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local function DisableTexture(button)
	for _, func in pairs({
		"SetNormalTexture",
		"SetPushedTexture",
		"SetDisabledTexture",
		"SetHighlightTexture",
		"SetWidth",
		"SetHeight",
	}) do
		if button[func] then
			button[func] = E.noop
		end
	end
end

local function HandleChatFrame(frame)
	if frame.isSkinned then
		return
	end

	local backdrop = frame.widgets.Backdrop
	local msgbox = frame.widgets.msg_box
	local chat = frame.widgets.chat_display
	local up = frame.widgets.scroll_up
	local down = frame.widgets.scroll_down
	local exit = frame.widgets.close

	for _, v in pairs({ "tl", "tr", "bl", "br", "t", "b", "l", "r", "bg" }) do
		backdrop[v]:SetTexture(nil)
		backdrop[v].SetTexture = E.noop
	end
	module:SetBD(backdrop)

	msgbox.bg = module:CreateBDFrame(msgbox, 0.25)
	msgbox.bg:Point("TOPLEFT", -6, -2)
	msgbox.bg:Point("BOTTOMRIGHT", E.mult, 2)

	chat.bg = module:CreateBDFrame(chat, 0.25)
	chat.bg:Point("TOPLEFT", -6, E.mult)
	chat.bg:Point("BOTTOMRIGHT", 4, -6)

	S:HandleNextPrevButton(up, "up")
	up:SetPoint("TOPRIGHT", -10, -49)
	DisableTexture(up)
	S:HandleNextPrevButton(down, "down")
	down:SetPoint("BOTTOMRIGHT", -10, 33)
	DisableTexture(down)

	if exit then
		exit:StripTextures()
		exit:Size(28)
		exit:ClearAllPoints()
		exit:Point("TOPRIGHT", -2, 0)

		local arrow = exit:CreateTexture(MER.Title .. "arrow", "ARTWORK")
		arrow:SetTexture(I.Media.Textures.arrow)
		arrow:SetAllPoints()
	end

	frame.circle = frame:CreateTexture(nil, "BACKGROUND")
	frame.circle:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	frame.circle:SetSize(40, 40)
	frame.circle:Point("TOPLEFT", 2, -2)
	frame.circle:Hide()

	if frame.UpdateIcon then
		hooksecurefunc(frame, "UpdateIcon", function(self)
			self.circle:Hide()
			if _G.WIM.constants.classes[self.class] then
				local classTag = _G.WIM.constants.classes[self.class].tag
				local tcoords = CLASS_ICON_TCOORDS[classTag]
				if tcoords then
					self.widgets.class_icon:SetTexture(nil)
					self.circle:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4])
					self.circle:Show()
				end
			end
		end)
	end

	frame.isSkinned = true
end

local function HandleIconButton(button)
	if button.icon and not button.isSkinned then
		S:HandleIcon(button:GetNormalTexture())
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
		button:SetPushedTexture(0)
		button.SetPushedTexture = E.noop
		button.icon:SetTexCoord(unpack(E.TexCoords))

		button.isSkinned = true
	end
end

local function HandleWindow()
	local index = 1
	local msgFrame = _G["WIM3_msgFrame" .. index]
	while msgFrame do
		HandleChatFrame(msgFrame)
		index = index + 1
		msgFrame = _G["WIM3_msgFrame" .. index]
	end

	index = 1
	local button = _G["WIM_ShortcutBarButton" .. index]
	while button do
		HandleIconButton(button)
		index = index + 1
		button = _G["WIM_ShortcutBarButton" .. index]
	end
end

function module:WIM()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wim then
		return
	end

	local WIM = _G.WIM
	if not WIM then
		return
	end

	hooksecurefunc(WIM, "CreateWhisperWindow", HandleWindow)
	hooksecurefunc(WIM, "CreateChatWindow", HandleWindow)
	hooksecurefunc(WIM, "CreateW2WWindow", HandleWindow)
	hooksecurefunc(WIM, "ShowDemoWindow", HandleWindow)
end

module:AddCallbackForAddon("WIM")
