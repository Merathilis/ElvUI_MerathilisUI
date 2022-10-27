local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local pairs, GetCVarBool = pairs, GetCVarBool
local C_ChatBubbles_GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

local function SkinChatBubble(chatbubble)
	if chatbubble.skinned then return end

	local frame = chatbubble:GetChildren()
	if frame and not frame:IsForbidden() then
		frame:CreateBackdrop('Transparent')
		frame.backdrop:SetScale(UIParent:GetEffectiveScale())
        frame.backdrop:SetInside(frame, 4, 4)
        module:CreateGradient(frame.backdrop)
		module:CreateTex(frame.backdrop)
		module:CreateBackdropShadow(frame)

		frame:DisableDrawLayer("BORDER")
		frame.Tail:SetAlpha(0)
	end

	chatbubble.skinned = true
end

local function LoadSkin()
	if not E.private.mui.skins.blizzard.chatBubbles or E.private.general.chatBubbles ~= "nobackdrop" then return end

	local events = {
		CHAT_MSG_SAY = "chatBubbles",
		CHAT_MSG_YELL = "chatBubbles",
		CHAT_MSG_MONSTER_SAY = "chatBubbles",
		CHAT_MSG_MONSTER_YELL = "chatBubbles",
		CHAT_MSG_PARTY = "chatBubblesParty",
		CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
		CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
	}

	local bubbleHook = CreateFrame("Frame")
	for event in next, events do
		bubbleHook:RegisterEvent(event)
	end
	bubbleHook:SetScript("OnEvent", function(self, event)
		if GetCVarBool(events[event]) then
			self.elapsed = 0
			self:Show()
		end
	end)

	bubbleHook:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > .1 then
			for _, chatbubble in pairs(C_ChatBubbles_GetAllChatBubbles()) do
				SkinChatBubble(chatbubble)
			end
			self:Hide()
		end
	end)
	bubbleHook:Hide()
end

S:AddCallback("ChatBubbles", LoadSkin)
