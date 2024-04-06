local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local LCG = E.Libs.CustomGlow
local M = E:GetModule("Misc")

local _G = _G

local GetLootSlotInfo = GetLootSlotInfo
local GetNumLootItems = GetNumLootItems
local hooksecurefunc = hooksecurefunc

function module:LOOT_OPENED(_, autoloot)
	local lootFrame = _G.ElvLootFrame

	local items = GetNumLootItems()
	if items > 0 then
		for i = 1, items do
			local slot = lootFrame.slots[i] or createSlot(i) -- Monitor this
			local _, _, _, _, _, _, isQuestItem, questId, isActive = GetLootSlotInfo(i)

			local questTexture = slot.questTexture
			if questId and not isActive then
				questTexture:Show()
				LCG.PixelGlow_Start(slot.iconFrame)
			elseif questId or isQuestItem then
				questTexture:Hide()
				LCG.PixelGlow_Start(slot.iconFrame)
			else
				LCG.PixelGlow_Stop(slot.iconFrame)
			end
		end
	end
end

function module:Loot()
	hooksecurefunc(M, "LOOT_OPENED", module.LOOT_OPENED)
end

module:AddCallback("Loot")
