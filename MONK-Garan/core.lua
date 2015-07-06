local addon, ns = ...
local L = ns[1]
local G = ns[2]

if select(2, UnitClass("player")) ~= "MONK" then return end

local Iconsize = 36 -- 图标大小
local font = GameFontHighlight:GetFont()
local texture = "Interface\\Buttons\\WHITE8x8"
local power_max = 0
local alpha = 0.6

local classicon_colors = { --monk/paladin/preist
	{150/255, 0/255, 40/255},
	{220/255, 20/255, 40/255},
	{255/255, 50/255, 90/255},
	{255/255, 80/255, 120/255},
	{255/255, 110/255, 160/255},
}

local Garan = CreateFrame("Frame", "Garan", UIParent)
Garan:SetPoint("CENTER", UIParent, "CENTER", -50, -120)
Garan:SetSize(200,35)

Garan:RegisterForDrag("LeftButton")
Garan:SetScript("OnDragStart", function(self) self:StartMoving() end)
Garan:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
Garan:SetClampedToScreen(true)
Garan:SetMovable(true)
Garan:SetUserPlaced(true)
Garan:EnableMouse(true)

local bk = "Interface\\ICONS\\ability_monk_roundhousekick" -- 幻灭踢
local eh = "Interface\\ICONS\\ability_monk_expelharm" -- 移花接木
local ks = "Interface\\ICONS\\achievement_brewery_2"
local jab = "Interface\\ICONS\\ability_monk_staffstrike"
local dn = "Interface\\ICONS\\monk_stance_drunkenox"
local cw = "Interface\\ICONS\\ability_monk_chiwave"
local ck = "Interface\\ICONS\\ability_monk_cranekick_new"
local zs = "Interface\\ICONS\\ability_monk_forcesphere" -- 醉酿投
local elu = "Interface\\ICONS\\ability_monk_elusiveale" -- 飘渺酒
local jzz = "Interface\\ICONS\\ability_monk_guard" -- 金钟罩
local cwmx = "Interface\\ICONS\\ability_monk_zenmeditation" -- 冥想
local cf = "Interface\\ICONS\\ability_monk_provoke" -- 嘲讽
local zdj = "Interface\\ICONS\\ability_monk_fortifyingale_new" -- 壮胆酒
local smg = "Interface\\ICONS\\spell_monk_diffusemagic" -- 散魔功
local qbh = "Interface\\ICONS\\ability_monk_dampenharm" -- 躯不坏
local qhs = "Interface\\ICONS\\ability_monk_spearhand" -- 切喉手
local sst = "Interface\\ICONS\\ability_monk_legsweep" -- 扫堂腿
local mnc = "Interface\\ICONS\\ability_monk_chargingoxwave" -- 蛮牛冲
local pxzh = "Interface\\ICONS\\spell_monk_ringofpeace" -- 平心之环
local htzy = "Interface\\ICONS\\spell_Shaman_SpectralTransformation" -- 魂体双分:转移
local gdf = "Interface\\ICONS\\ability_monk_roll" -- 滚地翻
local zqt = "Interface\\ICONS\\ability_monk_quitornado" -- 真气突
local xu = "Interface\\ICONS\\ability_monk_summontigerstatue" -- 雪怒
local tod = "Interface\\ICONS\\ability_monk_touchofdeath" -- 生死簿 


local name_elu = GetSpellInfo(115308) -- 飘渺酒
local name_strg = GetSpellInfo(138233) -- 醉八仙
local name_sck = GetSpellInfo(101546) -- 神鹤引项踢
local name_lst = GetSpellInfo(124275) -- 轻度醉拳
local name_mst = GetSpellInfo(124274) -- 中度醉拳
local name_hst = GetSpellInfo(124273) -- 重度醉拳
local name_shu = GetSpellInfo(115307) -- 酒醒入定
local name_ps = GetSpellInfo(129914) -- 力贯千均
local name_tod = GetSpellInfo(121125) -- 生死簿
local name_zs = GetSpellInfo(124081) -- 禅意珠
local name_he = GetSpellInfo(134563) -- 活血酒
local name_jab = GetSpellInfo(100780) -- 贯日击
local name_zy = GetSpellInfo(119996) -- 魂体双分 转移

---------------------------------------------------------------------------
--[[                       Background and Border                       ]]--
---------------------------------------------------------------------------

local function CreateBorder(parent, r, g, b, a, size, br, bg, bb)
	local sd = CreateFrame("Frame", nil, parent)
	sd:SetFrameLevel(parent:GetFrameLevel()-1)
	sd:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\AddOns\\MONK-Garan\\media\\glow",
		edgeSize = size,
		 insets = {
		left = size,
		right = size,
		top = size,
		bottom = size,
		}
	})
	sd:SetPoint("TOPLEFT", parent, -size, size)
	sd:SetPoint("BOTTOMRIGHT", parent, size, -size)
	sd:SetBackdropColor(r, g, b, a)
	sd:SetBackdropBorderColor(br, bg, bb)
