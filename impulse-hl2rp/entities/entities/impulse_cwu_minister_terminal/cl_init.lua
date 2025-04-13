include('shared.lua')

local useSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle4.wav"
}
--models to use
--models/props_combine/breenconsole.mdl
--models/props_combine/combine_binocular01.mdl
--models/props_combine/combine_smallmonitor001.mdl

sound.Add({
    name = "CWUTerminal.Hl2rp.ambience",
    channel = CHAN_STATIC,
    level = 60,
    volume = 100,
    sound = "ambient/machines/combine_terminal_loop1.wav"
})

function ENT:Think()
    local posdist = self:GetPos()
    if LocalPlayer():GetPos():Distance(posdist) <= 900 then
        if not self.TerminalEmitSound then
            self:EmitSound("CWUTerminal.Hl2rp.ambience")
            self.TerminalEmitSound = true
        end
    elseif self.TerminalEmitSound then
        self:StopSound("CWUTerminal.Hl2rp.ambience")
        self.TerminalEmitSound = false
    end
end

function ENT:Draw()
    self:DrawModel()
    local angles = self:GetAngles()
    local pos = self:GetPos()
    local f, r, u = angles:Forward(), angles:Right(), angles:Up()

    if not IsValid(self.tv) then
        self.tv = ClientsideModel("models/props_combine/combine_smallmonitor001.mdl", 0)
        self.tv:SetParent(self)
        self.tv:SetPos(pos + u * 70 + r * -8)
        self.tv:SetAngles(angles + Angle(20, -90, 0))
    end

    if not IsValid(self.stick) then
        self.stick = ClientsideModel("models/props_combine/combine_binocular01.mdl", 0)
        self.stick:SetParent(self)
        self.stick:SetPos(pos + u * 60 + r * -4)
        self.stick:SetAngles(angles + Angle(0, -90, 0))
    end


    local TerminalCol = Color(35, 110, 160)
    local JwCol = Color(220, 0, 0)
    local Screen_Color = Color(0, 0, 0)
    if (impulse.Dispatch.GetCityCode() >= CODE_JW) then
        Screen_Color = JwCol
    else
        Screen_Color = TerminalCol
    end


    local text = "MINISTER\nTERMINAL:\n" .. self:EntIndex() .. "\nGLORY TO THE \nUNIVERSAL UNION"


    pos = pos + (angles:Up() * 47.9)
    pos = pos + (angles:Right() * -5)
    pos = pos + (angles:Forward() * -10.21)

    angles:RotateAroundAxis(angles:Up(), 0)
	angles:RotateAroundAxis(angles:Right(), 0)
	angles:RotateAroundAxis(angles:Forward(), 42)
    local gear = Material("gui/progress_cog.png")

    if LocalPlayer():GetPos():Distance(self:GetPos()) <= 700 then
        cam.Start3D2D(pos, angles, 0.1)
            surface.SetDrawColor(Screen_Color)
            surface.DrawRect(0, 0, 161, 80)
            draw.DrawText(text, "DebugFixed", 8, 4, color_white, TEXT_ALIGN_LEFT)
    
            surface.SetDrawColor(color_white)
            surface.SetMaterial(gear)
            -- surface.DrawTexturedRect(34, 34, 100, 100)
            surface.DrawTexturedRectRotated(145, 65, 24, 24, math.sin(RealTime() * 1) * 110)
        cam.End3D2D()
    end
end

function ENT:OnRemove()
    if IsValid(self.stick) then
        self.stick:Remove()
    end

    if IsValid(self.tv) then
        self.tv:Remove()
    end
end

local PANEL = {}

local remindertext2 = [[
---------------------------------
Reminder: Report suspicious activity. 
A vigilant worker is a trusted worker.
--------------------------------- 
]]

