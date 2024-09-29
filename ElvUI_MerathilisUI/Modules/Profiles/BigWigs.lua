local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:LoadBigWigsProfile()
	if not E:IsAddOnEnabled("BigWigs") then
		F.DebugPrint(L["BigWigs is not installed or enabled."], "error")
		return
	end

	local ProfileName = "MerathilisUI"
	local ProfileString =
		"BW1:Lv1YUTXnu0oyIbAG7dl5Ahh0aeLIK6MfjXsopqmqrrgB5y7A9asJZRnDOgrndrOgYsszzveGwOnTl6kH(f4pbTOFaAx3nql6QUYFc(lO8YrZi74zbLi5L375EoxEP1FZxQlwkrb46mjrryrYVDcUlpmD6bT2UCv3YnITT(RV4SiMOlIMTxj3A1JxW6)wy6mNSnJYeYJBX7j4u8w1T34HpZYm60I2lzHsWWJTBeiW4OKvSnJo(dqPly3AaMsz93Y2SxXwmbkkaVLz2tmlvsGBNm34XsNpddnXkfjkq(hljy9uusewu7i3d3VA5HDyrQMKFbF)PqkEeNJf(ijoCyhuBSI0fx3U4dlDgSzfweZpuW6Idn8XU6Jwf1fZ)Qhu4LmviQBvKqW6)ahkY)9gpdBp5bfkFcxOrsF0ah)qKkCCBIKtrda)VWyWx1sG1e392F7FCg2ghOD2r8(irBz4WEsmXxRfEN6trsPpqREz4asHInqusquS9PDNJuEUiaIuKAol8OPk8jk4ygX5aB9hFfW7VuZV1fm)MkKq9Iisxp(QM11izhIa7dASzZgn2)L75ogCuToDKy1BSohS8fsU2QgiTHH8Ls9PRorpe3rzXxgwABgJ2M1pQAVUTWcPoiGFUAqIxymyEsaERLzstoYxNflCgmrtS6darWJN7IEUzFch7zqKdt0glsYulll7tHf3dtccv30yaqeZ4)4LUqg92fpdMCrzpL3aDnEvde2blrQEcn)oFBqnUNHKZkO8MAyNEkwtFefpdUaY3vG)5E4i)b79d)Bh4tRzxHoCoS8UU88xoNDhWXn4KtW0ZMNOqSTtS0OMW2hQtn5NF6CJ84RDr5gu6DGCqhPzNfsJkxSm6kLbXRNiMZJcokqfE9evpvik3oywUF56TjPlb4n30uhLyq9RTXdF(tMpUzjB(ntnb4WTrsvDDbcXNIL5MvJMId3qI)71jS0ormVK0oR8XAeCKxtARcVZq4VVJX6ALbkJ(U2fk(EZIJsYQS7lxQqE)OJ11XAAALpgLg12EulusfO8vt1)1r3FqF5Uxu7dYAEnFytWexaRHiTZnfTIzlzI9WuVziQnkcJpDtdDTPnC4Y6UciPMyBNqLpZy3ZHXN8uBbGvTawY51f5591Wqb5qw3(vhYt7MhBhB)NFYVpw7ZSUh3k(lJxAeoneENFmrsArXoiXHKUevUrM2qWv(4VFe(eEYDThzi30GeV(5zEaQQ6X9CGUHEd1hWilp(Z4lLzsdSe6h45a(WtaczpbECz6XhTFHQ6xGkcCst1akMFVp43z2xfSUMoKqjYpisw9zT3aD0(FquqitkeU9KKhWsa5DgNmZGG7MVvqk00b0l(gXRnl30tJx3PdHs9MMbsiJxHV8hrhGwC94Vjmo3xpj9XgyTBZxo7Kv6rveoLGfWRnfN7YkSJ1eCMeLucT6OoPxLEAEHD(aR8Tm1nt0CW83ShRzY0zV7uNAUU1QaDre6xOHFx8UF6eGa39NCrIaSk(AVl(xJ)nRDwKNBhScrOshDJRDf67cf55YarAHqhDDWTIZ9ptZ2biGfHu9gXR24ygXx)0io6OMBvyhChKohl8Dv03gU)))"

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