end

---------------------------------------------------------------------------
--[[                                APIs                               ]]--
---------------------------------------------------------------------------

local function GetShields()
	local total = UnitGetTotalAbsorbs("player")
	if total > 5e4 then
		if G.Locale == "zhCN" then
			Shield = (L["吸收"]..":%.1f万"):format(total/10000)
		else
			Shield = (L["吸收"]..":%.1fk"):format(total/1000)
		end
    else
		Shield = ""
	end
	return Shield
end

local function GetStagger()
	local Stagger, Purifier, HealingElixirs
	
	if UnitBuff("player", name_he) then
		HealingElixirs = "|cFF97FFFF!|r"
	else
		HealingElixirs = ""
	end

	if UnitDebuff("player", name_lst) then
		Stagger = HealingElixirs.."|cFF7CFC00"..(L["醉拳"]..":%.1f"..L["千"]):format(select(15, UnitDebuff("player", name_lst))/ 1e3).."|r"
	elseif UnitDebuff("player", name_mst) then
		if select(15, UnitDebuff("player", name_mst))*10/UnitHealth("player") >= 0.4 or UnitHealth("player")/UnitHealthMax("player")<0.7 then
			Stagger = HealingElixirs.."|cFFFF2400"..(L["醉拳"]..":%.1f"..L["千"]):format(select(15, UnitDebuff("player", name_mst))/ 1e3).."|r"
		else
			Stagger = HealingElixirs.."|cFFEEEE00"..(L["醉拳"]..":%.1f"..L["千"]):format(select(15, UnitDebuff("player", name_mst))/ 1e3).."|r"
		end
	elseif UnitDebuff("player", name_hst) then
		Stagger = HealingElixirs.."|cFFFF0000"..(L["醉拳"]..":%.1f"..L["千"]):format(select(15, UnitDebuff("player", name_hst))/ 1e3).."|r"
	else
		Stagger = HealingElixirs
	end
 
	return Stagger
end

local function GetAuraRemain(aura_name)
	local aura = aura or 0
	local expires = select(7, UnitBuff("player", aura_name))
    if expires then
        aura = expires - GetTime()
    end
	return aura
end

local function GetSpellCD(spell_id)
	local cd, cd_text
	local startTime, duration = GetSpellCooldown(spell_id)
    startTime = startTime or 0
    duration = duration or 0
	cd = cd or 0
	cd_text = cd_text or " "
	
    if duration > 1.51 and (startTime+duration-GetTime()) > 0 then
		cd = startTime+duration-GetTime()
		cd_text = format("%.1f",cd)
	end
	
	return cd, cd_text
end

local function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a)
    local i = 0                 -- iterator variable
    local iter = function()    -- iterator function
       i = i + 1
       if a[i] == nil then return nil
       else return a[i], t[a[i]]
       end
    end
    return iter
end

local function UpdateAnchors(table, frame, point, parent, direction, space)
	local index = 1
	for k, v in pairsByKeys(table) do
		if not v then return end
		if direction == "UP" then
			_G[frame..k]:SetPoint(point, parent, point, 0, (index-1)*space)
		elseif direction == "RIGHT" then
			_G[frame..k]:SetPoint(point, parent, point, (index-1)*space, 0)
		end
		index = index + 1
	end
end

local function CreateButton(level, size, tex, r, g, b, ...)
	local button = CreateFrame("Frame", nil, Garan)
	button:SetFrameLevel(level)
	button:SetSize(size, size)
	button:SetPoint(...)
	
	button.texture = button:CreateTexture(nil, "BORDER")
	button.texture:SetAllPoints()
	button.texture:SetTexture(tex)
	button.texture:SetTexCoord(0.1,0.9,0.1,0.9)
	
	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(font, 15, "OUTLINE")
	button.count:SetPoint("BOTTOMRIGHT", -3, -3)
	button.count:SetTextColor(0, 1, 1)

	button.cooldown = CreateFrame("Cooldown", nil, button,"CooldownFrameTemplate")
	button.cooldown:SetAllPoints(button)
	button.cooldown:SetFrameLevel(level)
	
	button.cooldown.text = button.cooldown:CreateFontString(nil, "OVERLAY")
	button.cooldown.text:SetFont(font, 20, "OUTLINE")
	button.cooldown.text:SetPoint("CENTER")
	button.cooldown.text:SetTextColor(r, g, b)
	
	CreateBorder(button, 0, 0, 0, 0, 3, 0, 0, 0)
	return button
