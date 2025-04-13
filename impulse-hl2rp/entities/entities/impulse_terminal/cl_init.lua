include('shared.lua')

net.Receive("ImpulseTerminalScreenOpen", function()
    local arrester = net.ReadEntity()

    local t = vgui.Create("ImpulseTerminalScreen")

    if arrester and arrester:IsPlayer() then
        t:OpenChargeScreen(arrester)
    end
end)

sound.Add({
    name = "Terminal.Hl2rp.ambience",
    channel = CHAN_STATIC,
    level = 60,
    volume = 100,
    sound = "ambient/machines/combine_terminal_loop1.wav"
})

function ENT:Think()
    local posdist = self:GetPos()
    if LocalPlayer():GetPos():Distance(posdist) <= 900 then
        if not self.TerminalEmitSound then
            self:EmitSound("Terminal.Hl2rp.ambience")
            self.TerminalEmitSound = true
        end
    elseif self.TerminalEmitSound then
        self:StopSound("Terminal.Hl2rp.ambience")
        self.TerminalEmitSound = false
    end
end

local TerminalCol = Color(18, 122, 192)
local JwCol = Color(220, 0, 0)

local Screen_Color = TerminalCol
local text = "nil"

local useSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle4.wav"
}

function ENT:Draw()
    self:DrawModel()
    local text = "TERMINAL: " .. self:EntIndex()

    local entPos = self:GetPos()
	local entAng = self:GetAngles()
	local pos = self:GetPos()
	local ang = self:GetAngles()

    local dummy = self:GetNetworkedUser()

    if (impulse.Dispatch.GetCityCode() >= CODE_JW) then
        terminalCol = JwCol
    end

    if (dummy:IsValid() and dummy:IsPlayer()) then
        text = text .. "\nUSER: " .. dummy:Name()
    else
        text = text .. "\nNO ACTIVE USER"
    end

    text = text.."\nTIME: "..os.date("%H:%M:%S - %d/%m", os.time()).."\n\nHUMAN INDEX: CONNECTED\nCONVICT INDEX: CONNECTED\nOVERWATCH INDEX: CONNECTED"

    pos = pos + (ang:Up() * 47.9)
    pos = pos + (ang:Right() * 9.8)
    pos = pos + (ang:Forward() * -2.21)

    ang:RotateAroundAxis(entAng:Up(), 90)
	ang:RotateAroundAxis(entAng:Right(), -42)

	cam.Start3D2D(pos, ang, 0.07)
		surface.SetDrawColor(Screen_Color)
		surface.DrawRect(0, 0, 221, 115)
		draw.DrawText(text, "DebugFixed", 8, 4, color_white, TEXT_ALIGN_LEFT)
	cam.End3D2D()
end

function ENT:OnRemove()
    self:StopSound("Terminal.Hl2rp.ambience")
end

local PANEL = {}

local remindertext2 = [[
---------------------------------
Reminder: Check BOL list regularly.
--------------------------------- 
]]

local remindertext = [[
---------------------------------
Reminder: Memory replacement is the first step towards rank 
priviledges.
--------------------------------- 
]]

function PANEL:BulletIn_Screen()

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    local citycode = impulse.Dispatch.GetCityCode()
    local cityinfo = impulse.Dispatch.CityCodes[citycode]

    local city = vgui.Create("DLabel", self.Window)
    city:SetFont("BudgetLabel")
    city:SetText("CITY CODE: " .. citycode .. " (" .. cityinfo[1] .. ")")
    city:SetTextColor(cityinfo[2])
    city:SizeToContents()
    city:Dock(TOP)

    local count = #team.GetPlayers(TEAM_CITIZEN) + #team.GetPlayers(TEAM_CWU) + #team.GetPlayers(TEAM_VORT)

    local population = vgui.Create("DLabel", self.Window)
    population:SetFont("BudgetLabel")
    population:SetText("CITIZEN POPULATION COUNT: " .. count)
    population:SizeToContents()
    population:Dock(TOP)
    population:DockMargin(0, 5, 0, 0)

    local playah = vgui.Create("DLabel", self.Window)
    playah:SetFont("BudgetLabel")
    playah:SetText("LOCAL UNIT: " .. LocalPlayer():Name() .. "\nLOCAL DIVISION: " .. LocalPlayer():GetTeamClassName() .. "\nLOCAL RANK: " .. LocalPlayer():GetTeamRankName())
    playah:SizeToContents()
    playah:Dock(TOP)
    playah:DockMargin(0, 12, 0, 0)

    local reminder = vgui.Create("DLabel", self.Window)
    reminder:SetFont("BudgetLabel")
    reminder:SetText(remindertext)
    reminder:SizeToContents()
    reminder:Dock(TOP)
    reminder:DockMargin(0, 34, 0, 0)

    local reminder2 = vgui.Create("DLabel", self.Window)
    reminder2:SetFont("BudgetLabel")
    reminder2:SetText(remindertext2)
    reminder2:SizeToContents()
    reminder2:Dock(TOP)
