local MER, E, L, V, P, G = unpack(select(2, ...))
local AB = E:GetModule("ActionBars")
local LAB = LibStub("LibActionButton-1.0-ElvUI")
local LSM = LibStub("LibSharedMedia-3.0");
local Masque = LibStub("Masque", true)
local MasqueGroup = Masque and Masque:Group("ElvUI", "ActionBars")

-- Cache global variables
-- Lua functions

-- WoW API / Variables

--GLOBALS: NUM_BAG_SLOTS

function MER:ActivateBar(bar)
	if (bar:IsVisible()) then
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), bar.db.alpha);
	end
end

function MER:DeactivateBar(bar)
	if (GetMouseFocus() == bar or (GetMouseFocus() and (GetMouseFocus():GetParent() == bar)) and bar:IsMouseOver(2, -2, -2, 2)) then
		return;
	end

	E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0);
end

function MER:InjectScripts(tbl)
	tbl["Bar_OnEnter"] = function(self, bar)
		MER:ActivateBar(bar);
	end

	tbl["Bar_OnLeave"] = function(self, bar)
		MER:DeactivateBar(bar);
	end

	tbl["Button_OnEnter"] = function(self, button)
		MER:ActivateBar(button:GetParent());
	end

	tbl["Button_OnLeave"] = function(self, button)
		MER:DeactivateBar(button:GetParent());
	end
end

local mui_ab_id = 770;

function MER:CreateBar(name, db, point, moverName)
	local bar = CreateFrame('Frame', name, E.UIParent, "SecureHandlerStateTemplate");

	bar.db = db;
	bar.id = mui_ab_id;

	if (not AB.db["bar"..mui_ab_id]) then
		AB.db["bar"..mui_ab_id] = { showGrid = false };
	end

	bar:SetFrameLevel(1);
	bar:SetTemplate('Transparent');
	bar:SetFrameStrata('MEDIUM');
	bar.buttons = {};

	RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');

	bar:Size(320, 36);
	if (point) then
		bar:Point(unpack(point));
	else
		bar:Point('BOTTOMLEFT', LeftChatPanel, 'TOPRIGHT', 0, 15);
	end
	E:CreateMover(bar, name..'Mover', moverName or name, nil, nil, nil, 'ALL,ACTIONBARS');

	return bar;
end

function MER:RegisterCreateButtonHook(bar, func)
	if (not bar.createButtonHooks) then
		bar.createButtonHooks = {};
	end
	tinsert(bar.createButtonHooks, func);
end

function MER:RegisterUpdateButtonHook(bar, func)
	if (not bar.updateButtonHooks) then
		bar.updateButtonHooks = {};
	end
	tinsert(bar.updateButtonHooks, func);
end

local function ExecuteHooks(tbl, ...)
	if (not tbl) then return end;

	for i, f in ipairs(tbl) do
		f(...);
	end
end

