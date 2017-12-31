local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:GetModule("mUIActionbars")

--Cache global variables
--Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local tinsert = table.insert
--WoW API / Variables
local CreateFrame = CreateFrame
local GetNumSpecializations = GetNumSpecializations
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local SetSpecialization = SetSpecialization
local GetLootSpecialization = GetLootSpecialization
local SetLootSpecialization = SetLootSpecialization
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, GameTooltip_Hide

function MAB:SpecBar()
	if E.db.mui.actionbars.specBar ~= true then return end

	local Spacing, Mult = 4, 1
	local Size = 24
	local Frames = { 'Player' }
 
	if E.myclass == "HUNTER" then
		tinsert(Frames, 'Pet')
	end
 
	for _, Name in pairs(Frames) do
		local Bar = CreateFrame('Frame', Name..'SpecializationBar', E.UIParent)
		Bar:SetFrameStrata('BACKGROUND')
		Bar:SetFrameLevel(0)
		Bar:SetSize(40, 40)
		Bar:SetTemplate('Transparent')
		Bar:Styling()
		Bar.Button = {}
 
		local Specs = GetNumSpecializations(false, Name == 'Pet' and true)
 
		for i = 1, Specs do
			local SpecID, SpecName, Description, Icon = GetSpecializationInfo(i, false, Name == 'Pet' and true)
			local Button = CreateFrame('Button', nil, Bar)
			Button:SetSize(Size, Size)
			Button:SetID(i)
			Button:SetTemplate()
			Button:SetNormalTexture(Icon)
			Button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			Button:GetNormalTexture():SetInside()
			Button:RegisterForClicks('AnyDown')
			Button:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:AddLine(SpecName)
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(Description, true)
				GameTooltip:Show()
			end)
			Button:SetScript('OnLeave', GameTooltip_Hide)
			Button:SetScript('OnClick', function(self, button)
				if button == 'LeftButton' then
					if self:GetID() ~= GetSpecialization(nil, Name == 'Pet' and true) then
						SetSpecialization(SpecID)
					end
				end
			end)
			Button:SetScript('OnEvent', function(self)
				local Spec = GetSpecialization(nil, Name == 'Pet' and true)
				if Spec == self:GetID() then
					self:SetBackdropBorderColor(0, 0.44, .87)
				else
					self:SetTemplate()
				end
			end)
			Button:SetPoint('LEFT', i == 1 and Bar or Bar.Button[i - 1], i == 1 and 'LEFT' or 'RIGHT', Spacing, 0)
 
			Bar.Button[i] = Button
		end
 
		local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
		local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))
 
		Bar:SetSize(BarWidth, BarHeight)
	end
 
	PlayerSpecializationBar:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 177)
	for _, Button in pairs(PlayerSpecializationBar.Button) do
		Button:HookScript('OnClick', function(self, button)
			if button == "RightButton" then
				local SpecID = GetSpecializationInfo(self:GetID())
				if (GetLootSpecialization() == SpecID) then
					SpecID = 0
				end
				SetLootSpecialization(SpecID)
			end
		end)
		Button:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		Button:RegisterEvent('PLAYER_ENTERING_WORLD')
		Button:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED')
		Button:HookScript('OnEvent', function(self)
			if (GetLootSpecialization() == GetSpecializationInfo(self:GetID())) then
				self:SetBackdropBorderColor(1, 0.44, .4)
			end
		end)
	end
 
	if E.myclass == "HUNTER" then
		local Events = { 'PET_BAR_UPDATE', 'PET_BAR_HIDE', 'PET_UI_UPDATE', 'PLAYER_ENTERING_WORLD', 'UPDATE_VEHICLE_ACTIONBAR' }
		PetSpecializationBar:SetPoint('RIGHT', PlayerSpecializationBar, 'LEFT', -.5, 0)
		RegisterStateDriver(PetSpecializationBar, 'visibility', '[pet] show; hide')
		for _, Button in pairs(PetSpecializationBar.Button) do
			for _, Event in pairs(Events) do
				Button:RegisterEvent(Event)
			end
			Button:RegisterUnitEvent('UNIT_PET', 'player')
			Button:RegisterUnitEvent('UNIT_FLAGS', 'pet')
		end
	end
end