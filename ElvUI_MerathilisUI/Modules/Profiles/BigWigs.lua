local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:Lv1tpTXruCTAdhArTbtAiTkTkOkrL6bqXoLqdxIYcgWuaB5)0KWHKD86X7ok7FMoZSyCfN8PEMpc8rWsTFa8Tk1dR892dOEVs8jOV3S)XMWEy0(EZ7p)E)EVzgJ)GVuavkjU0grsMIffk)Uj0aUxU4HD3P6jTR2mX04VVomseq8l2Qs76nswW4OfNMfJDI8JeYZ6YJfCF62nmF6gBzOxT66hNQOcU8dMnDfuAyQgt9QLZqsUcZUdP((rd22uVx5UrcsOlDBT0MAvve0EPY6iw5Mmm0IQuSqx5VTKikw5ZcPtAFqTD(P6DAFuTtQoQFuOQf7xPF)uSm7W5uHdrsTh1N0JQyb0gML3OY14Mhhfg54jIcOEAozpW1tib0jRVA1Z5ciFdid1be1MSILJhr5nUhtY9jdXyTWy0V6P4izPXUIObD4diIEsVrXskZbiC7RC8jsPdsE2fjcXy5MeFMByI5vbZGcVuiKnidQz16gtv0ZvOB6wWHMWh)Hy03hyXgIiNwkIq9QqwGnFfTEaj7YeuhStQ3SRv92TRF8yms173xsvVX4g00xj5GznjGLE8hGA2jkYVx0GWtId6sfsiKOt3nKjlmgnpnAV1ql0ItCamVW1OaqJGdigT5LMpYTgW4uBD6TIe9OI06YWWW8ku5buMRN6XAdWYoJIfzD55kI3ACnkmFVmNRWUg)lwF19JuEKGticOaw3YN48bn42LkjQybWZZCb7kRPj7ztot1KuSkQLdXNMviynTNG(lX0qNHnUhmGUjV0DyPVTtd(Y3MiApKtBYzNt9VEw1JP1m1sDdf3(iOELLUAMr28VC(oo2S3fHpKNmFXk445NKUZKqZM12)G2PD5zzIg6Q8(e(sZ3HQ2ZnR0V9y3KCviMV)08aLAaseVyZzRpRIj)RYnbPWDisvdyYH54dfx2OAooA7XC(au0sZ0(BXXkukBUY4s0LxZ6P8EYi83tJIcmkaL(G6MZnv(MuhM7yZTMWRfEgmGdu1d)yuQB2Mx2LKoAk)5PWVwWSdCgpoS3Hgh8Y)5D4h9Gx(FVh)EhEp1ZqZAJ41JajqprlYuPZ)O8iEy6uJMMEgU(8F0eDUkCbbrcKBVdnrNracDUkwVUmFzhi3ke4fxNVYiE(91jla3w)xlpgcsXnhFDY9tkFjnpM23CgtY66tTiIJybm1NDP(kO2WLzj7Ej9CE6jV10mAEsSoQ6ETVPii4evm32cVb0Ee4JUD8VlYxQWKMujEbHTfggBb2aJf0Xv9pRtTvpbEMPmYdTud9P81UWPF23XuyE2J5ZKxis1UvVNs6u7cXQcz6aWtMK(kvgohNkLIGpTRRgAEwycTtEuYkzLhiMqT6Z899MwasSOFe)bFeJG8)FMSQxsPhpj)Xeu3t4pOWZJJ9vmUpJkWxtkplKhhDgWXfDP0rNvUSF(rONVSWCzxJL7AmbQ)zVjpgyXCPttmHxJ)9jizT37Bap1qfj370K1sw7IpxT4Oo1Gtq0qfVurEYB39HU9sjLitl2bRXfXQb4IMNfXCO8VPAOlWWEBVADy2Aar5a)2copaLZwp))p"

	-- Profile import
	-- Arg 1: AddOn name, Arg 2: Profile string, Arg 3: Profile name
	BigWigsAPI:ImportProfileString(MER.Title, ProfileString, ProfileName)

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
