ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Ammo Crate"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Ammo Crate"
ENT.HUDDesc = "Retrieve your ammunition."

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "DrillEndTime")
end

function ENT:OnRemove()
    if IsValid(self.Drill) then
        self.Drill:Remove()
    end
end