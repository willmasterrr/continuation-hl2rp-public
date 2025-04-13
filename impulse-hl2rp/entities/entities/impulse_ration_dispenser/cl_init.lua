include('shared.lua')

local lightMat = Material("sprites/glow04_noz")
local lightCols = {
	Color(255, 50, 50),
	Color(50, 255, 50),
	Color(50, 50, 255)
}

function ENT:Draw()
    self:DrawModel()

    local position = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local pos = self:GetPos() + f * 8 + r * -4 + u * 2
	render.SetMaterial(lightMat)
    render.DrawSprite(pos, 8, 8, lightCols[self:GetLight()])
end