include('shared.lua')

local status = {
    [ENT.LAUNDRYSTATE_EMPTY] = "Empty",
    [ENT.LAUNDRYSTATE_PROCESSING] = "Processing...",
    [ENT.LAUNDRYSTATE_DONE] = "Done",
    [ENT.LAUNDRYSTATE_DISPENSING] = "Dispensing...",
}

function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 62500 then return end
    
    local pos = self:GetPos()
    local ang = self:GetAngles()
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local offset = Angle(0, 180, 35)

    cam.Start3D2D(pos + f * 26.5 + r * -9.5 + u * 23, ang + offset, 0.1)
        draw.SimpleText(status[self:GetLaundry1()], "DebugFixed", 0, 0, color_white)
        draw.SimpleText(status[self:GetLaundry2()], "DebugFixed", 0, 18, color_white)
        draw.SimpleText(status[self:GetLaundry3()], "DebugFixed", 0, 36, color_white)
        draw.SimpleText(status[self:GetLaundry4()], "DebugFixed", 0, 54, color_white)
    cam.End3D2D()
end
