local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local B = E:GetModule('Bags');

if E.db.muiGeneral == nil then E.db.muiGeneral = {} end
if E.db.muiGeneral.Bags == false then return end

-- Control the position of the Bag-/Bankframe
function B:PositionBagFrames()
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