local remindertext = [[
---------------------------------
Reminder: Compliance is the key to advancement.
Loyalty earns reward.
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
    local cwu_count = #team.GetPlayers(TEAM_CWU)

    local population = vgui.Create("DLabel", self.Window)
    population:SetFont("BudgetLabel")
    population:SetText("CITIZEN POPULATION COUNT: " .. count)
    population:SizeToContents()
    population:Dock(TOP)
    population:DockMargin(0, 5, 0, 0)

    local cwupopulation = vgui.Create("DLabel", self.Window)
    cwupopulation:SetFont("BudgetLabel")
    cwupopulation:SetText("WORKERS UNION MEMBER COUNT: " .. cwu_count)
    cwupopulation:SizeToContents()
    cwupopulation:Dock(TOP)
    cwupopulation:DockMargin(0, 5, 0, 0)

    local playah = vgui.Create("DLabel", self.Window)
    playah:SetFont("BudgetLabel")
    playah:SetText("LOCAL WORKER: " .. LocalPlayer():Name() .. "\nLOCAL WORK ROLE: " .. LocalPlayer():GetTeamClassName())
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

local WorkShift_COL = {
    [false] = {col = Color(197, 24, 24), status = "NOT AVAILABLE"},
    [true] = {col = Color(102, 197, 24), status = "AVAILABLE"},
}

function PANEL:Workshift_Screen()

    local time = GetGlobal2Int("ImpulseWorkshiftTimer", 0)
    local parent = self
    if (self.Window) then
        self.Window:Remove()
    end
    local WORKSHIFTSTATUS = false

    if time < CurTime() then
        WORKSHIFTSTATUS = true
    end

    local WorkData = WorkShift_COL[WORKSHIFTSTATUS]

    self.Window = vgui.Create("DPanel", self)
    self.Window:SetSize(426, 410)
    self.Window:SetPos(160, 30)


    local city = vgui.Create("DLabel", self.Window)
    city:SetFont("BudgetLabel")
    city:SetText("WORKSHIFT HOUR: " .. WorkData.status)
    city:SetTextColor(WorkData.col)
    city:Dock(TOP)

    local tim = vgui.Create("DLabel", self.Window)
    tim:SetFont("BudgetLabel")
    tim:SetText("WORKSHIFT TIMER: " .. string.NiceTime(time - CurTime()))
    tim:Dock(TOP)

    local start = vgui.Create("DButton", self.Window)
    start:SetFont("BudgetLabel")
    start:SetText("START WORKSHIFT")
    start:Dock(TOP)
    start.DoClick = function()
		Derma_Query("Are you sure you want to start a workshift?", "impulse", "YES", function()
            net.Start("impulseWorkshift")
            net.WriteBool(false) -- Is it the workshift end event?
            net.SendToServer()
            parent:Remove()
        end, "NO"):SetSkin("combine")
    end

    -- if not WORKSHIFTSTATUS then
    --     start:SetDisabled(true)
    -- end

    local stop = vgui.Create("DButton", self.Window)
    stop:SetFont("BudgetLabel")
    stop:SetText("END WORKSHIFT EARLY")
    stop:Dock(TOP)
    stop.DoClick = function()
		Derma_Query("Are you sure you want to end this workshift early?\nYou can start one again in the next 30 minutes.", "impulse", "YES", function()
            net.Start("impulseWorkshift")
            net.WriteBool(true) -- Is it the workshift end event?
            net.SendToServer()
            parent:Remove()
        end, "NO"):SetSkin("combine")
    end

    -- if WORKSHIFTSTATUS then
    --     stop:SetDisabled(true)
    -- end

    stop:SetHeight(84)
    start:SetHeight(84)

    local nextthink = CurTime()
    function tim:Think()
        if nextthink > CurTime() then return end
        nextthink = CurTime() + 1
        local text = "WORKSHIFT TIMER: " .. string.NiceTime(time - CurTime())
        if time < CurTime() then
            text = "WORKSHIFT NOT STARTED!"
        end
        self:SetText(text)
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
    if IsValid(tr.Entity) and tr.Entity:GetClass() == "impulse_cwu_minister_terminal" then
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
        {name = "HOME", func = function() self:BulletIn_Screen() end},
        {name = "WORKSHIFT", func = function() self:Workshift_Screen() end},
    }

    for k, v in ipairs(ButtonListing) do
        self:CreateButton(v.name, v.func)
    end

    self:BulletIn_Screen()
end

function PANEL:Paint(w, h)
    derma.SkinHook("Paint", "Frame", self, w, h)

    draw.SimpleText("<:: CWU MINISTER TERMINAL #" .. self.terminal:EntIndex(), "BudgetLabel", 7, 5)
end

vgui.Register("ImpulseCWUMinisterTerminal", PANEL, "DFrame")