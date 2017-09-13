local AS = unpack(AddOnSkins)

-- if not AS:CheckAddOn('OrderHallCommander') then return end

function AS:OrderHallCommander(event)
	if event == "ADDON_LOADED" then
		if not OrderHallMissionFrameMissions then return end
		OrderHallMissionFrameMissions:HookScript('OnShow', function(self)
			AS:Delay(0.5, function()
				local frame = FollowerIcon:GetParent()
				if frame.IsSkinned then return end

				AS:StripTextures(frame)
				AS:SetTemplate(frame, "Transparent")
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOM", OrderHallMissionFrame, "TOP", 0, 0)
				frame:SetWidth(OrderHallMissionFrame:GetWidth()+2)
				frame.IsSkinned = true

				frame = LibInitCheckbox00001:GetParent():GetParent()
				AS:StripTextures(frame)
				AS:SetTemplate(frame, 'Transparent')

				frame = {OrderHallMissionFrame.MissionTab:GetChildren()}
				AS:SkinNextPrevButton(frame[19], true)
				frame[19]:Size(12, 12)

				frame = {LibInitCheckbox00001:GetParent():GetParent():GetChildren()}
				AS:SkinCloseButton(frame[1])
				AS:StripTextures(frame[2])

				frame = {OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:GetChildren()}
				AS:SkinButton(frame[1])
			end)
		end)
		AS:UnregisterSkinEvent("OrderHallCommander", event)
	elseif OHCGUIContainer1 and event == "GARRISON_MISSION_COMPLETE_RESPONSE" then
		if OHCGUIContainer1.IsSkinned then return end
		AS:Delay(0.5, function()
			AS:SkinFrame(OHCGUIContainer1)
			AS:StripTextures(OHCGUIContainer1.GarrCorners)
			AS:SkinCloseButton(OHCGUIContainer1.CloseButton)
		end)
		AS:UnregisterSkinEvent("OrderHallCommander", event)
	end
end

AS:RegisterSkin('OrderHallCommander', AS.OrderHallCommander, 'ADDON_LOADED', 'GARRISON_MISSION_COMPLETE_RESPONSE')