function MER:CreateButton(bar)
	local button = LAB:CreateButton(#bar.buttons + 1, format(bar:GetName().."Button%d", #bar.buttons + 1), bar, nil);
	button:SetFrameLevel(bar:GetFrameLevel() + 2);
	button:SetTemplate();
	button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate");
	button.cooldown:SetAllPoints(button);
	button.texture = button:CreateTexture(nil, 'ARTWORK');
	button.texture:SetInside();
	button.texture:SetTexCoord(unpack(E.TexCoords));
	button.count = button:CreateFontString(nil, "OVERLAY");
	button.count:FontTemplate(LSM:Fetch("font", E.db.general.font), 10, "THINOUTLINE");
	button.count:SetWidth(E:Scale(bar.db.buttonsize) - 4);
	button.count:SetHeight(E:Scale(14));
	button.count:SetJustifyH("RIGHT");
	button.count:Point("BOTTOMRIGHT", 0, 0);
	AB:StyleButton(button, nil, MasqueGroup and E.private.actionbar.masque.actionbars and true or nil, true);
	button:SetCheckedTexture("")
	RegisterStateDriver(button, 'visibility', '[petbattle] hide; show')

	if MasqueGroup and E.private.actionbar.masque.actionbars then
		button:AddToMasque(MasqueGroup)
	end
	ExecuteHooks(bar.createButtonHooks, button);

	if (not AB.handledbuttons[button]) then
		E:RegisterCooldown(button.cooldown)

		AB.handledbuttons[button] = true;
	end

	return button;
end


function MER:CreateButtons(bar, num)
	for i = 1, num do
		local button = bar.buttons[i];
		if (not button) then
			button = MER:CreateButton(bar);
			bar.buttons[i] = button;
		end

		local size = E:Scale(bar.db.buttonsize);

		button:Size(size);
	end
end

local function GenericButtonUpdate(bar, button, ...)
	local size = E:Scale(bar.db.buttonsize);
	button:Size(size);

	ExecuteHooks(bar.updateButtonHooks, button, ...);
end

local waitingItemUpdates = {};
local waitingItemUpdateCount = 0;

local ItemInfoFrame = CreateFrame("Frame");
ItemInfoFrame:SetScript("OnEvent", function(self, event, itemID)
	if (waitingItemUpdates[itemID]) then
		waitingItemUpdateCount = waitingItemUpdateCount - 1;
		if (waitingItemUpdateCount == 0) then
			self:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
		end
		MER:UpdateButtonAsItem(unpack(waitingItemUpdates[itemID]));
	end
end);

function MER:UpdateButtonAsItem(bar, button, id, ...)
	button.data = id;
	local itemName, _, quality, _, _, _, _, _, _, texture = GetItemInfo(id);
	if (not texture) then
		waitingItemUpdates[id] = { bar, button, id, ... };
		waitingItemUpdateCount = waitingItemUpdateCount + 1;
		ItemInfoFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED");
	end
	local count = GetItemCount(id);
	button:SetAttribute('item', itemName);
	button.count:SetText(count);
	button.count:SetShown(count > 1);
	button.texture:SetTexture(texture);
	button.texture:SetDesaturated(count == 0);
	button:SetState(0, 'item', id);

	GenericButtonUpdate(bar, button, ...);
end

function MER:UpdateButtonAsSpell(bar, button, id, ...)
	button.data = id;
	local name = GetSpellInfo(id);
	button:SetAttribute('type', 'spell');
	button:SetAttribute("spell", name);
	button:SetState(0, 'spell', id);
	button.texture:SetTexture(select(3, GetSpellInfo(id)));
	button.count:Hide();
	button:SetBackdropBorderColor(0, 0, 0, 1)

	GenericButtonUpdate(bar, button, ...);
end

function MER:UpdateButtonAsToy(bar, button, id, ...)
	button.data = id;
	local name = select(2, C_ToyBox.GetToyInfo(id));
	button:SetAttribute('type', 'toy');
	button:SetAttribute('toy', name);
	button:SetState(0, 'toy', id);
	button.texture:SetTexture(select(3, C_ToyBox.GetToyInfo(id)));
	button.count:Hide();
	button:SetBackdropBorderColor(0, 0, 0, 1)

	GenericButtonUpdate(bar, button, ...);
end

function MER:UpdateButtonAsCustom(bar, button, texture, ...)
	local state = {
		func = function(button)
			return
		end,
		texture = texture,
		tooltip = nil, 
	}

	button.texture:SetTexture(texture);
	button.count:Hide();
	button:SetState(0, "custom", state);
	button:SetBackdropBorderColor(0, 0, 0, 1)
	GenericButtonUpdate(bar, button, ...);
end

function MER:UpdateBar(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, 'visibility', 'hide');
		return;
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	bar.mouseover = bar.db.mouseover;

	local spacing, mult = bar.db.spacing or 0, 1;
	local size = bar.db.buttonsize;
	local buttonsPerRow = bar.db.buttonsPerRow or 12;

	local shownButtons, anchorX, anchorY = 0, 0, 0
	for i = 1, #bar.buttons do
		local button = bar.buttons[i];
		if (button.data) then
			RegisterStateDriver(button, 'visibility', '[petbattle] hide; show')
			anchorX = anchorX + 1;
			shownButtons = shownButtons + 1;
			local xOffset, yOffset;
			if ((shownButtons - 1) % buttonsPerRow) == 0 then
				anchorX = 1;
				anchorY = anchorY + 1;
			end

			xOffset = spacing + ((size + spacing) * (anchorX - 1));
			yOffset = -(spacing + ((size + spacing) * (anchorY - 1)));

			button:ClearAllPoints();
			button:SetPoint('TOPLEFT', bar, 'TOPLEFT', xOffset, yOffset);
			if bar.db.mouseover == true then
				bar:SetAlpha(0);
				if not tbl.hooks[bar] then
					tbl:HookScript(bar, 'OnEnter', 'Bar_OnEnter');
					tbl:HookScript(bar, 'OnLeave', 'Bar_OnLeave');
				end
				
				if not tbl.hooks[button] then
					tbl:HookScript(button, 'OnEnter', 'Button_OnEnter');
					tbl:HookScript(button, 'OnLeave', 'Button_OnLeave');
				end
			else
				bar:SetAlpha(bar.db.alpha);
				if tbl.hooks[bar] then
					tbl:Unhook(bar, 'OnEnter');
					tbl:Unhook(bar, 'OnLeave');
				end
				
				if tbl.hooks[button] then
					tbl:Unhook(button, 'OnEnter');
					tbl:Unhook(button, 'OnLeave');
				end
			end
		else
			RegisterStateDriver(button, 'visibility', 'hide')
		end
	end
	local numRows;
	if (shownButtons <= buttonsPerRow) then
		buttonsPerRow = shownButtons;
		numRows = 1;
	else
		numRows = floor(shownButtons / buttonsPerRow) + (shownButtons % buttonsPerRow == 0 and 0 or 1);
	end

	local barWidth = spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	local barHeight = size * numRows + spacing;
	bar:Size(barWidth, barHeight);
	if (shownButtons == 0) then
		RegisterStateDriver(bar, 'visibility', 'hide');
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	for i = shownButtons + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], 'visibility', 'hide')
	end

	AB:UpdateButtonConfig(bar, bindButtons);
	if MasqueGroup and E.private.actionbar.masque.actionbars then MasqueGroup:ReSkin() end
