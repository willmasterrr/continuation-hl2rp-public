ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Dryer"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Dryer"
ENT.HUDDesc = "Dries wet laundry."

ENT.LAUNDRYSTATE_EMPTY = 0
ENT.LAUNDRYSTATE_PROCESSING = 1
ENT.LAUNDRYSTATE_DONE = 2
ENT.LAUNDRYSTATE_DISPENSING = 3

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Laundry1")
	self:NetworkVar("Int", 1, "Laundry2")
	self:NetworkVar("Int", 2, "Laundry3")
	self:NetworkVar("Int", 3, "Laundry4")
end