end

local function CreatePopupIcon(size, tex, r, g, b, ...)
	local icon = CreateFrame("Frame", nil, Garan)
	icon:SetSize(size, size)
	icon:SetPoint(...)
	icon:SetAlpha(alpha)
	
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:SetAllPoints()
	icon.texture:SetTexture(tex)
	icon.texture:SetTexCoord(0.1,0.9,0.1,0.9)

	icon.count = icon:CreateFontString(nil, "OVERLAY")
	icon.count:SetFont(font, 20, "OUTLINE")
	icon.count:SetPoint("BOTTOMRIGHT")
	icon.count:SetTextColor(0, 1, 1)
	
	icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	icon.cooldown:SetAllPoints(icon)
	
	icon.cooldown.text = icon.cooldown:CreateFontString(nil, "OVERLAY")
	icon.cooldown.text:SetFont(font, 20, "OUTLINE")
	icon.cooldown.text:SetPoint("CENTER")
	icon.cooldown.text:SetTextColor(r, g, b)
	
	CreateBorder(icon, 0, 0, 0, 0, 3, 0, 0, 0)
	return icon
end

local createStatusbar = function(parent, name, tex, layer, height, width, r, g, b, alpha)
    local bar = CreateFrame("StatusBar", name)
    bar:SetParent(parent)
    if height then
        bar:SetHeight(height)
    end
    if width then
        bar:SetWidth(width)
    end
    bar:SetStatusBarTexture(tex, layer)
    bar:SetStatusBarColor(r, g, b, alpha)

    return bar
end

local function ShowSpell(self, spell_id, path)
	local start, duration = GetSpellCooldown(spell_id)
	self.texture:SetTexture(path)
	self.cooldown:SetCooldown(start, duration)
	self:Show()
end

local function ShowAura(self)
	local duration, expires = select(6, UnitBuff("player", name_sck))
	self.texture:SetTexture(ck)
	self.cooldown:SetCooldown(expires-duration, duration)
	self:Show()
end
---------------------------------------------------------------------------
--[[                            Mainbutton                             ]]--
---------------------------------------------------------------------------
Garan.mainbutton = CreateFrame("Frame", "Garan_mainbutton", Garan)
Garan.mainbutton:SetPoint("BOTTOM", Garan, "TOP", 0, 25)
Garan.mainbutton:SetSize(Iconsize+15,Iconsize+15)

Garan.mainbutton.icon = CreateFrame("Frame", nil, Garan.mainbutton)
Garan.mainbutton.icon:SetAllPoints(Garan.mainbutton)
Garan.mainbutton.icon.texture = Garan.mainbutton.icon:CreateTexture(nil, "BORDER")
Garan.mainbutton.icon.texture:SetTexCoord(0.1,0.9,0.1,0.9)
Garan.mainbutton.icon.texture:SetAllPoints()
CreateBorder(Garan.mainbutton.icon, 0, 0, 0, 1, 3, 0, 0, 0)

Garan.mainbutton.icon.cooldown = CreateFrame("Cooldown", nil, Garan.mainbutton.icon,"CooldownFrameTemplate")
Garan.mainbutton.icon.cooldown:SetAllPoints(Garan.mainbutton.icon)
--Garan.mainbutton.icon.cooldown.noshowcd = true

-- 护盾
Garan.mainbutton.ab = Garan.mainbutton:CreateFontString(nil, "OVERLAY")
Garan.mainbutton.ab:SetPoint("BOTTOMRIGHT", Garan.mainbutton, "BOTTOMLEFT", -5, 0)
Garan.mainbutton.ab:SetFont(font, 20, "OUTLINE")
Garan.mainbutton.ab:SetJustifyH("RIGHT")
Garan.mainbutton.ab:SetTextColor(1, 1, .2)

-- 醉拳
Garan.mainbutton.st = Garan.mainbutton:CreateFontString(nil, "OVERLAY")
Garan.mainbutton.st:SetPoint("BOTTOMRIGHT", Garan.mainbutton.ab, "TOPRIGHT", 0, 2)
Garan.mainbutton.st:SetFont(font, 20, "OUTLINE")
Garan.mainbutton.st:SetJustifyH("RIGHT")