end

function MER:UpdateBarMultRow(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, 'visibility', 'hide');
		return;
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	bar.mouseover = bar.db.mouseover;

	local spacing, mult = bar.db.spacing, 1;
	local size = bar.db.buttonsize;
	local buttonsPerRow = bar.db.buttonsPerRow;

	local shownButtons, anchorX, anchorY = {}, {}, 0;

	local totalShown = 0;

	local seenButton = false;
	for i = 1, #bar.buttons do
		local button = bar.buttons[i];
		if (button.data) then
			local row = button.row;
			RegisterStateDriver(button, 'visibility', '[petbattle] hide; show')
			if (not anchorX[row]) then
				anchorX[row] = 0;
				shownButtons[row] = 0;
			end
			anchorX[row] = anchorX[row] + 1;
			shownButtons[row] = shownButtons[row] + 1;
			totalShown = totalShown + 1;

			seenButton = true;
			local xOffset, yOffset;
			
			anchorY = 1;
			for i = row - 1, 1, -1 do
				if (shownButtons[i] and shownButtons[i] > 0) then
					anchorY = anchorY + 1;
				end
			end

			xOffset = spacing + ((size + spacing) * (anchorX[row] - 1));
			yOffset = -(spacing + ((size + spacing) * (anchorY - 1)));

			button:ClearAllPoints();
			button:SetPoint('TOPLEFT', bar, 'TOPLEFT', xOffset, yOffset);
			if tbl.db.mouseover == true then
				bar:SetAlpha(0);
				if not tbl.hooks[bar] then
					tbl:HookScript(bar, 'OnEnter', 'Bar_OnEnter');
					tbl:HookScript(bar, 'OnLeave', 'Bar_OnLeave');
				end
				
				if not tbl.hooks[button] then
					tbl:HookScript(button, 'OnEnter', 'Button_OnEnter');
					tbl:HookScript(button, 'OnLeave', 'Button_OnLeave');
				end
			else
				bar:SetAlpha(bar.db.alpha);
				if tbl.hooks[bar] then
					tbl:Unhook(bar, 'OnEnter');
					tbl:Unhook(bar, 'OnLeave');
				end
				
				if tbl.hooks[button] then
					tbl:Unhook(button, 'OnEnter');
					tbl:Unhook(button, 'OnLeave');
				end
			end
		else
			RegisterStateDriver(button, 'visibility', 'hide')
		end
	end
	local numRows = 0
	local buttonsPerRow = 0;
	for i = 1, #bar.keys do
		if (shownButtons[i] and shownButtons[i] > 0) then
			buttonsPerRow = max(shownButtons[i], buttonsPerRow);
			numRows = numRows + 1;
		end
	end

	local barWidth = spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	local barHeight = max((spacing * ((numRows * 2) - 1)), spacing) + (size * numRows)
	bar:Size(barWidth, barHeight);
	if (not seenButton) then
		RegisterStateDriver(bar, 'visibility', 'hide');
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	for i = totalShown + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], 'visibility', 'hide')
	end

	AB:UpdateButtonConfig(bar, bindButtons);
	if MasqueGroup and E.private.actionbar.masque.actionbars then MasqueGroup:ReSkin() end
