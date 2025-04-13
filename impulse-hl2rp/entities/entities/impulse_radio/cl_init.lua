include('shared.lua')
local lightMat = Material("sprites/glow04_noz")
local green = Color(50, 255, 50)

function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) > (250 ^ 2) then return end

    local pos = self:GetPos()
    local ang = self:GetAngles()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    

    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    pos = pos + f * 8.6 + u * 15.3 + r * 5.8
    cam.Start3D2D(pos, ang, 0.07)
        surface.SetDrawColor(255, 197, 143, 75)
        surface.DrawRect(0, 0, 245, 50)
        surface.DrawRect(-80, 0, 50, 40)

        draw.SimpleText(math.Round(self:GetFrequency(), 1), "BudgetLabel", -74, 6, color_white, TEXT_ALIGN_LEFT)


        surface.SetDrawColor(0, 0, 0)

        local w = w or 0

        for i = 1, 21 do
            if i % 2 == 0 then
                surface.DrawRect(i * 11 - 8, 16, 6, 38) 
            else
                surface.DrawRect(i * 11 - 8, 30, 6, 24)
            end
        end


        surface.SetDrawColor(218, 33, 33)
        surface.DrawRect((self:GetFrequency() * 6.171284634760705) - 497, 16, 1, 40)

    cam.End3D2D()



    local poz = self:GetPos() + f * 9.8 + r * -1.3 + u * 7.4
    local poz2 = self:GetPos() + f * 9.8 + r * -8.8 + u * 7.4
	render.SetMaterial(lightMat)
    render.DrawSprite(poz, 4, 4, green)
    render.DrawSprite(poz2, 4, 4, green)
end