local function UpdateMainButton(self, event, arg1)
	if arg1 and arg1 ~= "player" then return end
	
	local mainbutton = self.mainbutton
	local power ,eps, chi, chi_rest
	
	power = UnitPower("player")
	chi = UnitPower("player", 12)
	chi_rest = UnitPowerMax("player", 12)-UnitPower("player", 12)
	eps = select(2, GetPowerRegen())
	
	mainbutton.st:SetText(GetStagger())
	mainbutton.ab:SetText(GetShields())

	if UnitThreatSituation("player", "target") and UnitThreatSituation("player", "target") >= 2 then -- tanking
		if  IsUsableSpell(name_elu) and GetSpellCD(115308)==0 and GetSpellCount(name_elu)>=4 and GetSpellCount(name_elu)>=GetAuraRemain(name_strg) then
			mainbutton.icon.texture:SetDesaturated(false)
			ShowSpell(mainbutton.icon, 115308, elu)
			return
		end
		if (GetAuraRemain(name_shu) < 2 and chi >=2) or (chi_rest <= 1 and power>70) then
			mainbutton.icon.texture:SetDesaturated(false)
			ShowSpell(mainbutton.icon, 100784, bk)
			return
		end
	end
	
	if event == "UNIT_POWER_FREQUENT" or event == "SPELL_UPDATE_COOLDOWN" or event == "UNIT_AURA"then
		if (power < 40) then
			mainbutton.icon.texture:SetDesaturated(true)
		else
			mainbutton.icon.texture:SetDesaturated(false)
		end
		
		if UnitAura("player", name_sck) then
			mainbutton.icon.texture:SetDesaturated(false)
			ShowAura(mainbutton.icon)
		elseif (UnitHealth("player")/UnitHealthMax("player") <= 0.35) then
			ShowSpell(mainbutton.icon, 115072, eh)
		elseif IsSpellInRange(name_jab,"target") == 1 and ((GetSpellCD(121253)<1) or (power+GetSpellCD(121253)*eps - 40 < 40)) and (chi_rest >= 2) then
			ShowSpell(mainbutton.icon, 121253, ks)
		elseif select(4, GetTalentInfo(2,1,GetActiveSpecGroup())) and GetSpellCD(115098)==0 then -- 真气波
			mainbutton.icon.texture:SetDesaturated(false)
			ShowSpell(mainbutton.icon, 115098, cw)
		elseif select(4, GetTalentInfo(2,2,GetActiveSpecGroup())) and GetSpellCD(124081)==0 and not UnitAura("player", name_zs) then -- 禅意珠
			mainbutton.icon.texture:SetDesaturated(false)
			ShowSpell(mainbutton.icon, 124081, zs)
		elseif IsSpellInRange(name_jab,"target") == 1 and (UnitHealth("player")/UnitHealthMax("player")) < 0.9 and (chi_rest -(UnitBuff("player", name_ps) and 1 or 0) >= 1) then
			ShowSpell(mainbutton.icon, 100780, jab)
			if power < 40 then
				mainbutton.icon:Hide()
			end
		elseif GetSpellCD(115072)==0 and (chi_rest >= 1) then
			ShowSpell(mainbutton.icon, 115072, eh)
		elseif IsSpellInRange(name_jab,"target") == 1 and (chi_rest >= 1) then
			ShowSpell(mainbutton.icon, 100780, jab)
			if power < 40 then
				mainbutton.icon:Hide()
			end
		else
			mainbutton.icon:Hide()
		end
	end
end

---------------------------------------------------------------------------
--[[                              Buffs                                ]]--
---------------------------------------------------------------------------
local Buffs = {}

Garan.buffframe = CreateFrame("Frame", "Garan_buffs", Garan)
Garan.buffframe:SetPoint("BOTTOMLEFT", Garan.mainbutton, "BOTTOMRIGHT", 10, 0)
Garan.buffframe:SetSize(50,80)

local function CreateBuffIcon(i, spell_id, showcount, r, g, b)
	local icon = CreateFrame("Cooldown", "Garan_buff"..i, Garan.buffframe)
	icon.i = i
	icon.name = GetSpellInfo(spell_id)
	
	icon:SetSize(20, 20)
	icon.texture = icon:CreateTexture(nil, "OVERLAY")
	icon.texture:SetTexCoord(0.1,0.9,0.1,0.9)
	icon.texture:SetAllPoints()
	icon.texture:SetTexture(select(3, GetSpellInfo(spell_id)))
	
	icon.text = icon:CreateFontString(nil, "OVERLAY")
	icon.text:SetFont(font, 18, "OUTLINE")
	icon.text:SetPoint("LEFT", icon, "RIGHT", 3, 0)
	icon.text:SetTextColor(r, g, b)
	
	icon.count = icon:CreateFontString(nil, "OVERLAY")
	icon.count:SetFont(font, 18, "OUTLINE")
	icon.count:SetPoint("CENTER")
	icon.count:SetTextColor(1, 1, 0)
	
	icon:SetScript("OnEvent", function(self,event,arg1)
		if arg1 and arg1 ~= "player" then return end
		local _, _, _, count, _, duration, expires = UnitBuff("player", self.name)
		if UnitBuff("player", self.name) then
			if (showcount and count >= 1) or count == 0 then
				CooldownFrame_SetTimer(self, expires-duration, duration, 1)
			else
				self:Hide()
			end
			if showcount and count >= 1 then
				icon.count:SetText(count)
			end
		else
			self:Hide()
		end
	end)
	
	icon:SetScript("OnShow", function(self)
		Buffs[self.i] = self.name
		UpdateAnchors(Buffs, "Garan_buff", "BOTTOMLEFT", Garan.buffframe, "UP", 25)
	end)
	icon:SetScript("OnHide", function(self)
		Buffs[self.i] = nil
		UpdateAnchors(Buffs, "Garan_buff", "BOTTOMLEFT", Garan.buffframe, "UP", 25)
	end)
	
	icon:RegisterEvent("UNIT_AURA")
