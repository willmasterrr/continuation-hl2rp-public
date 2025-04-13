include('shared.lua')

ENT.AutomaticFrameAdvance = true
function ENT:Initialize()
	self:DoAnimation()
end

function ENT:Think()
	if ((self.nextAnimCheck or 0) < CurTime()) then
		self:DoAnimation()
		self.nextAnimCheck = CurTime() + 8
	end

	self:SetNextClientThink(CurTime() + 2)

	return true
end
