local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("MERDashBoard")
local DT = E:GetModule("DataTexts")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, pairs = ipairs, pairs
local getn = getn
local tinsert, twipe = table.insert, table.wipe
-- WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
--GLOBALS:

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local boards = {"FPS", "MS", "Volume"}

function module:UpdateSystem()
	local db = E.db.mui.dashboard.system
	local holder = _G.MER_SystemDashboard
	local DASH_WIDTH = E.db.mui.dashboard.system.width or 150

	if(module.SystemDB[1]) then
		for i = 1, getn(module.SystemDB) do
			module.SystemDB[i]:Kill()
		end
		twipe(module.SystemDB)
		holder:Hide()
	end

	for _, name in pairs(boards) do
		if db.chooseSystem[name] == true then
			holder:Show()
			holder:SetHeight(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#module.SystemDB + 1)) + DASH_SPACING)

			local sysFrame = CreateFrame('Frame', 'MER_'..name, holder)
			sysFrame:SetHeight(DASH_HEIGHT)
			sysFrame:SetWidth(DASH_WIDTH)
			sysFrame:SetPoint('TOPLEFT', holder, 'TOPLEFT', SPACING, -SPACING)
			sysFrame:EnableMouse(true)

			sysFrame.dummy = CreateFrame('Frame', nil, sysFrame)
			sysFrame.dummy:SetPoint('BOTTOMLEFT', sysFrame, 'BOTTOMLEFT', 2, 2)
			sysFrame.dummy:SetPoint('BOTTOMRIGHT', sysFrame, 'BOTTOMRIGHT', (E.PixelMode and -4 or -8), 0)
			sysFrame.dummy:SetHeight(E.PixelMode and 3 or 5)

			sysFrame.dummy.dummyStatus = sysFrame.dummy:CreateTexture(nil, 'OVERLAY')
			sysFrame.dummy.dummyStatus:SetInside()
			sysFrame.dummy.dummyStatus:SetTexture(E['media'].normTex)
			sysFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

			sysFrame.Status = CreateFrame('StatusBar', nil, sysFrame.dummy)
			sysFrame.Status:SetStatusBarTexture(E['media'].normTex)
			sysFrame.Status:SetMinMaxValues(0, 100)
			sysFrame.Status:SetInside()

			sysFrame.spark = sysFrame.Status:CreateTexture(nil, 'OVERLAY', nil);
			sysFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
			sysFrame.spark:SetSize(12, 6)
			sysFrame.spark:SetBlendMode('ADD')
			sysFrame.spark:SetPoint('CENTER', sysFrame.Status:GetStatusBarTexture(), 'RIGHT')

			sysFrame.Text = sysFrame.Status:CreateFontString(nil, 'OVERLAY')
			sysFrame.Text:SetPoint('LEFT', sysFrame, 'LEFT', 6, (E.PixelMode and 2 or 3))
			sysFrame.Text:SetJustifyH('LEFT')

			tinsert(module.SystemDB, sysFrame)
		end
	end

	for key, frame in ipairs(module.SystemDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:SetPoint( 'TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:SetPoint('TOP', module.SystemDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function module:UpdateSystemSettings()
	module:FontStyle(module.SystemDB)
	module:FontColor(module.SystemDB)
	module:BarColor(module.SystemDB)
end

function module:CreateSystemDashboard()
	local DASH_WIDTH = E.db.mui.dashboard.system.width or 150

	self.sysHolder = self:CreateDashboardHolder("MER_SystemDashboard", "system")
	self.sysHolder:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 10, -55)
	self.sysHolder:SetWidth(DASH_WIDTH)

	module:UpdateSystem()
	module:UpdateHolderDimensions(self.sysHolder, "system", module.SystemDB)
	module:ToggleTransparency(self.sysHolder, "system")

	E:CreateMover(self.sysHolder, "MERDashboardMover", L["System"], nil, nil, nil, "ALL,MERATHILISUI", nil, 'mui,modules,dashboard,system')
end

function module:LoadSystem()
	if E.db.mui.dashboard.system.enableSystem ~= true then return end
	local db = E.db.mui.dashboard.system.chooseSystem

	if (db.FPS ~= true and db.MS ~= true and db.Bags ~= true and db.Durability ~= true and db.Volume ~= true) then return end

	module:CreateSystemDashboard()
	module:UpdateSystemSettings()

	hooksecurefunc(DT, "LoadDataTexts", module.UpdateSystemSettings)

	if db.FPS then module:CreateFps() end
	if db.MS then self:CreateMs() end
	if db.Volume then self:CreateVolume() end
end
