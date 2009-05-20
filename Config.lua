
local NUMROWS, NUMCOLS, GAP, EDGEGAP = 2, 5, 8, 16
local ICONSIZE = 32

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Crossdresser"
frame:Hide()
frame:SetScript("OnShow", function(frame)
	local ICONSIZE = (frame:GetWidth() - EDGEGAP*4 - GAP*9) / 10
	local Update

	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "Crossdresser", "This panel allows you to select which equipment sets Crossdresser will use.")


	local function OnClick(self)
		CrossdresserDBPC[self.g] = self:GetChecked() and self.name
		Update()
	end
	local function ShowTooltip(self)
		if not self.name then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("|cffffffff"..self.name)
		GameTooltip:Show()
	end
	local function HideTooltip() GameTooltip:Hide() end


	local groups = {}
	for g=1,2 do
		local group = LibStub("tekKonfig-Group").new(frame, g == 1 and "Primary Talent Set" or "Secondary Talent Set")
		group:SetHeight(EDGEGAP*2 + ICONSIZE)
		group:SetPoint("LEFT", EDGEGAP, 0)
		group:SetPoint("RIGHT", -EDGEGAP, 0)

		group.buttons = {}
		for i=1,10 do
			local iconbutton = CreateFrame("CheckButton", nil, group)
			if i == 1 then iconbutton:SetPoint("TOPLEFT", EDGEGAP, -EDGEGAP)
			else iconbutton:SetPoint("LEFT", group.buttons[i-1], "RIGHT", GAP, 0) end
			iconbutton:SetWidth(ICONSIZE)
			iconbutton:SetHeight(ICONSIZE)

			iconbutton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
			iconbutton:SetCheckedTexture("Interface\\Buttons\\UI-Button-Outline")
			local tex = iconbutton:GetCheckedTexture()
			tex:ClearAllPoints()
			tex:SetPoint("CENTER")
			tex:SetWidth(ICONSIZE/37*66) tex:SetHeight(ICONSIZE/37*66)

			iconbutton:SetScript("OnEnter", ShowTooltip)
			iconbutton:SetScript("OnLeave", HideTooltip)
			iconbutton:SetScript("OnClick", OnClick)

			iconbutton.g, iconbutton.i = g, i
			group.buttons[i] = iconbutton
		end

		groups[g] = group
	end

	groups[1]:SetPoint("TOP", subtitle, "BOTTOM", -2, -GAP-EDGEGAP)
	groups[2]:SetPoint("TOP", groups[1], "BOTTOM", 0, -EDGEGAP)


	function Update()
		for i,group in pairs(groups) do
			for _,butt in pairs(group.buttons) do
				local name, tex = GetEquipmentSetInfo(butt.i)
				if name then
					butt.name = name
					butt:SetNormalTexture(tex)
					butt:SetChecked(CrossdresserDBPC[i] == name)
					butt:Show()
				else
					butt:Hide()
				end
			end
		end
	end

	Update()
	frame:SetScript("OnShow", Update)
end)


InterfaceOptions_AddCategory(frame)

LibStub("tekKonfig-AboutPanel").new("Crossdresser", "Crossdresser")