end

function PANEL:BOL_Screen()

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.Window2 = vgui.Create("DScrollPanel", self.Window)
    self.Window2:Dock(FILL)

    local p = self.Window2

    self.CitizenSelectBOL = self.Window2:Add("DComboBox", self)
    self.CitizenSelectBOL:Dock(TOP)
    self.CitizenSelectBOL:SetText("Select Citizen...")

    for v,k in pairs(player.GetAll()) do
		local bol = k:IsDispatchBOL()

        if bol or k == LocalPlayer() then continue end

        self.CitizenSelectBOL:AddChoice(k:Name(), k)
    end

    self.ConvSelectBOL = self.Window2:Add("DComboBox", self)
    self.ConvSelectBOL:Dock(TOP)
    self.ConvSelectBOL:SetText("Select Conviction...")

    for v,k in pairs(impulse.Config.ArrestCharges) do
        self.ConvSelectBOL:AddChoice(k.name, v)
    end

    self.ChargeBOL = self.Window2:Add("DButton", self)
    self.ChargeBOL:Dock(TOP)
    self.ChargeBOL:SetText("Select Citizen...")
    self.ChargeBOL:SetText("Add BOL")
    self.ChargeBOL:DockMargin(0, 4, 0, 0)

    local convsel = self.ConvSelectBOL
    local civsel = self.CitizenSelectBOL

    function self.ChargeBOL:Think()
        if convsel:GetValue() == "Select Conviction..." or civsel:GetValue() == "Select Citizen..." then
            self:SetDisabled(true)
        else
            self:SetDisabled(false)
        end
    end

    local w = self

    function self.ChargeBOL:DoClick()
        local name, ply = civsel:GetSelected()
        local charge, crime = convsel:GetSelected()

        if not IsValid(ply) and not ply:IsDispatchBOL() then
            return
        end

        local panel = Derma_Query("Please confirm that you wish to set the BOL status of "..name..".",
            "BOL ADD CONFIRMATION",
            "ADD BOL",
            function()
                net.Start("impulseHL2RPAddBOL")
                net.WriteEntity(ply)
                net.WriteUInt(crime, 8)
                net.SendToServer()

                w:Remove()
            end,"CANCEL")
        panel:SetSkin("combine")
    end

    for v,k in pairs(player.GetAll()) do
		local bol, d = k:IsDispatchBOL()
        local crime = d or 1
		if bol then
			local entry = self.Window2:Add("impulseTerminalPlayer")
			entry.NoButtons = true
			entry.master = self
			entry:SetBOLPlayer(k, crime)
			entry:SetHeight(60)
			entry:DockMargin(0, 6, 0, 0)
			entry:Dock(TOP)

            if not LocalPlayer():IsCPCommand() then
                entry.editBtn:Remove()
            end

		end
	end

end

function PANEL:CameraList()

    local panel = self

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.camExit = vgui.Create("DButton", self.Window)
	self.camExit:SetText("EXIT CAMERA")
	self.camExit:SetFont("BudgetLabel")
	self.camExit:SetPos(0, 0)
	self.camExit:SetSize(450, 20)

	if not WATCHING_CAM then
		self.camExit:SetDisabled(true)
	end

	function self.camExit:DoClick()
		WATCHING_CAM = nil
		impulse.hudEnabled = true
		self:SetDisabled(true)
	end

    self.CameraListt = vgui.Create("DListView", self.Window)
    self.CameraListt:Dock(FILL)
    self.CameraListt:DockMargin(0, 24, 0, 0)
	self.CameraListt:SetMultiSelect(false)
	self.CameraListt:SetSortable(true)
    self.CameraListt:SetSkin("combine")

    local title1 = self.CameraListt:AddColumn("CAM")
	local title2 = self.CameraListt:AddColumn("STATUS")
	title1.Header:SetFont("BudgetLabel")
	title2.Header:SetFont("BudgetLabel")

    for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
		local camid = k:GetSyncVar(SYNC_CAM_CAMID, nil)

        if not camid then continue end

        local line = self.CameraListt:AddLine(camid, k:IsCameraEnabled() and "ONLINE" or "OFFLINE")
		for v,k in pairs(line.Columns) do
			k:SetFont("BudgetLabel")
		end

        line.entity = k
    end

    self.CameraListt:SortByColumn(1)

    function self.CameraListt:OnRowSelected(index, row)
        local w = DermaMenu()

        w:AddOption("View Camera", function()
            if not IsValid(row) then
				return
			end

			if not IsValid(row.entity) then
				return
			end

            if not row.entity:IsCameraEnabled() then
				return LocalPlayer():Notify("Camera is offline.")
			end

			net.Start("impulseHL2RPCameraView")
			net.WriteEntity(row.entity)
			net.SendToServer()

			WATCHING_CAM = row.entity
			WATCHING_CAM_POS = LocalPlayer():GetPos()
			impulse.hudEnabled = false

			panel.camExit:SetDisabled(false)
        end)

        w:Open()
    end
