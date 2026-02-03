local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

-- Runs after successful profile import
local function CallbackFunction(accepted)
	if not accepted then
		return
	end

	-- Handle minimap icon
	local LDBI = LibStub("LibDBIcon-1.0")
	BigWigsIconDB.hide = true
	LDBI:Hide("BigWigs")
end

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	-- Profile names
	local ProfileName = "MerathilisUI"

	-- Profile string
	local ProfileString =
		"BW2:dVZNiCNFFE7vD8iCrocFM6IShMXdg+CuB8cFCTPpTtKT7iST7syMICyV7pdOsZWuprsymaxzcma8etbbuvhzEPHmetXTnj2IxwURREXE9EFysap/Kp3JWsykq+u9evW97/1Uf9UdQxQhD7o0wgxTP/rUgHEwyl9P6zWtbWu97FEq/9b2aThGRCrU7E5X/F/c/NDMbNUooWH0RT2YhAGBk0X112EySnKmDshECB5/LMYni+rP6UTRvBDAX0oUOVOdGSoKlPoMCKHTE4XrfJcu1mmIfA9OlH83S3KxFoJ7ohTOyiadDK0FjGHfi75p0Akj2IdGp28beltrDqnPLHwfrpmCkn4QQOigCObNIXKB4TEsqv+8mYy2UDCpT51RSMcwTzis8+1tNIbdNmW0YiE/qvTAmxAUJpaFyHi9oh0FIQcyRTPVGSE2b7k4CgiaCfsXWsJOJ4Vl2E291sqwtbyQTvvBFIVuNG9OIsAOj1284xAURY7gP5YYhAvlsoYI9vwsjjvjJdaOQyc+c+nUT+P2QBfokvnDrVDZ8kpbg0X1x9TR3njGRtjpkkkkedtJDOxR7MCeC6p2p6LCEE0Iq9yoA08VuGljP2LId6AFs+j/adktqm0V4O4XBY2C52ZytOa7Fn+67W3s7WMvulPZ4tbGK+YSf04VPvaKy4WYHbxcFHTYCEJ1wrOJ+nIvT6uULYuhkCVnmvJMg/reiqNrJVLa1A5eLGpYIzrdIqTLww1hNF8XZgC4g/OU5W3wsH/ZWkG6mrVrXIvwP98vrjaxCzZmBOb6AIVp1D8z+XQbOfd4YnG3Trmr6Z8MvVCw4YhZI8ST5bRUKimNbCnhtZnbOl1UT+8/aXx97f1F9Zcb8fcfvXdzUf2TP27EPyjCisYTE0UclstV/7ryTvDwpyuL6rf55MnvZ6882v1DaRxyUjh/te392z2ZpLJRPWgGT29Sr5VrLX5Knp+PXjpf2DrkAOLOIY7wgMA2Cg08xuwZPSkTmxefamh1W4ejoAnYG7EXDFFi+elaT2807Y40JJJyEsSqqNq4yTftY5eNyo+7UqMHkUiaWBVm4gbjtE1CaGnksK9X2ryn3hIEWmxG4OD6sTPMhgkh4hVHcHQcpqtvuW+gvn4cVhpRgBzu4VUjbckpzmut9C0BsKFcr3s5NH5i/PTOkznNFVK/1CEmJDYldkHHFescVSKKl4qNRPbLZ418JnSuWtKOyZsCDgiGcFH9O+3Cy0NMegjx7gAxnpicLBm+V013wjnAhTpUmrxJIo7Fjbu8aYYeRG3qw1LeGtDQhSwdRaYaDqVEpI/mehCr4rzy7bYIhQoRYuIAuFh0xsjsJm0oZaUvGDzIM0DNQJWS5XfXlu0V7VpqrSRz9mw1ZzeU+eatZl/vohB8tpPCF3HSLEqwuyeQ2mnK1Dk+K+B3n65udC9lqoLsC1aBi7zynzvYyOmTZSdlnZwV3Re1xr1OrXWGwwhYyczF1hQHEPdzSg4RJoL9Jd+2D9NeQZK0RlXgkMFLiExq6nw57q0BXBru5jKJub+mLbKzpBLq3JurY+qCclA+j1Tu1gWRBdwrsZNByouku7yiTHDxZGzwEl1+KbV4nedvZzvbHdvumImDvNeL5+XyB4ao7/pdWxhm5z6dztK0Sn/fVgblL2UC7Mp2l5fB5zlrK58BsuTKrim3CD4urxXm069c7VBc2zb4fatwbZvi0v4P"

	-- Profile import
	-- API.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	BigWigsAPI.RegisterProfile(MER.Title, ProfileString, ProfileName, CallbackFunction)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

function module:ApplyBigWigsProfile()
	module:Wrap("Applying BigWigs Profile ...", function()
		-- Apply Fonts
		self:LoadBigWigsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "BigWigs")
end
