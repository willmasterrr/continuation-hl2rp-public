ENT.Type = "anim"
ENT.Base = "base_anim" 
ENT.PrintName = "Terminal"
ENT.Author = "WillMaster"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Combine Terminal"
ENT.HUDDesc = "This can be used by UU personnel."

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "NetworkedUser")
end