end

function PANEL:HumanIndexList()

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.List = vgui.Create("DListView", self.Window)
    self.List:Dock(FILL)
	self.List:SetMultiSelect(false)
	self.List:SetSortable(true)
    self.List:SetSkin("combine")

    local title1 = self.List:AddColumn("NAME")
	local title2 = self.List:AddColumn("CID")
	title1.Header:SetFont("BudgetLabel")
	title2.Header:SetFont("BudgetLabel")

    for k, v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end

        local line = self.List:AddLine(v:Nick(), v:SteamID64())

        for v,k in pairs(line.Columns) do
            k:SetFont("BudgetLabel")
        end
    end
end

function PANEL:DispatchScreen()

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.citylbl = vgui.Create("DLabel", self.Window)
    self.citylbl:SetText("CHANGE CITY CODE:")
    self.citylbl:SetFont("BudgetLabel")
    self.citylbl:SizeToContents()
    self.citylbl:Dock(TOP)

    local cityCodes = impulse.Dispatch.GetCityCode()
	local cityCodeData = impulse.Dispatch.CityCodes[cityCodes]

    self.citycode = vgui.Create("DComboBox", self.Window)
    self.citycode:Dock(TOP)
    self.citycode:SetValue(cityCodeData[1])
    self.citycode.lastThingy = cityCodeData[1]
    self.citycode:SetTextColor(cityCodeData[2])
    self.citycode:DockMargin(0,0,0,0)

    local panel = self

    function self.citycode:OnSelect(index, text, value) -- OnSelect from the original file, cant be bothered
        local ply = LocalPlayer()

        if self.skip then
            self.skip = false
            return
        end

        if ply:Team() != TEAM_CA then
            if not ply:IsCPCommand() then -- frick glua
                return ply:Notify("You must be a higher rank to perform this action.")
            end
        end

        if index < 4 or ((ply:Team() == TEAM_CP and ply:GetTeamRank() == RANK_CMD) or ply:IsAdmin()) then
            local name = impulse.Dispatch.CityCodes[index][1]

            local confirm = Derma_Query("Change City Code to: "..name.."?", "CONFIRMATION REQUIRED", "CONFIRM", function()
                if IsValid(self) and IsValid(panel) then
                    self.lastThingy = index

                    net.Start("impulseHL2RPDispatchCityCode")
                    net.WriteUInt(index, 4)
                    net.SendToServer()

                    self.skip = true
                    self:ChooseOptionID(self.lastThingy or 1)

                    panel:Remove()
                end
            end, "ABORT", function()
                if IsValid(self) and IsValid(panel) then
                    panel:Remove()
                    return ply:Notify("Aborted.")
                end
            end)

            confirm:SetSkin("combine")
        else
            panel:Remove()
            return ply:Notify("You must be a higher rank to perform this action.")
        end
    end

    for v,k in SortedPairs(impulse.Dispatch.CityCodes) do
        local name = k[1]
        if cityCodeData[1] == name then
            name = name .. " (CURRENT CODE)"
        end

        self.citycode:AddChoice(name, v)
    end

    local c = self.citycode

    function self.citycode:Paint(w, h)
        local alpha = 90

		if (c:GetDisabled()) then
			alpha = 10
		elseif (c.Depressed) then
			alpha = 180
		elseif (c.Hovered) then
			alpha = 75
		end

		surface.SetDrawColor(39, 60, 117, alpha)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(180, 180, 180, 2)
		surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        draw.SimpleText(self:GetText(), "DebugFixed", 5, 3, self:GetTextColor())

        return true
    end

    self.adrlbl = vgui.Create("DLabel", self.Window)
    self.adrlbl:SetText("CIVIL ADDRESS SYSTEM:")
    self.adrlbl:SetFont("BudgetLabel")
    self.adrlbl:SizeToContents()
    self.adrlbl:Dock(TOP)
    self.adrlbl:SetHeight(70)

    for k, v in pairs(impulse.Config.DispatchLines) do
        local button = self.Window:Add("DButton")
        button:SetText(v.name)
        button:Dock(TOP)
        button:DockMargin(0, 0, 0, 5)
        button:SetFont("BudgetLabel")
        button.Announcement = k

        button.DoClick = function()
            net.Start("impulseHL2RPDispatchAnnounce")
            net.WriteUInt(button.Announcement, 8)
            net.SendToServer()
        end
    end

