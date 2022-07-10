local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("lfg", "lfg") then
		return
	end

	local PVEFrame = _G.PVEFrame
	PVEFrame:Styling()

	local frames = {
		_G.PVEFrame,
		_G.LFGDungeonReadyDialog,
		_G.LFGDungeonReadyStatus,
		_G.LFDRoleCheckPopup,
		_G.ReadyCheckFrame,
		_G.QueueStatusFrame,
		_G.LFDReadyCheckPopup,
		_G.LFGListInviteDialog,
		_G.LFGListApplicationDialog
	}

	for _, frame in pairs(frames) do
		module:CreateShadow(frame)
	end

	for i = 1, 3 do
		module:ReskinTab(_G["PVEFrameTab" .. i])
	end

	local iconSize = 56-2*E.mult
	for i = 1, 3 do
		local bu = _G["GroupFinderFrame"]["groupButton"..i]
		bu.name:SetTextColor(1, 1, 1)

		bu.icon:SetSize(iconSize, iconSize)
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint("LEFT", bu, "LEFT", 5, 0)
	end
end

S:AddCallback("PVEFrame", LoadSkin)
