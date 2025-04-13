ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Washing Machine"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Washing Machine"
ENT.HUDDesc = "Cleans dirty laundry."

function ENT:SetupDataTables()
	self:NetworkVar("Bool", false, "IsWashing")
end

function ENT:OnRemove()
    if SERVER then
	    self:StopSound("WashingSound")
    else
        if IsValid(self.wash) then
            self.wash:Remove()
        end
    end
end