local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

--Module
local mActionBars = MER:GetModule("mUIActionbars")
local mArmory = MER:GetModule("MERArmory")
local mBags = MER:GetModule("mUIBags")
local mChat = MER:GetModule("muiChat")
local mCooldownFlash = MER:GetModule("CooldownFlash")
local mDataBars = MER:GetModule("mUI_databars")
local mLocPanel = MER:GetModule('LocPanel')
local mMedia = MER:GetModule("MERMedia")
local mPVP = MER:GetModule("PVP")
local mRaidCD = MER:GetModule("RaidCD")
local mRaidManager = MER:GetModule("RaidManager")
local mRaidMarkers = MER:GetModule("RaidMarkers")
local mRBReminder = MER:GetModule("RaidBuffs")
local mReminder = MER:GetModule("Reminder")
local mSkins = MER:GetModule("muiSkins")
local mUnitFrames = MER:GetModule("muiUnits")

function MER:UpdateDB()
	mActionBars.db = E.db.mui.actionbars
	mDataBars.db = E.db.mui.databars
	mMedia.db = E.db.mui.media
	mSkins.db = E.private.muiSkins
	mArmory.db = E.db.mui.armory
	mBags.db = E.db.mui.bags
	mChat.db = E.db.mui.chat
	mCooldownFlash.db = E.db.mui.cooldownFlash
	mLocPanel.db = E.db.mui.locPanel
	mPVP.db = E.db.mui.pvp
	mRaidCD.db = E.db.mui.raidCD
	mRaidManager.db = E.db.mui.raidmanager
	mRaidMarkers.db = E.db.mui.raidmarkers
	mRBReminder.db = E.db.mui.raidBuffs
	mReminder.db = E.db.mui.reminder
	mUnitFrames.db = E.db.mui.unitframes
end
hooksecurefunc(E, "UpdateDB", MER.UpdateDB)