end

function MER:UpdateVertBar(tbl, bar, bindButtons)
	if (not bar.db.enabled) then
		RegisterStateDriver(bar, 'visibility', 'hide');
		return;
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	bar.mouseover = bar.db.mouseover;

	local spacing, mult = bar.db.spacing or 0, 1;
	local size = bar.db.buttonsize;
	local buttonsPerRow = bar.db.buttonsPerRow or 12;

	local shownButtons, anchorX, anchorY = 0, 0, 0
	for i = 1, #bar.buttons do
		local button = bar.buttons[i];
		if (button.data) then
			RegisterStateDriver(button, 'visibility', '[petbattle] hide; show')
			anchorY = anchorY + 1;
			shownButtons = shownButtons + 1;
			local xOffset, yOffset;
			if ((shownButtons - 1) % buttonsPerRow) == 0 then
				anchorY = 1;
				anchorX = anchorX + 1;
			end

			xOffset = spacing + ((size + spacing) * (anchorX - 1));
			yOffset = spacing + ((size + spacing) * (anchorY - 1));

			button:ClearAllPoints();
			button:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', xOffset, yOffset);
			if bar.db.mouseover == true then
				bar:SetAlpha(0);
				if not tbl.hooks[bar] then
					tbl:HookScript(bar, 'OnEnter', 'Bar_OnEnter');
					tbl:HookScript(bar, 'OnLeave', 'Bar_OnLeave');
				end
				
				if not tbl.hooks[button] then
					tbl:HookScript(button, 'OnEnter', 'Button_OnEnter');
					tbl:HookScript(button, 'OnLeave', 'Button_OnLeave');
				end
			else
				bar:SetAlpha(bar.db.alpha);
				if tbl.hooks[bar] then
					tbl:Unhook(bar, 'OnEnter');
					tbl:Unhook(bar, 'OnLeave');
				end
				
				if tbl.hooks[button] then
					tbl:Unhook(button, 'OnEnter');
					tbl:Unhook(button, 'OnLeave');
				end
			end
		else
			RegisterStateDriver(button, 'visibility', 'hide')
		end
	end
	local numRows;
	if (shownButtons <= buttonsPerRow) then
		buttonsPerRow = shownButtons;
		numRows = 1;
	else
		numRows = floor(shownButtons / buttonsPerRow) + (shownButtons % buttonsPerRow == 0 and 0 or 1);
	end

	local barWidth = max((spacing * ((numRows * 2) - 1)), spacing) + (size * numRows)
	local barHeight = spacing + ((size * (buttonsPerRow * mult)) + ((spacing * (buttonsPerRow - 1) * mult) + (spacing * mult)))
	bar:Size(barWidth, barHeight);
	if (shownButtons == 0) then
		RegisterStateDriver(bar, 'visibility', 'hide');
	else
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show');
	end

	for i = shownButtons + 1, #bar.buttons do
		RegisterStateDriver(bar.buttons[i], 'visibility', 'hide')
	end

	AB:UpdateButtonConfig(bar, bindButtons);
	if MasqueGroup and E.private.actionbar.masque.actionbars then MasqueGroup:ReSkin() end
end