end

CreateBuffIcon(2, 115307, false, 0, 1, .5)-- 酒醒入定
CreateBuffIcon(3, 115308, false, 1, 1, 0)-- 飘渺酒
CreateBuffIcon(4, 122783, false, .7, 0, 1)-- 散魔功
CreateBuffIcon(5, 122278, true, 1, 0, 0)-- 躯不坏
CreateBuffIcon(6, 115203, false, 1, 1, 0)-- 壮胆酒
CreateBuffIcon(7, 47788, false, 1, 1, 1)-- 守护之魂
CreateBuffIcon(8, 33206, false, .7, .5, 1)-- 痛苦压制
CreateBuffIcon(9, 6940, false, .8, .2, .2)-- 牺牲之手
CreateBuffIcon(10, 102342, false, .5, .5, .2)-- 铁木树皮

---------------------------------------------------------------------------
--[[                      真气 能量 血条                               ]]--
---------------------------------------------------------------------------
local barwidth = (Iconsize+8)*5-6
local bars = CreateFrame("Frame", "Garan-SimpleChi", Garan)
bars:SetPoint("TOP", Garan, "TOP", 0, 0)
bars:SetSize(barwidth, 6)
bars:SetFrameLevel(1)

for i = 1, 5 do
	bars[i] = createStatusbar(bars, "SimpleChi"..i, texture, nil, 6, (barwidth+3)/4-3, 1, 1, 1, 1)
	bars[i]:SetStatusBarColor(unpack(classicon_colors[i]))
	bars[i]:SetFrameLevel(1)
	
    if i == 1 then
        bars[i]:SetPoint("TOPLEFT", bars, "TOPLEFT")
    else
        bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 3, 0)
    end

    bars[i].bd = CreateBorder(bars[i], .15, .15, .15, 0, 3, 0, 0, 0)
end

local powerbar = createStatusbar(bars, "Garan powerbar", texture, nil, 6, barwidth, 1, 1, 0, 1)
powerbar:SetPoint("TOPLEFT", bars, "BOTTOMLEFT", 0, -4)
powerbar.bd = CreateBorder(powerbar, .15, .15, .15, .8, 3, 0, 0, 0)
powerbar:SetMinMaxValues(0, 1)

local function UpdatePower()
	local power = UnitPower("player", 12)
	for i = 1, 5 do
		if i <= power then
			bars[i]:SetAlpha(1)
		else
			bars[i]:SetAlpha(0)
		end
	end
	
	if power_max ~= UnitPowerMax("player", 12) then
		for i = 1, 5 do
			bars[i]:SetWidth((barwidth+3)/UnitPowerMax("player", 12)-3)
		end
	end
	
	powerbar:SetValue(UnitPower("player")/UnitPowerMax("player"))
end

---------------------------------------------------------------------------
--[[                             冷却                                  ]]--
---------------------------------------------------------------------------
local function OnCooldown(self, spell_id, showcharge, showcount)
	
	if showcharge then
		local currentCharges, maxCharges, start, duration = GetSpellCharges(spell_id)
		if currentCharges then
			if currentCharges>0 then
				self.texture:SetDesaturated(false)
			else
				self.texture:SetDesaturated(true)
			end		
			if currentCharges < maxCharges then
				self.cooldown:SetCooldown(start, duration)
			end		
			if currentCharges > 0 then
				self.count:SetText(currentCharges)
				self:SetAlpha(1)
			else
				self.count:SetText("")
				self:SetAlpha(alpha)
			end
		end
	elseif showcount then
		local count = GetSpellCount(spell_id)
		if count then
			if GetSpellCD(spell_id) == 0 and count>0 then
				self.texture:SetDesaturated(false)
			else
				self.texture:SetDesaturated(true)
			end
			local start, duration = GetSpellCooldown(spell_id)
			self.cooldown:SetCooldown(start, duration)			
			if count > 0 then
				self.count:SetText(count)
				self:SetAlpha(1)
			else
				self.count:SetText("")
				self:SetAlpha(alpha)
			end
		end
	else
		if GetSpellCD(spell_id) == 0 then
			self.texture:SetDesaturated(false)
			self:SetAlpha(1)
		else
			self.texture:SetDesaturated(true)
			self:SetAlpha(alpha)
			local start, duration = GetSpellCooldown(spell_id)
			self.cooldown:SetCooldown(start, duration)			
		end
	end