end

function PANEL:CreateButton(txt, func)
    self.button = vgui.Create("DButton", self.ButtonList)
    self.button:Dock(TOP)
    self.button:DockMargin(4, 0, 4, 2)
    self.button:SetText(txt)
    self.button:SetFont("BudgetLabel")

    function self.button:DoClick()
        surface.PlaySound(table.Random(useSounds))
        func()
    end
end

function PANEL:UpdateChargers(vl)
    local p = self


    p.scroll:Remove()
    p.scroll = vgui.Create("DScrollPanel", p.Window)
    p.scroll:Dock(FILL)
    p.scroll:DockMargin(0, 18, 0, 32)

    local d = p.scroll

    for k, v in pairs(impulse.Config.ArrestCharges) do
        if (vl) then
            if not string.find(string.lower(v.name), vl) then continue end
        end
        local button = d:Add("DCheckBoxLabel")
        button:SetText(v.name)
        button:SetFont("BudgetLabel")
        button.chargeID = k
        button:Dock(TOP)
        button:SetSize(24, 24)
        button:SetValue(p.checkboxes[k] or false)

        function button:OnChange( val )
            if val then
                p.checkboxes[self.chargeID] = val
            else
                p.checkboxes[self.chargeID] = nil
            end
    
            self.value = val
    
            local chargeCount = 0
            local cycleCount = 0
            for v,k in pairs(p.checkboxes) do
                cycleCount = cycleCount + impulse.Config.ArrestCharges[v].severity 
                chargeCount = chargeCount + 1
            end
    
            local maxTime = impulse.Config.MaxJailTimeGrunt
    
            if LocalPlayer():IsCPCommand() then
                maxTime = impulse.Config.MaxJailTime
            end
    
            p.bt:SetText("Emit (Charges: "..chargeCount.." | Cycles: "..math.Clamp(cycleCount, 0, (maxTime / 60))..")")
        end
    end
end

