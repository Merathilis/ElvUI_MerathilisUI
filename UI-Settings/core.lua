local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:NewModule('MerathilisUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

-- Profile (if this gets big, move it to a seperate file but load before your core.lua. Put it in the .toc file)
-- In case you create options, also add them here
P['Merathilis Eule'] = {
	['installed'] = nil,
}
-- bla bla
-- local functions must go up
local function MER:SetupUI()
	-- Here you put ElvUI settings that you want enabled or not.
	-- Opening ElvUI.lua file from the WTF folder will show you your current profile settings.
	do
		--General
		E.db.general.totems.size = 36
		E.db.general.fontSize = 11
		E.db.general.interruptAnnounce = "RAID"
		E.db.general.autoRepair = "GUILD"
		E.db.general.minimap.garrisonPos = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.scale = 0.9
		E.db.general.minimap.icons.garrison.position = "TOPRIGHT"
		E.db.general.minimap.icons.garrison.yOffset = 10
		E.db.general.minimap.size = 150
		E.db.general.bottompanel = false
		E.db.general.backdropfadecolor.r = 0.0549019607843137
		E.db.general.backdropfadecolor.g = 0.0549019607843137
		E.db.general.backdropfadecolor.b = 0.0549019607843137
	end
	
	do
		-- Datatexts
		E.db.datatexts.font = 'Andy Roadway'
		E.db.datatexts.fontSize = 10
		E.db.datatexts.fontOutline = 'OUTLINE'
	end
	
	-- Movers
	if E.db.movers == nil then E.db.movers = {} end -- prevent a lua error when running the install after a profile gets deleted.
	do
		E.db.movers.MinimapMover = "TOPRIGHTElvUIParentTOPRIGHT-5-6"
		E.db.movers.DebuffsMover = "TOPRIGHTElvUIParentTOPRIGHT-183-134"
		E.db.movers.AlertFrameMover = "TOPElvUIParentTOP0-140"
		E.db.movers.ElvUF_PartyMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT61213"
		E.db.movers.ElvAB_9 = "BOTTOMElvUIParentBOTTOM0334"
		E.db.movers.WatchFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-122-292"
		E.db.movers.BossHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-56-397"
		E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM-2620"
		E.db.movers.ElvAB_10 = "BOTTOMElvUIParentBOTTOM-2288"
		E.db.movers.ElvAB_6 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-46262"
		E.db.movers.PetAB = "BOTTOMElvUIParentBOTTOM022"
		E.db.movers.TargetPowerBarMover = "BOTTOMElvUIParentBOTTOM203429"
		E.db.movers.LocationLiteMover = "TOPElvUIParentTOP0-7"
		E.db.movers.VehicleSeatMover = "TOPLEFTElvUIParentTOPLEFT325-195"
		E.db.movers.TotemBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT46243"
		E.db.movers.ElvAB_8 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-51957"
		E.db.movers.TempEnchantMover = "TOPRIGHTElvUIParentTOPRIGHT-5-299"
		E.db.movers.PetAB = "TOPRIGHTElvUIParentTOPRIGHT-5-299"
		E.db.movers.ElvAB_5 = "BOTTOMElvUIParentBOTTOM-25761"
		E.db.movers.ElvAB_3 = "BOTTOMElvUIParentBOTTOM25761"
		E.db.movers.ElvAB_10 = "BOTTOMElvUIParentBOTTOM-2288"
		E.db.movers.Top_Center_Mover = "BOTTOMElvUIParentBOTTOM25436"
		E.db.movers.ElvAB_7 = "BOTTOMLEFTElvUIParentBOTTOMLEFT520375"
		E.db.movers.WatchFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-122-292"
		E.db.movers.ReputationBarMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT8817"
		E.db.movers.ElvAB_2 = "BOTTOMElvUIParentBOTTOM097"
		E.db.movers.ElvAB_1 = "BOTTOMElvUIParentBOTTOM061"
		E.db.movers.ElvAB_9 = "BOTTOMElvUIParentBOTTOM0334"
		E.db.movers.ArenaHeaderMover = "TOPRIGHTElvUIParentTOPRIGHT-150-305"
		E.db.movers.ElvUF_Raid40Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT50214"
		E.db.movers.BuiDashboardMover = "TOPLEFTElvUIParentTOPLEFT4-8"
		E.db.movers.DP_2_Mover = "TOPLEFTElvUIParentTOPLEFT00"
		E.db.movers.ElvUF_TargetMover = "BOTTOMElvUIParentBOTTOM189201"
		E.db.movers.ElvUF_Raid25Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT2200"
		E.db.movers.ExperienceBarMover = "TOPElvUIParentTOP307-290"
		E.db.movers.ShiftAB = "BOTTOMLEFTElvUIParentBOTTOMLEFT905136"
		E.db.movers.MicrobarMover = "TOPLEFTElvUIParentTOPLEFT4-4"
		E.db.movers.ClassBarMover = "BOTTOMElvUIParentBOTTOM-1349"
		E.db.movers.ElvUF_FocusMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-432407"
		E.db.movers.DigSiteProgressBarMover = "TOPElvUIParentTOP-20"
		E.db.movers.FlareMover = "BOTTOMElvUIParentBOTTOM0253"
		E.db.movers.SLE_Dashboard_Mover = "TOPLEFTElvUIParentTOPLEFT0-46"
		E.db.movers.LocationMover = "TOPElvUIParentTOP0-7"
		E.db.movers.GMMover = "TOPLEFTElvUIParentTOPLEFT3290"
		E.db.movers.LeftChatMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT6156"
		E.db.movers.ElvUF_RaidMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT51213"
		E.db.movers.ElvUF_PlayerCastbarMover = "BOTTOMElvUIParentBOTTOM-189162"
		E.db.movers.ElvUF_AssistMover = "TOPLEFTElvUIParentBOTTOMLEFT25725"
		E.db.movers.RightChatMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-6156"
		E.db.movers.DP_3_Mover = "TOPElvUIParentTOP270"
		E.db.movers.ElvUF_PlayerMover = "BOTTOMElvUIParentBOTTOM-189201"
		E.db.movers.tokenHolderMover = "TOPLEFTElvUIParentTOPLEFT4-119"
		E.db.movers.ElvUF_TargetCastbarMover = "BOTTOMElvUIParentBOTTOM189162"
		E.db.movers.UIBFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-44-161"
		E.db.movers.BNETMover = "TOPElvUIParentTOP8-29"
		E.db.movers.ObjectiveFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-200-281"
		E.db.movers.DP_5_Mover = "BOTTOMLEFTElvUIParentBOTTOMLEFT5415"
		E.db.movers.AltPowerBarMover = "TOPElvUIParentTOP1-272"
		E.db.movers.ElvAB_4 = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT0367"
		E.db.movers.Bottom_Panel_Mover = "BOTTOMElvUIParentBOTTOM2601"
		E.db.movers.LossControlMover = "BOTTOMElvUIParentBOTTOM12526"
		E.db.movers.ElvUF_TargetTargetMover = "BOTTOMElvUIParentBOTTOM0221"
		E.db.movers.BuiMiddleDtMover = "BOTTOMElvUIParentBOTTOM033"
		E.db.movers.SquareMinimapBar = "TOPRIGHTElvUIParentTOPRIGHT-1-333"
		E.db.movers.ElvUF_PetCastbarMover = "BOTTOMElvUIParentBOTTOM0169"
		E.db.movers.MarkMover = "BOTTOMElvUIParentBOTTOM0167"
		E.db.movers.PlayerPortraitMover = "BOTTOMLEFTElvUIParentBOTTOMLEFT584177"
		E.db.movers.ElvUF_RaidpetMover = "TOPLEFTElvUIParentBOTTOMLEFT242810"
		E.db.movers.LootFrameMover = "TOPRIGHTElvUIParentTOPRIGHT-495-457"
		E.db.movers.BossButton = "BOTTOMLEFTElvUIParentBOTTOMLEFT535252"
		E.db.movers.ElvUF_Raid10Mover = "BOTTOMElvUIParentBOTTOM1282"
		E.db.movers.NemoMover = "TOPElvUIParentTOP-277-540"
		E.db.movers.BuffsMover = "TOPRIGHTElvUIParentTOPRIGHT-183-3"
		E.db.movers.ElvUF_FocusTargetMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-432473"
		E.db.movers.MinimapButtonAnchor = "TOPRIGHTElvUIParentTOPRIGHT-5-231"
		E.db.movers.ElvUF_FocusCastbarMover = "BOTTOMRIGHTElvUIParentBOTTOMRIGHT-432394"
		E.db.movers.DP_6_Mover = "BOTTOMElvUIParentBOTTOM-5263"
	end
	
	print('MerathilisUI Setup is done. Please Reload')
	-- Setup is done so set our option to true, so the Setup won't run again on this player.
	-- Enable it when you are done with the settings
	
	--E.db.mer.installed = true

end


function MER:Initialize()
	-- if ElvUI installed and if in your profile the install is nil then run the SetupUI() function.
	-- This is a check so that your setup won't run everytime you login
	-- Enable it when you are done
	--if E.private.install_complete == E.version and E.db.mer.installed == nil then SetupUI() end
	
	-- run your setup on load for testing purposes. When you are done with the options, disable it.
	SetupUI()
end

E:RegisterModule(MER:GetName())
-- test
=======
-- test