end

local function PopupSpell(self, spell_id)
	if IsSpellKnown(spell_id) and GetSpellCD(spell_id) == 0 then
		self:Show()
	else
		self:Hide()		
	end
end

local function PopupTalentSpell(self, tier, index, spell_id)
	if select(4, GetTalentInfo(tier, index, GetActiveSpecGroup())) and GetSpellCD(spell_id) == 0 then
		self:Show()
	else
		self:Hide()
	end
end


local function PopupAura(self, name, showtime, showstack, flash)
	if UnitBuff("player", name) then
		self:Show()
		if showtime then
			local _,_,_,count,_,duration,expires = UnitBuff("player", name)
			self.cooldown:SetCooldown(expires-duration, duration)
		end
		if showstack then
			self.count:SetText(count)
		end
		if flash and not flash_updater:IsShown() then
			flash_updater.timer = 4
			flash_updater:Show()
			flash_frame:Show()
		end
	else
		self:Hide()
		if showtime then
			self.cooldown.text:SetText("")
			self.cooldown:Hide()
		end
		if showstack then
			self.count:SetText("")
		end
	end
end

Garan.xu_p = CreatePopupIcon(Iconsize+15, xu, 1, 1, 1, "RIGHT", Garan.mainbutton, "LEFT", -20, 0) -- 雪怒
Garan.tod_p = CreatePopupIcon(Iconsize+15, tod, 1, 1, 1, "LEFT", Garan.mainbutton, "RIGHT", 20, 0) -- 生死簿


Garan.jzz = CreateButton(3, Iconsize, jzz, 1, 0, 0, "TOPLEFT", powerbar, "BOTTOMLEFT", 0, -6) -- 金钟罩
Garan.smg = CreateButton( 3, Iconsize, smg, 1, 1, 1, "LEFT", Garan.jzz, "RIGHT", 8, 0) -- 散魔功
Garan.qbh = CreateButton( 3, Iconsize, qbh, 1, 1, 1, "LEFT", Garan.jzz, "RIGHT", 8, 0) -- 躯不坏
Garan.elu = CreateButton( 3, Iconsize, elu, 1, 1, 1, "LEFT", Garan.smg, "RIGHT", 8, 0) -- 飘渺酒
Garan.zdj = CreateButton( 3, Iconsize, zdj, 1, 1, 1, "LEFT", Garan.elu, "RIGHT", 8, 0) -- 壮胆酒
Garan.cwmx = CreateButton( 3, Iconsize, cwmx, 1, 1, 1, "LEFT", Garan.zdj, "RIGHT", 8, 0) -- 冥想


Garan.znt = CreateButton(3, Iconsize, ks, 1, 0, 0, "TOPLEFT", Garan.jzz, "BOTTOMLEFT", 0, -6) -- 醉酿投
Garan.eh = CreateButton( 3, Iconsize, eh, 1, 1, 1, "LEFT", Garan.znt, "RIGHT", 8, 0) -- 移花接木
Garan.cf = CreateButton( 3, Iconsize, cf, 1, 1, 1, "LEFT", Garan.eh, "RIGHT", 8, 0) -- 嘲讽
Garan.qhs = CreateButton( 3, Iconsize, qhs, 1, 1, 1, "LEFT", Garan.cf, "RIGHT", 8, 0) -- 切喉手
Garan.sst = CreateButton( 3, Iconsize, sst, 1, 1, 1, "LEFT", Garan.qhs, "RIGHT", 8, 0) -- 扫堂腿
Garan.mnc = CreateButton( 3, Iconsize, mnc, 1, 1, 1, "LEFT", Garan.qhs, "RIGHT", 8, 0) -- 蛮牛冲
Garan.pxzh = CreateButton( 3, Iconsize, pxzh, 1, 1, 1, "LEFT", Garan.qhs, "RIGHT", 8, 0) -- 平心之环

Garan.gdf = CreateButton( 3, Iconsize, gdf, 1, 1, 1, "LEFT", Garan.cwmx, "RIGHT", 8, 0) -- 滚地翻
Garan.gdf.texture:SetDesaturated(true)

