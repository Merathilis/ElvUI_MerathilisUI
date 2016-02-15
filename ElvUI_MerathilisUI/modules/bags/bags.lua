local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule('Bags');

-- Control the position of the Bag-/Bankframe
function B:PositionBagFrames()
	if E.private.bags.enable ~= true or E.db.muiGeneral.Bags ~= true then return; end
	
	if self.BagFrame then
		self.BagFrame:ClearAllPoints()
		if E.db.datatexts.rightChatPanel then
			self.BagFrame:SetPoint('BOTTOMRIGHT', -30, 30);
		else
			self.BagFrame:SetPoint('BOTTOMRIGHT', -2, 24);
		end
	end
	
	if self.BankFrame then
		self.BankFrame:ClearAllPoints()
		if E.db.datatexts.leftChatPanel then
			self.BankFrame:SetPoint('TOPLEFT', 30, 30);
		else
			self.BankFrame:SetPoint('BOTTOMLEFT', 2, 24);
		end
	end
end
