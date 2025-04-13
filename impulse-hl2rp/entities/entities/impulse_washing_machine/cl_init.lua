include('shared.lua')
local lightMat = Material("sprites/glow04_noz")
local lightCols = {
	[false] = Color(50, 255, 50),
	[true] = Color(50, 50, 255),
}

function ENT:Draw()
    self:DrawModel()

    local position = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local pos = self:GetPos() + f * 25.5 + r * 15 + u * 5

	render.SetMaterial(lightMat)
    render.DrawSprite(pos, 18, 18, lightCols[self:GetIsWashing()])

    if IsValid(self.wash) then
        local spin = self.wash:GetAngles().z + FrameTime() * 300
        local parentAngle = self:GetAngles()
		self.wash:SetAngles(Angle(parentAngle.x, parentAngle.y, spin))
    end

    if self:GetIsWashing() then
        if IsValid(self.wash) then return end
        AvoidError = true
        self.wash = ents.CreateClientProp()
		self.wash:SetModel("models/props_junk/garbage_bag001a.mdl")
		self.wash:SetPos(self:GetPos() + Vector(0, 0, 5))
		self.wash:SetMaterial("models/props_c17/FurnitureFabric003a")
		self.wash:SetMoveType(MOVETYPE_NONE)
		self.wash:SetParent(self)
		self.wash:SetModelScale(2)
		self.wash:Spawn()
    else
        if IsValid(self.wash) then
            timer.Simple(0, function()
                if not IsValid(self.wash) then return end
                self.wash:Remove()
            end)
		end
    end
end