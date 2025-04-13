ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Cloth"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = false
ENT.AdminOnly = true

ENT.HUDName = "Laundry"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Stage")
end