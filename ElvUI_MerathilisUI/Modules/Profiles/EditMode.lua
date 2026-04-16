local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles

local _G = _G

function module:ToggleEditMode()
	if not _G.EditModeManagerFrame then
		return
	end

	if not _G.EditModeManagerFrame:IsShown() then
		_G.EditModeManagerFrame:Show()
	else
		_G.EditModeManagerFrame:Hide()
	end
end

function module:EditModeString()
	if not _G.EditModeManagerFrame then
		return
	end

	local importString =
		[[2 50 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&('%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&('%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&('%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&('%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&('%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&('%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&('% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 1 6 7 UIParent 300.0 250.0 -1 %#3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 '#(#)#-5.)/#1$3#5#6(7-7$ 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-5.)/#0#1#2(5#6(7-7$ 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -5.)/#4$5#6(7-7$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()(-$ 6 2 1 1 1 UIParent 0.0 -25.0 -1 ##$#%$&.(()(+#,-,$ 7 -1 0 1 1 UIParent -0.0 -101.7 -1 # 8 -1 1 6 6 UIParent 35.0 50.0 -1 #'$A%$&i 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 7 7 UIParent 827.0 82.0 -1 # 12 -1 0 5 3 DurabilityFrame -4.0 -218.5 -1 #+$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 0 2 8 MinimapCluster 0.0 -4.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 0 0 0 UIParent 1434.0 -287.5 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 0 7 7 UIParent -362.8 482.0 -1 ##$7%$&&'%(-($)#+$,$-# 20 1 0 7 7 UIParent -379.0 602.0 -1 ##$*%$&('%(-($)#+$,$-$ 20 2 0 4 4 UIParent 0.0 -260.0 -1 ##$$%$&(')(-($)#+$,$-$ 20 3 0 4 4 UIParent -397.3 200.0 -1 #$$$%#&&'((-($)#*#+$,$-$.t 21 -1 1 7 7 UIParent -410.0 380.0 -1 ##$# 22 0 0 4 4 UIParent -549.5 220.0 -1 #$$$%#&('((#)U*$+$,$-#.#/U0% 22 1 1 1 1 UIParent 0.0 -40.0 -1 &('()U*#+$ 22 2 1 1 1 UIParent 0.0 -90.0 -1 &('()U*#+$ 22 3 1 1 1 UIParent 0.0 -130.0 -1 &('()U*#+$ 23 -1 1 0 0 UIParent 0.0 0.0 -1 ##$#%$&-&$'7(%)U+$,$-$.(/U]]

	E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, importString)
end
