local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local format, match, gsub = string.format, string.match, string.gsub
local strmatch = strmatch
-- WoW API / Variables
local GetItemCooldown = GetItemCooldown
local GetItemIcon = GetItemIcon
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemID = GetContainerItemID
local HasExtraActionBar = HasExtraActionBar
local InCombatLockdown = InCombatLockdown

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip

local tooltip = CreateFrame('GameTooltip', 'ArtifactScanner', E.UIParent, 'GameTooltipTemplate')
tooltip:SetOwner(E.UIParent, 'ANCHOR_NONE')

local button = CreateFrame('Button', 'ArtifactConsumable', E.UIParent, 'SecureActionButtonTemplate')
button:SetSize(36, 36)
button:SetFrameLevel(0)
button:SetAttribute('type', 'item')
button:CreateBackdrop('Transparent')
button:Hide()
S:HandleButton(button)

button.texture = button:CreateTexture()
button.texture:SetTexCoord(.1, .9, .1, .9)
button.texture:SetAllPoints()
S:HandleIcon(button.texture)

button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
button.cd:SetAllPoints()

local function cooldown()
	if button.id then
		local start, cd = GetItemCooldown(button.id)
		button.cd:SetCooldown(start, cd)
	end
end

local function hide()
	button.id = nil
	button:SetAttribute('item', nil)
	button:Hide()
	button.texture:SetTexture('')
end

local function show(id, ap)
	button.id = id
	button:SetAttribute('item', 'item:'..id)
	button:ClearAllPoints()
	button:Show()
	button.texture:SetTexture(GetItemIcon(id))
	if _G["ZoneAbilityFrame"]:IsShown() or HasExtraActionBar() then
		button:SetPoint('BOTTOMRIGHT', _G["ZoneAbility"], 'TOPLEFT', -3, 8)
	else
		button:SetPoint('BOTTOM', _G["ZoneAbility"], 'TOP', 0, 8)
	end
end

local function scan()
	hide()
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			local item = GetContainerItemLink(i, j)
			local id = GetContainerItemID(i, j)
			if id then
				tooltip:ClearLines()
				tooltip:SetHyperlink(item)
				local two = _G[tooltip:GetName()..'TextLeft2']
				if two and two:GetText() then
					if strmatch(two:GetText(), L['Artifact Power']) then
						local four = _G[tooltip:GetName()..'TextLeft4']:GetText()
						four = gsub(four, ',', '')  --  strip BreakUpLargeNumbers
						local ap = match(four, '%d+')
						if ap then show(id, ap) break end
					end
				end
			end
		end
	end
end

button:SetScript('OnEnter', function()
	GameTooltip:SetOwner(button, 'ANCHOR_TOP')
	if button.id then
		GameTooltip:SetItemByID(button.id)
	end
end)

button:SetScript('OnLeave', function()
	GameTooltip:Hide()
end)

local f = CreateFrame('Frame')
f:RegisterEvent('BAG_UPDATE_COOLDOWN')
f:RegisterEvent('SPELL_UPDATE_COOLDOWN')
f:RegisterEvent('BAG_UPDATE_DELAYED')
f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

function f:BAG_UPDATE_COOLDOWN() cooldown() end
function f:SPELL_UPDATE_COOLDOWN() cooldown() end
function f:BAG_UPDATE_DELAYED()
	if InCombatLockdown() then
		f:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		scan()
	end
end
function f:PLAYER_REGEN_ENABLED()
	scan()
	f:UnregisterEvent('PLAYER_REGEN_ENABLED')
end