include('shared.lua')
local vignette = Material("impulse/vignette.png")
local col1, col2, col3 = Color(21, 91, 156), Color(20, 42, 85), Color(17, 30, 56)
local arrow = Material("gui/point.png")
ENT.Value = ENT.Value or 1
local icon = {
    [1] = Material("impulse/continuation/ui/steel-icon.png"),
    [2] = Material("impulse/continuation/ui/screw-icon.png"),
    [3] = Material("impulse/continuation/ui/adhesive-glue-icon.png"),
}


function ENT:Draw()
    self:DrawModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    local angles = self:GetAngles()
    local f, r, u = ang:Forward(), ang:Right(), ang:Up()

    -- if IsValid(self.tv) then
    --     self.tv:Remove()
    -- end

    ang:RotateAroundAxis(r, 90)
    ang:RotateAroundAxis(u, 0)
    ang:RotateAroundAxis(f, 270)

    if not IsValid(self.tv) then
        self.tv = ClientsideModel("models/props_combine/combine_smallmonitor001.mdl", 0)
        self.tv:SetParent(self)
        self.tv:SetPos(pos + r * 1 + f * 7 + u * .9)
        self.tv:SetAngles(ang)
    end

    if bDrawingDepth then return end

    pos = pos + (u * 5)
    pos = pos + (r * -12)
    pos = pos + (f * -7)

    angles:RotateAroundAxis(r, 90)
    angles:RotateAroundAxis(u, 90)
    angles:RotateAroundAxis(f, 180)

    if imgui.Start3D2D(pos, angles, 0.1, 200, 150) then
        surface.SetDrawColor(col1)
        surface.DrawRect(-26, -47, 170, 145)
        surface.SetDrawColor(col2)
        surface.SetMaterial(vignette)
        surface.DrawTexturedRect(-26, -47, 170, 145)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(icon[self.Value])
        surface.DrawTexturedRect(28, -10, 52, 52, 2)

        surface.SetDrawColor(col2)
        surface.SetMaterial(vignette)
        surface.DrawTexturedRect(12, -24, 84, 84, 2)

        surface.SetDrawColor(col3)
        surface.DrawOutlinedRect(12, -24, 84, 84, 2)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(arrow)
        surface.DrawTexturedRectRotated(-7, 17, 34, 34, -90)
        surface.DrawTexturedRectRotated(114, 17, 34, 34, 90)
        if imgui.xButton(-24, 0, 34, 34, 0, color_white, color_white, color_white) then
            if self.Value == 1 then
                self:EmitSound("buttons/combine_button3.wav")
                self.Value = self.Value
            else
                self:EmitSound("buttons/combine_button1.wav")
                self.Value = self.Value - 1
            end
            -- print(self.Value)
        end

        if imgui.xButton(97, 0, 34, 34, 0, color_white, color_white, color_white) then
            if self.Value == 3 then
                self:EmitSound("buttons/combine_button3.wav")
                self.Value = self.Value
            else
                self:EmitSound("buttons/combine_button1.wav")
                self.Value = self.Value + 1
            end
            -- print(self.Value)
        end

        if imgui.xTextButton("Dispense", "BudgetLabel", -31, 85, 170, 14, 0, Color(255,255,255), Color(190,190,190), Color(60,255,0)) then
            timer.Simple(0, function()
                net.Start("ImpulseUseScrapChute")
                net.WriteUInt(self.Value, 8)
                net.SendToServer()
            end)
        end

        imgui.End3D2D()
    end
end

function ENT:OnRemove()
    if IsValid(self.tv) then
        self.tv:Remove()
    end
end