
----------------------
--      Locals      --
----------------------

local L = setmetatable({}, {__index=function(t,i) return i end})
local dbpc
CrossdresserDBPC = {}


------------------------------
--      Util Functions      --
------------------------------

local function Print(...) print("|cFF33FF99Crossdresser|r:", ...) end

local debugf = tekDebug and tekDebug:GetFrame("Crossdresser")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end


-----------------------------
--      Event Handler      --
-----------------------------

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")


function f:ADDON_LOADED(event, addon)
	if addon:lower() ~= "crossdresser" then return end

	dbpc = CrossdresserDBPC

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end


local lastgroup
function f:PLAYER_LOGIN()
	lastgroup = GetActiveTalentGroup()
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


function f:ACTIVE_TALENT_GROUP_CHANGED()
	if lastgroup == GetActiveTalentGroup() then return end

	lastgroup = GetActiveTalentGroup()
	local name = dbpc[lastgroup]
	Debug("Talent switch detected", lastgroup)
	if not name then return end

	local found
	for i=1,GetNumEquipmentSets() do if GetEquipmentSetInfo(i) == name then found = true end end
	if not found then return Print("Cannot find set:", name) end

	Debug("Equipping set", name)
	EquipmentManager_EquipSet(name)
end

