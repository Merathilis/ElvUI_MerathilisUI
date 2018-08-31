local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = MER:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = MER:GetModule("muiSkins")
local B = E:GetModule("Bags")
MERB.modName = L["Bags"]

--Cache global variables
--Lua Variables
local ipairs = ipairs
local floor = math.floor
--WoW API / Variables
local GetContainerNumSlots = GetContainerNumSlots
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERB:SkinBags()
	if ElvUI_ContainerFrame then
		ElvUI_ContainerFrame:Styling()
		ElvUI_ContainerFrameContainerHolder:Styling()
	end

	if ElvUIBags then
		ElvUIBags.backdrop:Styling()
	end
end

function MERB:SkinBank()
	if ElvUI_BankContainerFrame then
		ElvUI_BankContainerFrame:Styling()
		ElvUI_BankContainerFrameContainerHolder:Styling()
	end
end

function MERB:AllInOneBags()
	self:SkinBags()
	self:RegisterEvent('BANKFRAME_OPENED', 'SkinBank')
end

function MERB:SkinBlizzBags()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.bags ~= true or E.private.bags.enable then return end

	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local container = _G['ContainerFrame'..i]
		if container.backdrop then
			container.backdrop:Styling()
		end
	end
	if BankFrame then
		BankFrame:Styling()
	end
end

-- Credits SMRTL (ElvUI_SplitBag)
function MERB:Layout(self, isBank)
	if isBank then return end
	local f = B:GetContainerFrame(isBank)

	if not f then return end
	local buttonSize = isBank and B.db.bankSize or B.db.bagSize
	local buttonSpacing = E.Border*2
	local containerWidth = ((isBank and B.db.bankWidth) or B.db.bagWidth)
	local numContainerColumns = floor(containerWidth / (buttonSize + buttonSpacing))
	local numContainerRows = 0

	local numBags = 0
	local numBagSlots = 0
	local bagSpacing = E.db.mui.bags.splitBags.bagSpacing or 5
	local bag1 = E.db.mui.bags.splitBags.bag1
	local bag2 = E.db.mui.bags.splitBags.bag2
	local bag3 = E.db.mui.bags.splitBags.bag3
	local bag4 = E.db.mui.bags.splitBags.bag4

	local lastButton
	local lastRowButton
	for i, bagID in ipairs(f.BagIDs) do
		local newBag = bagID == 1 and bag1 or bagID == 2 and bag2 or bagID == 3 and bag3 or bagID == 4 and bag4 or false

		--Bag Slots
		local numSlots = GetContainerNumSlots(bagID)
		if numSlots > 0 and f.Bags[bagID] then
			for slotID = 1, numSlots do
				f.totalSlots = f.totalSlots + 1
				f.Bags[bagID][slotID]:ClearAllPoints()

				if lastButton then
					if newBag and slotID == 1 then
						f.Bags[bagID][slotID]:Point('TOP', lastRowButton, 'BOTTOM', 0, -(buttonSpacing + bagSpacing))
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
						numBags = numBags + 1
						numBagSlots = 0
					elseif numBagSlots % numContainerColumns == 0 then
						f.Bags[bagID][slotID]:Point('TOP', lastRowButton, 'BOTTOM', 0, -buttonSpacing)
						lastRowButton = f.Bags[bagID][slotID]
						numContainerRows = numContainerRows + 1
					else
						f.Bags[bagID][slotID]:Point('LEFT', lastButton, 'RIGHT', buttonSpacing, 0)
					end
				else
					f.Bags[bagID][slotID]:Point('TOPLEFT', f.holderFrame, 'TOPLEFT')
					lastRowButton = f.Bags[bagID][slotID]
					numContainerRows = numContainerRows + 1
				end

				lastButton = f.Bags[bagID][slotID]
				numBagSlots = numBagSlots + 1
			end
		end
	end

	f:Size(containerWidth, ((buttonSize + buttonSpacing) * numContainerRows) + numBags * bagSpacing + f.topOffset + f.bottomOffset + 2);
end
hooksecurefunc(B, "Layout", MERB.Layout)

function MERB:Initialize()
	if E.private.bags.enable ~= true then return end

	self:AllInOneBags()
	self:SkinBlizzBags()
	self:SkinBank()
end

local function InitializeCallback()
	MERB:Initialize()
end

MER:RegisterModule(MERB:GetName(), InitializeCallback)