Garan.zqt = CreateButton( 3, Iconsize, zqt, 1, 1, 1, "LEFT", Garan.cwmx, "RIGHT", 8, 0) -- 真气突
Garan.zqt.texture:SetDesaturated(true)

Garan.htzy = CreateButton( 3, Iconsize, htzy, 1, 1, 1, "LEFT", Garan.pxzh, "RIGHT", 8, 0) -- 魂体双分:转移
Garan.htzy.texture:SetDesaturated(true)
Garan.htzy:SetAlpha(alpha)

Garan.UpdateBuff = function()
	PopupAura(Garan.tod_p, name_tod)
end

Garan.Cooldowns = function()
	OnCooldown(Garan.znt, 121253)
	OnCooldown(Garan.jzz, 115295, true)
	OnCooldown(Garan.zdj, 115203)
	OnCooldown(Garan.smg, 122783)	
	OnCooldown(Garan.qbh, 122278)
	OnCooldown(Garan.elu, 115308, false, true)
	OnCooldown(Garan.cwmx, 115176)
	
	OnCooldown(Garan.eh, 115072)
	OnCooldown(Garan.cf, 115546)
	OnCooldown(Garan.qhs, 116705)
	OnCooldown(Garan.mnc, 119392)
	OnCooldown(Garan.pxzh, 116844)
	OnCooldown(Garan.sst, 119381)
	
	PopupTalentSpell(Garan.xu_p, 6, 2, 123904)
	
	if GetSpellCD(109132) == 0 then
		Garan.gdf:Hide()
	else
		Garan.gdf:Show()
		local start, duration = GetSpellCooldown(109132)
		Garan.gdf.cooldown:SetCooldown(start, duration)			
	end
	
	if GetSpellCD(115008) == 0 then
		Garan.zqt:Hide()
	else
		Garan.zqt:Show()
		local start, duration = GetSpellCooldown(115008)
		Garan.zqt.cooldown:SetCooldown(start, duration)			
	end
	
	if GetSpellCD(119996) == 0 then
		Garan.htzy:Hide()
	else
		Garan.htzy:Show()
		local start, duration = GetSpellCooldown(119996)
		Garan.htzy.cooldown:SetCooldown(start, duration)			
	end
end

---------------------------------------------------------------------------
--[[                           Textures                                ]]--
---------------------------------------------------------------------------
Garan.texframe = CreateFrame("Frame", "Garan_textures", Garan)
Garan.texframe:SetPoint("CENTER", Garan.mainbutton, "CENTER")
Garan.texframe:SetSize(120,120)
Garan.texframe:SetFrameStrata("HIGH")

local function CreateTex(path, r, g, b, layer, blend)
	local size = Garan.mainbutton:GetHeight()
	local frame = CreateFrame("Frame", nil, Garan.texframe)
	frame:SetPoint("CENTER")
	frame:SetSize(size*1.4, size*1.4)
	
	frame.tex = frame:CreateTexture(nil, layer)
	frame.tex:SetAllPoints(frame)
	frame.tex:SetTexture(path)
	frame.tex:SetDesaturated(true)
	frame.tex:SetVertexColor(r, g, b, alpha)
	
	if blend then
		frame.tex:SetBlendMode("ADD")
	end

	return frame
end

Garan.texframe.Trans = CreateTex("Interface\\AddOns\\MONK-Garan\\media\\RenaitreFadeBorder", 1, 1, 0, "BORDER") -- 魂体双分:转移
Garan.texframe.Trans.t = 0
Garan.texframe.Trans:SetScript("OnUpdate", function(self, elapsed)
	self.t = self.t + elapsed
	if self.t > 0.2 then
		if IsUsableSpell(119996) and GetSpellCD(119996)==0 then
			self.tex:Show()
		else
			self.tex:Hide()
		end
	self.t = 0
	end
end)
Garan.texframe.Trans:SetScript("OnEvent", function(self,event)
	if event == "PLAYER_REGEN_DISABLED" then
		self:Show()
	end
	if event == "PLAYER_REGEN_ENABLED" then
		self:Hide()
	end
end)
Garan.texframe.Trans:RegisterEvent("PLAYER_REGEN_DISABLED")
Garan.texframe.Trans:RegisterEvent('PLAYER_REGEN_ENABLED')
---------------------------------------------------------------------------
--[[                               Command                             ]]--
---------------------------------------------------------------------------
local function slashCmdFunction(msg)
	msg = string.lower(msg)
	local args = {}
	for word in string.gmatch(msg, "[^%s]+") do
		table.insert(args, word)
	end
	
	if (args[1] == "show") then
		if Garan:IsShown() then
			Garan:Hide()
		else
			Garan:Show()
		end
	elseif (args[1] == "scale") then
		local scale = tonumber(args[2])
		if (scale and scale >= 0.8 and scale <= 2) then
			Garan_DB.scale = scale
			Garan:SetScale(Garan_DB.scale)
		else
			print("|cffF2D118Garan|r:"..L["必须是0.8~2之间的数字"])
		end
	else
		print("|cffF2D118Garan|r: /gr scale x "..L["-调整大小(x是0.8~2之间的数字)"])
		print("|cffF2D118Garan|r: /gr show "..L["-显示/隐藏插件"])
	end
