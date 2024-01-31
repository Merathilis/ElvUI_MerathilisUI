local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G
local select = select
local strmatch = strmatch
local gsub = string.gsub

local function ReplaceGossipFormat(button, textFormat, text)
	local newFormat, count = gsub(textFormat, '000000', 'ffffff')
	if count > 0 then
		button:SetFormattedText(newFormat, text)
	end
end

local ReplacedGossipColor = {
	['000000'] = 'ffffff',
	['414141'] = '7b8489',
}

local function ReplaceGossipText(button, text)
	if text and text ~= '' then
		local newText, count = gsub(text, ':32:32:0:0', ':32:32:0:0:64:64:5:59:5:59')
		if count > 0 then
			text = newText
			button:SetFormattedText('%s', text)
		end

		local colorStr, rawText = strmatch(text, '|c[fF][fF](%x%x%x%x%x%x)(.-)|r')
		colorStr = ReplacedGossipColor[colorStr]
		if colorStr and rawText then
			button:SetFormattedText('|cff%s%s|r', colorStr, rawText)
		end
	end
end

local function ReplaceTextColor(text, r)
	if r ~= 1 then
		text:SetTextColor(1, 1, 1)
	end
end

function module:GossipFrame()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local GossipFrame = _G.GossipFrame
	module:CreateBackdropShadow(GossipFrame)

	if _G.GossipFrameInset then
		_G.GossipFrameInset:Hide() -- Parchment
	end

	if GossipFrame.Background then
		GossipFrame.Background:Hide()
	end

	_G.QuestFont:SetTextColor(1, 1, 1)

	_G.ItemTextPageText:SetTextColor('P', 1, 1, 1)
	hooksecurefunc(_G.ItemTextPageText, 'SetTextColor', function(pageText, headerType, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			pageText:SetTextColor(headerType, 1, 1, 1)
		end
	end)

	hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, 'Update', function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local button = select(i, self.ScrollTarget:GetChildren())
			if not button.IsSkinned then
				local buttonText = button.GreetingText or button.GetFontString and button:GetFontString()
				if buttonText then
					buttonText:SetTextColor(1, 1, 1)
					hooksecurefunc(buttonText, "SetTextColor", ReplaceTextColor)
				end
				if button.SetText then
					local buttonText = select(3, button:GetRegions())
					if buttonText and buttonText:IsObjectType("FontString") then
						ReplaceGossipText(button, button:GetText())
						hooksecurefunc(button, 'SetText', ReplaceGossipText)
						hooksecurefunc(button, 'SetFormattedText', ReplaceGossipFormat)
					end
				end

				button.IsSkinned = true
			end
		end
	end)

	for i = 1, 4 do
		local notch = GossipFrame.FriendshipStatusBar["Notch" .. i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end

	MER.NPC:Register(GossipFrame)
end

module:AddCallback("GossipFrame")
