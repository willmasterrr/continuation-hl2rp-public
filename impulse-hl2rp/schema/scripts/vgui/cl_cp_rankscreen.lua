local PANEL = {}

local function ButtonThing(panel)
    local div = impulse.Teams.Data[LocalPlayer():Team()].ranks
    local team_div = impulse.Teams.Data[LocalPlayer():Team()].classes
    div = div[panel.Rank]
    team_div = team_div[panel.Division]

    if (panel.Rank and panel.Division) then
        panel.done:SetText("Become a " .. team_div.name .. " " .. div.name)
        panel.done:SetDisabled(false)
    end
end

function PANEL:Init()
    local w, h = ScrW(), ScrH()
    self:SetSize(500, 450)
    self:MakePopup()
    self:Center()
    self:SetTitle("Division and rank selection")

    local panel = self

    self.mdl = vgui.Create("DModelPanel", self)
    self.mdl:SetPos(500 - 224, 38)
	self.mdl:SetSize(270, 450)
    self.mdl:SetFOV(38)
    self.mdl:SetModel(LocalPlayer():GetModel(), LocalPlayer():GetSkin())
    self.mdl:MoveToBack()
	self.mdl:SetCursor("arrow")

    function self.mdl:LayoutEntity(ent)
        ent:SetAngles(Angle(0, 40, 0))
	end

    self.divlbl = vgui.Create("DLabel", self)
    self.divlbl:SetPos(12, 45)
    self.divlbl:SetFont("Impulse-Elements18-Shadow")
    self.divlbl:SetText("Division:")
    self.divlbl:SizeToContents()

    self.div = vgui.Create("DComboBox", self)
    self.div:SetPos(12, 65)
    self.div:SetSize(295, 22)
	self.div:SetSortItems(false)
    self.div:SetText("Select a division")
	local xp = LocalPlayer():GetXP()

    if (impulse.Teams.Data[LocalPlayer():Team()].classes) then
        for v,k in pairs(impulse.Teams.Data[LocalPlayer():Team()].classes) do
            local add = (k.whitelistLevel and " and whitelist") or ""
            if k.xp <= xp then
                self.div:AddChoice(k.name.." - Requires "..k.xp.."XP"..add, v, false)
            else
                self.div:AddChoice(k.name.." - Requires "..k.xp.."XP"..add, v, false, "icon16/lock.png")
            end
        end
    end

    function self.div:OnSelect(index, value, data)
        panel.Division = data

        local div = impulse.Teams.Data[LocalPlayer():Team()].ranks[panel.Ranks]
        local team_div = impulse.Teams.Data[LocalPlayer():Team()].classes[panel.Division]


        panel.desc:SetText(team_div["description"])
		panel.desc:SetWrap(true)

        if (team_div["model"]) then
            panel.mdl:SetModel(team_div["model"])
        else
            panel.mdl:SetModel(team_div["model"] or "models/dpfilms/metropolice/hdpolice.mdl")
        end

        if (team_div["skin"]) then
            panel.mdl:SetSkin(team_div["skin"])
        end

        if (team_div["subMaterial"]) then
			panel.mdl.subMats = {}
			for v,k in pairs(team_div["subMaterial"]) do
				panel.mdl.Entity:SetSubMaterial(v - 1, k)
				panel.mdl.subMats[v] = k
			end
		end

        ButtonThing(panel, div, team_div)
    end

    self.ranklbl = vgui.Create("DLabel", self)
    self.ranklbl:SetPos(12, 97)
    self.ranklbl:SetFont("Impulse-Elements18-Shadow")
    self.ranklbl:SetText("Division:")
    self.ranklbl:SizeToContents()

    self.rank = vgui.Create("DComboBox", self)
    self.rank:SetPos(12, 117)
    self.rank:SetSize(295, 22)
	self.rank:SetSortItems(false)
    self.rank:SetText("Select a rank")

    if impulse.Teams.Data[LocalPlayer():Team()].ranks then
        for v,k in ipairs(impulse.Teams.Data[LocalPlayer():Team()].ranks) do

            local add = (k.whitelistLevel and " and whitelist") or ""
            if k.xp <= xp then
                self.rank:AddChoice(k.name.." - Requires "..k.xp.."XP"..add, v, false)
            else
                self.rank:AddChoice(k.name.." - Requires "..k.xp.."XP"..add, v, false, "icon16/lock.png")
            end
        end
    end


    function self.rank:OnSelect(index, value, data)
        panel.Rank = data

		local div = impulse.Teams.Data[LocalPlayer():Team()].ranks[panel.Rank]
        local team_div = impulse.Teams.Data[LocalPlayer():Team()].classes[panel.Division or 1]


        if (div["skin"]) then
            panel.mdl:SetSkin(div["skin"])
        end

        if (div["model"]) then
            panel.mdl:SetModel(div["model"])
        else
            panel.mdl:SetModel(team_div["model"] or "models/dpfilms/metropolice/hdpolice.mdl")
        end

        if (div["subMaterial"]) then
			panel.mdl.subMats = {}
			for v,k in pairs(div["subMaterial"]) do
				panel.mdl.Entity:SetSubMaterial(v - 1, k)
				panel.mdl.subMats[v] = k
			end
		end


        ButtonThing(panel, div, team_div)
    end

    self.desclbl = vgui.Create("DLabel", self)
    self.desclbl:SetPos(12, 164)
    self.desclbl:SetFont("Impulse-Elements18-Shadow")
    self.desclbl:SetText("Description:")
    self.desclbl:SizeToContents()

    self.desc = vgui.Create("DLabel", self)
    self.desc:SetPos(12, 184)
  	self.desc:SetSize(300, 400)
    self.desc:SetFont("Impulse-Elements14")
    self.desc:SetText("")
    self.desc:SetContentAlignment(7)

    self.done = vgui.Create("DButton", self)
    self.done:Dock(BOTTOM)
    self.done:SetHeight(24)
    self.done:SetDisabled(true)
    self.done:DockMargin(6, 0, 190, 4)
    self.done:SetText("No divison or rank selected")

    function self.done:DoClick()
        if (panel.Division and panel.Rank) then
            net.Start("impulseRankTerminalBecome")
            net.WriteUInt(panel.Division, 8)
            net.WriteUInt(panel.Rank, 8)
            net.SendToServer()

            panel:Remove()
        end
    end
end

vgui.Register("ImpulseCPRankScreen", PANEL, "DFrame")