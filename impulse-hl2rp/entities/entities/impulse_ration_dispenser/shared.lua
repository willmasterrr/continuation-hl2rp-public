ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Ration Dispenser"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true 

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Light")
end