function PANEL:ChargeScreen(arrester)
    self.arrester = arrester
    self.checkboxes = {}
    self.chargecount = 0
    self.timecount = 0

    local charge = self.chargecount
    local time = self.timecount

    if (self.Window) then
        self.Window:Remove()
    end

    local panel = self

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.scroll = vgui.Create("DScrollPanel", self.Window)
    self.scroll:DockMargin(0, 18, 0, 32)
	self.scroll:Dock(FILL)

    self:UpdateChargers()

    self.cg = vgui.Create("DLabel", self.Window)
    self.cg:SetText("You are charging: " .. self.arrester:Nick())
    self.cg:SetFont("BudgetLabel")
    self.cg:SizeToContents()

    self.bt = vgui.Create("DButton", self.Window)
	self.bt:Dock(BOTTOM)
	self.bt:SetFont("BudgetLabel")
	self.bt:SetText("Emit (Charges: 0 | Cycles: 0)")

    function self.bt:DoClick()
        local chargeCount = 0
		local charges = {}
		for v,k in pairs(panel.checkboxes) do
			table.insert(charges, v)
			chargeCount = chargeCount + 1
		end

		if chargeCount > 0 then
			net.Start("impulseHL2RPTerminalCharge")
			net.WriteUInt(#charges, 4)

			for a,b in pairs(charges) do
				net.WriteUInt(b, 8)
			end
			
			net.SendToServer()
		end

		panel:Remove()
    end

    self.search = vgui.Create("DTextEntry", self.Window)
	self.search:Dock(BOTTOM)
	self.search:SetUpdateOnType(true)

    self.searchLbl = vgui.Create("DLabel", self.search)
	self.searchLbl:SetPos(4, 0)
	self.searchLbl:SetFont("BudgetLabel")
	self.searchLbl:SetText("Search")

    function self.search:OnValueChange(val)
        panel:UpdateChargers(val)
    end
end

function PANEL:OpenChargeScreen(arrester)
    self:CreateButton("CHARGE", function() self:ChargeScreen(arrester) end)

    self:ChargeScreen(arrester)
end

function PANEL:DisiplineScreen()

    if (self.Window) then
        self.Window:Remove()
    end

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)

    self.List = vgui.Create("DListView", self.Window)
    self.List:Dock(FILL)
	self.List:SetMultiSelect(false)
	self.List:SetSortable(true)
    self.List:SetSkin("combine")

    local title1 = self.List:AddColumn("UNIT")
	local title2 = self.List:AddColumn("CID")
	title1.Header:SetFont("BudgetLabel")
	title2.Header:SetFont("BudgetLabel")

    for k, v in pairs(player.GetAll()) do
        if not IsValid(v) or !v:IsCP() then continue end

        local line = self.List:AddLine(v:Nick(), v:SteamID64())

        for v,k in pairs(line.Columns) do
            k:SetFont("BudgetLabel")
        end

        local sss = "YOU MAY ONLY DEMOTE IF THIS USER HAS BROKEN THE RULES. YOU CAN NOT DEMOTE A VALID ROGUE UNIT.\nABUSE OF THIS SYSTEM WILL RESULT IN WHITELIST REMOVAL AND A BAN."

        function self.List:OnRowSelected(index, row)
            local w = DermaMenu()
            w:SetSkin("combine")
            w:AddOption("Demote", function()
                Derma_Query("Are you sure you want to demote "..row:GetValue(1).."?\nThis will ban them from combine teams for a limited time.\n\n"..sss,
                "CONFIRMATION OF DEMOTION",
                "DEMOTE",
                function()
                    Derma_StringRequest(
                    "",
                    "How long do you want them demoted for? (Input the number in minutes.)",
                    "",
                    function(number)
                        local targ = player.GetBySteamID64(row:GetValue(2))
                        if not IsValid(targ) then
                            return
                        end

                        if not tonumber(number) then
                            return LocalPlayer():Notify("You need to put a digit!")
                        end

                        net.Start("impulseDemoteCP")
                        net.WriteEntity(targ)
                        net.WriteUInt(tonumber(number), 16)
                        net.SendToServer()
                    end):SetSkin("combine")
                end,
                "CANCEL"):SetSkin("combine")
            end):SetIcon("icon16/delete.png")

            w:Open()
        end
    end
end

function PANEL:Init()
	self:SetSize(600, 450)
	self:MakePopup()
	self:Center()
	self:SetSkin("combine")
    surface.PlaySound(table.Random(useSounds))

    local p = self -- parent panel
    local trace = {}
	trace.start = LocalPlayer():EyePos()
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 85
	trace.filter = LocalPlayer()

	local tr = util.TraceLine(trace)

    if IsValid(tr.Entity) and tr.Entity:GetClass() == "impulse_terminal" then
		self.terminal = tr.Entity
	else
		return self:Remove()
	end

    local terminal = self.terminal

    self:SetTitle("")

    self.ButtonList = vgui.Create("DScrollPanel", self)
    self.ButtonList:SetPos(16, 50)
    self.ButtonList:SetSize(140, 380)

    local ButtonListing = {
        {name = "BULLETIN", func = function() self:BulletIn_Screen() end},
        {name = "CAM INDEX", func = function() self:CameraList() end},
        {name = "HUMN. INDEX", func = function() self:HumanIndexList() end},
    }

    for k, v in ipairs(ButtonListing) do
        self:CreateButton(v.name, v.func)
    end

    if (LocalPlayer():IsCPCommand()) then
        self:CreateButton("BOL INDEX", function() self:BOL_Screen() end)
    end

    if (LocalPlayer():IsCPCommand() or LocalPlayer():Team() == TEAM_CA) then
        self:CreateButton("DISPATCH", function() self:DispatchScreen() end)
	end

	if LocalPlayer():IsCP() and LocalPlayer():GetTeamRank() >= RANK_SQL then
        self:CreateButton("DISIPLINE", function() self:DisiplineScreen() end)
	end


    self:BulletIn_Screen()
end

function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "Frame", self, w, h)

    draw.SimpleText("<:: TERMINAL #" .. self.terminal:EntIndex(), "BudgetLabel", 7, 5)
end

vgui.Register("ImpulseTerminalScreen", PANEL, "DFrame")