end

SlashCmdList["Garan"] = slashCmdFunction
SLASH_Garan1 = "/gr"
SLASH_Garan2 = "/garan"
---------------------------------------------------------------------------
--[[                                 Init                              ]]--
---------------------------------------------------------------------------
local default_Settings = {
	scale = 1, -- 框体比例
}

local function LoadVariables()
	for a, b in pairs(default_Settings) do
		if Garan_DB[a] == nil then
			Garan_DB[a] = b
		end
	end
end

Garan:SetScript("OnEvent", function(self,event)
	if event == "PLAYER_LOGIN" then	
		self:RegisterEvent("UNIT_SPELL_HASTE")
		self:RegisterEvent("UNIT_POWER_FREQUENT")
		self:RegisterEvent("UNIT_AURA")
		self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		self:RegisterEvent("ACTIONBAR_UPDATE_STATE")
		self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		self:RegisterEvent("SPELL_UPDATE_CHARGES")
		self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		
		if Garan_DB == nil then
			Garan_DB = {}
		end
		LoadVariables()
		
		Garan:SetScale(Garan_DB.scale)
	end
	
	if event == "PLAYER_TALENT_UPDATE" then
		if GetSpecialization() == 1 then
			self:Show()
			enableglow = true
			self:RegisterEvent("PET_BATTLE_OPENING_START")
			self:RegisterEvent("PET_BATTLE_OVER")
		else
			self:Hide()
			enableglow = false
			self:UnregisterEvent("PET_BATTLE_OPENING_START")
			self:UnregisterEvent("PET_BATTLE_OVER")
		end
		
		if select(4, GetTalentInfo(5,3,GetActiveSpecGroup())) then -- 散魔功
			Garan.smg:Show()
		else
			Garan.smg:Hide()
		end
		
		if select(4, GetTalentInfo(5,2,GetActiveSpecGroup())) then -- 躯不坏
			Garan.qbh:Show()
		else
			Garan.qbh:Hide()
		end
		
		if select(4, GetTalentInfo(4,2,GetActiveSpecGroup())) then -- 蛮牛冲
			Garan.mnc:Show()
		else
			Garan.mnc:Hide()
		end
		
		if select(4, GetTalentInfo(4,3,GetActiveSpecGroup())) then -- 扫堂腿
			Garan.sst:Show()
		else
			Garan.sst:Hide()
		end
		
		if select(4, GetTalentInfo(4,1,GetActiveSpecGroup())) then -- 平心之环
			Garan.pxzh:Show()
		else
			Garan.pxzh:Hide()
		end
		
		if select(4, GetTalentInfo(6,3,GetActiveSpecGroup())) then -- 真气突
			Garan.zqt:SetAlpha(alpha)
			Garan.gdf:SetAlpha(0)
		else
			Garan.zqt:SetAlpha(0)
			Garan.gdf:SetAlpha(alpha)
		end
		
		UpdateMainButton(self, event, arg1)
		self.Cooldowns()
	end
	
	if event == "ACTIONBAR_UPDATE_STATE" or event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_CHARGES" then
		self.Cooldowns()
	end
	
	if (event == "UNIT_SPELL_HASTE" or event == "UNIT_POWER_FREQUENT" or event == "UNIT_AURA" or event == "UNIT_ABSORB_AMOUNT_CHANGED" or
		event == "ACTIONBAR_UPDATE_STATE" or event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_CHARGES" or event == "SPELL_UPDATE_COOLDOWN") then
		UpdateMainButton(self, event, arg1)
	end
	
	if event == "UNIT_AURA" then
		self.UpdateBuff()
	end
	
	if event == "UNIT_POWER_FREQUENT" then
		UpdatePower()
	end
	
	if event == "PET_BATTLE_OPENING_START" then
		self:Hide()
	end
	
	if event == "PET_BATTLE_OVER" then
		self:Show()
	end
end)

Garan:RegisterEvent("PLAYER_TALENT_UPDATE")
Garan:RegisterEvent("PLAYER_LOGIN")