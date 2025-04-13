include('shared.lua')

function ENT:Draw()
    self:DrawModel()

    self.Percentage = math.Round((math.Clamp((self:GetTimer() - CurTime()) / (self:GetTimer() - self:GetEndTimer()), 0, 1) * 100), 1)

    if self.Percentage == 0 then
        self.HUDName = "Brewing Barrel"
        self.HUDDesc = "Used to brew alcohol"

        return
    end

    self.HUDName = "Brewing..."
    self.HUDDesc = self.Percentage .. "%"
end