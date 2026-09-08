local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

-- Runs after successful profile import
local function CallbackFunction(accepted)
	if not accepted then
		return
	end

	-- Handle minimap icon
	local LDBI = LibStub("LibDBIcon-1.0", true)
	if BigWigsIconDB then
		BigWigsIconDB.hide = true
	end
	if LDBI then
		LDBI:Hide("BigWigs")
	end
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
		"BW2:hVfNj+TEFW8PrIiIEhBCUQ/LQhNBLsmBLAd2UaRRd9v9Mf3hnrZ7xitONXaNu4Tb5djume1ob7v8B+FAboAQJ4REcoA/IUfEiX+AAzdE94HMIdSHXVW224wPPZ6qV+/j937vvfLnsxVMEuDDGU5QinCYfDyGq2iZ//uk1zWmtjHP/jQa0xDHKxDI/Y5p2+aka5uzxn3t1iRT18UBjpPPetE6jgL4+Pro+wv2NMSbfh6s6cZ/P6TPv66PvuMvmuHHEIZyRxNvursB6obW28AgwFePNSLzNV/s4RiEPnys/XyvIRa7MfQea4qt7MXMvLVgmqLQT77s43UaoBCO7cGwOzIX9ng4NQYXOEwt9A/44pRCM8EhdpcxXsEtg6pHdqdgBU+mOMUtC4RJaw79dQBisU0PN/+iu0uQbidJsPbnMPRgTExuB+sEIpfgvjt2A5AkLgVuN6EnF1EEYxckcGeAAPlhloPjlXSAuUaNHxsPo5gEcwU2Iz/GV4voCsResh1RReaeoE7ohlV05QJ4MEUreH3001vsGXkoiQKwoYsHJy5eh6mHr8Icrs9+Ha7mm6MUPkyNEJwH0NtNxHmbqLt1UxjGJUYuHBuhH6Bk+U6rvdqYQgOn10dDeo69f9KOtbbfaJ835qtNukTuLFgnuZ9ftZw7UYx9qplaISGl0EyXMDYvLhKYPmg4tyv7SppPUJikIHThCG6SNk2FPjZ69q8rdZrLM/VcX2ZlV1DI/H+ikeeYxXdaidt5pWLIBrEP09x9DoyVgji1yJs36SD/DPnJO60xDn1btSYKl4XAfp4hdeu8pApZS3zVDoIZST2Mk63TrAbKE9/P2VQR2FqqwpJ4waO8QJ53Xq1o6eX5ZcBSkEhZO3cKqumOviY1j0MBJZU63KuN/jOTlTqBHlqvnFa9ZY40y0+NSur8C5zdRuixBExFAtqkD6z20Iu5zbhkzIf9ge28XJNjRWaRi9gYBymKerQVp9oN9HCaf+fE6kAfhbdOVfAUklcZkIFKYtruMVHoHbtKRvfifLYHPxbCQj0+QB60URrA7fAcxLzUP52Q1w5w3yPNjeD7pEEeumSTBmMtAekJdEnrZ0ssXYP89JPG/47e+vd/NI2eMEjfAwlJmSeW+5eE5aQmup2zu3PRY8RE/GgQ5UVDx1w26v48IspEh/lj3gpzio/4nDxDXrpsfjmDudU5TGiZ7gbwYcQ3v9Bp/9/pFygItoskIiNtGHrIBSmJm6fwoEd7+jra3dQ0rUuUINJtO2T4oBVKabBNbyKsT/Al3IkG/TuzJN70hmzS0AbNKTckbg4g8pfpH0yhpc+d0elY2PWTCLgEg+ekFXr8txR9K90E0HnjkXuRPRMYA9KdSWd7FPPVt703wWL4KG45TWKqi6NNd52keNUO3SWOGUJb5zYHc//uOA+HBvvcUHixy2IhdGBt7qwEbZ5ftmmVNqm+p8c0MQUxnQ60XZ/+rmM4MoLLxbA1Jc79dcxd5Fi9YEnE17RSAwTj66Mfs1tHydbhU/8/OQcpITwhh2DU6xNvTcBCSlfTBmQe82E6I3cJUuLJFIdQ7o/OcUwKMiM9qYexSzoFJbPh+XCnU4ead6c0LB0mIKUG4FMqqcaZXrXr0GgdAUPmVIMtP6gs2wXpLtfWEBX0fnZfzP7c1z7+zWAxnIEYhukx955S2rBwgLxT6qjNse4R9yyGm344ezoTpVki9xJuhDODinfeSCwFn7xH/945zCEVTUDszQXaqhozx28Y0h5B8OGGeVk2Jvm2dYUiuFvk4F0CFNA8yczYIbyaKztsSujUO5FmebEo95LTittS8SzfE5EsKtK0Hht6gN33tvoKe1BzmmVPxekhxVzxu5Blkc6Lug4/JlUvPyVGpKRnIvOFL4lD7eDeP0XqS18V73Pm8d/72rv3vhGSlotXpFhoSLL7Hp+AcNNlG7Wzxz7HScJlCimey/VhCNwUXUJ9ak6NGV0nVyoSLy/qZvNUWGEA5eIUqOujb/mV2ZbHCmakh7WA/HDvAxmmEO8IpmuK7k6pVGYyitxbpyl1iMEpWgO5ISlnxoQb0NueyJXSjc0UugQYZWeymliUPM+WT6R4SfVUHODz8K4pveArfzPl4WzlVMoUzMylZCGbZTwlcnZpRzbPCtwsCWcKj2pZoLghrrczYagEgHNbSR4inIk3lN78anSgxN5WvgIV2tYR6uBPCqGcl/fFKZwn8RYpXAOW3KK8zlxUgFIulIsyfBLZabGQWKeRGaqpGz2ffSVw9980lTKszZJZSiXzQ/qmwu28IguAp4jcUj1I5gJf3DqvKeEWy+0mkBXMTstW2it6HX3WuVPOSb1mhRn1Hzy3le5WoZzTqhCSzC5IQCJ3FtbZyaeQ4tDe7iI7RtZcFJYo3OGRVWiyNzJudC/GmVHn1TKAJcefKU4KVphyqaZlqF9Jr9XGvddls8RDRjGFdyrHziqoZ9lf7E0+qyTppMRUU0ZXhr3zUhkXJd0lwjBMlBoTdVfpC6wfKpK1jchXG1GrbizdxGbhyC8="

	-- Profile import
	-- API.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	BigWigsAPI.RegisterProfile(MER.Title, ProfileString, ProfileName, CallbackFunction)

	-- No chat print here
	-- BigWigs will print a message with all important information after the import
end

function module:ApplyBigWigsProfile()
	Splash:Wrap("Applying BigWigs Profile ...", function()
		self:LoadBigWigsProfile()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "BigWigs")
end
