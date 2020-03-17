local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule('MER_Loot', 'AceEvent-3.0', 'AceHook-3.0')
local LCG = LibStub('LibCustomGlow-1.0')
local M = E:GetModule('Misc')

--Cache global variables
local _G = _G
--WoW API / Variables
local GetLootSlotInfo = GetLootSlotInfo
local GetNumLootItems = GetNumLootItems
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:LOOT_OPENED(_, autoloot)
	local lootFrame = _G.ElvLootFrame

	local items = GetNumLootItems()
	if items > 0 then
		for i=1, items do
			local slot = lootFrame.slots[i] or createSlot(i) -- Monitor this
			local textureID, item, quantity, _, quality, _, isQuestItem, questId, isActive = GetLootSlotInfo(i)

			local questTexture = slot.questTexture
			if ( questId and not isActive ) then
				questTexture:Show()
				LCG.PixelGlow_Start(slot.iconFrame)
			elseif ( questId or isQuestItem ) then
				questTexture:Hide()
				LCG.PixelGlow_Start(slot.iconFrame)
			else
				LCG.PixelGlow_Stop(slot.iconFrame)
			end
		end
	end
end

function module:Initialize()
	hooksecurefunc(M, "LOOT_OPENED", module.LOOT_OPENED)
end

MER:RegisterModule(module:GetName())
