local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select
local strmatch = strmatch
local gsub = string.gsub

local hooksecurefunc = hooksecurefunc

local function ReplaceGossipFormat(button, textFormat, text)
	local newFormat, count = gsub(textFormat, "000000", "ffffff")
	if count > 0 then
		button:SetFormattedText(newFormat, text)
	end
end

local ReplacedGossipColor = {
	["000000"] = "ffffff",
	["414141"] = "7b8489", -- lighter color for some gossip options
}

local function ReplaceGossipText(button, text)
	if text and text ~= "" then
		local newText, count = gsub(text, ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59") -- replace icon texture
		if count > 0 then
			text = newText
			button:SetFormattedText("%s", text)
		end

		local colorStr, rawText = strmatch(text, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
		colorStr = ReplacedGossipColor[colorStr]
		if colorStr and rawText then
			button:SetFormattedText("|cff%s%s|r", colorStr, rawText)
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local GossipFrame = _G.GossipFrame
	GossipFrame:Styling()
	module:CreateBackdropShadow(GossipFrame)

	if _G.GossipFrameInset then
		_G.GossipFrameInset:Hide() -- Parchment
	end

	if GossipFrame.Background then
		GossipFrame.Background:Hide()
	end

	_G.QuestFont:SetTextColor(1, 1, 1)

	MER.NPC:Register(GossipFrame)
	-- hooksecurefunc("GossipTitleButton_OnClick", function() MER.NPC:PlayerTalksFirst() end)
end

S:AddCallback("GossipFrame", LoadSkin)
